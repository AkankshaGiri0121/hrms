import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class AdminAttendanceScreen extends StatefulWidget {
  final bool showBackButton;
  const AdminAttendanceScreen({super.key, this.showBackButton = true});

  @override
  State<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Daily Attendance',
    'Leave Requests',
    'Holidays',
    'Shift Management',
    'Overtime',
    'Regularization',
    'Reports'
  ];

  final List<Map<String, dynamic>> _dummyEmployees = [
    {
      'name': 'Arpit Agarwal',
      'id': 'EMP-2024-001',
      'dept': 'IT',
      'in': '-',
      'out': '-',
      'work': '-',
      'img': null,
    },
    {
      'name': 'Abhishek Singh',
      'id': 'EMP-2024-01',
      'dept': 'IT',
      'in': '-',
      'out': '-',
      'work': '-',
      'img': null,
    },
    {
      'name': 'Prabhanjan Kumar das',
      'id': 'EMP-2024-002',
      'dept': 'IT',
      'in': '-',
      'out': '-',
      'work': '-',
      'img': null,
    },
    {
      'name': 'Shalini Tomar',
      'id': 'EMP-2026-004-353',
      'dept': 'SALES',
      'in': '-',
      'out': '-',
      'work': '-',
      'img': null,
    },
    {
      'name': 'Akshita Mishra',
      'id': 'EMP-2026-005-647',
      'dept': 'SALES',
      'in': '-',
      'out': '-',
      'work': '-',
      'img': null,
    },
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
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade200;
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
                icon: Icon(Icons.arrow_back_ios_rounded, color: isDark ? Colors.white : Colors.black, size: Responsive.w(22)),
                onPressed: () => Get.back(),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attendance Management', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: Responsive.sp(22))),
            Text('Track and manage employee attendance and requests.', style: TextStyle(fontSize: Responsive.sp(10), color: subText)),
          ],
        ),
        actions: [
          _buildAnimated(0, child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(10)),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(Responsive.r(8)),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.download_rounded, color: isDark ? Colors.white : Colors.black87, size: Responsive.w(14)),
                      SizedBox(width: Responsive.w(6)),
                      Text('Export', style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: Responsive.sp(11), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: Responsive.w(8)),
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(right: Responsive.w(16)),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(10)),
                  decoration: BoxDecoration(color: isDark ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(Responsive.r(8))),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: isDark ? Colors.black : Colors.white, size: Responsive.w(14)),
                      SizedBox(width: Responsive.w(4)),
                      Text('Mark Attendance', style: TextStyle(color: isDark ? Colors.black : Colors.white, fontSize: Responsive.sp(11), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Stat Cards (Scrollable Row) ───
          SliverToBoxAdapter(
            child: _buildAnimated(1, child: SizedBox(
              height: Responsive.h(110),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                children: [
                  _statCard('TOTAL EMPLOYEES', '23', Icons.people_alt_rounded, const Color(0xFF6366F1), isDark, cardBg, borderColor, width: Responsive.w(160)),
                  SizedBox(width: Responsive.w(12)),
                  _statCard('PRESENT', '0', Icons.how_to_reg_rounded, const Color(0xFF10B981), isDark, cardBg, borderColor, width: Responsive.w(140)),
                  SizedBox(width: Responsive.w(12)),
                  _statCard('LATE', '0', Icons.access_time_filled_rounded, const Color(0xFFF59E0B), isDark, cardBg, borderColor, width: Responsive.w(140)),
                  SizedBox(width: Responsive.w(12)),
                  _statCard('ON LEAVE', '0', Icons.event_busy_rounded, const Color(0xFF3B82F6), isDark, cardBg, borderColor, width: Responsive.w(140)),
                  SizedBox(width: Responsive.w(12)),
                  _statCard('ABSENT', '23', Icons.person_off_rounded, const Color(0xFFEF4444), isDark, cardBg, borderColor, width: Responsive.w(140)),
                ],
              ),
            )),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Navigation Tabs (Scrollable Pills) ───
          SliverToBoxAdapter(
            child: _buildAnimated(2, child: SizedBox(
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
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(22), vertical: Responsive.h(10)),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black)
                            : (isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(Responsive.r(20)),
                        border: Border.all(color: isSelected ? Colors.transparent : borderColor),
                      ),
                      child: Center(
                        child: Text(_tabs[index], style: TextStyle(
                          fontSize: Responsive.sp(12), fontWeight: FontWeight.w700,
                          color: isSelected ? (isDark ? Colors.white : Colors.white) : subText,
                        )),
                      ),
                    ),
                  );
                },
              ),
            )),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(24))),

          // ─── Main Content Area ───
          SliverToBoxAdapter(
            child: _buildAnimated(3, child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
              child: Column(
                children: [
                  // ─── Left Panel on Desktop -> Top Panel on Mobile ───
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Responsive.w(20)),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(Responsive.r(16)),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Date', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        SizedBox(height: Responsive.h(12)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Responsive.w(14), vertical: Responsive.h(14)),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(Responsive.r(10)),
                            border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text('05/03/2026', style: TextStyle(fontSize: Responsive.sp(13), fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87))),
                              Icon(Icons.calendar_today_outlined, size: Responsive.w(16), color: isDark ? Colors.white70 : Colors.grey),
                            ],
                          ),
                        ),
                        SizedBox(height: Responsive.h(20)),
                        // Legend
                        _legendItem('PRESENT / HALFDAY', const Color(0xFF10B981), isDark),
                        _legendItem('LATE / LATE-HALFDAY', const Color(0xFFF59E0B), isDark),
                        _legendItem('LEAVE DAYS', const Color(0xFF3B82F6), isDark),
                        _legendItem('ABSENT / SHORTFALL HALFDAY', const Color(0xFFEF4444), isDark),
                      ],
                    ),
                  ),
                  SizedBox(height: Responsive.h(20)),

                  // ─── Right Panel on Desktop -> Bottom List on Mobile ───
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(Responsive.r(16)),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(Responsive.w(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Daily Attendance', style: TextStyle(fontSize: Responsive.sp(16), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                                  SizedBox(height: Responsive.h(4)),
                                  Text('Sunday, 3 May 2026', style: TextStyle(fontSize: Responsive.sp(11), color: subText)),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(6)),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(Responsive.r(6)),
                                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                                ),
                                child: Text('0% PRESENT', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: borderColor),
                        
                        // Employee Cards
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _dummyEmployees.length,
                          separatorBuilder: (_, __) => Divider(height: 1, color: borderColor),
                          itemBuilder: (_, index) {
                            final emp = _dummyEmployees[index];
                            return _employeeAttendanceCard(emp, isDark, subText);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ),
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(60))),
        ],
      ),
    );
  }

  // ─── Stat Card ───
  Widget _statCard(String title, String value, IconData icon, Color color, bool isDark, Color bg, Color border, {required double width}) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(16)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Responsive.r(14)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(title, style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.w800, color: isDark ? Colors.white38 : Colors.grey.shade600, letterSpacing: 0.3)),
              ),
              Container(
                padding: EdgeInsets.all(Responsive.w(6)),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(Responsive.r(8))),
                child: Icon(icon, size: Responsive.w(14), color: color),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(8)),
          Text(value, style: TextStyle(fontSize: Responsive.sp(22), fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }

  // ─── Legend Item ───
  Widget _legendItem(String label, Color color, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.h(12)),
      child: Row(
        children: [
          Container(
            width: Responsive.w(8), height: Responsive.w(8),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: Responsive.w(12)),
          Text(label, style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.w700, color: isDark ? Colors.white70 : Colors.black54, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  // ─── Mobile Employee Card ───
  Widget _employeeAttendanceCard(Map<String, dynamic> emp, bool isDark, Color subText) {
    return Padding(
      padding: EdgeInsets.all(Responsive.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Info
          Row(
            children: [
              CircleAvatar(
                radius: Responsive.w(20),
                backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                child: Text(
                  emp['name'].toString().substring(0, 1).toUpperCase(),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: Responsive.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emp['name'], style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    SizedBox(height: Responsive.h(2)),
                    Text('${emp['id']}  •  ${emp['dept']}', style: TextStyle(fontSize: Responsive.sp(11), color: subText)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          // Stats Grid
          Container(
            padding: EdgeInsets.all(Responsive.w(12)),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(Responsive.r(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _empStat('IN', emp['in'], isDark, subText),
                _empStat('OUT', emp['out'], isDark, subText),
                _empStat('WORK', emp['work'], isDark, subText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _empStat(String label, String value, bool isDark, Color subText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText)),
        SizedBox(height: Responsive.h(4)),
        Text(value, style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
      ],
    );
  }

  // ─── Staggered Entrance Animation ───
  Widget _buildAnimated(int i, {required Widget child}) {
    final delay = (i * 0.1).clamp(0.0, 0.7);
    final end = (delay + 0.3).clamp(0.0, 1.0);
    final curved = CurvedAnimation(parent: _anim, curve: Interval(delay, end, curve: Curves.easeOutCubic));
    return AnimatedBuilder(
      animation: curved,
      builder: (_, __) => Opacity(
        opacity: curved.value,
        child: Transform.translate(offset: Offset(0, 24 * (1 - curved.value)), child: child),
      ),
    );
  }
}
