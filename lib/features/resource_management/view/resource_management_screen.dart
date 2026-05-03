import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class ResourceManagementScreen extends StatefulWidget {
  const ResourceManagementScreen({super.key});

  @override
  State<ResourceManagementScreen> createState() => _ResourceManagementScreenState();
}

class _ResourceManagementScreenState extends State<ResourceManagementScreen> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  int _activeTabIndex = 0;

  final List<String> _tabs = [
    'Department Allocation',
    'Project Allocation',
    'Skill Mapping',
    'Workforce Planning',
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

  Widget _buildAnimated(int index, {required Widget child}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _anim,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOutCubic),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _anim,
            curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade200;
    final subText = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black,
            size: Responsive.w(20),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Header ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resource Management',
                            style: TextStyle(
                              fontSize: Responsive.sp(22),
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: Responsive.h(4)),
                          Text(
                            'Workforce planning, utilization, and project allocation.',
                            style: TextStyle(
                              fontSize: Responsive.sp(12),
                              color: subText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: Responsive.w(16)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.w(16),
                        vertical: Responsive.h(10),
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black87,
                        borderRadius: BorderRadius.circular(Responsive.r(8)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            size: Responsive.w(16),
                            color: isDark ? Colors.black87 : Colors.white,
                          ),
                          SizedBox(width: Responsive.w(8)),
                          Text(
                            'Create Allocation',
                            style: TextStyle(
                              fontSize: Responsive.sp(12),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.black87 : Colors.white,
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

          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(24))),

          // ─── Metrics Row ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                child: MediaQuery.sizeOf(context).width < 600
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  'TOTAL WORKFORCE',
                                  '21',
                                  Icons.group_outlined,
                                  Colors.blue,
                                  isDark,
                                  cardBg,
                                  borderColor,
                                ),
                              ),
                              SizedBox(width: Responsive.w(16)),
                              Expanded(
                                child: _buildMetricCard(
                                  'ACTIVE PROJECTS',
                                  '1',
                                  Icons.work_outline,
                                  Colors.deepPurpleAccent,
                                  isDark,
                                  cardBg,
                                  borderColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Responsive.h(16)),
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  'RESOURCES ON BENCH',
                                  '21',
                                  Icons.person_off_outlined,
                                  Colors.orange,
                                  isDark,
                                  cardBg,
                                  borderColor,
                                ),
                              ),
                              SizedBox(width: Responsive.w(16)),
                              Expanded(
                                child: _buildUtilizationCard(
                                  'OVERALL UTILIZATION',
                                  '0.00%',
                                  0.0,
                                  isDark,
                                  cardBg,
                                  borderColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              'TOTAL WORKFORCE',
                              '21',
                              Icons.group_outlined,
                              Colors.blue,
                              isDark,
                              cardBg,
                              borderColor,
                            ),
                          ),
                          SizedBox(width: Responsive.w(16)),
                          Expanded(
                            child: _buildMetricCard(
                              'ACTIVE PROJECTS',
                              '1',
                              Icons.work_outline,
                              Colors.deepPurpleAccent,
                              isDark,
                              cardBg,
                              borderColor,
                            ),
                          ),
                          SizedBox(width: Responsive.w(16)),
                          Expanded(
                            child: _buildMetricCard(
                              'RESOURCES ON BENCH',
                              '21',
                              Icons.person_off_outlined,
                              Colors.orange,
                              isDark,
                              cardBg,
                              borderColor,
                            ),
                          ),
                          SizedBox(width: Responsive.w(16)),
                          Expanded(
                            child: _buildUtilizationCard(
                              'OVERALL UTILIZATION',
                              '0.00%',
                              0.0,
                              isDark,
                              cardBg,
                              borderColor,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(24))),

          // ─── Tab Navigation ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              2,
              child: SizedBox(
                height: Responsive.h(40),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                  itemCount: _tabs.length,
                  separatorBuilder: (_, __) => SizedBox(width: Responsive.w(12)),
                  itemBuilder: (_, index) {
                    final isSelected = _activeTabIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _activeTabIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(16),
                          vertical: Responsive.h(10),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black87)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(Responsive.r(8)),
                          border: Border.all(
                            color: isSelected
                                ? (isDark ? Colors.white24 : Colors.transparent)
                                : borderColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              fontSize: Responsive.sp(12),
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? (isDark ? Colors.white : Colors.white)
                                  : subText,
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

          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(24))),

          // ─── Tab Content ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              3,
              child: _buildTabContent(isDark, cardBg, borderColor, subText),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(60))),
        ],
      ),
    );
  }

  // ─── Components ───

  Widget _buildMetricCard(String title, String value, IconData icon, Color iconColor, bool isDark, Color bg, Color border) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(9),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(6)),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(6)),
                ),
                child: Icon(icon, size: Responsive.w(14), color: iconColor),
              ),
              SizedBox(width: Responsive.w(12)),
              Text(
                value,
                style: TextStyle(
                  fontSize: Responsive.sp(18),
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUtilizationCard(String title, String value, double percent, bool isDark, Color bg, Color border) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(9),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.sp(16),
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: Responsive.h(8)),
          Container(
            height: Responsive.h(4),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.white12 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(Responsive.r(2)),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(Responsive.r(2)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab Builder ───

  Widget _buildTabContent(bool isDark, Color cardBg, Color borderColor, Color subText) {
    switch (_activeTabIndex) {
      case 0:
        return _buildDepartmentAllocationTab(isDark, cardBg, borderColor, subText);
      case 1:
        return _buildProjectAllocationTab(isDark, cardBg, borderColor, subText);
      case 2:
        return _buildSkillMappingTab(isDark, cardBg, borderColor, subText);
      case 3:
        return _buildWorkforcePlanningTab(isDark, cardBg, borderColor, subText);
      default:
        return const SizedBox.shrink();
    }
  }

  // ─── Tab 1: Department Allocation ───
  Widget _buildDepartmentAllocationTab(bool isDark, Color cardBg, Color borderColor, Color subText) {
    return _buildPanelContainer(
      'Department-wise Allocation',
      'RESOURCE DISTRIBUTION ACROSS DEPARTMENTS',
      isDark,
      cardBg,
      borderColor,
      subText,
      child: Column(
        children: [
          _buildDeptRow('Sales', 9, 0.0, isDark, borderColor, subText),
          _buildDeptRow('Information Technology', 4, 0.0, isDark, borderColor, subText),
          _buildDeptRow('Unassigned', 3, 0.0, isDark, borderColor, subText),
          _buildDeptRow('Administration', 2, 0.0, isDark, borderColor, subText),
          _buildDeptRow('AI&ML', 2, 0.5, isDark, borderColor, subText),
          _buildDeptRow('Demo role', 1, 0.0, isDark, borderColor, subText),
          _buildDeptRow('General', 1, 0.0, isDark, borderColor, subText),
          _buildDeptRow('IT', 1, 0.0, isDark, borderColor, subText, isLast: true),
        ],
      ),
    );
  }

  Widget _buildDeptRow(String name, int empCount, double percent, bool isDark, Color border, Color subText, {bool isLast = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(16), horizontal: Responsive.w(16)),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: Responsive.w(150),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: Responsive.sp(11),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: Responsive.w(8)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(6), vertical: Responsive.h(2)),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(Responsive.r(4)),
                  ),
                  child: Text(
                    '$empCount EMPLOYEES',
                    style: TextStyle(fontSize: Responsive.sp(8), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Responsive.w(20)),
          Expanded(
            child: Container(
              height: Responsive.h(4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(Responsive.r(2)),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black87,
                    borderRadius: BorderRadius.circular(Responsive.r(2)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: Responsive.w(20)),
          Text(
            '${(percent * 100).toInt()}% Allocated',
            style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
          ),
        ],
      ),
    );
  }

  // ─── Tab 2: Project Allocation ───
  Widget _buildProjectAllocationTab(bool isDark, Color cardBg, Color borderColor, Color subText) {
    return _buildPanelContainer(
      'Active Project Allocations',
      'TRACK RESOURCES CURRENTLY ASSIGNED TO PROJECTS.',
      isDark,
      cardBg,
      borderColor,
      subText,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: Responsive.w(800),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _headerText('PROJECT NAME', subText)),
                    Expanded(flex: 2, child: _headerText('TEAM SIZE', subText)),
                    Expanded(flex: 2, child: _headerText('START DATE', subText)),
                    Expanded(flex: 2, child: _headerText('END DATE', subText)),
                    Expanded(flex: 3, child: _headerText('AVG UTILIZATION', subText)),
                    Expanded(flex: 1, child: _headerText('STATUS', subText)),
                  ],
                ),
              ),
              Divider(height: 1, color: borderColor),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(16)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('AI project', style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(4)),
                          decoration: BoxDecoration(color: isDark ? Colors.white12 : Colors.grey.shade200, borderRadius: BorderRadius.circular(Responsive.r(4))),
                          child: Text('1 MEMBERS', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        ),
                      ),
                    ),
                    Expanded(flex: 2, child: Text('Apr 13, 2026', style: TextStyle(fontSize: Responsive.sp(11), color: subText))),
                    Expanded(flex: 2, child: Text('Apr 15, 2026', style: TextStyle(fontSize: Responsive.sp(11), color: subText))),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: Responsive.h(4),
                              decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey.shade200, borderRadius: BorderRadius.circular(Responsive.r(2))),
                              child: Container(decoration: BoxDecoration(color: isDark ? Colors.white : Colors.black87, borderRadius: BorderRadius.circular(Responsive.r(2)))),
                            ),
                          ),
                          SizedBox(width: Responsive.w(12)),
                          Text('100%', style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('ACTIVE', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerText(String text, Color subText) {
    return Text(text, style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText));
  }

  // ─── Tab 3: Skill Mapping ───
  Widget _buildSkillMappingTab(bool isDark, Color cardBg, Color borderColor, Color subText) {
    return MediaQuery.sizeOf(context).width < 600
        ? Column(
            children: [
              _buildSkillDistribution(isDark, cardBg, borderColor, subText),
              SizedBox(height: Responsive.h(20)),
              _buildSkillGaps(isDark, cardBg, borderColor, subText),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildSkillDistribution(isDark, cardBg, borderColor, subText)),
              SizedBox(width: Responsive.w(20)),
              Expanded(child: _buildSkillGaps(isDark, cardBg, borderColor, subText)),
            ],
          );
  }

  Widget _buildSkillDistribution(bool isDark, Color cardBg, Color border, Color subText) {
    return _buildPanelContainer(
      'Skill Distribution',
      'EMPLOYEE SKILLS ACROSS ORGANIZATION',
      isDark,
      cardBg,
      border,
      subText,
      child: Column(
        children: [
          _buildSkillRow('React', 'ADVANCED', 3, isDark, border, subText),
          _buildSkillRow('Node.js', 'INTERMEDIATE', 2, isDark, border, subText),
          _buildSkillRow('MongoDB', 'INTERMEDIATE', 2, isDark, border, subText),
          _buildSkillRow('TypeScript', 'INTERMEDIATE', 2, isDark, border, subText),
          _buildSkillRow('UI/UX', 'INTERMEDIATE', 1, isDark, border, subText),
          _buildSkillRow('Figma', 'INTERMEDIATE', 1, isDark, border, subText, isLast: true),
        ],
      ),
    );
  }

  Widget _buildSkillRow(String name, String level, int count, bool isDark, Color border, Color subText, {bool isLast = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              SizedBox(height: Responsive.h(2)),
              Text(level, style: TextStyle(fontSize: Responsive.sp(9), color: subText)),
            ],
          ),
          Text('$count people', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: subText)),
        ],
      ),
    );
  }

  Widget _buildSkillGaps(bool isDark, Color cardBg, Color border, Color subText) {
    return _buildPanelContainer(
      'Skill Gaps',
      'SKILLS NEEDED FOR UPCOMING PROJECTS',
      isDark,
      cardBg,
      border,
      subText,
      child: Column(
        children: [
          _buildGapRow('Backend Developer Skills', 'LOW', 1, 0, 1, Colors.blue, isDark, border, subText),
          _buildGapRow('HR Executive Skills', 'MEDIUM', 2, 0, 2, Colors.orange, isDark, border, subText),
          _buildGapRow('Tester Role Skills', 'MEDIUM', 2, 0, 2, Colors.orange, isDark, border, subText),
          _buildGapRow('Software Engineer Skills', 'LOW', 1, 0, 1, Colors.blue, isDark, border, subText, isLast: true),
        ],
      ),
    );
  }

  Widget _buildGapRow(String name, String priority, int req, int avail, int gap, Color badgeColor, bool isDark, Color border, Color subText, {bool isLast = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : Responsive.h(12)),
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(8)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(2)),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(4)),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                ),
                child: Text(priority, style: TextStyle(fontSize: Responsive.sp(8), fontWeight: FontWeight.bold, color: badgeColor)),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(12)),
          Row(
            children: [
              Text('Req: $req', style: TextStyle(fontSize: Responsive.sp(10), color: subText)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(8)),
                child: Container(width: 1, height: Responsive.h(10), color: border),
              ),
              Text('Avail: $avail', style: TextStyle(fontSize: Responsive.sp(10), color: subText)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(8)),
                child: Container(width: 1, height: Responsive.h(10), color: border),
              ),
              Text('Gap: $gap', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Tab 4: Workforce Planning ───
  Widget _buildWorkforcePlanningTab(bool isDark, Color cardBg, Color borderColor, Color subText) {
    return MediaQuery.sizeOf(context).width < 600
        ? Column(
            children: [
              _buildHiringRequests(isDark, cardBg, borderColor, subText),
              SizedBox(height: Responsive.h(20)),
              _buildCapacityPlanning(isDark, cardBg, borderColor, subText),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildHiringRequests(isDark, cardBg, borderColor, subText)),
              SizedBox(width: Responsive.w(20)),
              Expanded(child: _buildCapacityPlanning(isDark, cardBg, borderColor, subText)),
            ],
          );
  }

  Widget _buildHiringRequests(bool isDark, Color cardBg, Color border, Color subText) {
    return _buildPanelContainer(
      'Hiring Requests',
      'OPEN POSITIONS AND REQUIREMENTS',
      isDark,
      cardBg,
      border,
      subText,
      child: Column(
        children: [
          _buildHiringRow('Backend Developer', '69A56C3E32C413E...', 1, 'LOW', Colors.blue, isDark, border, subText),
          _buildHiringRow('HR Executive', '69D374D6A57EAF...', 2, 'MEDIUM', Colors.orange, isDark, border, subText),
          _buildHiringRow('Tester Role', '69DCDSFDCDE83...', 2, 'MEDIUM', Colors.orange, isDark, border, subText),
          _buildHiringRow('Software Engineer', '69DCDSFDCDE83...', 1, 'LOW', Colors.blue, isDark, border, subText, isLast: true),
        ],
      ),
    );
  }

  Widget _buildHiringRow(String role, String id, int pos, String urgency, Color badgeColor, bool isDark, Color border, Color subText, {bool isLast = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                SizedBox(height: Responsive.h(4)),
                Row(
                  children: [
                    Text(id, style: TextStyle(fontSize: Responsive.sp(9), color: subText)),
                    SizedBox(width: Responsive.w(8)),
                    Container(width: 4, height: 4, decoration: BoxDecoration(color: subText, shape: BoxShape.circle)),
                    SizedBox(width: Responsive.w(8)),
                    Text('$pos POSITIONS', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(4)),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Responsive.r(4)),
              border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
            ),
            child: Text(urgency, style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: badgeColor)),
          ),
          SizedBox(width: Responsive.w(12)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(6)),
            decoration: BoxDecoration(
              color: isDark ? Colors.white12 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(Responsive.r(4)),
            ),
            child: Text('View', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityPlanning(bool isDark, Color cardBg, Color border, Color subText) {
    return _buildPanelContainer(
      'Capacity Planning',
      'RESOURCE AVAILABILITY FORECAST',
      isDark,
      cardBg,
      border,
      subText,
      child: Column(
        children: [
          _buildCapacityCard('CURRENT QUARTER FORECAST', Icons.bar_chart, Colors.blue, 100, 0, 100, isDark, border, subText),
          SizedBox(height: Responsive.h(16)),
          _buildCapacityCard('NEXT QUARTER FORECAST', Icons.trending_up, Colors.orange, 100, 10, 90, isDark, border, subText),
        ],
      ),
    );
  }

  Widget _buildCapacityCard(String title, IconData icon, Color iconColor, int avail, int proj, int buffer, bool isDark, Color border, Color subText) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(8)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: Responsive.w(14), color: iconColor),
              SizedBox(width: Responsive.w(8)),
              Text(title, style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          _buildCapRow('Available Capacity', '$avail%', isDark, subText),
          SizedBox(height: Responsive.h(8)),
          _buildCapRow('Projected Utilization', '$proj%', isDark, subText),
          SizedBox(height: Responsive.h(12)),
          Divider(height: 1, color: border),
          SizedBox(height: Responsive.h(12)),
          _buildCapRow('Buffer', '$buffer%', isDark, subText, valueColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildCapRow(String label, String value, bool isDark, Color subText, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: Responsive.sp(11), color: subText)),
        Text(value, style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: valueColor ?? (isDark ? Colors.white : Colors.black87))),
      ],
    );
  }

  // ─── Helpers ───
  Widget _buildPanelContainer(String title, String subtitle, bool isDark, Color bg, Color border, Color subText, {required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Responsive.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                SizedBox(height: Responsive.h(4)),
                Text(subtitle, style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText)),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          child,
        ],
      ),
    );
  }
}
