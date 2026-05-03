import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class MyOnboardingScreen extends StatefulWidget {
  final bool showBackButton;

  const MyOnboardingScreen({super.key, this.showBackButton = true});

  @override
  State<MyOnboardingScreen> createState() => _MyOnboardingScreenState();
}

class _MyOnboardingScreenState extends State<MyOnboardingScreen> {
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
        title: Text(
          'My Onboarding',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: Responsive.sp(26),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Responsive.h(16)),
            Text(
              'TRACK YOUR CHECKLIST, TIMELINE, AND SESSIONS.',
              style: TextStyle(
                fontSize: Responsive.sp(10),
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white38 : Colors.grey.shade500,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: Responsive.h(24)),

            // ─── Progress Card ───
            _buildProgressCard(isDark),
            SizedBox(height: Responsive.h(16)),

            // ─── Stat Row ───
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildStatCard('CHECKLIST', '0/0', '0 pending, 0 in progress', Icons.fact_check_rounded, Colors.green, isDark),
                  SizedBox(width: Responsive.w(16)),
                  _buildStatCard('TARGET DATE', 'Not scheduled', 'Align with HR timeline.', Icons.event_available_rounded, Colors.blue, isDark),
                  SizedBox(width: Responsive.w(16)),
                  _buildStatCard('DUE SOON', '0', 'AWAITING SETUP', Icons.timer_rounded, Colors.orange, isDark),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(32)),

            // ─── Main Sections ───
            _buildSection(
              'CHECKLIST',
              'UPDATE PROGRESS ON ONBOARDING STEPS.',
              'No onboarding tasks are assigned yet.',
              Icons.assignment_turned_in_rounded,
              isDark,
            ),
            SizedBox(height: Responsive.h(24)),
            _buildSection(
              'ORIENTATION SESSIONS',
              'ASSIGNED PROGRAMS.',
              'No sessions assigned yet.',
              Icons.meeting_room_rounded,
              isDark,
            ),
            SizedBox(height: Responsive.h(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(24)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(24)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESS',
                style: TextStyle(
                  fontSize: Responsive.sp(11),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(Icons.rocket_launch_rounded, size: Responsive.w(20), color: const Color(0xFF8B5CF6)),
            ],
          ),
          SizedBox(height: Responsive.h(12)),
          Text(
            '0%',
            style: TextStyle(
              fontSize: Responsive.sp(36),
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          ClipRRect(
            borderRadius: BorderRadius.circular(Responsive.r(8)),
            child: LinearProgressIndicator(
              value: 0.0,
              minHeight: Responsive.h(8),
              backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color, bool isDark) {
    return Container(
      width: Responsive.w(220),
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(20)),
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
                title,
                style: TextStyle(
                  fontSize: Responsive.sp(10),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: Responsive.w(18), color: color),
            ],
          ),
          SizedBox(height: Responsive.h(12)),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.sp(18),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: Responsive.h(4)),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              color: isDark ? Colors.white24 : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, String emptyText, IconData icon, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Responsive.sp(12),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: Responsive.h(4)),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: Responsive.sp(9),
            color: isDark ? Colors.white38 : Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: Responsive.h(16)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: Responsive.h(40)),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(Responsive.r(16)),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: Responsive.w(48), color: isDark ? Colors.white10 : Colors.grey.shade200),
              SizedBox(height: Responsive.h(16)),
              Text(
                emptyText,
                style: TextStyle(
                  fontSize: Responsive.sp(12),
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
