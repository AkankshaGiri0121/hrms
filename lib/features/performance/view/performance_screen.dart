import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class PerformanceScreen extends StatefulWidget {
  final bool showBackButton;

  const PerformanceScreen({super.key, this.showBackButton = true});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
              'Performance', // Shortened from 'Performance Hub' to fit nicely
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
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                  SizedBox(width: Responsive.w(8)),
                  Text(
                    'Yash Raj',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Responsive.sp(18),
                      color: isDark
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
          _buildAnimatedEntry(
            0,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
              child: Text(
                'Real-time productivity & performance history',
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.grey.shade600,
                  fontSize: Responsive.sp(13),
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.h(24)),

          // Scrollable Glowing Cards
          _buildAnimatedEntry(
            1,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
              child: Row(
                children: [
                  _buildGlowingCard(
                    'TOTAL PROJECTS',
                    '0',
                    Icons.cases_rounded,
                    Colors.blue,
                    isDark,
                  ),
                  SizedBox(width: Responsive.w(16)),
                  _buildGlowingCard(
                    'TOTAL TASKS',
                    '0',
                    Icons.check_circle_outline_rounded,
                    Colors.purple,
                    isDark,
                  ),
                  SizedBox(width: Responsive.w(16)),
                  _buildGlowingCard(
                    'WITHIN DUE TIME',
                    '0',
                    Icons.access_time_rounded,
                    Colors.green,
                    isDark,
                  ),
                  SizedBox(width: Responsive.w(16)),
                  _buildGlowingCard(
                    'PRODUCTIVITY',
                    '0%',
                    Icons.trending_up_rounded,
                    Colors.orange,
                    isDark,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: Responsive.h(32)),

          // Pill Tabs
          _buildAnimatedEntry(
            2,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
              child: Row(
                children: [
                  _buildPillTab('Reviews', 0, isDark),
                  SizedBox(width: Responsive.w(12)),
                  _buildPillTab('Feedback', 1, isDark),
                ],
              ),
            ),
          ),
          SizedBox(height: Responsive.h(24)),

          // Content Area
          Expanded(
            child: _buildAnimatedEntry(
              3,
              AnimatedSwitcher(
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
                    ? _buildReviewsTab(isDark)
                    : _buildFeedbackTab(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedEntry(int index, Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildGlowingCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    bool isDark,
  ) {
    return Container(
      width: Responsive.w(180),
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
                  blurRadius: Responsive.w(10),
                  offset: Offset(0, Responsive.h(4)),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(8)),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1A24)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(Responsive.r(8)),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Icon(icon, size: Responsive.w(18), color: iconColor),
              ),
              Icon(
                Icons.show_chart_rounded,
                size: Responsive.w(16),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.grey.shade300,
              ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.grey.shade600,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: Responsive.h(6)),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.sp(26),
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
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
            fontSize: Responsive.sp(13),
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

  Widget _buildReviewsTab(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('reviews'),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Past Reviews',
            style: TextStyle(
              fontSize: Responsive.sp(15),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: Responsive.h(40)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF13131A) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(12)),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.shade200,
              ),
            ),
            child: Center(
              child: Text(
                'No past reviews found.',
                style: TextStyle(
                  fontSize: Responsive.sp(13),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTab(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('feedback'),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Feedback',
            style: TextStyle(
              fontSize: Responsive.sp(15),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: Responsive.h(40)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF13131A) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(12)),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.shade200,
              ),
            ),
            child: Center(
              child: Text(
                'No recent feedback found.',
                style: TextStyle(
                  fontSize: Responsive.sp(13),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
