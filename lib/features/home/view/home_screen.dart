import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../task/view/task_menu_screen.dart';
import '../../leave/view/leave_screen.dart';
import '../../expense/view/expenses_screen.dart';
import '../../payroll/view/payroll_screen.dart';
import '../../attendance/view/clock_in_screen.dart';
import '../../notifications/view/notifications_screen.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  final AppDrawerController? drawerController;

  const HomeScreen({super.key, this.drawerController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _staggered(int index, Widget child) {
    final delay = (index * 0.08).clamp(0.0, 0.7);
    final end = (delay + 0.45).clamp(0.0, 1.0);
    final slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Interval(delay, end, curve: Curves.easeOutCubic),
          ),
        );
    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(delay, end, curve: Curves.easeOut),
      ),
    );
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) => Opacity(
        opacity: fadeAnim.value,
        child: SlideTransition(position: slideAnim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: Responsive.h(56),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: theme.appBarTheme.foregroundColor,
            size: Responsive.w(24),
          ),
          onPressed: () {
            widget.drawerController?.toggleDrawer();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purpleAccent,
              radius: Responsive.w(18),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: Responsive.w(20),
              ),
            ),
            SizedBox(width: Responsive.w(12)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '👋 Yash Raj ',
                      style: TextStyle(
                        color: theme.textTheme.titleMedium?.color,
                        fontSize: Responsive.sp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: Responsive.w(16),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(4)),
                Text(
                  'Here is your work today.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: Responsive.sp(12),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: theme.appBarTheme.foregroundColor,
              size: Responsive.w(24),
            ),
            onPressed: () {
              Get.to(
                () => const NotificationsScreen(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session row
            _staggered(
              0,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.bolt,
                        color: const Color(0xFF8C52FF),
                        size: Responsive.w(20),
                      ),
                      SizedBox(width: Responsive.w(8)),
                      Text(
                        'Session',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: Responsive.sp(16),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '00:00:00',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: Responsive.sp(18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(12)),

            // Clock In card
            _staggered(
              1,
              Container(
                padding: EdgeInsets.all(Responsive.w(20)),
                decoration: BoxDecoration(
                  color: const Color(0xFF8C52FF),
                  borderRadius: BorderRadius.circular(Responsive.r(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '03:42 PM Thu, Apr 20',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                          SizedBox(height: Responsive.h(4)),
                          Text(
                            'Corporate Office • OFFICE FULL TIME',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                          SizedBox(height: Responsive.h(12)),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(
                                () => const ClockInScreen(),
                                transition: Transition.downToUp,
                                duration: const Duration(milliseconds: 400),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF8C52FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.r(20),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: Responsive.w(24),
                                vertical: Responsive.h(8),
                              ),
                            ),
                            child: Text(
                              'Clock In Free',
                              style: TextStyle(fontSize: Responsive.sp(13)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.touch_app,
                      color: Colors.white54,
                      size: Responsive.w(50),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Responsive.h(24)),

            // Quick Actions title
            _staggered(
              2,
              Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: Responsive.sp(16),
                ),
              ),
            ),
            SizedBox(height: Responsive.h(16)),

            // Quick Action items
            _staggered(
              3,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionItem(
                    context,
                    Icons.backpack,
                    'Apply\nLeave',
                    Colors.red,
                    onTap: () {
                      Get.to(
                        () => const LeaveScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _buildActionItem(
                    context,
                    Icons.receipt_long,
                    'Submit\nExpense',
                    Colors.green,
                    onTap: () {
                      Get.to(
                        () => const ExpensesScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _buildActionItem(
                    context,
                    Icons.request_page,
                    'View\nPayslip',
                    Colors.redAccent,
                    onTap: () {
                      Get.to(
                        () => const PayrollScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _buildActionItem(
                    context,
                    Icons.play_arrow,
                    'Start\nTask',
                    Colors.blue,
                    onTap: () {
                      Get.to(
                        () => const TaskMenuScreen(),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(24)),

            // Pending Tasks
            _staggered(
              4,
              Row(
                children: [
                  Text(
                    'Pending Tasks ',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Responsive.sp(16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.w(6),
                      vertical: Responsive.h(2),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8C52FF).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Responsive.r(10)),
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: const Color(0xFF8C52FF),
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(12)),
            _staggered(
              5,
              Container(
                padding: EdgeInsets.all(Responsive.w(16)),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(Responsive.r(12)),
                  color: theme.brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wiring Dashboard Analytics',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: Responsive.sp(15),
                      ),
                    ),
                    SizedBox(height: Responsive.h(12)),
                    Row(
                      children: [
                        _buildTag(
                          'In Progress',
                          Colors.grey.shade200,
                          Colors.black87,
                        ),
                        SizedBox(width: Responsive.w(8)),
                        _buildTag('High', Colors.red.shade100, Colors.red),
                      ],
                    ),
                    SizedBox(height: Responsive.h(12)),
                    LinearProgressIndicator(
                      value: 0.4,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF8C52FF),
                      minHeight: Responsive.h(5),
                      borderRadius: BorderRadius.circular(Responsive.r(10)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Responsive.h(24)),

            // Leave Balance
            _staggered(
              6,
              Text(
                'Leave Balance',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: Responsive.sp(16),
                ),
              ),
            ),
            SizedBox(height: Responsive.h(12)),
            _staggered(
              7,
              Row(
                children: [
                  Expanded(
                    child: _buildLeaveCard(
                      context,
                      'Available',
                      '20',
                      Colors.green,
                    ),
                  ),
                  SizedBox(width: Responsive.w(16)),
                  Expanded(
                    child: _buildLeaveCard(
                      context,
                      'Leave Used',
                      '2',
                      const Color(0xFF8C52FF),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(24)),

            // Performance Score
            _staggered(
              8,
              Text(
                'Performance Score',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: Responsive.sp(16),
                ),
              ),
            ),
            SizedBox(height: Responsive.h(16)),
            _staggered(
              9,
              _buildPerformanceRow('Attendance Rate (92%)', 0.92, Colors.green),
            ),
            SizedBox(height: Responsive.h(12)),
            _staggered(
              10,
              _buildPerformanceRow('Task Completion (30%)', 0.30, Colors.green),
            ),
            SizedBox(height: Responsive.h(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return AnimatedQuickAction(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(10),
        vertical: Responsive.h(4),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: Responsive.sp(12),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLeaveCard(
    BuildContext context,
    String title,
    String count,
    Color dotColor,
  ) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: Responsive.w(4), backgroundColor: dotColor),
              SizedBox(width: Responsive.w(8)),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: Responsive.sp(12),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(8)),
          Text(
            count,
            style: TextStyle(
              fontSize: Responsive.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceRow(String title, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: Responsive.sp(12), color: Colors.grey),
        ),
        SizedBox(height: Responsive.h(8)),
        Row(
          children: [
            Icon(Icons.face, color: color, size: Responsive.w(24)),
            SizedBox(width: Responsive.w(8)),
            Expanded(
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.shade200,
                color: color,
                minHeight: Responsive.h(6),
                borderRadius: BorderRadius.circular(Responsive.r(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AnimatedQuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const AnimatedQuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  State<AnimatedQuickAction> createState() => _AnimatedQuickActionState();
}

class _AnimatedQuickActionState extends State<AnimatedQuickAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: EdgeInsets.all(Responsive.w(18)),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(Responsive.r(16)),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade200,
                ),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
                size: Responsive.w(34),
              ),
            ),
          ),
          SizedBox(height: Responsive.h(10)),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Responsive.sp(13),
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.9)
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
