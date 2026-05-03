import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class HrDashboardScreen extends StatefulWidget {
  final bool showBackButton;

  const HrDashboardScreen({super.key, this.showBackButton = true});

  @override
  State<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends State<HrDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
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
        automaticallyImplyLeading: widget.showBackButton,
        titleSpacing: widget.showBackButton ? 0 : Responsive.w(24),
        leading: widget.showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: isDark ? Colors.white : Colors.black,
                  size: Responsive.w(22),
                ),
                onPressed: () => Get.back(),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Executive Dashboard',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(22),
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              'Strategic workforce insights and business intelligence.',
              style: TextStyle(
                fontSize: Responsive.sp(10),
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: Responsive.h(20)),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Top Metrics (Scrollable Row) ───
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                    child: Row(
                      children: [
                        _AnimatedCard(
                          controller: _animController,
                          index: 0,
                          child: _buildMetricCard(
                            title: 'TOTAL EMPLOYEES',
                            value: '0',
                            icon: Icons.people_alt_rounded,
                            iconColor: const Color(0xFF8B5CF6),
                            badgeText: 'LIVE',
                            isDark: isDark,
                          ),
                        ),
                        SizedBox(width: Responsive.w(16)),
                        _AnimatedCard(
                          controller: _animController,
                          index: 1,
                          child: _buildMetricCard(
                            title: 'MONTHLY PAYROLL',
                            value: '₹0',
                            icon: Icons.currency_rupee_rounded,
                            iconColor: Colors.blue,
                            badgeText: 'LIVE',
                            isDark: isDark,
                          ),
                        ),
                        SizedBox(width: Responsive.w(16)),
                        _AnimatedCard(
                          controller: _animController,
                          index: 2,
                          child: _buildAttendanceCard(isDark),
                        ),
                        SizedBox(width: Responsive.w(16)),
                        _AnimatedCard(
                          controller: _animController,
                          index: 3,
                          child: _buildMetricCard(
                            title: 'AVG SCORE',
                            value: '0/5',
                            icon: Icons.track_changes_rounded,
                            iconColor: const Color(0xFF8B5CF6),
                            badgeText: 'OVERALL',
                            isDark: isDark,
                          ),
                        ),
                        SizedBox(width: Responsive.w(16)),
                        _AnimatedCard(
                          controller: _animController,
                          index: 4,
                          child: _buildPendingApprovalsCard(isDark),
                        ),
                        SizedBox(width: Responsive.w(16)),
                        _AnimatedCard(
                          controller: _animController,
                          index: 5,
                          child: _buildMetricCard(
                            title: 'ACTIVE DEPTS',
                            value: '0',
                            icon: Icons.domain_rounded,
                            iconColor: Colors.teal,
                            badgeText: 'LIVE',
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Responsive.h(24)),

                  // ─── Trend Charts ───
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                    child: Column(
                      children: [
                        _AnimatedCard(
                          controller: _animController,
                          index: 6,
                          child: _buildTrendChart(
                            'Employee Growth Trend',
                            'Actual vs Target headcount tracking',
                            [
                              _buildLegendItem(Colors.blue, 'ACTUAL'),
                              _buildLegendItem(Colors.grey.shade400, 'TARGET'),
                            ],
                            isDark,
                          ),
                        ),
                        SizedBox(height: Responsive.h(16)),
                        _AnimatedCard(
                          controller: _animController,
                          index: 7,
                          child: _buildTrendChart(
                            'Payroll Cost Trend',
                            'Monthly payroll expenses (₹)',
                            [],
                            isDark,
                          ),
                        ),
                        SizedBox(height: Responsive.h(16)),

                        // Middle Grid section
                        Row(
                          children: [
                            Expanded(
                              child: _AnimatedCard(
                                controller: _animController,
                                index: 8,
                                child: _buildEmptyStateBox(
                                  'Department Density',
                                  'Resource distribution across units',
                                  'No data available.',
                                  isDark,
                                ),
                              ),
                            ),
                            SizedBox(width: Responsive.w(16)),
                            Expanded(
                              child: _AnimatedCard(
                                controller: _animController,
                                index: 9,
                                child: _buildEmptyStateBox(
                                  'Performance Matrix',
                                  'Organizational appraisal ratings',
                                  'No data.',
                                  isDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.h(16)),

                        _AnimatedCard(
                          controller: _animController,
                          index: 10,
                          child: _buildTrendChart(
                            'Talent Flux',
                            'Monthly hiring vs exit tracking',
                            [
                              _buildLegendItem(Colors.redAccent, 'Exits'),
                              _buildLegendItem(Colors.teal, 'Hires'),
                            ],
                            isDark,
                          ),
                        ),
                        SizedBox(height: Responsive.h(16)),

                        // Bottom Alerts section
                        Row(
                          children: [
                            Expanded(
                              child: _AnimatedCard(
                                controller: _animController,
                                index: 11,
                                child: _buildEmptyStateBox(
                                  'Top Performing Departments',
                                  'Highest average employee scores',
                                  'NO DEPARTMENT DATA AVAILABLE.',
                                  isDark,
                                ),
                              ),
                            ),
                            SizedBox(width: Responsive.w(16)),
                            Expanded(
                              child: _AnimatedCard(
                                controller: _animController,
                                index: 12,
                                child: _buildAlertBox(isDark),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.h(40)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required String badgeText,
    required bool isDark,
  }) {
    return Container(
      width: Responsive.w(200),
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(8)),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(8)),
                ),
                child: Icon(icon, size: Responsive.w(16), color: iconColor),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(6),
                  vertical: Responsive.h(2),
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(Responsive.r(4)),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                    fontSize: Responsive.sp(8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: Responsive.h(4)),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.sp(24),
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(bool isDark) {
    return Container(
      width: Responsive.w(200),
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
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
              Text(
                'ATTENDANCE HEALTH',
                style: TextStyle(
                  fontSize: Responsive.sp(10),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                Icons.access_time_rounded,
                size: Responsive.w(16),
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),
          Text(
            '0%',
            style: TextStyle(
              fontSize: Responsive.sp(24),
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: Responsive.h(8)),
          Container(
            height: Responsive.h(4),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(Responsive.r(2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovalsCard(bool isDark) {
    return Container(
      width: Responsive.w(200),
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
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
              Text(
                'PENDING APPROVALS',
                style: TextStyle(
                  fontSize: Responsive.sp(10),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                Icons.description_outlined,
                size: Responsive.w(16),
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '0',
                style: TextStyle(
                  fontSize: Responsive.sp(24),
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(width: Responsive.w(8)),
              Padding(
                padding: EdgeInsets.only(bottom: Responsive.h(4)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(6),
                    vertical: Responsive.h(2),
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(Responsive.r(4)),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    'REQUESTS',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                      fontSize: Responsive.sp(8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(
    String title,
    String subtitle,
    List<Widget> legends,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      height: Responsive.h(220),
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
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
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(14),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: Responsive.sp(11),
              color: isDark ? Colors.white38 : Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          // Placeholder for actual chart
          Divider(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
            thickness: 1,
            // using dashed line visually by opacity or just a simple line for now
          ),
          SizedBox(height: Responsive.h(40)),
          Divider(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
            thickness: 1,
          ),
          SizedBox(height: Responsive.h(16)),
          if (legends.isNotEmpty)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: legends),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Responsive.w(6),
            height: Responsive.w(6),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: Responsive.w(6)),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: Responsive.sp(9),
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateBox(
    String title,
    String subtitle,
    String emptyMessage,
    bool isDark,
  ) {
    return Container(
      height: Responsive.h(180),
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
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
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(14),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: Responsive.sp(11),
              color: isDark ? Colors.white38 : Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Center(
            child: Text(
              emptyMessage,
              style: TextStyle(
                fontSize: Responsive.sp(11),
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white38 : Colors.grey.shade500,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildAlertBox(bool isDark) {
    return Container(
      height: Responsive.h(180),
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
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
          Text(
            'System Alerts',
            style: TextStyle(
              fontSize: Responsive.sp(14),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            'Items requiring immediate attention',
            style: TextStyle(
              fontSize: Responsive.sp(11),
              color: isDark ? Colors.white38 : Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: Responsive.w(24),
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                ),
                SizedBox(height: Responsive.h(8)),
                Text(
                  'ALL SYSTEMS CLEAR',
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _AnimatedCard extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final Widget child;

  const _AnimatedCard({
    required this.controller,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final delay = (index * 0.1).clamp(0.0, 0.8);
    final start = delay;
    final end = (start + 0.3).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOutQuint),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
