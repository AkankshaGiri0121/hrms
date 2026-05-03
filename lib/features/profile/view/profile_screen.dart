import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class ProfileScreen extends StatefulWidget {
  final bool showBackButton;

  const ProfileScreen({super.key, this.showBackButton = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _staggerController;
  bool _isEditingContact = false;
  bool _isEditingBank = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  Widget _staggered(int index, Widget child) {
    final start = (index * 0.1).clamp(0.0, 1.0);
    final end = (start + 0.4).clamp(0.0, 1.0);
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _staggerController,
        curve: Interval(start, end, curve: Curves.easeOutQuint),
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutQuint),
        )),
        child: child,
      ),
    );
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
        titleSpacing: widget.showBackButton ? 0 : Responsive.w(24),
        title: Row(
          children: [
            Text(
              'Profile',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _staggered(0, Text(
              'Manage your personal information',
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.grey.shade600,
                fontSize: Responsive.sp(13),
              ),
            )),
            SizedBox(height: Responsive.h(20)),

            // ─── Top Blue Card ───
            _staggered(1, _buildProfileHeaderCard()),
            SizedBox(height: Responsive.h(16)),

            // ─── 4 Info Chips ───
            _staggered(2, _buildInfoChipsGrid(isDark)),
            SizedBox(height: Responsive.h(24)),

            // ─── Tabs ───
            _staggered(3, Theme(
              data: theme.copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.primary,
                indicatorWeight: Responsive.h(3),
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.grey.shade600,
                dividerColor: Colors.transparent,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(13),
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.sp(13),
                ),
                tabs: const [
                  Tab(text: 'Personal Info'),
                  Tab(text: 'Employment Info'),
                  Tab(text: 'Work Week'),
                  Tab(text: 'Contact & Emergency'),
                  Tab(text: 'Bank & Tax'),
                ],
              ),
            )),
            SizedBox(height: Responsive.h(16)),

            // ─── Tab Content ───
            _staggered(4, AnimatedBuilder(
              animation: _tabController,
              builder: (context, _) {
                if (_tabController.index == 0) {
                  return _buildPersonalInfoTab(isDark, theme);
                } else if (_tabController.index == 1) {
                  return _buildEmploymentInfoTab(isDark, theme);
                } else if (_tabController.index == 2) {
                  return _buildWorkWeekTab(isDark, theme);
                } else if (_tabController.index == 3) {
                  return _buildContactEmergencyTab(isDark, theme);
                } else if (_tabController.index == 4) {
                  return _buildBankTaxTab(isDark, theme);
                } else {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Responsive.w(40)),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.construction_rounded,
                          size: Responsive.w(40),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.grey.shade300,
                        ),
                        SizedBox(height: Responsive.h(12)),
                        Text(
                          'Content for this section is coming soon.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.5)
                                : Colors.grey.shade500,
                            fontSize: Responsive.sp(13),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            )),
            SizedBox(height: Responsive.h(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6), // Primary purple color
        borderRadius: BorderRadius.circular(Responsive.r(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(2)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            ),
            child: CircleAvatar(
              radius: Responsive.w(30),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: Responsive.w(30),
              ),
            ),
          ),
          SizedBox(width: Responsive.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yash Raj',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Responsive.h(4)),
                Text(
                  'Flutter Developer',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: Responsive.sp(13),
                  ),
                ),
                SizedBox(height: Responsive.h(2)),
                Text(
                  'EMP-2024-001',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: Responsive.sp(12),
                  ),
                ),
                SizedBox(height: Responsive.h(12)),
                Wrap(
                  spacing: Responsive.w(12),
                  runSpacing: Responsive.h(8),
                  children: [
                    _buildHeaderIconText(
                      Icons.email_outlined,
                      'yash@capyngen.com',
                    ),
                    _buildHeaderIconText(
                      Icons.phone_outlined,
                      '+91 9304837716',
                    ),
                    _buildHeaderIconText(
                      Icons.location_on_outlined,
                      'Corporate Office',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: Responsive.w(14),
        ),
        SizedBox(width: Responsive.w(6)),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: Responsive.sp(11),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChipsGrid(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - Responsive.w(12)) / 2;
        return Column(
          children: [
            Row(
              children: [
                _buildChip(
                  isDark,
                  Icons.work_outline,
                  'DEPARTMENT',
                  'Information Technology',
                  width,
                ),
                SizedBox(width: Responsive.w(12)),
                _buildChip(
                  isDark,
                  Icons.calendar_today_outlined,
                  'JOINED',
                  '01 Mar 2024',
                  width,
                ),
              ],
            ),
            SizedBox(height: Responsive.h(12)),
            Row(
              children: [
                _buildChip(
                  isDark,
                  Icons.person_outline,
                  'REPORTS TO',
                  'Not Assigned',
                  width,
                ),
                SizedBox(width: Responsive.w(12)),
                _buildChip(
                  isDark,
                  Icons.access_time,
                  'WORK TYPE',
                  'Full-Time',
                  width,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildChip(
    bool isDark,
    IconData icon,
    String label,
    String value,
    double width,
  ) {
    return Container(
      width: width,
      padding: EdgeInsets.all(Responsive.w(12)),
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
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: Responsive.w(18), color: AppColors.primary),
          SizedBox(width: Responsive.w(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: Responsive.sp(9),
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Responsive.h(4)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: Responsive.sp(12),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
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

  Widget _buildPersonalInfoTab(bool isDark, ThemeData theme) {
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
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: Responsive.w(12),
                  offset: Offset(0, Responsive.h(4)),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(16),
                      ),
                    ),
                    SizedBox(height: Responsive.h(4)),
                    Text(
                      'Basic personal details and contact info',
                      style: TextStyle(
                        fontSize: Responsive.sp(12),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.edit_outlined,
                  size: Responsive.w(14),
                  color: isDark ? Colors.white : Colors.black,
                ),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: Responsive.sp(12),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(12),
                    vertical: Responsive.h(8),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Responsive.r(8)),
                  ),
                  side: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),

          // Fields - Stacking vertically on mobile to prevent overflow
          _buildFieldBox('FIRST NAME', 'Yash', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('LAST NAME', 'Raj', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('DATE OF BIRTH', '2001-06-12', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('GENDER', 'Male', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('BLOOD GROUP', 'A+', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('MARITAL STATUS', 'Single', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('OFFICIAL EMAIL ID', 'yash@capyngen.com', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('PERSONAL EMAIL ID', 'yash@gmail.com', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('PHONE NUMBER', '+91 9304837716', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('ALTERNATE PHONE', 'Not set', isDark),
        ],
      ),
    );
  }

  Widget _buildFieldBox(String label, String value, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(16),
        vertical: Responsive.h(12),
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.transparent,
        borderRadius: BorderRadius.circular(Responsive.r(8)),
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
            label,
            style: TextStyle(
              fontSize: Responsive.sp(9),
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: Responsive.h(6)),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.sp(13),
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmploymentInfoTab(bool isDark, ThemeData theme) {
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
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: Responsive.w(12),
                  offset: Offset(0, Responsive.h(4)),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employment Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(16),
            ),
          ),
          SizedBox(height: Responsive.h(4)),
          Text(
            'Your work-related details (Read-only)',
            style: TextStyle(
              fontSize: Responsive.sp(12),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.grey.shade500,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(12),
              vertical: Responsive.h(8),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: Responsive.w(14),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.grey.shade700,
                ),
                SizedBox(width: Responsive.w(8)),
                Text(
                  'Compensation fields are managed by Admin/HR only.',
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(24)),
          _buildSectionHeader('BASIC INFO', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('EMPLOYEE ID', 'EMP-2024-001', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('DATE OF JOINING', '01 Mar 2024', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('MONTHLY CTC', 'Rs. 1,00,666', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('ANNUAL CTC', 'Rs. 12,07,989', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('PROBATION PERIOD', '30 Days', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('EMPLOYEE TYPE', 'Full-Time', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('WORK LOCATION', 'Corporate Office', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('PROBATION STATUS', 'On Probation', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('WORK EXPERIENCE', '2 Years', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('BILLING STATUS', 'Non-Billable', isDark),
          SizedBox(height: Responsive.h(32)),
          _buildSectionHeader('WORK INFO', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('ROLE', 'admin', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('DESIGNATION', 'Full Stack Web Developer', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('JOB TITLE', 'Full Stack Web Developer', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('DEPARTMENT', 'Information Technology', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('SUB DEPARTMENT', 'Web Development', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('REPORTING MANAGER', 'Not Assigned', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('BRANCH', 'Main Office', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('ASSIGNED SHIFT', 'OFFICE FULL TIME', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('SHIFT TIMING', '10:00 - 18:30', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('WORK WEEK RULE', 'OFFICE FULL TIME', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('WORKING DAYS / WEEK', '5 days', isDark),
          SizedBox(height: Responsive.h(12)),
          _buildFieldBox('WEEKLY OFF', 'Sat, Sun', isDark),
        ],
      ),
    );
  }

  Widget _buildWorkWeekTab(bool isDark, ThemeData theme) {
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
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: Responsive.w(12),
                  offset: Offset(0, Responsive.h(4)),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Week Configuration',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: Responsive.sp(16),
            ),
          ),
          SizedBox(height: Responsive.h(4)),
          Text(
            'View your working days and weekly off policy',
            style: TextStyle(
              fontSize: Responsive.sp(12),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.grey.shade500,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          Container(
            padding: EdgeInsets.all(Responsive.w(20)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2C) : Colors.transparent,
              borderRadius: BorderRadius.circular(Responsive.r(12)),
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
                  'OFFICE FULL TIME',
                  style: TextStyle(
                    fontSize: Responsive.sp(14),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: Responsive.h(4)),
                Text(
                  'This rule determines your daily work status.',
                  style: TextStyle(
                    fontSize: Responsive.sp(12),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: Responsive.h(16)),
                Text(
                  'EFFECTIVE DATE',
                  style: TextStyle(
                    fontSize: Responsive.sp(9),
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: Responsive.h(4)),
                Text(
                  '20 Mar 2026',
                  style: TextStyle(
                    fontSize: Responsive.sp(13),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: Responsive.h(16)),
                Divider(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade100,
                ),
                SizedBox(height: Responsive.h(16)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildWorkWeekGrid(isDark),
                ),
                SizedBox(height: Responsive.h(24)),
                Wrap(
                  spacing: Responsive.w(16),
                  runSpacing: Responsive.h(12),
                  children: [
                    _buildLegendItem(
                      const Color(0xFF22C55E),
                      'Working Day',
                      isDark,
                    ),
                    _buildLegendItem(
                      const Color(0xFFEF4444),
                      'Weekly Off',
                      isDark,
                    ),
                    _buildLegendItem(
                      const Color(0xFFEAB308),
                      'Half Day',
                      isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkWeekGrid(bool isDark) {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final weeks = [1, 2, 3, 4, 5];

    return Table(
      defaultColumnWidth: FixedColumnWidth(Responsive.w(40)),
      children: [
        TableRow(
          children: [
            _buildGridHeader('WEEK', isDark),
            ...days.map((day) => _buildGridHeader(day, isDark)),
          ],
        ),
        TableRow(
          children: List.generate(8, (_) => SizedBox(height: Responsive.h(16))),
        ),
        ...weeks.map((week) {
          return TableRow(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(8)),
                  child: Text(
                    '$week',
                    style: TextStyle(
                      fontSize: Responsive.sp(12),
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              ...days.map((day) {
                bool isWeekend = day == 'SAT' || day == 'SUN';
                return Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: Responsive.h(6)),
                    width: Responsive.w(16),
                    height: Responsive.w(16),
                    decoration: BoxDecoration(
                      color: isWeekend
                          ? const Color(0xFFEF4444) // Red for weekend
                          : const Color(0xFF22C55E), // Green for weekday
                      borderRadius: BorderRadius.circular(Responsive.r(4)),
                    ),
                  ),
                );
              }),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildGridHeader(String text, bool isDark) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: Responsive.sp(10),
          fontWeight: FontWeight.bold,
          color: isDark
              ? Colors.white.withValues(alpha: 0.5)
              : Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Responsive.w(10),
          height: Responsive.w(10),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: Responsive.w(6)),
        Text(
          text,
          style: TextStyle(
            fontSize: Responsive.sp(11),
            color: isDark
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildContactEmergencyTab(bool isDark, ThemeData theme) {
    return Column(
      children: [
        // Addresses Card
        Container(
          padding: EdgeInsets.all(Responsive.w(20)),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A24) : Colors.white,
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
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: Responsive.w(12),
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
                  Text(
                    'Addresses',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(16),
                    ),
                  ),
                  if (!_isEditingContact)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _isEditingContact = true),
                      icon: Icon(
                        Icons.edit_outlined,
                        size: Responsive.w(14),
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      label: Text(
                        'Edit',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: Responsive.sp(12),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(12),
                          vertical: Responsive.h(8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Responsive.r(8)),
                        ),
                        side: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.grey.shade300,
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () =>
                              setState(() => _isEditingContact = false),
                          icon: Icon(
                            Icons.close,
                            size: Responsive.w(14),
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          label: Text(
                            'Cancel',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.w(12),
                              vertical: Responsive.h(8),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.r(8),
                              ),
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.w(8)),
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => _isEditingContact = false),
                          icon: Icon(
                            Icons.save_outlined,
                            size: Responsive.w(14),
                            color: Colors.white,
                          ),
                          label: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2962FF),
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.w(12),
                              vertical: Responsive.h(8),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.r(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: Responsive.h(24)),
              _buildEditableFieldBox(
                'STREET ADDRESS',
                'sjkdf',
                isDark,
                isEditing: _isEditingContact,
              ),
              SizedBox(height: Responsive.h(12)),
              _buildEditableFieldBox(
                'CITY',
                '-',
                isDark,
                isEditing: _isEditingContact,
              ),
              SizedBox(height: Responsive.h(12)),
              _buildEditableFieldBox(
                'STATE',
                '-',
                isDark,
                isEditing: _isEditingContact,
              ),
              SizedBox(height: Responsive.h(12)),
              _buildEditableFieldBox(
                'ZIP CODE',
                '-',
                isDark,
                isEditing: _isEditingContact,
              ),
              SizedBox(height: Responsive.h(12)),
              _buildEditableFieldBox(
                'COUNTRY',
                '-',
                isDark,
                isEditing: _isEditingContact,
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.h(16)),
        // Emergency Contact Card
        Container(
          padding: EdgeInsets.all(Responsive.w(20)),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A24) : Colors.white,
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
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: Responsive.w(12),
                      offset: Offset(0, Responsive.h(4)),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade400,
                    size: Responsive.w(18),
                  ),
                  SizedBox(width: Responsive.w(8)),
                  Text(
                    'Emergency Contact',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(24)),
              _buildEditableFieldBox(
                'CONTACT NAME',
                '-',
                isDark,
                isEditing: _isEditingContact,
              ),
              SizedBox(height: Responsive.h(12)),
              _buildEditableFieldBox(
                'RELATIONSHIP',
                '-',
                isDark,
                isEditing: _isEditingContact,
              ),
              SizedBox(height: Responsive.h(12)),
              _buildEditableFieldBox(
                'PHONE NUMBER',
                '-',
                isDark,
                isEditing: _isEditingContact,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankTaxTab(bool isDark, ThemeData theme) {
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
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: Responsive.w(12),
                  offset: Offset(0, Responsive.h(4)),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Salary Account Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(16),
                            ),
                          ),
                          SizedBox(height: Responsive.h(4)),
                          Text(
                            'Manage your salary account and tax info',
                            style: TextStyle(
                              fontSize: Responsive.sp(12),
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
              ),
              if (!_isEditingBank)
                OutlinedButton.icon(
                  onPressed: () => setState(() => _isEditingBank = true),
                  icon: Icon(
                    Icons.edit_outlined,
                    size: Responsive.w(14),
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  label: Text(
                    'Edit',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: Responsive.sp(12),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.w(12),
                      vertical: Responsive.h(8),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Responsive.r(8)),
                    ),
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.grey.shade300,
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _isEditingBank = false),
                      icon: Icon(
                        Icons.close,
                        size: Responsive.w(14),
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      label: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: Responsive.sp(12),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(12),
                          vertical: Responsive.h(8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Responsive.r(8)),
                        ),
                        side: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.w(8)),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isEditingBank = false),
                      icon: Icon(
                        Icons.save_outlined,
                        size: Responsive.w(14),
                        color: Colors.white,
                      ),
                      label: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(12),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(12),
                          vertical: Responsive.h(8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Responsive.r(8)),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),
          _buildEditableFieldBox(
            'ACCOUNT HOLDER\'S NAME',
            'Yash Raj',
            isDark,
            isEditing: _isEditingBank,
          ),
          SizedBox(height: Responsive.h(12)),
          _buildEditableFieldBox(
            'BANK NAME',
            'sadfasdfgasdfsdgfsdf',
            isDark,
            isEditing: _isEditingBank,
          ),
          SizedBox(height: Responsive.h(12)),
          _buildEditableFieldBox(
            'ACCOUNT NUMBER',
            '54353454353',
            isDark,
            isEditing: _isEditingBank,
          ),
          SizedBox(height: Responsive.h(12)),
          _buildEditableFieldBox(
            'BRANCH NAME',
            'SDdasdasdsdsd',
            isDark,
            isEditing: _isEditingBank,
          ),
          SizedBox(height: Responsive.h(12)),
          _buildEditableFieldBox(
            'CITY',
            '-',
            isDark,
            isEditing: _isEditingBank,
          ),
          SizedBox(height: Responsive.h(12)),
          _buildEditableFieldBox(
            'IFSC CODE',
            '-',
            isDark,
            isEditing: _isEditingBank,
          ),
          SizedBox(height: Responsive.h(12)),
          _buildEditableFieldBox(
            'PAN NUMBER (TAX)',
            'DXNPA6705B',
            isDark,
            isEditing: _isEditingBank,
          ),
        ],
      ),
    );
  }

  Widget _buildEditableFieldBox(
    String label,
    String value,
    bool isDark, {
    bool isEditing = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(16),
        vertical: Responsive.h(12),
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.transparent,
        borderRadius: BorderRadius.circular(Responsive.r(8)),
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
            label,
            style: TextStyle(
              fontSize: Responsive.sp(9),
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: Responsive.h(6)),
          if (isEditing)
            Container(
              height: Responsive.h(36),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(Responsive.r(6)),
              ),
              child: TextField(
                controller: TextEditingController(text: value),
                style: TextStyle(
                  fontSize: Responsive.sp(13),
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(12),
                    vertical: Responsive.h(12),
                  ),
                  isDense: true,
                ),
              ),
            )
          else
            Text(
              value,
              style: TextStyle(
                fontSize: Responsive.sp(13),
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: Responsive.sp(10),
        fontWeight: FontWeight.bold,
        color: isDark
            ? Colors.white.withValues(alpha: 0.5)
            : Colors.grey.shade600,
        letterSpacing: 1.0,
      ),
    );
  }
}
