import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class RecruitmentScreen extends StatefulWidget {
  final bool showBackButton;
  const RecruitmentScreen({super.key, this.showBackButton = true});

  @override
  State<RecruitmentScreen> createState() => _RecruitmentScreenState();
}

class _RecruitmentScreenState extends State<RecruitmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Job Postings',
    'Candidates',
    'Interviews',
    'Offers',
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
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.grey.shade200;
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
              'Recruitment',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(22),
              ),
            ),
            Text(
              'Manage job postings & interviews.',
              style: TextStyle(fontSize: Responsive.sp(10), color: subText),
            ),
          ],
        ),
        actions: [
          _buildAnimated(
            0,
            child: GestureDetector(
              onTap: () =>
                  _showCreateJobDialog(isDark, cardBg, borderColor, subText),
              child: Container(
                margin: EdgeInsets.only(right: Responsive.w(16)),
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(14),
                  vertical: Responsive.h(10),
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(Responsive.r(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: isDark ? Colors.black : Colors.white,
                      size: Responsive.w(14),
                    ),
                    SizedBox(width: Responsive.w(4)),
                    Text(
                      'Create Job',
                      style: TextStyle(
                        color: isDark ? Colors.black : Colors.white,
                        fontSize: Responsive.sp(11),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Stat Cards (2x2 Grid) ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _statCard(
                          'Active Postings',
                          '0',
                          Icons.work_outline_rounded,
                          Colors.blue,
                          isDark,
                          cardBg,
                          borderColor,
                        ),
                        SizedBox(width: Responsive.w(12)),
                        _statCard(
                          'Total Applicants',
                          '0',
                          Icons.people_alt_outlined,
                          Colors.amber,
                          isDark,
                          cardBg,
                          borderColor,
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.h(12)),
                    Row(
                      children: [
                        _statCard(
                          'Interviews',
                          '0',
                          Icons.calendar_today_outlined,
                          Colors.orange,
                          isDark,
                          cardBg,
                          borderColor,
                        ),
                        SizedBox(width: Responsive.w(12)),
                        _statCard(
                          'Offers Extended',
                          '0',
                          Icons.description_outlined,
                          Colors.green,
                          isDark,
                          cardBg,
                          borderColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Navigation Tabs (Scrollable Pills) ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              2,
              child: SizedBox(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(22),
                          vertical: Responsive.h(10),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                    ? Colors.white.withValues(alpha: 0.12)
                                    : Colors.black)
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.03)
                                    : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(Responsive.r(20)),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : borderColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              fontSize: Responsive.sp(12),
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : subText,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Content Area ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(Responsive.r(16)),
                    border: Border.all(color: borderColor),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: Responsive.h(80)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(Responsive.w(20)),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.work_off_outlined,
                            size: Responsive.w(36),
                            color: subText,
                          ),
                        ),
                        SizedBox(height: Responsive.h(16)),
                        Text(
                          _selectedTabIndex == 0
                              ? 'No Active Postings'
                              : _selectedTabIndex == 1
                              ? 'No Candidates Yet'
                              : _selectedTabIndex == 2
                              ? 'No Interviews Scheduled'
                              : 'No Offers Extended',
                          style: TextStyle(
                            fontSize: Responsive.sp(14),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        SizedBox(height: Responsive.h(6)),
                        Text(
                          _selectedTabIndex == 0
                              ? "Tap 'Create Job' to add one."
                              : _selectedTabIndex == 1
                              ? 'Candidates will appear once jobs are posted.'
                              : _selectedTabIndex == 2
                              ? 'Schedule interviews from candidate profiles.'
                              : 'Extend offers from interview results.',
                          style: TextStyle(
                            fontSize: Responsive.sp(11),
                            color: subText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(60))),
        ],
      ),
    );
  }

  // ─── Stat Card ───
  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
    Color bg,
    Color border,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(16),
          vertical: Responsive.h(18),
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Responsive.r(14)),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.sp(10),
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white38 : Colors.grey.shade600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: Responsive.h(6)),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: Responsive.sp(26),
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
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

  // ─── Staggered Entrance Animation ───
  Widget _buildAnimated(int i, {required Widget child}) {
    final delay = (i * 0.1).clamp(0.0, 0.7);
    final end = (delay + 0.3).clamp(0.0, 1.0);
    final curved = CurvedAnimation(
      parent: _anim,
      curve: Interval(delay, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (_, __) => Opacity(
        opacity: curved.value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - curved.value)),
          child: child,
        ),
      ),
    );
  }

  // ─── Create Job Posting Dialog ───
  void _showCreateJobDialog(bool isDark, Color bg, Color border, Color sub) {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Responsive.w(370),
            constraints: BoxConstraints(maxHeight: Responsive.h(700)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A24) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 40,
                ),
              ],
            ),
            child: Column(
              children: [
                // ─── Header ───
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.w(24),
                    Responsive.h(24),
                    Responsive.w(24),
                    Responsive.h(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Job Posting',
                            style: TextStyle(
                              fontSize: Responsive.sp(18),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: Responsive.h(4)),
                          Text(
                            'Define requirements to open a new role.',
                            style: TextStyle(
                              fontSize: Responsive.sp(11),
                              color: sub,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(Responsive.w(6)),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(
                              Responsive.r(6),
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            size: Responsive.w(18),
                            color: isDark ? Colors.white54 : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Scrollable Form ───
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Responsive.w(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Prefill Template (highlighted)
                        Container(
                          padding: EdgeInsets.all(Responsive.w(16)),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF8B5CF6,
                            ).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(
                              Responsive.r(12),
                            ),
                            border: Border.all(
                              color: const Color(
                                0xFF8B5CF6,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PREFILL FROM DESIGNATION TEMPLATE',
                                style: TextStyle(
                                  fontSize: Responsive.sp(9),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF8B5CF6),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: Responsive.h(10)),
                              _dialogDropdown(
                                'Select a template to prefill Title and Department...',
                                isDark,
                                border,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Responsive.h(24)),

                        // Job Title
                        _dialogLabel('JOB TITLE', true, isDark, sub),
                        SizedBox(height: Responsive.h(8)),
                        _dialogTextField(
                          'e.g. Senior React Developer',
                          isDark,
                          border,
                          sub,
                          isHint: true,
                        ),
                        SizedBox(height: Responsive.h(20)),

                        // Department & Employment Type
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('DEPARTMENT', true, isDark, sub),
                                  SizedBox(height: Responsive.h(8)),
                                  _dialogDropdown(
                                    'Select Department',
                                    isDark,
                                    border,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Responsive.w(16)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel(
                                    'EMPLOYMENT TYPE',
                                    false,
                                    isDark,
                                    sub,
                                  ),
                                  SizedBox(height: Responsive.h(8)),
                                  _dialogDropdown('Full-Time', isDark, border),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.h(20)),

                        // Location & Experience
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('LOCATION', true, isDark, sub),
                                  SizedBox(height: Responsive.h(8)),
                                  _dialogTextField(
                                    'e.g. New York, Remote',
                                    isDark,
                                    border,
                                    sub,
                                    isHint: true,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Responsive.w(16)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel(
                                    'EXPERIENCE',
                                    false,
                                    isDark,
                                    sub,
                                  ),
                                  SizedBox(height: Responsive.h(8)),
                                  _dialogDropdown(
                                    'Fresher (0 years)',
                                    isDark,
                                    border,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.h(20)),

                        // Min & Max Salary
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel(
                                    'MIN SALARY (ANNUAL)',
                                    true,
                                    isDark,
                                    sub,
                                  ),
                                  SizedBox(height: Responsive.h(8)),
                                  _dialogTextFieldWithPrefix(
                                    '250000',
                                    '₹',
                                    isDark,
                                    border,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Responsive.w(16)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel(
                                    'MAX SALARY (ANNUAL)',
                                    true,
                                    isDark,
                                    sub,
                                  ),
                                  SizedBox(height: Responsive.h(8)),
                                  _dialogTextFieldWithPrefix(
                                    '500000',
                                    '₹',
                                    isDark,
                                    border,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.h(20)),

                        // Openings & Initial Status
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('OPENINGS', false, isDark, sub),
                                  SizedBox(height: Responsive.h(8)),
                                  _dialogTextFieldWithPrefix(
                                    '1',
                                    null,
                                    isDark,
                                    border,
                                    icon: Icons.people_outline_rounded,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Responsive.w(16)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel(
                                    'INITIAL STATUS',
                                    false,
                                    isDark,
                                    sub,
                                  ),
                                  SizedBox(height: Responsive.h(8)),
                                  _dialogDropdown('Active', isDark, border),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.h(20)),

                        // Job Description
                        _dialogLabel('JOB DESCRIPTION', true, isDark, sub),
                        SizedBox(height: Responsive.h(8)),
                        Container(
                          height: Responsive.h(120),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.w(14),
                            vertical: Responsive.h(12),
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(
                              Responsive.r(10),
                            ),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white12
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            'Outline the requirements and responsibilities...',
                            style: TextStyle(
                              fontSize: Responsive.sp(12),
                              color: sub,
                            ),
                          ),
                        ),
                        SizedBox(height: Responsive.h(24)),
                      ],
                    ),
                  ),
                ),

                // ─── Publish Button ───
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.w(24),
                    0,
                    Responsive.w(24),
                    Responsive.h(24),
                  ),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        ),
                        borderRadius: BorderRadius.circular(Responsive.r(10)),
                      ),
                      child: Center(
                        child: Text(
                          'Publish Job',
                          style: TextStyle(
                            fontSize: Responsive.sp(14),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Dialog Helpers ───
  Widget _dialogLabel(String text, bool required, bool isDark, Color sub) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: Responsive.sp(10),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        if (required)
          Text(
            ' *',
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _dialogDropdown(String value, bool isDark, Color border) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(14),
        vertical: Responsive.h(14),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(10)),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: Responsive.sp(13),
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: Responsive.w(4)),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: Responsive.w(18),
            color: isDark ? Colors.white38 : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _dialogTextField(
    String text,
    bool isDark,
    Color border,
    Color sub, {
    bool isHint = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(14),
        vertical: Responsive.h(14),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(10)),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Responsive.sp(13),
          fontWeight: isHint ? FontWeight.w400 : FontWeight.w600,
          color: isHint ? sub : (isDark ? Colors.white : Colors.black87),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _dialogTextFieldWithPrefix(
    String value,
    String? prefix,
    bool isDark,
    Color border, {
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(14),
        vertical: Responsive.h(14),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(10)),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: Responsive.w(16),
              color: isDark ? Colors.white38 : Colors.grey,
            ),
            SizedBox(width: Responsive.w(8)),
          ],
          if (prefix != null) ...[
            Text(
              prefix,
              style: TextStyle(
                fontSize: Responsive.sp(13),
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white38 : Colors.grey,
              ),
            ),
            SizedBox(width: Responsive.w(8)),
          ],
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.sp(13),
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
