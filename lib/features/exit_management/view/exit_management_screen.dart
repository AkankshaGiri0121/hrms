import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class ExitManagementScreen extends StatefulWidget {
  final bool showBackButton;
  const ExitManagementScreen({super.key, this.showBackButton = true});

  @override
  State<ExitManagementScreen> createState() => _ExitManagementScreenState();
}

class _ExitManagementScreenState extends State<ExitManagementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Separation Requests',
    'Exit Interviews',
    'Full & Final',
    'Exit Analytics',
  ];

  final List<String> _hrTasks = [
    'Accept resignation letter',
    'Calculate notice period',
    'Schedule exit interview',
    'Process final settlement',
    'Issue experience certificate',
  ];

  final List<String> _itTasks = [
    'Revoke system access',
    'Collect company assets',
    'Disable email account',
    'Retrieve ID card',
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF13131A) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade200;
    final subText = isDark ? Colors.white38 : Colors.grey.shade500;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: widget.showBackButton,
        titleSpacing: widget.showBackButton ? 0 : Responsive.w(24),
        leading: widget.showBackButton
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, color: isDark ? Colors.white : Colors.black, size: Responsive.w(22)),
                onPressed: () => Get.back(),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exit Management', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: Responsive.sp(22))),
            Text('Separations, interviews & offboarding.', style: TextStyle(fontSize: Responsive.sp(10), color: subText)),
          ],
        ),
        actions: [
          _buildAnimated(0, child: GestureDetector(
            onTap: () => _showInitiateExitDialog(isDark, cardBg, borderColor, subText),
            child: Container(
              margin: EdgeInsets.only(right: Responsive.w(16)),
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(10)),
              decoration: BoxDecoration(color: isDark ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(Responsive.r(8))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add, color: isDark ? Colors.black : Colors.white, size: Responsive.w(14)),
                SizedBox(width: Responsive.w(4)),
                Text('Initiate Exit', style: TextStyle(color: isDark ? Colors.black : Colors.white, fontSize: Responsive.sp(11), fontWeight: FontWeight.bold)),
              ]),
            ),
          )),
        ],
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Stat Cards (2x2 Grid) ───
          SliverToBoxAdapter(
            child: _buildAnimated(1, child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
              child: Column(children: [
                Row(children: [
                  _statCard('Pending Exits', '0', Icons.access_time_rounded, Colors.amber, isDark, cardBg, borderColor),
                  SizedBox(width: Responsive.w(12)),
                  _statCard('Exit Interviews', '0', Icons.chat_bubble_outline_rounded, Colors.blue, isDark, cardBg, borderColor),
                ]),
                SizedBox(height: Responsive.h(12)),
                Row(children: [
                  _statCard('Pending Settlements', '0', Icons.currency_rupee_rounded, Colors.pink, isDark, cardBg, borderColor),
                  SizedBox(width: Responsive.w(12)),
                  _statCard('Total Exits (YTD)', '0', Icons.logout_rounded, subText, isDark, cardBg, borderColor),
                ]),
              ]),
            )),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Navigation Tabs (Horizontally Scrollable) ───
          SliverToBoxAdapter(
            child: _buildAnimated(2, child: SizedBox(
              height: Responsive.h(42),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => SizedBox(width: Responsive.w(8)),
                itemBuilder: (_, index) {
                  final isSelected = _selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20), vertical: Responsive.h(10)),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black)
                            : (isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(Responsive.r(20)),
                        border: Border.all(color: isSelected ? Colors.transparent : borderColor),
                      ),
                      child: Center(
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            fontSize: Responsive.sp(12),
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? (isDark ? Colors.white : Colors.white)
                                : subText,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Main Content Area (Separation Requests) ───
          SliverToBoxAdapter(
            child: _buildAnimated(3, child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(Responsive.r(16)),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.all(Responsive.w(20)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Employee Separations', style: TextStyle(fontSize: Responsive.sp(17), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        SizedBox(height: Responsive.h(4)),
                        Text('Track and manage resignation and termination requests.', style: TextStyle(fontSize: Responsive.sp(11), color: subText)),
                      ]),
                    ),
                    Divider(height: 1, color: borderColor),
                    // Empty State
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: Responsive.h(60)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(Responsive.w(20)),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person_off_outlined, size: Responsive.w(36), color: subText),
                          ),
                          SizedBox(height: Responsive.h(16)),
                          Text('No Separation Requests', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black54)),
                          SizedBox(height: Responsive.h(6)),
                          Text('All clear! No pending resignations or terminations.', style: TextStyle(fontSize: Responsive.sp(11), color: subText)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(24))),

          // ─── Exit Checklist Section ───
          SliverToBoxAdapter(
            child: _buildAnimated(4, child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
              child: Container(
                padding: EdgeInsets.all(Responsive.w(20)),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(Responsive.r(16)),
                  border: Border.all(color: borderColor),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Exit Checklist', style: TextStyle(fontSize: Responsive.sp(17), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  SizedBox(height: Responsive.h(4)),
                  Text('STANDARD EXIT PROCESS TASK TRACKING', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText, letterSpacing: 1.0)),
                  SizedBox(height: Responsive.h(24)),

                  // ─── HR Tasks ───
                  Text('HR TASKS', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87)),
                  SizedBox(height: Responsive.h(12)),
                  ..._hrTasks.map((t) => _checklistItem(t, isDark, borderColor, subText)),

                  SizedBox(height: Responsive.h(24)),

                  // ─── IT & Admin Tasks ───
                  Text('IT & ADMIN TASKS', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87)),
                  SizedBox(height: Responsive.h(12)),
                  ..._itTasks.map((t) => _checklistItem(t, isDark, borderColor, subText)),
                ]),
              ),
            )),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(60))),
        ],
      ),
    );
  }

  // ─── Stat Card (2x2 friendly) ───
  Widget _statCard(String title, String value, IconData icon, Color color, bool isDark, Color bg, Color border) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(18)),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Responsive.r(14)),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.w700, color: isDark ? Colors.white38 : Colors.grey.shade600, letterSpacing: 0.3)),
                SizedBox(height: Responsive.h(6)),
                Text(value, style: TextStyle(fontSize: Responsive.sp(26), fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87)),
              ]),
            ),
            Container(
              padding: EdgeInsets.all(Responsive.w(8)),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Responsive.r(10)),
              ),
              child: Icon(icon, size: Responsive.w(18), color: color),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Checklist Item ───
  Widget _checklistItem(String title, bool isDark, Color border, Color sub) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(10)),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(16)),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(10)),
        border: Border.all(color: border),
      ),
      child: Row(children: [
        Container(
          width: Responsive.w(20),
          height: Responsive.w(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: sub, width: 1.5),
          ),
          child: Icon(Icons.check_rounded, size: Responsive.w(12), color: sub),
        ),
        SizedBox(width: Responsive.w(14)),
        Expanded(
          child: Text(title, style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
        ),
      ]),
    );
  }

  // ─── Staggered Entrance Animation ───
  Widget _buildAnimated(int i, {required Widget child}) {
    final delay = (i * 0.1).clamp(0.0, 0.7);
    final end = (delay + 0.3).clamp(0.0, 1.0);
    final curved = CurvedAnimation(parent: _anim, curve: Interval(delay, end, curve: Curves.easeOutCubic));
    return AnimatedBuilder(
      animation: curved,
      builder: (_, __) => Opacity(
        opacity: curved.value,
        child: Transform.translate(offset: Offset(0, 24 * (1 - curved.value)), child: child),
      ),
    );
  }

  // ─── Initiate Exit Dialog ───
  void _showInitiateExitDialog(bool isDark, Color bg, Color border, Color sub) {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Responsive.w(360),
            constraints: BoxConstraints(maxHeight: Responsive.h(620)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A24) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(16)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40)],
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Responsive.w(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // ─── Header ───
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Initiate Exit Process', style: TextStyle(fontSize: Responsive.sp(18), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    SizedBox(height: Responsive.h(4)),
                    Text('Start the offboarding sequence for an employee.', style: TextStyle(fontSize: Responsive.sp(11), color: sub)),
                  ]),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(Responsive.w(6)),
                      decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey.shade200, borderRadius: BorderRadius.circular(Responsive.r(6))),
                      child: Icon(Icons.close, size: Responsive.w(18), color: isDark ? Colors.white54 : Colors.grey),
                    ),
                  ),
                ]),
                SizedBox(height: Responsive.h(28)),

                // ─── Employee Dropdown ───
                _dialogLabel('EMPLOYEE', true, isDark, sub),
                SizedBox(height: Responsive.h(8)),
                _dialogDropdown('Preeti Singh (EMP004)', isDark, border),
                SizedBox(height: Responsive.h(20)),

                // ─── Dates Row ───
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _dialogLabel('RESIGNATION DATE', true, isDark, sub),
                    SizedBox(height: Responsive.h(8)),
                    _dialogDateField('mm/dd/yyyy', isDark, border, sub),
                  ])),
                  SizedBox(width: Responsive.w(16)),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _dialogLabel('LAST WORKING DAY', true, isDark, sub),
                    SizedBox(height: Responsive.h(8)),
                    _dialogDateField('mm/dd/yyyy', isDark, border, sub),
                  ])),
                ]),
                SizedBox(height: Responsive.h(20)),

                // ─── Notice Period & Reason Row ───
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _dialogLabel('NOTICE PERIOD (DAYS)', true, isDark, sub),
                    SizedBox(height: Responsive.h(8)),
                    _dialogTextField('30', isDark, border),
                  ])),
                  SizedBox(width: Responsive.w(16)),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _dialogLabel('PRIMARY REASON', true, isDark, sub),
                    SizedBox(height: Responsive.h(8)),
                    _dialogDropdown('Select Reason', isDark, border),
                  ])),
                ]),
                SizedBox(height: Responsive.h(20)),

                // ─── Detailed Remarks ───
                _dialogLabel('DETAILED REMARKS', false, isDark, sub),
                SizedBox(height: Responsive.h(8)),
                Container(
                  height: Responsive.h(100),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(12)),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(Responsive.r(10)),
                    border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
                  ),
                  child: Text('Add any additional notes...', style: TextStyle(fontSize: Responsive.sp(12), color: sub)),
                ),
                SizedBox(height: Responsive.h(28)),

                // ─── Action Buttons ───
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24), vertical: Responsive.h(14)),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(Responsive.r(8)),
                      ),
                      child: Text('Cancel', style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                    ),
                  ),
                  SizedBox(width: Responsive.w(12)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(24), vertical: Responsive.h(14)),
                    decoration: BoxDecoration(color: isDark ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(Responsive.r(8))),
                    child: Text('Initiate', style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.bold, color: isDark ? Colors.black : Colors.white)),
                  ),
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogLabel(String text, bool required, bool isDark, Color sub) {
    return Row(children: [
      Text(text, style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white54 : Colors.grey.shade600, letterSpacing: 0.5)),
      if (required) Text(' *', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: Colors.red)),
    ]);
  }

  Widget _dialogDropdown(String value, bool isDark, Color border) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(14)),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(10)),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: Row(children: [
        Expanded(child: Text(value, style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87))),
        Icon(Icons.keyboard_arrow_down_rounded, size: Responsive.w(18), color: isDark ? Colors.white38 : Colors.grey),
      ]),
    );
  }

  Widget _dialogDateField(String hint, bool isDark, Color border, Color sub) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(14)),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(10)),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: Row(children: [
        Expanded(child: Text(hint, style: TextStyle(fontSize: Responsive.sp(13), color: sub))),
        Icon(Icons.calendar_today_outlined, size: Responsive.w(14), color: sub),
      ]),
    );
  }

  Widget _dialogTextField(String value, bool isDark, Color border) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(14)),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(10)),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: Text(value, style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
    );
  }
}
