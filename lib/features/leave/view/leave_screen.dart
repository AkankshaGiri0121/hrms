import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: theme.appBarTheme.foregroundColor,
              size: Responsive.w(22)),
          onPressed: () => Get.back(),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Leave & Absence',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(22),
                                ),
                              ),
                              SizedBox(height: Responsive.h(4)),
                              Text(
                                'Manage your time off and balance',
                                style: TextStyle(
                                  color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade600,
                                  fontSize: Responsive.sp(13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showApplyLeaveModal(context, isDark),
                          icon: Icon(Icons.add, size: Responsive.w(16), color: isDark ? Colors.black : Colors.white),
                          label: Text('Apply Leave', style: TextStyle(color: isDark ? Colors.black : Colors.white, fontSize: Responsive.sp(12), fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(8))),
                            backgroundColor: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.h(24)),
                    
                    // Balance Card
                    _buildBalanceCard(isDark),
                    SizedBox(height: Responsive.h(24)),
                    
                    // Upcoming Leave Card
                    _buildUpcomingLeaveCard(isDark),
                    SizedBox(height: Responsive.h(32)),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                  indicator: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(Responsive.r(8)),
                  ),
                  labelColor: isDark ? Colors.white : Colors.black,
                  unselectedLabelColor: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600,
                  dividerColor: Colors.transparent,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: Responsive.sp(12)),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: Responsive.sp(12)),
                  tabs: [
                    _buildTab('Leave History'),
                    _buildTab('Calendar'),
                    _buildTab('Holidays'),
                    _buildTab('Leave Rules'),
                  ],
                ),
                isDark,
                theme.scaffoldBackgroundColor,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildLeaveHistoryTab(isDark, theme),
            _buildCalendarTab(isDark, theme),
            _buildHolidaysTab(isDark, theme),
            _buildLeaveRulesTab(isDark, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16)),
      child: Tab(text: text),
    );
  }

  Widget _buildBalanceCard(bool isDark) {
    return Container(
      width: Responsive.w(300),
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(10)),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(Responsive.r(8)),
            ),
            child: Icon(Icons.calendar_today, size: Responsive.w(18), color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade600),
          ),
          SizedBox(height: Responsive.h(16)),
          Text(
            'NEW LEAVE RULE',
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: Responsive.h(4)),
          Text(
            '3',
            style: TextStyle(
              fontSize: Responsive.sp(28),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: Responsive.h(8)),
          Text(
            '1/1 LEFT THIS MONTH • 3/12 ACCRUED',
            style: TextStyle(
              fontSize: Responsive.sp(9),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingLeaveCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month_outlined, size: Responsive.w(16), color: Colors.blue),
              SizedBox(width: Responsive.w(8)),
              Text(
                'Upcoming Leave',
                style: TextStyle(
                  fontSize: Responsive.sp(14),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: Responsive.h(24)),
            // Dashed border effect using normal solid border since native dashes aren't quick
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.withValues(alpha: 0.05) : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(Responsive.r(8)),
              border: Border.all(
                color: Colors.blue.withValues(alpha: 0.3),
                style: BorderStyle.solid, 
              ),
            ),
            child: Center(
              child: Text(
                'No upcoming leave scheduled.',
                style: TextStyle(
                  fontSize: Responsive.sp(12),
                  color: Colors.blue.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveHistoryTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      child: Container(
        padding: EdgeInsets.all(Responsive.w(20)),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A24) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(16)),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Leave History',
                  style: TextStyle(
                    fontSize: Responsive.sp(16),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download_rounded, size: Responsive.w(14), color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black54),
                  label: Text('Export Report', style: TextStyle(color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black54, fontSize: Responsive.sp(11))),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(8))),
                    side: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.h(24)),
            
            _buildHistoryItem(
              isDark: isDark,
              ruleName: 'New Leave Rule',
              dates: '17 Apr 2026 - 17 Apr 2026',
              reason: '"xzxzxc"',
              duration: '1 DAY • APPLIED: 16 APR',
              status: 'REJECTED',
              statusColor: Colors.red,
              icon: Icons.error_outline,
            ),
            SizedBox(height: Responsive.h(16)),
            _buildHistoryItem(
              isDark: isDark,
              ruleName: 'New Leave Rule',
              dates: '08 Apr 2026 - 08 Apr 2026',
              reason: '"asdfasdfasdf"',
              duration: '1 DAY • APPLIED: 01 APR',
              status: 'PENDING',
              statusColor: Colors.orange,
              icon: Icons.access_time,
            ),
            SizedBox(height: Responsive.h(16)),
            _buildHistoryItem(
              isDark: isDark,
              ruleName: 'New Leave Rule',
              dates: '03 Apr 2026 - 04 Apr 2026',
              reason: '"sdfasdfasdf"',
              duration: '1 DAY • APPLIED: 31 MAR',
              status: 'PENDING',
              statusColor: Colors.orange,
              icon: Icons.access_time,
            ),
            SizedBox(height: Responsive.h(16)),
            _buildHistoryItem(
              isDark: isDark,
              ruleName: 'New Leave Rule',
              dates: '31 Mar 2026 - 01 Apr 2026',
              reason: '"asfdslfdl"',
              duration: '1 DAY • APPLIED: 31 MAR',
              status: 'REJECTED',
              statusColor: Colors.red,
              icon: Icons.error_outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required bool isDark,
    required String ruleName,
    required String dates,
    required String reason,
    required String duration,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(10)),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: Responsive.w(18), color: statusColor),
          ),
          SizedBox(width: Responsive.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ruleName,
                  style: TextStyle(
                    fontSize: Responsive.sp(14),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: Responsive.h(4)),
                Text(
                  dates,
                  style: TextStyle(
                    fontSize: Responsive.sp(12),
                    color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: Responsive.h(4)),
                Text(
                  reason,
                  style: TextStyle(
                    fontSize: Responsive.sp(11),
                    color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: Responsive.h(8)),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                status,
                style: TextStyle(
                  fontSize: Responsive.sp(10),
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              SizedBox(width: Responsive.w(8)),
              Icon(Icons.chevron_right, size: Responsive.w(16), color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.grey.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, bool isDark) {
    return Center(
      child: Text(
        '$title coming soon',
        style: TextStyle(color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500),
      ),
    );
  }

  Widget _buildHolidaysTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      child: Container(
        padding: EdgeInsets.all(Responsive.w(20)),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A24) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(16)),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company Holidays',
              style: TextStyle(
                fontSize: Responsive.sp(16),
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: Responsive.h(4)),
            Text(
              'Official holidays for 2026',
              style: TextStyle(
                fontSize: Responsive.sp(11),
                color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500,
              ),
            ),
            SizedBox(height: Responsive.h(24)),
            LayoutBuilder(
              builder: (context, constraints) {
                // If it's very narrow, do 1 column, otherwise 2
                final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                final width = constraints.maxWidth;
                final childAspectRatio = crossAxisCount == 2 
                    ? (width / 2) / Responsive.h(90) 
                    : width / Responsive.h(90);

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: Responsive.w(16),
                  mainAxisSpacing: Responsive.h(16),
                  childAspectRatio: childAspectRatio,
                  children: [
                    _buildHolidayCard('APR', '15', 'office party', 'Wednesday', 'dhhhhchcdhhhchbdhbc', isDark),
                    _buildHolidayCard('APR', '24', 'check', 'Friday', 'wsdws', isDark),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHolidayCard(String month, String day, String title, String weekday, String subtitle, bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(12)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(8)),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(Responsive.r(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    fontSize: Responsive.sp(9),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: Responsive.h(2)),
                Text(
                  day,
                  style: TextStyle(
                    fontSize: Responsive.sp(16),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Responsive.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Responsive.sp(13),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Responsive.h(2)),
                Text(
                  weekday,
                  style: TextStyle(
                    fontSize: Responsive.sp(11),
                    color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: Responsive.h(2)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey.shade500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRulesTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      child: Center(
        child: Container(
          width: Responsive.w(450),
          padding: EdgeInsets.all(Responsive.w(24)),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A24) : Colors.white,
            borderRadius: BorderRadius.circular(Responsive.r(16)),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(Responsive.w(12)),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.blue.withValues(alpha: 0.1) : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(Responsive.r(12)),
                        ),
                        child: Icon(Icons.menu_book_rounded, size: Responsive.w(20), color: Colors.blue),
                      ),
                      SizedBox(width: Responsive.w(16)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NEW LEAVE RULE',
                            style: TextStyle(
                              fontSize: Responsive.sp(12),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: Responsive.h(4)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '3',
                                style: TextStyle(
                                  fontSize: Responsive.sp(24),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(width: Responsive.w(6)),
                              Text(
                                'Left',
                                style: TextStyle(
                                  fontSize: Responsive.sp(14),
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white.withValues(alpha: 0.8) : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Responsive.h(4)),
                          Text(
                            '3/12 ACCRUED',
                            style: TextStyle(
                              fontSize: Responsive.sp(10),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(4)),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(Responsive.r(4)),
                    ),
                    child: Text(
                      '12/YR',
                      style: TextStyle(
                        fontSize: Responsive.sp(10),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(24)),
              Container(
                padding: EdgeInsets.all(Responsive.w(20)),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF13131A) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(Responsive.r(12)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRuleDetailItem('Accrued so far', '3/12', isDark),
                          _buildRuleDetailItem('Approved this month', '0/1', isDark),
                          _buildRuleDetailItem('Limit', '1/mo', isDark),
                          _buildRuleDetailItem('Advance', 'up to 30d', isDark),
                          _buildRuleDetailItem('Allowed in probation', '', isDark, isBool: true),
                        ],
                      ),
                    ),
                    SizedBox(width: Responsive.w(16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRuleDetailItem('Monthly left', '1', isDark),
                          _buildRuleDetailItem('Accrual', '1/mo', isDark),
                          _buildRuleDetailItem('Max 10 consecutive', '', isDark, isBool: true),
                          _buildRuleDetailItem('Backdate', 'up to 7d', isDark),
                          _buildRuleDetailItem('No carry forward', '', isDark, isBool: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleDetailItem(String label, String value, bool isDark, {bool isBool = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.h(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: Responsive.h(6)),
            width: Responsive.w(4),
            height: Responsive.w(4),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey.shade500,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: Responsive.w(8)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: Responsive.sp(12),
                  color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.grey.shade700,
                ),
                children: [
                  TextSpan(text: label),
                  if (!isBool) TextSpan(text: ': $value', style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      child: Container(
        padding: EdgeInsets.all(Responsive.w(20)),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A24) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(16)),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave Calendar',
              style: TextStyle(
                fontSize: Responsive.sp(16),
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: Responsive.h(4)),
            Text(
              'Overview of your scheduled time off and company holidays',
              style: TextStyle(
                fontSize: Responsive.sp(11),
                color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500,
              ),
            ),
            SizedBox(height: Responsive.h(24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'May 2026',
                  style: TextStyle(
                    fontSize: Responsive.sp(16),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    _buildCalendarIconButton(Icons.chevron_left, isDark),
                    SizedBox(width: Responsive.w(8)),
                    _buildCalendarIconButton(Icons.chevron_right, isDark),
                  ],
                ),
              ],
            ),
            SizedBox(height: Responsive.h(24)),
            _buildCalendarGrid(isDark),
            SizedBox(height: Responsive.h(32)),
            Row(
              children: [
                _buildLegendItem(Colors.blue, 'HOLIDAY', isDark),
                SizedBox(width: Responsive.w(16)),
                _buildLegendItem(Colors.green, 'APPROVED', isDark),
                SizedBox(width: Responsive.w(16)),
                _buildLegendItem(Colors.orange, 'PENDING', isDark),
                SizedBox(width: Responsive.w(16)),
                _buildLegendItem(Colors.white, 'TODAY', isDark, isOutlined: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarIconButton(IconData icon, bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(6)),
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(Responsive.r(6)),
      ),
      child: Icon(icon, size: Responsive.w(14), color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black87),
    );
  }

  Widget _buildLegendItem(Color color, String text, bool isDark, {bool isOutlined = false}) {
    return Row(
      children: [
        Container(
          width: Responsive.w(8),
          height: Responsive.w(8),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.transparent : color,
            border: isOutlined ? Border.all(color: isDark ? Colors.white : Colors.black, width: 2) : null,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: Responsive.w(6)),
        Text(
          text,
          style: TextStyle(
            fontSize: Responsive.sp(9),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(bool isDark) {
    final daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    final calendarDays = [
      '26', '27', '28', '29', '30', '1', '2',
      '3', '4', '5', '6', '7', '8', '9',
      '10', '11', '12', '13', '14', '15', '16',
      '17', '18', '19', '20', '21', '22', '23',
      '24', '25', '26', '27', '28', '29', '30',
      '31', '1', '2', '3', '4', '5', '6'
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // Accounting for spacing (6 gaps of 8px)
        final totalSpacing = Responsive.w(8) * 6;
        final cellWidth = (availableWidth - totalSpacing) / 7;
        final cellHeight = cellWidth * 0.7; // Aspect ratio

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: daysOfWeek.map((day) {
                return SizedBox(
                  width: cellWidth,
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: Responsive.sp(10),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey.shade500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: Responsive.h(16)),
            Wrap(
              spacing: Responsive.w(8),
              runSpacing: Responsive.h(8),
              children: List.generate(calendarDays.length, (index) {
                final day = calendarDays[index];
                final isOtherMonth = index < 5 || index > 35; // Rough approximation for this specific view
                final isSelected = day == '2' && !isOtherMonth;
                
                return Container(
                  width: cellWidth,
                  height: cellHeight,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
                    borderRadius: BorderRadius.circular(Responsive.r(8)),
                    border: Border.all(
                      color: isSelected 
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isDark ? [] : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: Responsive.sp(12),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isOtherMonth 
                            ? (isDark ? Colors.white.withValues(alpha: 0.2) : Colors.grey.shade400)
                            : (isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black87),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  void _showApplyLeaveModal(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(Responsive.w(20)),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: Responsive.w(400)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF13131A) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(16)),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(Responsive.w(20)),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Leave Request',
                        style: TextStyle(
                          fontSize: Responsive.sp(16),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(Responsive.w(6)),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(Responsive.r(6)),
                          ),
                          child: Icon(Icons.close, size: Responsive.w(16), color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Padding(
                  padding: EdgeInsets.all(Responsive.w(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LEAVE TYPE', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600)),
                      SizedBox(height: Responsive.h(8)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(14)),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
                          border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(Responsive.r(8)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('New Leave Rule (1 day available now, 3 days total left)', 
                                  style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            SizedBox(width: Responsive.w(8)),
                            Icon(Icons.keyboard_arrow_down, size: Responsive.w(16), color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600),
                          ],
                        ),
                      ),
                      SizedBox(height: Responsive.h(8)),
                      Text('1 day available to apply now. 3 days total left, 1 day left this month.', 
                          style: TextStyle(fontSize: Responsive.sp(10), color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey.shade500)),
                      SizedBox(height: Responsive.h(24)),
                      
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('FROM DATE', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600)),
                                SizedBox(height: Responsive.h(8)),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
                                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(Responsive.r(8)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('mm/dd/yyyy', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w500, color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade600)),
                                      Icon(Icons.calendar_today_outlined, size: Responsive.w(14), color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Responsive.w(16)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TO DATE', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600)),
                                SizedBox(height: Responsive.h(8)),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
                                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(Responsive.r(8)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('mm/dd/yyyy', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w500, color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade600)),
                                      Icon(Icons.calendar_today_outlined, size: Responsive.w(14), color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(24)),
                      
                      Text('REASON', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600)),
                      SizedBox(height: Responsive.h(8)),
                      Container(
                        height: Responsive.h(80),
                        width: double.infinity,
                        padding: EdgeInsets.all(Responsive.w(16)),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
                          border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(Responsive.r(8)),
                        ),
                        child: Text('Brief explanation...', style: TextStyle(fontSize: Responsive.sp(12), color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.grey.shade400)),
                      ),
                    ],
                  ),
                ),
                // Footer Buttons
                Container(
                  padding: EdgeInsets.all(Responsive.w(20)),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Responsive.r(16)),
                      bottomRight: Radius.circular(Responsive.r(16)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: Responsive.h(14)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(8))),
                            side: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
                            backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                          ),
                          child: Text('Cancel', style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        ),
                      ),
                      SizedBox(width: Responsive.w(16)),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.white : Colors.black,
                            foregroundColor: isDark ? Colors.black : Colors.white,
                            padding: EdgeInsets.symmetric(vertical: Responsive.h(14)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(8))),
                          ),
                          child: Text('Submit Request', style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this._isDark, this._backgroundColor);

  final TabBar _tabBar;
  final bool _isDark;
  final Color _backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height + Responsive.h(16);
  @override
  double get maxExtent => _tabBar.preferredSize.height + Responsive.h(16);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _backgroundColor,
      padding: EdgeInsets.only(bottom: Responsive.h(16)),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
