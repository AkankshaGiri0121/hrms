import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import '../models/employee_model.dart';

class EmployeeHubScreen extends StatefulWidget {
  final bool showBackButton;
  const EmployeeHubScreen({super.key, this.showBackButton = true});

  @override
  State<EmployeeHubScreen> createState() => _EmployeeHubScreenState();
}

class _EmployeeHubScreenState extends State<EmployeeHubScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  final _searchController = TextEditingController();

  final List<EmployeeModel> _employees = const [
    EmployeeModel(
      id: 'EMP004',
      clockStatus: 'CLOCKED OUT',
      name: 'Preeti Singh',
      title: 'Sales Executive',
      department: 'Sales',
      office: 'Main',
      joinDate: '01 May 2026',
      salary: '-',
      manager: 'No manager assigned',
      email: 'preeti@test.com',
    ),
    EmployeeModel(
      id: 'EMP003',
      clockStatus: 'CLOCKED OUT',
      name: 'Sales Manager',
      title: 'Sales Manager',
      department: 'Sales',
      office: 'Main',
      joinDate: '01 May 2026',
      salary: '-',
      manager: 'manager@test.com',
      email: 'manager@test.com',
    ),
    EmployeeModel(
      id: 'EMP002',
      clockStatus: 'CLOCKED OUT',
      name: 'Sales Head',
      title: 'Sales Head',
      department: 'Sales',
      office: 'Main',
      joinDate: '01 May 2026',
      salary: '-',
      manager: 'saleshead@test.com',
      email: 'saleshead@test.com',
    ),
    EmployeeModel(
      id: 'EMP001',
      clockStatus: 'CLOCKED OUT',
      name: 'System Admin',
      title: 'Administrator',
      department: 'IT',
      office: 'Main',
      joinDate: '01 May 2026',
      salary: '-',
      manager: 'admin@test.com',
      email: 'admin@test.com',
    ),
    EmployeeModel(
      id: 'sales-2026-028-711',
      clockStatus: 'CLOCKED OUT',
      name: 'Arpit Sales Head',
      title: 'Employee',
      department: '-',
      office: 'Main Office',
      joinDate: '-',
      salary: '-',
      manager: 'head@test.com',
      email: 'head@test.com',
    ),
    EmployeeModel(
      id: 'EMP-2026-022-326',
      clockStatus: 'CLOCKED OUT',
      name: 'Raj kumar',
      title: 'Software Engineer',
      department: 'AI&ML',
      office: 'Main Office',
      joinDate: '23 Apr 2026',
      salary: '₹25,250/mo',
      manager: 'No manager assigned',
      email: 'emp-2026-022-326@capyngen.com',
      hasImage: true,
    ),
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
              'Employee Hub',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(22),
              ),
            ),
            Text(
              'Manage and view all employee information.',
              style: TextStyle(fontSize: Responsive.sp(10), color: subText),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(16))),
          // ─── Seats Used Badge ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.w(12),
                        vertical: Responsive.h(6),
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(Responsive.r(20)),
                      ),
                      child: Text(
                        '23 / 5000 SEATS USED',
                        style: TextStyle(
                          fontSize: Responsive.sp(9),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Search Bar & Add Button ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: Responsive.h(42),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.transparent
                              : Colors.grey.shade50,
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
                            hintText: 'Search by name, ID, or dept...',
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
                    SizedBox(width: Responsive.w(12)),
                    Container(
                      height: Responsive.h(42),
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.w(16),
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(Responsive.r(12)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: isDark ? Colors.black : Colors.white,
                            size: Responsive.w(16),
                          ),
                          SizedBox(width: Responsive.w(6)),
                          Text(
                            'Add Employee',
                            style: TextStyle(
                              color: isDark ? Colors.black : Colors.white,
                              fontSize: Responsive.sp(12),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(32))),

          // ─── Active Employees Section Header ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Employees',
                      style: TextStyle(
                        fontSize: Responsive.sp(16),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.w(8),
                        vertical: Responsive.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(Responsive.r(8)),
                      ),
                      child: Text(
                        '23',
                        style: TextStyle(
                          fontSize: Responsive.sp(10),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(16))),

          // ─── Employee List (Single column for mobile readability) ───
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((ctx, i) {
                return _buildAnimated(
                  i + 3,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: Responsive.h(16)),
                    child: _employeeCard(
                      _employees[i],
                      isDark,
                      cardBg,
                      borderColor,
                      subText,
                    ),
                  ),
                );
              }, childCount: _employees.length),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(60))),
        ],
      ),
    );
  }

  Widget _employeeCard(
    EmployeeModel emp,
    bool isDark,
    Color bg,
    Color border,
    Color sub,
  ) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: ID & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID: ${emp.id}',
                style: TextStyle(
                  fontSize: Responsive.sp(9),
                  fontWeight: FontWeight.bold,
                  color: sub,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(8),
                  vertical: Responsive.h(4),
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(Responsive.r(6)),
                ),
                child: Text(
                  emp.clockStatus,
                  style: TextStyle(
                    fontSize: Responsive.sp(8),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(16)),

          // Profile Row
          Row(
            children: [
              Container(
                width: Responsive.w(40),
                height: Responsive.w(40),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: emp.hasImage
                      ? Icon(
                          Icons.person,
                          color: Colors.white,
                          size: Responsive.w(24),
                        )
                      : Text(
                          emp.initials,
                          style: TextStyle(
                            color: const Color(0xFF8B5CF6),
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(14),
                          ),
                        ),
                ),
              ),
              SizedBox(width: Responsive.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emp.name,
                      style: TextStyle(
                        fontSize: Responsive.sp(16),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Responsive.h(4)),
                    Row(
                      children: [
                        Text(
                          emp.title,
                          style: TextStyle(
                            fontSize: Responsive.sp(11),
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: Responsive.w(8)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.w(6),
                            vertical: Responsive.h(2),
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(
                              Responsive.r(4),
                            ),
                          ),
                          child: Text(
                            emp.title.replaceAll(' ', '_').toUpperCase(),
                            style: TextStyle(
                              fontSize: Responsive.sp(7),
                              fontWeight: FontWeight.bold,
                              color: sub,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(20)),

          // Details List
          _detailRow(Icons.work_outline_rounded, emp.department, sub, isDark),
          SizedBox(height: Responsive.h(8)),
          _detailRow(Icons.location_on_outlined, emp.office, sub, isDark),
          SizedBox(height: Responsive.h(8)),
          _detailRow(Icons.calendar_today_outlined, emp.joinDate, sub, isDark),
          SizedBox(height: Responsive.h(8)),
          _detailRow(Icons.currency_rupee_rounded, emp.salary, sub, isDark),
          SizedBox(height: Responsive.h(8)),
          _detailRow(
            Icons.supervisor_account_outlined,
            emp.manager,
            sub,
            isDark,
          ),
          SizedBox(height: Responsive.h(8)),
          _detailRow(Icons.mail_outline_rounded, emp.email, sub, isDark),
          SizedBox(height: Responsive.h(20)),

          // Actions Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(Responsive.r(8)),
                  ),
                  child: Center(
                    child: Text(
                      'View Profile',
                      style: TextStyle(
                        fontSize: Responsive.sp(12),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: Responsive.w(12)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(16),
                  vertical: Responsive.h(12),
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(Responsive.r(8)),
                ),
                child: Icon(
                  Icons.mail_outline_rounded,
                  size: Responsive.w(18),
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text, Color sub, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: Responsive.w(14), color: sub),
        SizedBox(width: Responsive.w(12)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: Responsive.sp(11),
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
}
