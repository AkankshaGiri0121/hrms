import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attendance',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(22),
                              ),
                            ),
                            SizedBox(height: Responsive.h(4)),
                            Text(
                              'Track time & shifts',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : Colors.grey.shade600,
                                fontSize: Responsive.sp(13),
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.download_rounded,
                              size: Responsive.w(16),
                              color: isDark ? Colors.white : Colors.black),
                          label: Text('Export Report',
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: Responsive.sp(12))),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: Responsive.w(16),
                                vertical: Responsive.h(12)),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Responsive.r(8))),
                            side: BorderSide(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.2)
                                    : Colors.grey.shade300),
                            backgroundColor: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.h(24)),
                    // Clock In Card
                    _buildClockInCard(isDark),
                    SizedBox(height: Responsive.h(16)),
                    // Summary Cards
                    _buildSummaryCards(isDark),
                    SizedBox(height: Responsive.h(24)),
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
                  indicatorColor: AppColors.primary,
                  indicatorWeight: Responsive.h(3),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.grey.shade600,
                  dividerColor: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade200,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Responsive.sp(13)),
                  unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: Responsive.sp(13)),
                  tabs: const [
                    Tab(text: 'Daily Log'),
                    Tab(text: 'Monthly Log'),
                    Tab(text: 'Regularization'),
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
            _buildDailyLogTab(isDark, theme),
            _buildMonthlyLogTab(isDark, theme),
            _buildRegularizationTab(isDark, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildClockInCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(24)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade200,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '08:41 PM',
                style: TextStyle(
                  fontSize: Responsive.sp(28),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(width: Responsive.w(12)),
              Container(
                margin: EdgeInsets.only(bottom: Responsive.h(4)),
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(8), vertical: Responsive.h(4)),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(Responsive.r(4)),
                ),
                child: Text(
                  'SAT, MAY 2',
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(8)),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: Responsive.w(14),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.grey.shade500),
              SizedBox(width: Responsive.w(6)),
              Expanded(
                child: Text(
                  'Corporate Office • OFFICE FULL TIME (10:00 - 18:30)',
                  style: TextStyle(
                    fontSize: Responsive.sp(12),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(Responsive.w(8)),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.access_time,
                        size: Responsive.w(16),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.grey.shade500),
                  ),
                  SizedBox(width: Responsive.w(12)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SESSION',
                        style: TextStyle(
                          fontSize: Responsive.sp(9),
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.4)
                              : Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: Responsive.h(2)),
                      Text(
                        '00:00:00',
                        style: TextStyle(
                          fontSize: Responsive.sp(16),
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.9)
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.play_circle_fill_rounded,
                    size: Responsive.w(18), color: Colors.white),
                label: Text(
                  'CLOCK IN',
                  style: TextStyle(
                      fontSize: Responsive.sp(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2962FF),
                  padding: EdgeInsets.symmetric(
                      horizontal: Responsive.w(20), vertical: Responsive.h(14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Responsive.r(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust for responsive grid
        int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        double childAspectRatio = constraints.maxWidth > 600 ? 2.2 : 1.5;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: Responsive.w(12),
          crossAxisSpacing: Responsive.w(12),
          childAspectRatio: childAspectRatio,
          children: [
            _buildStatCard('WEEKLY', '-', isDark,
                icon: Icons.trending_up, iconColor: Colors.green),
            _buildStatCard('MONTHLY', '-', isDark,
                icon: Icons.trending_up, iconColor: Colors.blue),
            _buildStatCard('OVERTIME', '-', isDark,
                icon: Icons.schedule,
                iconColor: Colors.orange,
                subtitle: '> 8.5H/DAY'),
            _buildStatCard('ATTENDANCE', '0%', isDark,
                icon: Icons.check_circle_outline,
                iconColor: Colors.purple,
                subtitle: 'PRESENT RATE'),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, bool isDark,
      {required IconData icon,
      required Color iconColor,
      String? subtitle}) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade200,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Responsive.sp(10),
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: Responsive.w(14), color: iconColor),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: Responsive.sp(22),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: Responsive.h(4)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: Responsive.sp(9),
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.grey.shade500,
                  ),
                ),
              ] else ...[
                SizedBox(height: Responsive.h(8)),
                Container(
                  height: Responsive.h(4),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(Responsive.r(2)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // --- Tab 1: Daily Log ---
  Widget _buildDailyLogTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      child: Container(
        padding: EdgeInsets.all(Responsive.w(20)),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A24) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(16)),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Responsive.w(16),
              runSpacing: Responsive.h(16),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(Responsive.w(8)),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.info_outline,
                          size: Responsive.w(16),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.grey.shade600),
                    ),
                    SizedBox(width: Responsive.w(12)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Activity',
                          style: TextStyle(
                            fontSize: Responsive.sp(14),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          'TIMELINE & EVENT LOG',
                          style: TextStyle(
                            fontSize: Responsive.sp(9),
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.grey.shade500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIconButton(Icons.chevron_left, isDark),
                    SizedBox(width: Responsive.w(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(12),
                          vertical: Responsive.h(8)),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(Responsive.r(6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: Responsive.w(12),
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : Colors.grey.shade600),
                          SizedBox(width: Responsive.w(6)),
                          Text(
                            '05/02/2026',
                            style: TextStyle(
                              fontSize: Responsive.sp(12),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Responsive.w(8)),
                    _buildIconButton(Icons.chevron_right, isDark),
                  ],
                ),
              ],
            ),
            SizedBox(height: Responsive.h(60)),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(Responsive.w(16)),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.info_outline,
                        size: Responsive.w(24),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.grey.shade400),
                  ),
                  SizedBox(height: Responsive.h(16)),
                  Text(
                    'No Record Found',
                    style: TextStyle(
                      fontSize: Responsive.sp(16),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: Responsive.h(8)),
                  Text(
                    'There is no log for May 02, 2026.',
                    style: TextStyle(
                      fontSize: Responsive.sp(13),
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(60)),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(8)),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(Responsive.r(6)),
      ),
      child: Icon(icon,
          size: Responsive.w(16),
          color: isDark ? Colors.white : Colors.black87),
    );
  }

  // --- Tab 2: Monthly Log ---
  Widget _buildMonthlyLogTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      child: Container(
        padding: EdgeInsets.all(Responsive.w(20)),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A24) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(16)),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Reset Filter',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: Responsive.sp(12),
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Responsive.w(12), vertical: Responsive.h(8)),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(Responsive.r(6)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: Responsive.w(12),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.6)
                              : Colors.grey.shade600),
                      SizedBox(width: Responsive.w(6)),
                      Text('mm/dd/yyyy - mm/dd/yyyy',
                          style: TextStyle(
                              fontSize: Responsive.sp(12),
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.6)
                                  : Colors.grey.shade600)),
                      SizedBox(width: Responsive.w(6)),
                      Icon(Icons.calendar_today_outlined,
                          size: Responsive.w(12),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.6)
                              : Colors.grey.shade600),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.h(20)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultColumnWidth: FixedColumnWidth(Responsive.w(80)),
                columnWidths: {
                  0: FixedColumnWidth(Responsive.w(30)),
                  1: FixedColumnWidth(Responsive.w(90)),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.grey.shade300)),
                    ),
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Responsive.h(12)),
                          child: Icon(Icons.square_outlined,
                              size: Responsive.w(14),
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : Colors.grey.shade400)),
                      _buildHeaderCell('DATE', isDark),
                      _buildHeaderCell('IN TIME', isDark),
                      _buildHeaderCell('OUT TIME', isDark),
                      _buildHeaderCell('WORK DURATION', isDark),
                      _buildHeaderCell('OVERTIME', isDark),
                      _buildHeaderCell('BREAK DURATION', isDark),
                      _buildHeaderCell('STATUS', isDark),
                    ],
                  ),
                  _buildMonthlyTableRow(isDark, '24 Apr 2026', '10:00 AM',
                      '06:00 PM', '8h 0m', '-', '-', 'PRESENT'),
                  _buildMonthlyTableRow(isDark, '01 Apr 2026', '09:00 AM',
                      '06:00 PM', '9h 0m', '0h 30m', '-', 'PRESENT',
                      isOvertime: true),
                  _buildMonthlyTableRow(isDark, '30 Mar 2026', '04:02 PM',
                      '11:59 PM', '7h 58m', '-', '-', 'PRESENT'),
                  _buildMonthlyTableRow(isDark, '25 Mar 2026', '11:29 AM',
                      '11:59 PM', '12h 31m', '4h 1m', '-', 'PRESENT',
                      isOvertime: true),
                  _buildMonthlyTableRow(isDark, '24 Mar 2026', '06:51 PM',
                      '11:59 PM', '5h 8m', '-', '0h 1m', 'PRESENT'),
                  _buildMonthlyTableRow(isDark, '23 Mar 2026', '11:27 AM',
                      '06:46 PM', '7h 19m', '-', '-', 'PRESENT'),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Page 1 of 1',
                    style: TextStyle(
                        fontSize: Responsive.sp(12),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.grey.shade500)),
                Row(
                  children: [
                    _buildPaginationButton('Previous', isDark),
                    SizedBox(width: Responsive.w(8)),
                    _buildPaginationButton('Next', isDark),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationButton(String text, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(12), vertical: Responsive.h(8)),
      decoration: BoxDecoration(
        border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(Responsive.r(6)),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: Responsive.sp(12),
              color: isDark ? Colors.white : Colors.black87)),
    );
  }

  Widget _buildHeaderCell(String text, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Responsive.sp(9),
          fontWeight: FontWeight.bold,
          color: isDark
              ? Colors.white.withValues(alpha: 0.4)
              : Colors.grey.shade500,
        ),
      ),
    );
  }

  TableRow _buildMonthlyTableRow(bool isDark, String date, String inTime,
      String outTime, String duration, String overtime, String breakDur, String status,
      {bool isOvertime = false}) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.shade100)),
      ),
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
            child: Icon(Icons.square,
                size: Responsive.w(14),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.grey.shade300)),
        _buildDataCell(date, isDark, isBold: true),
        _buildDataCell(inTime, isDark),
        _buildDataCell(outTime, isDark),
        _buildDataCell(duration, isDark),
        _buildDataCell(overtime, isDark,
            textColor: isOvertime ? Colors.orange : null),
        _buildDataCell(breakDur, isDark),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(8), vertical: Responsive.h(4)),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(Responsive.r(4)),
              ),
              child: Text(status,
                  style: TextStyle(
                      fontSize: Responsive.sp(9),
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataCell(String text, bool isDark,
      {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Responsive.sp(12),
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: textColor ?? (isDark ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  // --- Tab 3: Regularization ---
  Widget _buildRegularizationTab(bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          if (isDesktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: _buildRegularizationForm(isDark, theme)),
                SizedBox(width: Responsive.w(16)),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _buildRequestOverview(isDark, theme),
                      SizedBox(height: Responsive.h(16)),
                      _buildRequestHistory(isDark, theme),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                _buildRegularizationForm(isDark, theme),
                SizedBox(height: Responsive.h(16)),
                _buildRequestOverview(isDark, theme),
                SizedBox(height: Responsive.h(16)),
                _buildRequestHistory(isDark, theme),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildRegularizationForm(bool isDark, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A24) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(8)),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.schedule,
                    size: Responsive.w(16),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.grey.shade600),
              ),
              SizedBox(width: Responsive.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance Regularization',
                      style: TextStyle(
                        fontSize: Responsive.sp(14),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      'Submit a correction if you missed a punch or your working hours were recorded incorrectly.',
                      style: TextStyle(
                        fontSize: Responsive.sp(11),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),
          Row(
            children: [
              Expanded(child: _buildInputField('DATE', '05/02/2026', Icons.calendar_today_outlined, isDark)),
              SizedBox(width: Responsive.w(12)),
              Expanded(child: _buildInputField('ACTUAL IN TIME', '--:-- --', Icons.access_time, isDark)),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInputField('ACTUAL OUT TIME', '--:-- --', Icons.access_time, isDark)),
              SizedBox(width: Responsive.w(12)),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(Responsive.w(12)),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B2236) : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(Responsive.r(8)),
                    border: Border.all(color: isDark ? Colors.blue.withValues(alpha: 0.3) : Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: Responsive.w(14), color: Colors.blue),
                          SizedBox(width: Responsive.w(6)),
                          Text('Approval flow', style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                      SizedBox(height: Responsive.h(4)),
                      Text('HR receives this request in the admin queue and can approve or reject it.', style: TextStyle(fontSize: Responsive.sp(10), color: isDark ? Colors.blue.shade100 : Colors.blue.shade800)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          Text('REASON', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600)),
          SizedBox(height: Responsive.h(6)),
          Container(
            height: Responsive.h(80),
            padding: EdgeInsets.all(Responsive.w(12)),
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(Responsive.r(8)),
            ),
            child: Text('Explain why your attendance needs correction...', style: TextStyle(fontSize: Responsive.sp(12), color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.grey.shade400)),
          ),
          SizedBox(height: Responsive.h(24)),
          Divider(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200),
          SizedBox(height: Responsive.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Approved requests update your record immediately.', style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500))),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(20), vertical: Responsive.h(12)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(8))),
                ),
                child: Text('Submit Request', style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String value, IconData icon, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600)),
        SizedBox(height: Responsive.h(6)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(12)),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(Responsive.r(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyle(fontSize: Responsive.sp(12), color: isDark ? Colors.white : Colors.black87)),
              Icon(icon, size: Responsive.w(14), color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestOverview(bool isDark, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A24) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Request Overview', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          SizedBox(height: Responsive.h(4)),
          Text('Track the outcome of your corrections.', style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500)),
          SizedBox(height: Responsive.h(16)),
          Row(
            children: [
              Expanded(child: _buildOverviewStat('TOTAL', '0', isDark)),
              SizedBox(width: Responsive.w(12)),
              Expanded(child: _buildOverviewStat('PENDING', '0', isDark, valueColor: Colors.orange)),
            ],
          ),
          SizedBox(height: Responsive.h(12)),
          Row(
            children: [
              Expanded(child: _buildOverviewStat('APPROVED', '0', isDark, valueColor: Colors.green)),
              SizedBox(width: Responsive.w(12)),
              Expanded(child: _buildOverviewStat('REJECTED', '0', isDark, valueColor: Colors.red)),
            ],
          ),
          SizedBox(height: Responsive.h(24)),
          Container(
            padding: EdgeInsets.all(Responsive.w(12)),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(Responsive.r(8)),
            ),
            child: Text('Submit one request per attendance day. Approved changes will directly reflect in your monthly log.', style: TextStyle(fontSize: Responsive.sp(10), color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value, bool isDark, {Color? valueColor}) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(12)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(8)),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600)),
          SizedBox(height: Responsive.h(4)),
          Text(value, style: TextStyle(fontSize: Responsive.sp(20), fontWeight: FontWeight.bold, color: valueColor ?? (isDark ? Colors.white : Colors.black))),
        ],
      ),
    );
  }

  Widget _buildRequestHistory(bool isDark, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A24) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Request History', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          SizedBox(height: Responsive.h(4)),
          Text('Latest requests are shown first and refresh automatically.', style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500)),
          SizedBox(height: Responsive.h(16)),
          Divider(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200),
          SizedBox(height: Responsive.h(40)),
          Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.w(16)),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.access_time, size: Responsive.w(24), color: isDark ? Colors.white.withValues(alpha: 0.3) : Colors.grey.shade400),
                ),
                SizedBox(height: Responsive.h(16)),
                Text('No requests yet', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                SizedBox(height: Responsive.h(8)),
                Text('When you submit a correction, it will appear here with its approval status.', textAlign: TextAlign.center, style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500)),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(40)),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this._isDark, this._backgroundColor);

  final TabBar _tabBar;
  final bool _isDark;
  final Color _backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
