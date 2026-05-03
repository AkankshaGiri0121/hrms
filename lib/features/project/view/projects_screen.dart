import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import '../models/project_model.dart';

class ProjectsScreen extends StatefulWidget {
  final bool showBackButton;

  const ProjectsScreen({super.key, this.showBackButton = true});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedViewIndex = 0;

  // Backend: Replace with API data
  List<ProjectModel> _projects = [];
  int get _totalProjects => _projects.length;
  int get _completedProjects =>
      _projects.where((p) => p.status == 'completed').length;
  int get _delayedProjects =>
      _projects.where((p) => p.status == 'delayed').length;
  int get _ongoingProjects =>
      _projects.where((p) => p.status == 'on_going').length;
  int get _totalTasks => _projects.fold(0, (sum, p) => sum + p.taskCount);
  double get _overallProgress =>
      _projects.isEmpty ? 0 : (_completedProjects / _totalProjects * 100);

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day.toString().padLeft(2, '0')}, ${d.year}';
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        automaticallyImplyLeading: widget.showBackButton,
        titleSpacing: widget.showBackButton ? 0 : Responsive.w(24),
        leading: widget.showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: theme.appBarTheme.foregroundColor,
                  size: Responsive.w(22),
                ),
                onPressed: () => Get.back(),
              )
            : null,
        title: Row(
          children: [
            Text(
              'Projects',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(26),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutQuint,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-20 * (1 - value), 0),
                    child: child,
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: Responsive.w(8)),
                  Container(
                    height: Responsive.h(20),
                    width: Responsive.w(2),
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.grey.shade300,
                  ),
                  SizedBox(width: Responsive.w(8)),
                  Text(
                    'Yash Raj',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Responsive.sp(18),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage and track all your projects',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.grey.shade600,
                    fontSize: Responsive.sp(13),
                  ),
                ),
                SizedBox(height: Responsive.h(16)),
                Row(
                  children: [
                    _buildPillTab('Overview', 0, isDark),
                    SizedBox(width: Responsive.w(8)),
                    _buildPillTab('Projects', 1, isDark),
                    const Spacer(),
                    if (_tabController.index == 1) ...[
                      _buildViewToggle(Icons.format_list_bulleted, 0, isDark),
                      SizedBox(width: Responsive.w(4)),
                      _buildViewToggle(Icons.grid_view, 1, isDark),
                    ],
                    SizedBox(width: Responsive.w(8)),
                    Container(
                      padding: EdgeInsets.all(Responsive.w(8)),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(Responsive.r(8)),
                      ),
                      child: Icon(
                        Icons.add,
                        size: Responsive.w(16),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.7)
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(24)),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child: _tabController.index == 0
                  ? _buildOverviewTab(isDark)
                  : _buildProjectsTab(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTab(String text, int index, bool isDark) {
    final isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () => setState(() => _tabController.index = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(16),
          vertical: Responsive.h(8),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.shade200)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Responsive.r(8)),
          border: Border.all(
            color: isSelected
                ? (isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.grey.shade300)
                : Colors.transparent,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: Responsive.sp(12),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? (isDark ? Colors.white : Colors.black87)
                : (isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle(IconData icon, int index, bool isDark) {
    final isSelected = _selectedViewIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedViewIndex = index),
      child: Container(
        padding: EdgeInsets.all(Responsive.w(6)),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.shade200)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Responsive.r(6)),
        ),
        child: Icon(
          icon,
          size: Responsive.w(16),
          color: isSelected
              ? (isDark ? Colors.white : Colors.black87)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.grey.shade500),
        ),
      ),
    );
  }

  // ─── OVERVIEW TAB ───
  Widget _buildOverviewTab(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('overview'),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Horizontal Scrollable Stats Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
            child: Row(
              children: [
                _buildAnimatedEntry(
                  0,
                  _buildStatCard(
                    'PROJECTS',
                    '$_totalProjects',
                    '/$_totalProjects',
                    Icons.account_balance_rounded,
                    Colors.red,
                    '0% decrease from last month',
                    isDark,
                  ),
                ),
                SizedBox(width: Responsive.w(16)),
                _buildAnimatedEntry(
                  1,
                  _buildStatCard(
                    'TASKS',
                    '$_totalTasks',
                    '/$_totalTasks',
                    Icons.account_balance_rounded,
                    Colors.red,
                    '0% decrease from last month',
                    isDark,
                  ),
                ),
                SizedBox(width: Responsive.w(16)),
                _buildAnimatedEntry(
                  2,
                  _buildStatCard(
                    'DUE PROJECTS',
                    '0',
                    '/0',
                    Icons.access_time_rounded,
                    Colors.amber,
                    '0% increase from last month',
                    isDark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(24)),

          // 2. Main Dashboard Cards (Stacked vertically on mobile)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                return Column(
                  children: [
                    if (isMobile) ...[
                      // Mobile: Stack everything vertically
                      _buildAnimatedEntry(3, _buildProjectSummaryCard(isDark)),
                      SizedBox(height: Responsive.h(16)),
                      _buildAnimatedEntry(4, _buildOverallProgressCard(isDark)),
                      SizedBox(height: Responsive.h(16)),
                      _buildAnimatedEntry(5, _buildTaskSection(isDark)),
                      SizedBox(height: Responsive.h(16)),
                      _buildAnimatedEntry(6, _buildWorkloadCard(isDark)),
                      SizedBox(height: Responsive.h(32)), // Bottom padding
                    ] else ...[
                      // Tablet/Desktop: 2-column Layout
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildAnimatedEntry(
                              3,
                              _buildProjectSummaryCard(isDark),
                            ),
                          ),
                          SizedBox(width: Responsive.w(16)),
                          Expanded(
                            child: _buildAnimatedEntry(
                              4,
                              _buildOverallProgressCard(isDark),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(24)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildAnimatedEntry(
                              5,
                              _buildTaskSection(isDark),
                            ),
                          ),
                          SizedBox(width: Responsive.w(16)),
                          Expanded(
                            flex: 2,
                            child: _buildAnimatedEntry(
                              6,
                              _buildWorkloadCard(isDark),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(32)), // Bottom padding
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper to stagger entry animations
  Widget _buildAnimatedEntry(int index, Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        // Delay calculation based on index
        final delay = (index * 0.1).clamp(0.0, 1.0);
        final adjustedValue = ((value - delay) / (1 - delay)).clamp(0.0, 1.0);

        return Opacity(
          opacity: adjustedValue,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - adjustedValue)),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String suffix,
    IconData icon,
    Color iconColor,
    String trend,
    bool isDark,
  ) {
    return Container(
      width: Responsive.w(160), // Fixed width for horizontal scroll
      padding: EdgeInsets.all(Responsive.w(16)),
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
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(8)),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Responsive.r(10)),
            ),
            child: Icon(icon, size: Responsive.w(18), color: iconColor),
          ),
          SizedBox(height: Responsive.h(16)),
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: Responsive.h(4)),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: Responsive.sp(28),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                TextSpan(
                  text: suffix,
                  style: TextStyle(
                    fontSize: Responsive.sp(14),
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(8)),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: Responsive.w(12),
                color: Colors.green.withValues(alpha: 0.8),
              ),
              SizedBox(width: Responsive.w(4)),
              Expanded(
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: Responsive.sp(9),
                    color: Colors.green.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSummaryCard(bool isDark) {
    return Container(
      height: Responsive.h(220),
      width: double.infinity,
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
            'Project Summary',
            style: TextStyle(
              fontSize: Responsive.sp(15),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.folder_open_rounded,
                  size: Responsive.w(40),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.grey.shade300,
                ),
                SizedBox(height: Responsive.h(12)),
                Text(
                  'No projects found',
                  style: TextStyle(
                    fontSize: Responsive.sp(13),
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.grey.shade500,
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

  Widget _buildOverallProgressCard(bool isDark) {
    return Container(
      height: Responsive.h(300), // Increased height to give plenty of space
      width: double.infinity,
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
            'Overall Progress',
            style: TextStyle(
              fontSize: Responsive.sp(16),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: Responsive.h(24)), // More space
          Expanded(
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: _overallProgress / 100),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return CustomPaint(
                    size: Size(
                      Responsive.w(220),
                      Responsive.h(120),
                    ), // Larger gauge
                    painter: _GaugePainter(progress: value, isDark: isDark),
                    child: SizedBox(
                      width: Responsive.w(220),
                      height: Responsive.h(120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${(value * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: Responsive.sp(36),
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: Responsive.sp(13),
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.5)
                                  : Colors.grey.shade500,
                            ),
                          ),
                          SizedBox(
                            height: Responsive.h(12),
                          ), // Push up slightly from baseline
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: Responsive.h(24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildProgressStat(
                  '$_totalProjects',
                  'Total',
                  isDark
                      ? Colors.white
                      : Colors.black87, // Visible in light mode
                  isDark,
                ),
              ),
              Expanded(
                child: _buildProgressStat(
                  '$_completedProjects',
                  'Done',
                  Colors.green,
                  isDark,
                ),
              ),
              Expanded(
                child: _buildProgressStat(
                  '$_delayedProjects',
                  'Delayed',
                  Colors.orange,
                  isDark,
                ),
              ),
              Expanded(
                child: _buildProgressStat(
                  '$_ongoingProjects',
                  'Active',
                  Colors.red,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(
    String value,
    String label,
    Color color,
    bool isDark,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.sp(22),
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: Responsive.h(4)),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Responsive.sp(12),
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white.withValues(alpha: 0.4)
                : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskSection(bool isDark) {
    return Container(
      height: Responsive.h(240),
      width: double.infinity,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task',
                style: TextStyle(
                  fontSize: Responsive.sp(15),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                _formatDate(DateTime.now()),
                style: TextStyle(
                  fontSize: Responsive.sp(11),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.grey.shade500,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          Row(
            children: [
              _buildMiniTab('All', true, isDark, badgeCount: 0),
              SizedBox(width: Responsive.w(16)),
              _buildMiniTab('Important', false, isDark),
            ],
          ),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: Responsive.w(40),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.grey.shade300,
                ),
                SizedBox(height: Responsive.h(12)),
                Text(
                  "You're all caught up!",
                  style: TextStyle(
                    fontSize: Responsive.sp(14),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: Responsive.h(6)),
                Text(
                  'No tasks found for this filter.',
                  style: TextStyle(
                    fontSize: Responsive.sp(12),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.grey.shade500,
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

  Widget _buildMiniTab(
    String text,
    bool isSelected,
    bool isDark, {
    int? badgeCount,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: Responsive.sp(13),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? Colors.blue
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.grey.shade600),
              ),
            ),
            if (badgeCount != null) ...[
              SizedBox(width: Responsive.w(6)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(8),
                  vertical: Responsive.h(2),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Responsive.r(6)),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: Responsive.h(8)),
        Container(
          height: 2,
          width: Responsive.w(40),
          color: isSelected ? Colors.blue : Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildWorkloadCard(bool isDark) {
    return Container(
      height: Responsive.h(240),
      width: double.infinity,
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
              Flexible(
                child: Text(
                  'Projects Workload',
                  style: TextStyle(
                    fontSize: Responsive.sp(15),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: Responsive.w(8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(10),
                  vertical: Responsive.h(6),
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(Responsive.r(8)),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timeline',
                          style: TextStyle(
                            fontSize: Responsive.sp(9),
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          'Last 3 months',
                          style: TextStyle(
                            fontSize: Responsive.sp(11),
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.8)
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: Responsive.w(6)),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: Responsive.w(16),
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: Text(
              'No workload data available.',
              style: TextStyle(
                fontSize: Responsive.sp(13),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.grey.shade500,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // ─── PROJECTS TAB (List View for Mobile) ───
  Widget _buildProjectsTab(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('projects'),
      padding: EdgeInsets.all(Responsive.w(24)),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A24) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(12)),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.shade200,
              ),
            ),
            child: TextField(
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: Responsive.sp(14),
              ),
              decoration: InputDecoration(
                hintText: 'Search by project name...',
                hintStyle: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.grey.shade500,
                  fontSize: Responsive.sp(14),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: Responsive.w(20),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.grey.shade500,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: Responsive.h(16),
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.h(24)),

          // Empty State
          if (_projects.isEmpty)
            _buildAnimatedEntry(
              0,
              Container(
                padding: EdgeInsets.symmetric(vertical: Responsive.h(80)),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.folder_off_rounded,
                        size: Responsive.w(48),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.grey.shade300,
                      ),
                      SizedBox(height: Responsive.h(16)),
                      Text(
                        'No projects found.',
                        style: TextStyle(
                          fontSize: Responsive.sp(14),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            // Render beautiful mobile project cards here when backend is connected
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                return _buildAnimatedEntry(
                  index,
                  _buildMobileProjectCard(_projects[index], isDark),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMobileProjectCard(ProjectModel project, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(16)),
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
                project.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(16),
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(8),
                  vertical: Responsive.h(4),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(8)),
                ),
                child: Text(
                  project.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(12)),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: Responsive.w(14),
                color: Colors.grey,
              ),
              SizedBox(width: Responsive.w(4)),
              Text(
                project.manager,
                style: TextStyle(
                  fontSize: Responsive.sp(12),
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.check_circle_outline,
                size: Responsive.w(14),
                color: Colors.grey,
              ),
              SizedBox(width: Responsive.w(4)),
              Text(
                '${project.taskCount} Tasks',
                style: TextStyle(
                  fontSize: Responsive.sp(12),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── GAUGE PAINTER ───
class _GaugePainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _GaugePainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.42;

    // Background arc
    final bgPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = Responsive.w(18)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = SweepGradient(
          startAngle: math.pi,
          endAngle: 2 * math.pi,
          colors: const [Colors.blue, Colors.purple, Colors.orange],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = Responsive.w(18)
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        math.pi * progress,
        false,
        progressPaint,
      );
    }

    // Scale labels
    final labelStyle = TextStyle(
      fontSize: Responsive.sp(14),
      fontWeight: FontWeight.bold,
      color: isDark
          ? Colors.white.withValues(alpha: 0.5)
          : Colors.grey.shade600,
    );
    _drawLabel(
      canvas,
      '0',
      Offset(
        center.dx - radius - Responsive.w(14),
        center.dy + Responsive.h(12),
      ),
      labelStyle,
    );
    _drawLabel(
      canvas,
      '50',
      Offset(center.dx - Responsive.w(8), center.dy - radius - Responsive.h(8)),
      labelStyle,
    );
    _drawLabel(
      canvas,
      '100',
      Offset(
        center.dx + radius - Responsive.w(4),
        center.dy + Responsive.h(12),
      ),
      labelStyle,
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
