import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import '../models/department_model.dart';

class DepartmentsScreen extends StatefulWidget {
  final bool showBackButton;
  const DepartmentsScreen({super.key, this.showBackButton = true});
  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  final _searchController = TextEditingController();

  final List<DepartmentModel> _departments = const [
    DepartmentModel(
      name: 'Information Technology',
      head: 'Arpit Agarwal',
      headcount: 4,
      performance: 0.0,
      openings: 0,
      recentActivity: 'STABLE',
    ),
    DepartmentModel(
      name: 'Sales',
      head: 'Arpit Agarwal',
      headcount: 9,
      performance: 0.0,
      openings: 0,
      recentActivity: '+3 HIRES IN 30D',
    ),
    DepartmentModel(
      name: 'General',
      head: 'Unassigned',
      headcount: 1,
      performance: 0.0,
      openings: 0,
      recentActivity: '+1 HIRE IN 30D',
    ),
    DepartmentModel(
      name: 'Product',
      head: 'Unassigned',
      headcount: 0,
      performance: 0.0,
      openings: 0,
      recentActivity: 'STABLE',
    ),
    DepartmentModel(
      name: 'Demo role',
      head: 'Prabhanjan Das',
      headcount: 1,
      performance: 4.5,
      openings: 0,
      recentActivity: 'STABLE',
    ),
    DepartmentModel(
      name: 'Management',
      head: 'Unassigned',
      headcount: 0,
      performance: 0.0,
      openings: 0,
      recentActivity: 'STABLE',
    ),
    DepartmentModel(
      name: 'HR',
      head: 'Arvind kumar Sah',
      headcount: 0,
      performance: 0.0,
      openings: 0,
      recentActivity: 'STABLE',
    ),
    DepartmentModel(
      name: 'Administration',
      head: 'Unassigned',
      headcount: 2,
      performance: 0.0,
      openings: 0,
      recentActivity: '+2 HIRES IN 30D',
    ),
    DepartmentModel(
      name: 'AI&ML',
      head: 'Prabhanjan Kumar Das',
      headcount: 2,
      performance: 3.0,
      openings: 0,
      recentActivity: '+2 HIRES IN 30D',
    ),
    DepartmentModel(
      name: 'IT',
      head: 'Unassigned',
      headcount: 1,
      performance: 0.0,
      openings: 0,
      recentActivity: '+1 HIRE IN 30D',
    ),
  ];

  final List<DesignationModel> _designations = const [
    DesignationModel(title: 'AI&MI', department: 'AI&ML'),
    DesignationModel(
      title: 'Backend Developer',
      department: 'Information Technology',
    ),
    DesignationModel(
      title: 'Full Stack Web Developer',
      department: 'Information Technology',
    ),
    DesignationModel(title: 'HR Executive', department: 'HR'),
    DesignationModel(title: 'Lead management', department: 'demo'),
    DesignationModel(title: 'Product Manager', department: 'Product'),
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
    _searchController.dispose();
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
              'Departments',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(22),
              ),
            ),
            Text(
              'Organizational structure and unit analytics.',
              style: TextStyle(fontSize: Responsive.sp(10), color: subText),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => _showNewDeptDialog(isDark, cardBg),
            child: Container(
              margin: EdgeInsets.only(right: Responsive.w(16)),
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.w(12),
                vertical: Responsive.h(8),
              ),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(Responsive.r(8)),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: Responsive.w(14),
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  SizedBox(width: Responsive.w(4)),
                  Text(
                    'New Dept',
                    style: TextStyle(
                      fontSize: Responsive.sp(11),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(16))),
          // ─── Stat Summary Cards ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                child: Row(
                  children: [
                    _statCard(
                      'DEPARTMENTS',
                      '${_departments.length}',
                      Icons.apartment_rounded,
                      const Color(0xFF8B5CF6),
                      isDark,
                      cardBg,
                      borderColor,
                    ),
                    SizedBox(width: Responsive.w(12)),
                    _statCard(
                      'EMPLOYEES',
                      '${_departments.fold<int>(0, (s, d) => s + d.headcount)}',
                      Icons.people_alt_rounded,
                      Colors.teal,
                      isDark,
                      cardBg,
                      borderColor,
                    ),
                    SizedBox(width: Responsive.w(12)),
                    _statCard(
                      'AVG PERFORMANCE',
                      _departments.where((d) => d.performance > 0).isEmpty
                          ? '0.0'
                          : (_departments
                                        .where((d) => d.performance > 0)
                                        .map((d) => d.performance)
                                        .reduce((a, b) => a + b) /
                                    _departments
                                        .where((d) => d.performance > 0)
                                        .length)
                                .toStringAsFixed(1),
                      Icons.track_changes_rounded,
                      Colors.green,
                      isDark,
                      cardBg,
                      borderColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),
          // ─── Search Bar ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                child: Container(
                  height: Responsive.h(42),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(Responsive.r(12)),
                    border: Border.all(color: borderColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      fontSize: Responsive.sp(13),
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search departments...',
                      hintStyle: TextStyle(
                        color: subText,
                        fontSize: Responsive.sp(13),
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: subText,
                        size: Responsive.w(18),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: Responsive.h(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),
          // ─── Department Grid ───
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Responsive.h(12),
                crossAxisSpacing: Responsive.w(12),
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildAnimated(
                  i + 2,
                  child: _deptCard(
                    _departments[i],
                    isDark,
                    cardBg,
                    borderColor,
                    subText,
                  ),
                ),
                childCount: _departments.length,
              ),
            ),
          ),
          // ─── Designations Section ───
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(32))),
          SliverToBoxAdapter(
            child: _buildAnimated(
              12,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Designations',
                          style: TextStyle(
                            fontSize: Responsive.sp(18),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          'Manage job roles across the organization.',
                          style: TextStyle(
                            fontSize: Responsive.sp(10),
                            color: subText,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _showNewDesignationDialog(isDark, cardBg),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(12),
                          vertical: Responsive.h(8),
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(Responsive.r(8)),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: Responsive.w(14),
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                            SizedBox(width: Responsive.w(4)),
                            Text(
                              'New Designation',
                              style: TextStyle(
                                fontSize: Responsive.sp(10),
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(12))),
          SliverToBoxAdapter(
            child: _buildAnimated(
              13,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(Responsive.r(16)),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(16),
                          vertical: Responsive.h(12),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: borderColor),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'DESIGNATION TITLE',
                                style: TextStyle(
                                  fontSize: Responsive.sp(9),
                                  fontWeight: FontWeight.bold,
                                  color: subText,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'DEPARTMENT',
                                style: TextStyle(
                                  fontSize: Responsive.sp(9),
                                  fontWeight: FontWeight.bold,
                                  color: subText,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Responsive.w(30),
                              child: Text(
                                'ACTIONS',
                                style: TextStyle(
                                  fontSize: Responsive.sp(9),
                                  fontWeight: FontWeight.bold,
                                  color: subText,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ..._designations.map(
                        (d) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.w(16),
                            vertical: Responsive.h(14),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: borderColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  d.title,
                                  style: TextStyle(
                                    fontSize: Responsive.sp(12),
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  d.department,
                                  style: TextStyle(
                                    fontSize: Responsive.sp(12),
                                    color: subText,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Responsive.w(30),
                                child: Icon(
                                  Icons.more_vert_rounded,
                                  size: Responsive.w(16),
                                  color: subText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
        padding: EdgeInsets.all(Responsive.w(14)),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Responsive.r(14)),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.sp(10),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                    maxLines: 2,
                  ),
                ),
                SizedBox(width: Responsive.w(4)),
                Icon(icon, size: Responsive.w(18), color: color),
              ],
            ),
            SizedBox(height: Responsive.h(8)),
            Text(
              value,
              style: TextStyle(
                fontSize: Responsive.sp(22),
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deptCard(
    DepartmentModel dept,
    bool isDark,
    Color bg,
    Color border,
    Color sub,
  ) {
    final isHiring = dept.recentActivity != 'STABLE';
    return Container(
      padding: EdgeInsets.all(Responsive.w(14)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Responsive.r(14)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(6)),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Responsive.r(6)),
                ),
                child: Icon(
                  Icons.apartment_rounded,
                  size: Responsive.w(14),
                  color: const Color(0xFF8B5CF6),
                ),
              ),
              GestureDetector(
                onTap: () => _showDeptMenu(dept, isDark, bg),
                child: Icon(
                  Icons.more_vert_rounded,
                  size: Responsive.w(16),
                  color: sub,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(8)),
          Text(
            dept.name,
            style: TextStyle(
              fontSize: Responsive.sp(13),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Head: ${dept.head}',
            style: TextStyle(fontSize: Responsive.sp(9), color: sub),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          _infoRow('Headcount', '${dept.headcount}', isDark, sub),
          SizedBox(height: Responsive.h(4)),
          _infoRow(
            'Performance',
            '⭐ ${dept.performance}',
            isDark,
            sub,
            valueColor: Colors.amber,
          ),
          SizedBox(height: Responsive.h(4)),
          _infoRow(
            'Openings',
            '${dept.openings}',
            isDark,
            sub,
            valueColor: const Color(0xFF8B5CF6),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: Responsive.h(6)),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RECENT ACTIVITY',
                  style: TextStyle(
                    fontSize: Responsive.sp(7),
                    fontWeight: FontWeight.bold,
                    color: sub,
                    letterSpacing: 0.3,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(6),
                    vertical: Responsive.h(2),
                  ),
                  decoration: BoxDecoration(
                    color: isHiring
                        ? const Color(0xFF8B5CF6).withValues(alpha: 0.15)
                        : (isDark ? Colors.white10 : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(Responsive.r(4)),
                  ),
                  child: Text(
                    dept.recentActivity,
                    style: TextStyle(
                      fontSize: Responsive.sp(7),
                      fontWeight: FontWeight.bold,
                      color: isHiring ? const Color(0xFF8B5CF6) : sub,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value,
    bool isDark,
    Color sub, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: Responsive.sp(10), color: sub),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.sp(10),
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimated(int i, {required Widget child}) {
    final delay = (i * 0.06).clamp(0.0, 0.7);
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

  void _showDeptMenu(DepartmentModel dept, bool isDark, Color bg) {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Responsive.w(200),
            padding: EdgeInsets.symmetric(vertical: Responsive.h(8)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _menuItem(
                  Icons.edit_rounded,
                  'Edit Head',
                  isDark,
                  () => Get.back(),
                ),
                _menuItem(
                  Icons.people_alt_rounded,
                  'Employees',
                  isDark,
                  () => Get.back(),
                ),
                _menuItem(
                  Icons.delete_rounded,
                  'Delete',
                  isDark,
                  () => Get.back(),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String text,
    bool isDark,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? Colors.redAccent
        : (isDark ? Colors.white70 : Colors.black87);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(16),
          vertical: Responsive.h(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: Responsive.w(18), color: color),
            SizedBox(width: Responsive.w(12)),
            Text(
              text,
              style: TextStyle(
                fontSize: Responsive.sp(13),
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewDeptDialog(bool isDark, Color bg) {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Responsive.w(340),
            padding: EdgeInsets.all(Responsive.w(24)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Department',
                      style: TextStyle(
                        fontSize: Responsive.sp(18),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: isDark ? Colors.white54 : Colors.grey,
                        size: Responsive.w(20),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Add a new organizational unit.',
                  style: TextStyle(
                    fontSize: Responsive.sp(11),
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: Responsive.h(24)),
                Text(
                  'DEPARTMENT NAME *',
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: Responsive.h(8)),
                _dialogField('e.g. Engineering', isDark),
                SizedBox(height: Responsive.h(16)),
                Text(
                  'DEPARTMENT HEAD (Optional)',
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: Responsive.h(8)),
                _dialogField('No department head yet', isDark),
                SizedBox(height: Responsive.h(8)),
                Text(
                  'Headcount is calculated from assigned employees. Openings stay at 0 until active job postings are created.',
                  style: TextStyle(
                    fontSize: Responsive.sp(9),
                    color: isDark ? Colors.white24 : Colors.grey.shade400,
                  ),
                ),
                SizedBox(height: Responsive.h(24)),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.h(14),
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(
                              Responsive.r(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: Responsive.sp(13),
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.w(12)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.h(14),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Responsive.r(10)),
                        ),
                        child: Center(
                          child: Text(
                            'Create Department',
                            style: TextStyle(
                              fontSize: Responsive.sp(13),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNewDesignationDialog(bool isDark, Color bg) {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Responsive.w(340),
            padding: EdgeInsets.all(Responsive.w(24)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Designation',
                      style: TextStyle(
                        fontSize: Responsive.sp(18),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: isDark ? Colors.white54 : Colors.grey,
                        size: Responsive.w(20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(24)),
                Text(
                  'DESIGNATION TITLE *',
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: Responsive.h(8)),
                _dialogField('e.g. Senior Product Designer', isDark),
                SizedBox(height: Responsive.h(16)),
                Text(
                  'DEPARTMENT',
                  style: TextStyle(
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: Responsive.h(8)),
                _dialogField('General (No Department)', isDark),
                SizedBox(height: Responsive.h(24)),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.h(14),
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(
                              Responsive.r(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: Responsive.sp(13),
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.w(12)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.h(14),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Responsive.r(10)),
                        ),
                        child: Center(
                          child: Text(
                            'Create Designation',
                            style: TextStyle(
                              fontSize: Responsive.sp(13),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogField(String hint, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(14),
        vertical: Responsive.h(12),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(10)),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      child: Text(
        hint,
        style: TextStyle(
          fontSize: Responsive.sp(13),
          color: isDark ? Colors.white38 : Colors.grey.shade400,
        ),
      ),
    );
  }
}
