import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/app_colors.dart';

class AdminPayrollScreen extends StatefulWidget {
  final bool showBackButton;
  const AdminPayrollScreen({super.key, this.showBackButton = true});

  @override
  State<AdminPayrollScreen> createState() => _AdminPayrollScreenState();
}

class _AdminPayrollScreenState extends State<AdminPayrollScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  int _primaryTabIndex = 0;
  final List<String> _primaryTabs = [
    'Run Payroll',
    'Setup Payroll',
    'Declaration',
    'Advanced Settings',
    'Audit History',
  ];

  int _secondaryTabIndex = 0;
  List<String> get _currentSecondaryTabs {
    switch (_primaryTabIndex) {
      case 0:
        return [
          'Overview',
          'Attendance & Leave',
          'Variable & Adhoc',
          'Salary Revision',
          'Salary on Hold',
        ];
      case 1:
        return ['Assign Structure', 'Create Structure'];
      case 2:
        return []; // No secondary tabs for Declaration
      case 3:
        return [
          'Payroll Settings',
          'PF & ESI Settings',
          'PT Settings',
          'Declaration Settings',
          'Component',
          'Payout Settings',
          'Payslip Settings',
          'Bank Integration',
        ];
      default:
        return [];
    }
  }

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
              'Admin Payroll',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(22),
              ),
            ),
            Text(
              'Manage payroll runs, statutory compliance, and declarations.',
              style: TextStyle(fontSize: Responsive.sp(10), color: subText),
            ),
          ],
        ),
        actions: [
          _buildAnimated(
            0,
            child: Padding(
              padding: EdgeInsets.only(right: Responsive.w(16)),
              child: Row(
                children: [
                  _buildDropdown('MAY', isDark, borderColor),
                  SizedBox(width: Responsive.w(8)),
                  _buildDropdown('2026', isDark, borderColor),
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
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Primary Navigation (Pills) ───
          SliverToBoxAdapter(
            child: _buildAnimated(
              1,
              child: SizedBox(
                height: Responsive.h(42),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                  itemCount: _primaryTabs.length,
                  separatorBuilder: (_, __) => SizedBox(width: Responsive.w(8)),
                  itemBuilder: (_, index) {
                    final isSelected = _primaryTabIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _primaryTabIndex = index;
                        _secondaryTabIndex = 0; // Reset secondary tab
                      }),
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
                          borderRadius: BorderRadius.circular(
                            Responsive.r(8),
                          ), // Less rounded for this menu
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : borderColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _primaryTabs[index],
                            style: TextStyle(
                              fontSize: Responsive.sp(12),
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? (isDark ? AppColors.primary : Colors.white)
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
          SliverToBoxAdapter(child: SizedBox(height: Responsive.h(20))),

          // ─── Secondary Navigation (Text Tabs) ───
          if (_currentSecondaryTabs.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildAnimated(
                2,
                child: SizedBox(
                  height: Responsive.h(36),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
                    itemCount: _currentSecondaryTabs.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: Responsive.w(24)),
                    itemBuilder: (_, index) {
                      final isSelected = _secondaryTabIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _secondaryTabIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.w(4),
                            vertical: Responsive.h(6),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _currentSecondaryTabs[index],
                              style: TextStyle(
                                fontSize: Responsive.sp(12),
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? (isDark ? Colors.white : Colors.black87)
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

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
              child: Divider(color: borderColor, height: 1),
            ),
          ),

          // ─── Dynamic Tab Content ───
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

  // ─── Content Builder ───
  Widget _buildTabContent(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color subText,
  ) {
    switch (_primaryTabIndex) {
      case 0: // Run Payroll
        switch (_secondaryTabIndex) {
          case 0:
            return _buildOverviewTab(isDark, cardBg, borderColor, subText);
          case 1:
            return _buildAttendanceLeaveTab(isDark, cardBg, borderColor, subText);
          case 3:
            return _buildSalaryRevisionTab(isDark, cardBg, borderColor, subText);
          case 4:
            return _buildSalaryOnHoldTab(isDark, cardBg, borderColor, subText);
          default:
            return _buildEmptyState('No Content', 'No details available for this tab.', isDark, cardBg, borderColor, subText);
        }
      case 1: // Setup Payroll
        return _buildSetupPayrollTab(isDark, cardBg, borderColor, subText);
      case 2: // Declaration
        return _buildDeclarationTab(isDark, cardBg, borderColor, subText);
      case 3: // Advanced Settings
        return _buildAdvancedSettingsTab(isDark, cardBg, borderColor, subText);
      default:
        return _buildEmptyState('Work in Progress', 'This section is currently under development.', isDark, cardBg, borderColor, subText);
    }
  }

  // ─── Tab 1: Overview ───
  Widget _buildOverviewTab(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color subText,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payroll Overview',
                style: TextStyle(
                  fontSize: Responsive.sp(16),
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                'May 2026 - 0 employees',
                style: TextStyle(fontSize: Responsive.sp(10), color: subText),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(12)),

          // Action Buttons (Scrollable to prevent overflow)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _actionBtn(
                  'Generate',
                  Icons.bolt,
                  const Color(0xFFA855F7),
                  isDark,
                ),
                SizedBox(width: Responsive.w(8)),
                _actionBtn(
                  'Revert',
                  Icons.refresh,
                  Colors.transparent,
                  isDark,
                  textColor: const Color(0xFFEF4444),
                  border: const Color(0xFFEF4444).withValues(alpha: 0.3),
                ),
                SizedBox(width: Responsive.w(8)),
                _actionBtn(
                  'Run Payroll',
                  Icons.play_arrow_rounded,
                  const Color(0xFF10B981),
                  isDark,
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(16)),

          // Status Pills
          Row(
            children: [
              _statusPill('0 Pending', Colors.orange, isDark),
              SizedBox(width: Responsive.w(8)),
              _statusPill('0 Processed', Colors.green, isDark),
            ],
          ),
          SizedBox(height: Responsive.h(24)),

          // Primary Stats (2x2 Grid for Mobile)
          Row(
            children: [
              _primaryStatCard(
                'TOTAL EMPLOYEES',
                '0',
                '0 PROCESSED - 0 PENDING',
                Icons.people_alt_outlined,
                Colors.blue,
                isDark,
                cardBg,
                borderColor,
              ),
              SizedBox(width: Responsive.w(12)),
              _primaryStatCard(
                'GROSS PAY',
                '₹0',
                'INCL. VARIABLE & ADHOC',
                Icons.currency_rupee,
                const Color(0xFF8B5CF6),
                isDark,
                cardBg,
                borderColor,
              ),
            ],
          ),
          SizedBox(height: Responsive.h(12)),
          Row(
            children: [
              _primaryStatCard(
                'TOTAL DEDUCTIONS',
                '₹0',
                'LOP + PF + ESI + PT + TDS',
                Icons.trending_down,
                const Color(0xFFEF4444),
                isDark,
                cardBg,
                borderColor,
              ),
              SizedBox(width: Responsive.w(12)),
              _primaryStatCard(
                'NET PAYABLE',
                '₹0',
                'AFTER ALL DEDUCTIONS',
                Icons.account_balance_wallet_outlined,
                const Color(0xFF10B981),
                isDark,
                cardBg,
                borderColor,
              ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),

          // Secondary Stats (Vertical Grid for better mobile view)
          Column(
            children: [
              Row(
                children: [
                  _secondaryStatCard(
                    'PF (EMPLOYEE)',
                    '₹0',
                    Icons.verified_user_outlined,
                    isDark,
                    cardBg,
                    borderColor,
                  ),
                  SizedBox(width: Responsive.w(12)),
                  _secondaryStatCard(
                    'ESI (EMPLOYEE)',
                    '₹0',
                    Icons.health_and_safety_outlined,
                    isDark,
                    cardBg,
                    borderColor,
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(12)),
              Row(
                children: [
                  _secondaryStatCard(
                    'PROF. TAX (PT)',
                    '₹0',
                    Icons.account_balance_outlined,
                    isDark,
                    cardBg,
                    borderColor,
                  ),
                  SizedBox(width: Responsive.w(12)),
                  _secondaryStatCard(
                    'INCOME TAX (TDS)',
                    '₹0',
                    Icons.receipt_long_outlined,
                    isDark,
                    cardBg,
                    borderColor,
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(12)),
              Row(
                children: [
                  _secondaryStatCard(
                    'LOP DEDUCTIONS',
                    '₹0',
                    Icons.timer_off_outlined,
                    isDark,
                    cardBg,
                    borderColor,
                  ),
                  SizedBox(width: Responsive.w(12)),
                  _secondaryStatCard(
                    'OVERTIME PAY',
                    '₹0',
                    Icons.more_time,
                    isDark,
                    cardBg,
                    borderColor,
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(12)),
              Row(
                children: [
                  _secondaryStatCard(
                    'TOTAL ABSENCES',
                    '0 days',
                    Icons.event_busy_outlined,
                    isDark,
                    cardBg,
                    borderColor,
                  ),
                  SizedBox(width: Responsive.w(12)),
                  _secondaryStatCard(
                    'APPROVED LEAVES',
                    '0 days',
                    Icons.event_available_outlined,
                    isDark,
                    cardBg,
                    borderColor,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Responsive.h(24)),

          // Payroll Summary Table Area
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(Responsive.r(12)),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(Responsive.w(16)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColors.primary,
                        size: Responsive.w(18),
                      ),
                      SizedBox(width: Responsive.w(8)),
                      Text(
                        'Payroll Summary',
                        style: TextStyle(
                          fontSize: Responsive.sp(14),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(8),
                          vertical: Responsive.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(Responsive.r(4)),
                        ),
                        child: Text(
                          '0 RECORDS',
                          style: TextStyle(
                            fontSize: Responsive.sp(9),
                            fontWeight: FontWeight.bold,
                            color: subText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: borderColor),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(60)),
                  child: Center(
                    child: Text(
                      'No payroll records found for May 2026.',
                      style: TextStyle(
                        fontSize: Responsive.sp(12),
                        color: subText,
                      ),
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

  // ─── Tab 2: Attendance & Leave ───
  Widget _buildAttendanceLeaveTab(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color subText,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _pillBtn('Attendance', true, isDark, borderColor),
              SizedBox(width: Responsive.w(12)),
              _pillBtn('Leave', false, isDark, borderColor),
              SizedBox(width: Responsive.w(12)),
              _pillBtn('Overtime', false, isDark, borderColor),
            ],
          ),
          SizedBox(height: Responsive.h(20)),
          _buildTableContainer(
            'Attendance Summary',
            'LIVE MAPPED FROM ACTIVITY',
            'Search employee...',
            isDark,
            cardBg,
            borderColor,
            subText,
          ),
        ],
      ),
    );
  }

  // ─── Tab 3: Salary Revision ───
  Widget _buildSalaryRevisionTab(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color subText,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pillBtn('Salary Revision History', true, isDark, borderColor),
          SizedBox(height: Responsive.h(20)),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(Responsive.r(12)),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(Responsive.w(16)),
                  child: Row(
                    children: [
                      Expanded(
                        child: _searchBar(
                          'Search all employees...',
                          isDark,
                          borderColor,
                          subText,
                        ),
                      ),
                      SizedBox(width: Responsive.w(12)),
                      _outlineBtn(
                        'Export',
                        Icons.download_rounded,
                        isDark,
                        borderColor,
                      ),
                      SizedBox(width: Responsive.w(12)),
                      _actionBtn(
                        'Revise Salary',
                        Icons.add,
                        AppColors.primary,
                        isDark,
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: borderColor),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(80)),
                  child: Center(
                    child: Text(
                      'No employee records found.',
                      style: TextStyle(
                        fontSize: Responsive.sp(12),
                        color: subText,
                      ),
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

  // ─── Tab 4: Salary on Hold ───
  Widget _buildSalaryOnHoldTab(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color subText,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pillBtn('Salary On Hold', true, isDark, borderColor),
          SizedBox(height: Responsive.h(20)),
          _buildTableContainer(
            null,
            null,
            'Search held employees...',
            isDark,
            cardBg,
            borderColor,
            subText,
            showHoldWarning: true,
          ),
        ],
      ),
    );
  }

  // ─── Tab: Setup Payroll ───
  Widget _buildSetupPayrollTab(bool isDark, Color cardBg, Color borderColor, Color subText) {
    if (_secondaryTabIndex == 0) {
      return _buildAssignStructureTab(isDark, cardBg, borderColor, subText);
    } else {
      return _buildCreateStructureTab(isDark, cardBg, borderColor, subText);
    }
  }

  Widget _buildAssignStructureTab(bool isDark, Color cardBg, Color borderColor, Color subText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(Responsive.r(12)), border: Border.all(color: borderColor)),
        child: IntrinsicHeight(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Responsive.w(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assign Salary Structure', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        SizedBox(height: Responsive.h(4)),
                        Text('Map appropriate compensation models to employees.', style: TextStyle(fontSize: Responsive.sp(9), color: subText)),
                      ],
                    ),
                  ),
                  SizedBox(width: Responsive.w(16)),
                  _outlineBtn('Export CSV', Icons.download, isDark, borderColor),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
              child: Row(
                children: [
                  Expanded(child: _searchBar('Search by name or ID...', isDark, borderColor, subText)),
                  SizedBox(width: Responsive.w(16)),
                  Container(
                    decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100, borderRadius: BorderRadius.circular(Responsive.r(6)), border: Border.all(color: borderColor)),
                    child: Row(
                      children: [
                        _buildTogglePill('Annual', false, isDark),
                        _buildTogglePill('Monthly', true, isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),
            SingleChildScrollView(
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
                          Container(width: Responsive.w(12), height: Responsive.w(12), decoration: BoxDecoration(color: isDark ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(2))),
                          SizedBox(width: Responsive.w(16)),
                          Expanded(flex: 1, child: Text('ID', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText))),
                          Expanded(flex: 3, child: Text('EMPLOYEE NAME', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText))),
                          Expanded(flex: 2, child: Text('DESIGNATION', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText))),
                          Expanded(flex: 2, child: Text('STRUCTURE', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText))),
                          Expanded(flex: 2, child: Text('CTC / WAGE', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText))),
                          Text('ACTION', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText)),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: borderColor),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: Responsive.h(80)),
                      child: Center(child: Text('No employee profiles found.', style: TextStyle(fontSize: Responsive.sp(12), color: subText))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildTogglePill(String label, bool isActive, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(6)),
      decoration: BoxDecoration(
        color: isActive ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white) : Colors.transparent,
        borderRadius: BorderRadius.circular(Responsive.r(4)),
      ),
      child: Text(label, style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isActive ? (isDark ? Colors.white : Colors.black87) : Colors.grey)),
    );
  }

  Widget _buildCreateStructureTab(bool isDark, Color cardBg, Color borderColor, Color subText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
                decoration: BoxDecoration(color: isDark ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(Responsive.r(8))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call_made, size: Responsive.w(12), color: isDark ? Colors.black : Colors.white),
                    SizedBox(width: Responsive.w(8)),
                    Text('Create New Structure', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.black : Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(16)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: Responsive.h(24)),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(Responsive.r(8)),
                  border: Border.all(color: subText.withValues(alpha: 0.3), style: BorderStyle.none),
                ),
                child: Center(child: Text('NO STRUCTURES', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: subText))),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(20)),
          Container(
            height: Responsive.h(300),
            width: double.infinity,
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(Responsive.r(12)), border: Border.all(color: borderColor)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(padding: EdgeInsets.all(Responsive.w(12)), decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.grey.shade100, shape: BoxShape.circle), child: Icon(Icons.search, size: Responsive.w(20), color: subText)),
                  SizedBox(height: Responsive.h(12)),
                  Text('Select a structure to view configuration', style: TextStyle(fontSize: Responsive.sp(11), color: subText)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab: Declaration ───
  Widget _buildDeclarationTab(bool isDark, Color cardBg, Color borderColor, Color subText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(Responsive.r(12)), border: Border.all(color: borderColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Responsive.w(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tax Declaration & Investment Proofs', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                        SizedBox(height: Responsive.h(4)),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: Responsive.w(10), color: subText),
                            SizedBox(width: Responsive.w(4)),
                            Text('ACTIVE PERIOD: 2025-2026', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Responsive.w(16)),
                  _outlineBtn('New Period', Icons.add, isDark, borderColor),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Responsive.h(80)),
              child: Center(child: Text('No tax declarations found for this period.', style: TextStyle(fontSize: Responsive.sp(12), color: subText))),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Tab: Advanced Settings ───
  Widget _buildAdvancedSettingsTab(bool isDark, Color cardBg, Color borderColor, Color subText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Responsive.w(20)),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(Responsive.r(12)), border: Border.all(color: borderColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Advanced Payroll Settings', style: TextStyle(fontSize: Responsive.sp(16), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            Text('Configure global payroll cycles and rules.', style: TextStyle(fontSize: Responsive.sp(10), color: subText)),
            SizedBox(height: Responsive.h(24)),
            
            // Effective Date
            Text('EFFECTIVE DATE', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText)),
            SizedBox(height: Responsive.h(8)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(12)),
              decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50, borderRadius: BorderRadius.circular(Responsive.r(8)), border: Border.all(color: borderColor)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('02/01/2026', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  SizedBox(width: Responsive.w(32)),
                  Icon(Icons.calendar_today_outlined, size: Responsive.w(14), color: subText),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(24)),

            // Pay Settings
            Row(
              children: [
                Container(width: Responsive.w(6), height: Responsive.w(6), decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                SizedBox(width: Responsive.w(8)),
                Text('Pay Settings', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              ],
            ),
            SizedBox(height: Responsive.h(16)),
            Column(
              children: [
                _buildSettingsDropdown('PAY FREQUENCY', 'Monthly', isDark, borderColor, subText),
                SizedBox(height: Responsive.h(12)),
                _buildSettingsDropdown('PAY CYCLE', 'From 1st to 31st', isDark, borderColor, subText),
                SizedBox(height: Responsive.h(12)),
                _buildSettingsDropdown('ATTENDANCE CYCLE', 'From 1st to 31st', isDark, borderColor, subText),
                SizedBox(height: Responsive.h(12)),
                _buildSettingsDropdown('PAYOUT DATE', '1st of Month', isDark, borderColor, subText),
              ],
            ),
            SizedBox(height: Responsive.h(24)),

            // Additional Settings
            Row(
              children: [
                Container(width: Responsive.w(6), height: Responsive.w(6), decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle)),
                SizedBox(width: Responsive.w(8)),
                Text('Additional Settings', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              ],
            ),
            SizedBox(height: Responsive.h(16)),
            _buildSettingsToggle('Decimal Value in Payslip', 'Show exact decimal values on generated documents', false, isDark, borderColor, subText),
            SizedBox(height: Responsive.h(12)),
            _buildSettingsToggle('Wage ESI for Overtime', 'Calculate ESI contributions on OT amounts', false, isDark, borderColor, subText),
            SizedBox(height: Responsive.h(12)),
            _buildSettingsToggle('Enable DA for Calculation', 'Include Dearness Allowance in primary structure', true, isDark, borderColor, subText),
            SizedBox(height: Responsive.h(24)),

            // Pay Days Calculation
            Row(
              children: [
                Container(width: Responsive.w(6), height: Responsive.w(6), decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                SizedBox(width: Responsive.w(8)),
                Text('Pay Days Calculation', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              ],
            ),
            SizedBox(height: Responsive.h(16)),
            _buildSettingsToggle('Include Weekly Offs', '', true, isDark, borderColor, subText),
            SizedBox(height: Responsive.h(12)),
            _buildSettingsToggle('Include Holidays', '', true, isDark, borderColor, subText),
            SizedBox(height: Responsive.h(12)),
            _buildSettingsToggle('Fixed Paydays', '', false, isDark, borderColor, subText),
            SizedBox(height: Responsive.h(32)),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionBtn('CANCEL', Icons.close, Colors.transparent, isDark, textColor: subText, border: borderColor),
                SizedBox(width: Responsive.w(12)),
                _actionBtn('SAVE SETTINGS', Icons.check, AppColors.primary, isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsDropdown(String label, String value, bool isDark, Color border, Color subText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: subText)),
        SizedBox(height: Responsive.h(8)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(12)),
          decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50, borderRadius: BorderRadius.circular(Responsive.r(8)), border: Border.all(color: border)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white : Colors.black87)),
              Icon(Icons.keyboard_arrow_down, size: Responsive.w(16), color: subText),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsToggle(String title, String desc, bool isActive, bool isDark, Color border, Color subText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(14)),
      decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50, borderRadius: BorderRadius.circular(Responsive.r(8)), border: Border.all(color: border)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                if (desc.isNotEmpty) ...[
                  SizedBox(height: Responsive.h(4)),
                  Text(desc, style: TextStyle(fontSize: Responsive.sp(9), color: subText)),
                ]
              ],
            ),
          ),
          Container(
            width: Responsive.w(36),
            height: Responsive.h(20),
            decoration: BoxDecoration(color: isActive ? AppColors.primary : (isDark ? Colors.white24 : Colors.grey.shade300), borderRadius: BorderRadius.circular(Responsive.r(10))),
            child: Align(
              alignment: isActive ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.all(Responsive.w(2)),
                width: Responsive.w(16),
                height: Responsive.w(16),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Reusable Components ───

  Widget _buildDropdown(String text, bool isDark, Color border) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(10),
        vertical: Responsive.h(6),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(Responsive.r(6)),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(width: Responsive.w(4)),
          Icon(
            Icons.keyboard_arrow_down,
            size: Responsive.w(14),
            color: isDark ? Colors.white70 : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    String text,
    IconData icon,
    Color bgColor,
    bool isDark, {
    Color? textColor,
    Color? border,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(10),
        vertical: Responsive.h(8),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(Responsive.r(6)),
        border: border != null ? Border.all(color: border) : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: Responsive.w(12), color: textColor ?? Colors.white),
          SizedBox(width: Responsive.w(4)),
          Text(
            text,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlineBtn(String text, IconData icon, bool isDark, Color border) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(10),
        vertical: Responsive.h(8),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(6)),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: Responsive.w(12),
            color: isDark ? Colors.white : Colors.black87,
          ),
          SizedBox(width: Responsive.w(4)),
          Text(
            text,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String text, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(8),
        vertical: Responsive.h(4),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(Responsive.r(4)),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: Responsive.w(6),
            height: Responsive.w(6),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: Responsive.w(6)),
          Text(
            text,
            style: TextStyle(
              fontSize: Responsive.sp(9),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryStatCard(
    String title,
    String value,
    String sub,
    IconData icon,
    Color iconColor,
    bool isDark,
    Color bg,
    Color border,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(Responsive.w(14)),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Responsive.r(12)),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: Responsive.w(14), color: iconColor),
                SizedBox(width: Responsive.w(6)),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.sp(9),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.h(12)),
            Text(
              value,
              style: TextStyle(
                fontSize: Responsive.sp(22),
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: Responsive.h(4)),
            Text(
              sub,
              style: TextStyle(
                fontSize: Responsive.sp(7),
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white38 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondaryStatCard(
    String title,
    String value,
    IconData icon,
    bool isDark,
    Color bg,
    Color border,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(Responsive.w(14)),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Responsive.r(12)),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: Responsive.w(14),
                  color: isDark ? Colors.white54 : Colors.grey,
                ),
                SizedBox(width: Responsive.w(8)),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.sp(9),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.h(8)),
            Text(
              value,
              style: TextStyle(
                fontSize: Responsive.sp(16),
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pillBtn(String text, bool active, bool isDark, Color border) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(16),
        vertical: Responsive.h(8),
      ),
      decoration: BoxDecoration(
        color: active
            ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(Responsive.r(8)),
        border: Border.all(color: active ? Colors.transparent : border),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Responsive.sp(11),
          fontWeight: FontWeight.bold,
          color: active
              ? (isDark ? AppColors.primary : Colors.white)
              : (isDark ? Colors.white54 : Colors.grey),
        ),
      ),
    );
  }

  Widget _searchBar(String hint, bool isDark, Color border, Color subText) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(12),
        vertical: Responsive.h(10),
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(Responsive.r(6)),
        border: Border.all(color: isDark ? Colors.white10 : border),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: Responsive.w(14), color: subText),
          SizedBox(width: Responsive.w(8)),
          Expanded(
            child: Text(
              hint,
              style: TextStyle(fontSize: Responsive.sp(11), color: subText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContainer(
    String? title,
    String? sub,
    String searchHint,
    bool isDark,
    Color bg,
    Color border,
    Color subText, {
    bool showHoldWarning = false,
  }) {
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
            child: Row(
              children: [
                if (title != null) ...[
                  Container(
                    padding: EdgeInsets.all(Responsive.w(8)),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Responsive.r(6)),
                    ),
                    child: Icon(
                      Icons.date_range,
                      size: Responsive.w(14),
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: Responsive.w(12)),
                  Column(
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
                      if (sub != null)
                        Text(
                          sub,
                          style: TextStyle(
                            fontSize: Responsive.sp(8),
                            fontWeight: FontWeight.bold,
                            color: subText,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                ],
                Expanded(
                  flex: title == null ? 1 : 0,
                  child: _searchBar(searchHint, isDark, border, subText),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Responsive.h(80)),
            child: Center(
              child: Text(
                'No records found.',
                style: TextStyle(fontSize: Responsive.sp(12), color: subText),
              ),
            ),
          ),
          if (showHoldWarning) ...[
            Divider(height: 1, color: border),
            Padding(
              padding: EdgeInsets.all(Responsive.w(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _outlineBtn(
                    'Put Employee on Hold',
                    Icons.add,
                    isDark,
                    border,
                  ),
                  SizedBox(height: Responsive.h(16)),
                  Container(
                    padding: EdgeInsets.all(Responsive.w(12)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.05),
                      border: Border.all(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(Responsive.r(6)),
                    ),
                    child: Text(
                      'NOTE: Salary on hold cannot be processed when you click "Execute Payroll". If you wish to run payroll for all employees but defer the bank transfer payout, we recommend NOT keeping the salary on hold here.',
                      style: TextStyle(
                        fontSize: Responsive.sp(9),
                        color: const Color(0xFFEF4444),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    String title,
    String desc,
    bool isDark,
    Color bg,
    Color border,
    Color subText,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Responsive.h(60)),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Responsive.r(12)),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Icon(Icons.construction, size: Responsive.w(32), color: subText),
            SizedBox(height: Responsive.h(16)),
            Text(
              title,
              style: TextStyle(
                fontSize: Responsive.sp(14),
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: Responsive.h(4)),
            Text(
              desc,
              style: TextStyle(fontSize: Responsive.sp(11), color: subText),
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
}
