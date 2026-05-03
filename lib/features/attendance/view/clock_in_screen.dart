import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class ClockInScreen extends StatefulWidget {
  const ClockInScreen({super.key});

  @override
  State<ClockInScreen> createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _entryController;
  late Animation<double> _pulseAnimation;
  late Timer _clockTimer;
  String _currentTime = '';
  String _currentDate = '';
  String _currentSeconds = '';
  bool _showVerification = false;
  bool _isClockingIn = false;
  bool _clockedIn = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final amPm = now.hour >= 12 ? 'PM' : 'AM';
    setState(() {
      _currentTime = '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $amPm';
      _currentSeconds = now.second.toString().padLeft(2, '0');
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      _currentDate = '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entryController.dispose();
    _clockTimer.cancel();
    super.dispose();
  }

  void _handleClockIn() {
    setState(() => _showVerification = true);
  }

  void _confirmClockIn() async {
    setState(() => _isClockingIn = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isClockingIn = false;
      _clockedIn = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A12) : const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: Responsive.w(20),
              color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text('Clock In', style: TextStyle(
          fontSize: Responsive.sp(18), fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        )),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _showVerification
            ? _buildVerificationView(isDark)
            : _buildMainView(isDark),
      ),
    );
  }

  Widget _buildMainView(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('main'),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
      child: Column(
        children: [
          SizedBox(height: Responsive.h(16)),
          // Live Clock
          _buildAnimatedEntry(0, child: _buildLiveClock(isDark)),
          SizedBox(height: Responsive.h(24)),
          // Shift Info
          _buildAnimatedEntry(1, child: _buildShiftCard(isDark)),
          SizedBox(height: Responsive.h(16)),
          // Location
          _buildAnimatedEntry(2, child: _buildLocationCard(isDark)),
          SizedBox(height: Responsive.h(16)),
          // Today's Schedule
          _buildAnimatedEntry(3, child: _buildScheduleCard(isDark)),
          SizedBox(height: Responsive.h(32)),
          // Clock In Button
          _buildAnimatedEntry(4, child: _buildClockInButton(isDark)),
          SizedBox(height: Responsive.h(40)),
        ],
      ),
    );
  }

  Widget _buildAnimatedEntry(int index, {required Widget child}) {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, _) {
        final delay = index * 0.15;
        final progress = ((_entryController.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);
        final curved = Curves.easeOutCubic.transform(progress);
        return Opacity(
          opacity: curved,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - curved)),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildLiveClock(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Responsive.h(32)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Responsive.r(20)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_currentTime, style: TextStyle(
                fontSize: Responsive.sp(36), fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2,
              )),
              Padding(
                padding: EdgeInsets.only(top: Responsive.h(6)),
                child: Text(':$_currentSeconds', style: TextStyle(
                  fontSize: Responsive.sp(16), fontWeight: FontWeight.bold, color: Colors.white70,
                )),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(8)),
          Text(_currentDate, style: TextStyle(
            fontSize: Responsive.sp(13), color: Colors.white70, fontWeight: FontWeight.w500,
          )),
          SizedBox(height: Responsive.h(16)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(6)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(Responsive.r(20)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                SizedBox(width: Responsive.w(8)),
                Text('NOT CLOCKED IN', style: TextStyle(
                  fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: _cardDecoration(isDark),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(12)),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Responsive.r(12)),
            ),
            child: Icon(Icons.schedule_rounded, color: const Color(0xFF8B5CF6), size: Responsive.w(24)),
          ),
          SizedBox(width: Responsive.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OFFICE FULL TIME', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.grey.shade500, letterSpacing: 0.5)),
                SizedBox(height: Responsive.h(4)),
                Text('10:00 AM – 06:30 PM', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                SizedBox(height: Responsive.h(2)),
                Text('8h 30m shift duration', style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white54 : Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(10), vertical: Responsive.h(6)),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Responsive.r(6)),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Text('ON TIME', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(12)),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(12)),
                ),
                child: Icon(Icons.location_on_rounded, color: Colors.blue, size: Responsive.w(24)),
              ),
              SizedBox(width: Responsive.w(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WORK LOCATION', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.grey.shade500, letterSpacing: 0.5)),
                    SizedBox(height: Responsive.h(4)),
                    Text('Corporate Office', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  ],
                ),
              ),
              Icon(Icons.check_circle_rounded, color: Colors.green, size: Responsive.w(20)),
            ],
          ),
          SizedBox(height: Responsive.h(12)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.w(12)),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(Responsive.r(8)),
            ),
            child: Row(
              children: [
                Icon(Icons.near_me_rounded, size: Responsive.w(14), color: isDark ? Colors.white38 : Colors.grey.shade500),
                SizedBox(width: Responsive.w(8)),
                Expanded(child: Text('427A, Tower B, Spaze Edge, Malibu Town, Sector 47, Gurugram', style: TextStyle(fontSize: Responsive.sp(10), color: isDark ? Colors.white54 : Colors.grey.shade600))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("TODAY'S SCHEDULE", style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.grey.shade500, letterSpacing: 0.5)),
          SizedBox(height: Responsive.h(16)),
          _buildTimelineItem('10:00 AM', 'Shift Start', Colors.green, isDark, isFirst: true),
          _buildTimelineItem('01:00 PM', 'Lunch Break (30 min)', Colors.orange, isDark),
          _buildTimelineItem('06:30 PM', 'Shift End', Colors.red, isDark, isLast: true),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String time, String label, Color color, bool isDark, {bool isFirst = false, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: Responsive.w(60),
            child: Text(time, style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black54)),
          ),
          Column(
            children: [
              if (!isFirst) Container(width: 2, height: 12, color: isDark ? Colors.white10 : Colors.grey.shade300),
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle, border: Border.all(color: color, width: 2))),
              if (!isLast) Container(width: 2, height: 12, color: isDark ? Colors.white10 : Colors.grey.shade300),
            ],
          ),
          SizedBox(width: Responsive.w(16)),
          Expanded(child: Padding(
            padding: EdgeInsets.symmetric(vertical: Responsive.h(4)),
            child: Text(label, style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
          )),
        ],
      ),
    );
  }

  Widget _buildClockInButton(bool isDark) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: GestureDetector(
        onTap: _handleClockIn,
        child: Container(
          width: Responsive.w(160),
          height: Responsive.w(160),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 5),
              BoxShadow(color: const Color(0xFF8B5CF6).withValues(alpha: 0.2), blurRadius: 60, spreadRadius: 10),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fingerprint_rounded, size: Responsive.w(40), color: Colors.white),
              SizedBox(height: Responsive.h(8)),
              Text('CLOCK IN', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
            ],
          ),
        ),
      ),
    );
  }

  // Verification View
  Widget _buildVerificationView(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('verify'),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
      child: Column(
        children: [
          SizedBox(height: Responsive.h(16)),
          // Header
          Container(
            padding: EdgeInsets.all(Responsive.w(20)),
            decoration: _cardDecoration(isDark),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.w(12)),
                  decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Responsive.r(12))),
                  child: Icon(Icons.verified_user_rounded, color: const Color(0xFF8B5CF6), size: Responsive.w(24)),
                ),
                SizedBox(width: Responsive.w(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verify Identity', style: TextStyle(fontSize: Responsive.sp(16), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                      SizedBox(height: Responsive.h(4)),
                      Text('Capture a live selfie for attendance verification', style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white54 : Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(24)),
          // Camera placeholder
          Container(
            width: double.infinity,
            height: Responsive.h(350),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A24) : Colors.grey.shade900,
              borderRadius: BorderRadius.circular(Responsive.r(20)),
              border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3), width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Simulated viewfinder
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.face_rounded, size: Responsive.w(60), color: Colors.white24),
                    SizedBox(height: Responsive.h(16)),
                    Text('Camera Preview', style: TextStyle(fontSize: Responsive.sp(14), color: Colors.white38, fontWeight: FontWeight.w500)),
                    SizedBox(height: Responsive.h(4)),
                    Text('Position your face within the frame', style: TextStyle(fontSize: Responsive.sp(10), color: Colors.white24)),
                  ],
                ),
                // Corner brackets
                ..._buildCornerBrackets(),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(24)),
          // Info row
          Container(
            padding: EdgeInsets.all(Responsive.w(16)),
            decoration: _cardDecoration(isDark),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVerifyInfo(Icons.access_time, _currentTime, 'Time', isDark),
                Container(width: 1, height: 30, color: isDark ? Colors.white10 : Colors.grey.shade300),
                _buildVerifyInfo(Icons.location_on_outlined, 'Office', 'Location', isDark),
                Container(width: 1, height: 30, color: isDark ? Colors.white10 : Colors.grey.shade300),
                _buildVerifyInfo(Icons.wifi, 'Connected', 'Network', isDark),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(24)),
          // Action buttons
          if (_clockedIn)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(Responsive.r(12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: Responsive.w(20)),
                  SizedBox(width: Responsive.w(8)),
                  Text('CLOCKED IN SUCCESSFULLY', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                ],
              ),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isClockingIn ? null : _confirmClockIn,
                icon: _isClockingIn
                    ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Icon(Icons.camera_alt_rounded, size: Responsive.w(20)),
                label: Text(
                  _isClockingIn ? 'VERIFYING...' : 'CAPTURE & CLOCK IN',
                  style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(12))),
                  elevation: 4,
                ),
              ),
            ),
            SizedBox(height: Responsive.h(12)),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _showVerification = false),
                icon: Icon(Icons.arrow_back_rounded, size: Responsive.w(18)),
                label: Text('Go Back', style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : Colors.black54,
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(14)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(12))),
                  side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
                ),
              ),
            ),
          ],
          SizedBox(height: Responsive.h(40)),
        ],
      ),
    );
  }

  Widget _buildVerifyInfo(IconData icon, String value, String label, bool isDark) {
    return Column(
      children: [
        Icon(icon, size: Responsive.w(16), color: const Color(0xFF8B5CF6)),
        SizedBox(height: Responsive.h(6)),
        Text(value, style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        Text(label, style: TextStyle(fontSize: Responsive.sp(9), color: isDark ? Colors.white38 : Colors.grey.shade500)),
      ],
    );
  }

  List<Widget> _buildCornerBrackets() {
    const color = Color(0xFF8B5CF6);
    const len = 30.0;
    const thickness = 3.0;
    const offset = 20.0;
    return [
      Positioned(top: offset, left: offset, child: _corner(color, len, thickness, topLeft: true)),
      Positioned(top: offset, right: offset, child: _corner(color, len, thickness, topRight: true)),
      Positioned(bottom: offset, left: offset, child: _corner(color, len, thickness, bottomLeft: true)),
      Positioned(bottom: offset, right: offset, child: _corner(color, len, thickness, bottomRight: true)),
    ];
  }

  Widget _corner(Color color, double len, double thickness, {bool topLeft = false, bool topRight = false, bool bottomLeft = false, bool bottomRight = false}) {
    return SizedBox(
      width: len, height: len,
      child: CustomPaint(painter: _CornerPainter(color: color, thickness: thickness, topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)),
    );
  }

  BoxDecoration _cardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF13131A) : Colors.white,
      borderRadius: BorderRadius.circular(Responsive.r(16)),
      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200),
      boxShadow: [
        if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool topLeft, topRight, bottomLeft, bottomRight;

  _CornerPainter({required this.color, required this.thickness, this.topLeft = false, this.topRight = false, this.bottomLeft = false, this.bottomRight = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = thickness..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    if (topLeft) {
      path.moveTo(0, size.height); path.lineTo(0, 0); path.lineTo(size.width, 0);
    } else if (topRight) {
      path.moveTo(0, 0); path.lineTo(size.width, 0); path.lineTo(size.width, size.height);
    } else if (bottomLeft) {
      path.moveTo(0, 0); path.lineTo(0, size.height); path.lineTo(size.width, size.height);
    } else if (bottomRight) {
      path.moveTo(size.width, 0); path.lineTo(size.width, size.height); path.lineTo(0, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
