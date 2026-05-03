import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class PayrollScreen extends StatefulWidget {
  final bool showBackButton;

  const PayrollScreen({super.key, this.showBackButton = true});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final String _selectedYear = '2026';
  final String _selectedMonth = 'April';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
              'Payroll',
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
          SizedBox(height: Responsive.h(16)),

          // ─── TABS ───
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
            child: Row(
              children: [
                _buildPillTab('Payslip', 0, isDark),
                SizedBox(width: Responsive.w(12)),
                _buildPillTab('Salary Structure', 1, isDark),
                SizedBox(width: Responsive.w(12)),
                _buildPillTab('Declaration', 2, isDark),
                SizedBox(width: Responsive.w(12)),
                _buildPillTab('Bank Account', 3, isDark),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
            child: Divider(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              height: 1,
            ),
          ),
          SizedBox(height: Responsive.h(16)),

          // ─── FILTERS ───
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
            child: _buildFiltersRow(isDark),
          ),
          SizedBox(height: Responsive.h(16)),

          // ─── CONTENT ───
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
                  ? _buildPayslipTab(isDark)
                  : _tabController.index == 1
                      ? _buildSalaryStructureTab(isDark)
                      : _tabController.index == 2
                          ? _buildDeclarationTab(isDark)
                          : _tabController.index == 3
                              ? _buildBankAccountTab(isDark)
                              : _buildComingSoon(isDark),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(isDark),
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
              ? (isDark ? const Color(0xFF8B5CF6).withValues(alpha: 0.15) : const Color(0xFF8B5CF6).withValues(alpha: 0.08))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Responsive.r(8)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: Responsive.sp(13),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersRow(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Text(
            'YEAR',
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: Responsive.w(8)),
          _buildDropdown(_selectedYear, isDark),
          SizedBox(width: Responsive.w(16)),
          Text(
            'MONTH',
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: Responsive.w(8)),
          _buildDropdown(_selectedMonth, isDark),
          const Spacer(),
          Icon(
            Icons.chevron_left_rounded,
            color: isDark ? Colors.white54 : Colors.grey.shade400,
            size: Responsive.w(24),
          ),
          SizedBox(width: Responsive.w(8)),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? Colors.white54 : Colors.grey.shade400,
            size: Responsive.w(24),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(4)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A24) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(6)),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.sp(12),
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(width: Responsive.w(4)),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: Responsive.w(16),
            color: isDark ? Colors.white54 : Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipTab(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('payslip'),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24), vertical: Responsive.h(8)),
      physics: const BouncingScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF13131A) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(16)),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(Responsive.w(20)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(Responsive.w(8)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Responsive.r(8)),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Icon(Icons.business_rounded, color: const Color(0xFF8B5CF6), size: Responsive.w(24)),
                      ),
                      SizedBox(width: Responsive.w(16)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CAPYNGEN PRIVATE LIMITED',
                              style: TextStyle(
                                fontSize: Responsive.sp(16),
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            SizedBox(height: Responsive.h(4)),
                            Text(
                              '427A, Tower B, Spaze Edge, Malibu Town, Sector 47, Gurugram, Haryana, 122018, India',
                              style: TextStyle(
                                fontSize: Responsive.sp(10),
                                color: isDark ? Colors.white54 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(24)),
                  Text(
                    'PAYSLIP FOR APRIL 2026',
                    style: TextStyle(
                      fontSize: Responsive.sp(12),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      decoration: TextDecoration.underline,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: isDark ? Colors.white10 : Colors.grey.shade200, height: 1),
            
            // Details Matrix
            Padding(
              padding: EdgeInsets.all(Responsive.w(20)),
              child: Column(
                children: [
                  _buildDetailRow('Name:', 'Yash Raj', 'Bank:', 'sadfasdfgasdfsdgfsdf', isDark),
                  _buildDetailRow('Emp ID:', 'EMP-2024-001', 'Acct No:', '54353454353', isDark),
                  _buildDetailRow('Role:', 'Flutter Developer', 'PAN:', 'DXNPA6705B', isDark),
                  _buildDetailRow('Dept:', 'Information Technology', '', '', isDark),
                  _buildDetailRow('Loc:', 'Corporate Office', '', '', isDark),
                  _buildDetailRow('Attendance Days:', '20', '', '', isDark),
                  _buildDetailRow('LOP:', '19', '', '', isDark, highlightVal1: true),
                ],
              ),
            ),
            Divider(color: isDark ? Colors.white10 : Colors.grey.shade200, height: 1),

            // Financials (Mobile Vertical Layout)
            Padding(
              padding: EdgeInsets.all(Responsive.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EARNINGS',
                    style: TextStyle(
                      fontSize: Responsive.sp(11),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: Responsive.h(12)),
                  _buildFinancialRow('Basic', '40,266', isDark),
                  _buildFinancialRow('HRA', '16,106', isDark),
                  _buildFinancialRow('Special Allowance', '44,294', isDark),
                  SizedBox(height: Responsive.h(8)),
                  _buildFinancialRow('Total Earnings (₹)', '1,00,666', isDark, isBold: true),
                  
                  SizedBox(height: Responsive.h(32)),

                  Text(
                    'DEDUCTIONS',
                    style: TextStyle(
                      fontSize: Responsive.sp(11),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: Responsive.h(12)),
                  _buildFinancialRow('Loss Of Pay (LOP)', '95,633', isDark, isDeduction: true),
                  SizedBox(height: Responsive.h(8)),
                  _buildFinancialRow('Total Deductions (₹)', '95,633', isDark, isBold: true),
                ],
              ),
            ),
            
            // Net Pay
            Container(
              padding: EdgeInsets.all(Responsive.w(20)),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade50,
                border: Border(
                  top: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NET PAY FOR THE MONTH',
                        style: TextStyle(
                          fontSize: Responsive.sp(12),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        '(Rupees Five Thousand Thirty Three Only)',
                        style: TextStyle(
                          fontSize: Responsive.sp(10),
                          fontStyle: FontStyle.italic,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '5,033',
                    style: TextStyle(
                      fontSize: Responsive.sp(28),
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer Text
            Padding(
              padding: EdgeInsets.symmetric(vertical: Responsive.h(24), horizontal: Responsive.w(20)),
              child: Text(
                'THIS IS A SYSTEM GENERATED DOCUMENT AND DOES NOT REQUIRE A SIGNATURE.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.sp(8),
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String l1, String v1, String l2, String v2, bool isDark, {bool highlightVal1 = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.h(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Responsive.w(75),
                  child: Text(
                    l1,
                    style: TextStyle(fontSize: Responsive.sp(10), color: isDark ? Colors.white54 : Colors.grey.shade500),
                  ),
                ),
                Expanded(
                  child: Text(
                    v1,
                    style: TextStyle(
                      fontSize: Responsive.sp(11),
                      fontWeight: FontWeight.w600,
                      color: highlightVal1 ? Colors.red : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (l2.isNotEmpty) SizedBox(width: Responsive.w(12)),
          if (l2.isNotEmpty)
            Expanded(
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Responsive.w(50),
                    child: Text(
                      l2,
                      style: TextStyle(fontSize: Responsive.sp(10), color: isDark ? Colors.white54 : Colors.grey.shade500),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      v2,
                      style: TextStyle(
                        fontSize: Responsive.sp(11),
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
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

  Widget _buildFinancialRow(String title, String amount, bool isDark, {bool isBold = false, bool isDeduction = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.h(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(isBold ? 13 : 12),
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: Responsive.sp(isBold ? 14 : 12),
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDeduction ? Colors.red : (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoon(bool isDark) {
    return Center(
      child: Text(
        'Section coming soon.',
        style: TextStyle(
          color: isDark ? Colors.white54 : Colors.grey.shade500,
          fontSize: Responsive.sp(14),
        ),
      ),
    );
  }

  Widget _buildBottomButton(bool isDark) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(Responsive.w(24)),
        child: ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.black87,
            foregroundColor: isDark ? Colors.black87 : Colors.white,
            padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Responsive.r(12)),
            ),
            elevation: 0,
          ),
          icon: Icon(Icons.download_rounded, size: Responsive.w(20)),
          label: Text(
            'DOWNLOAD PDF',
            style: TextStyle(
              fontSize: Responsive.sp(14),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Salary Structure Tab ───
  Widget _buildSalaryStructureTab(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('salary_structure'),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24), vertical: Responsive.h(8)),
      physics: const BouncingScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF13131A) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(16)),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
          ),
          boxShadow: [
            if (!isDark)
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
            // Header
            Padding(
              padding: EdgeInsets.all(Responsive.w(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salary Structure',
                        style: TextStyle(
                          fontSize: Responsive.sp(16),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: Responsive.h(4)),
                      Text(
                        'test2',
                        style: TextStyle(
                          fontSize: Responsive.sp(12),
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Effective: May 3, 2026',
                    style: TextStyle(
                      fontSize: Responsive.sp(10),
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            // CTC Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20)),
              child: Row(
                children: [
                  Expanded(
                    child: _buildCTCCard('MONTHLY CTC', '₹1,00,666', isDark),
                  ),
                  SizedBox(width: Responsive.w(16)),
                  Expanded(
                    child: _buildCTCCard('ANNUAL CTC', '₹12,07,989', isDark),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.h(20)),

            // Table Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20), vertical: Responsive.h(12)),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: _headerText('COMPONENT', isDark)),
                  Expanded(flex: 2, child: _headerText('TYPE', isDark)),
                  Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: _headerText('MONTHLY', isDark))),
                  Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: _headerText('ANNUAL', isDark))),
                ],
              ),
            ),

            // Table Rows
            _buildComponentRow('Basic', 'EARNING', '₹40,266', '₹4,83,192', isDark),
            _buildComponentRow('HRA', 'EARNING', '₹16,106', '₹1,93,272', isDark),
            _buildComponentRow('Special Allowance', 'EARNING', '₹44,294', '₹5,31,528', isDark),
            
            // Total Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(20), vertical: Responsive.h(16)),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text('Total CTC', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87))),
                  Expanded(flex: 2, child: const SizedBox()),
                  Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('₹1,00,666', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)))),
                  Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('₹12,07,989', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)))),
                ],
              ),
            ),

            // Footer Note
            Padding(
              padding: EdgeInsets.all(Responsive.w(20)),
              child: Text(
                '* Effective date reflects the last CTC or structure revision.',
                style: TextStyle(
                  fontSize: Responsive.sp(9),
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTCCard(String title, String amount, bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A24) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(8)),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // Using a blue tint as seen in screenshot
            ),
          ),
          SizedBox(height: Responsive.h(8)),
          Text(
            amount,
            style: TextStyle(
              fontSize: Responsive.sp(16),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerText(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Responsive.sp(10),
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white54 : Colors.grey.shade500,
      ),
    );
  }

  Widget _buildComponentRow(String name, String type, String monthly, String annual, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(20), vertical: Responsive.h(12)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: TextStyle(
                fontSize: Responsive.sp(11),
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(6), vertical: Responsive.h(2)),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(4)),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontSize: Responsive.sp(8),
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                monthly,
                style: TextStyle(
                  fontSize: Responsive.sp(11),
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                annual,
                style: TextStyle(
                  fontSize: Responsive.sp(11),
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Declaration Tab ───
  Widget _buildDeclarationTab(bool isDark) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    
    return SingleChildScrollView(
      key: const ValueKey('declaration'),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24), vertical: Responsive.h(8)),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildTaxDeclarationCard(isDark, isMobile),
          SizedBox(height: Responsive.h(16)),
          if (isMobile) ...[
            _buildExtraGridCard('Extra Earnings', Icons.trending_up, Colors.greenAccent, ['NAME', 'MODE', 'AMOUNT'], 'No extra earnings.', isDark),
            SizedBox(height: Responsive.h(16)),
            _buildExtraGridCard('Extra Deductions', Icons.trending_down, Colors.redAccent, ['NAME', 'MODE', 'AMOUNT'], 'No extra deductions.', isDark),
            SizedBox(height: Responsive.h(16)),
            _buildExtraGridCard('Expense Claims', Icons.receipt_long, Colors.blueAccent, ['TYPE', 'AMOUNT', 'DATE', 'STATUS'], 'No expense claims.', isDark, hasSubmit: true),
            SizedBox(height: Responsive.h(16)),
            _buildExtraGridCard('Overtime', Icons.access_time, Colors.orangeAccent, ['DATE', 'HRS', 'AMT', 'STATUS'], 'No overtime records.', isDark),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildExtraGridCard('Extra Earnings', Icons.trending_up, Colors.greenAccent, ['NAME', 'MODE', 'AMOUNT'], 'No extra earnings.', isDark)),
                SizedBox(width: Responsive.w(16)),
                Expanded(child: _buildExtraGridCard('Extra Deductions', Icons.trending_down, Colors.redAccent, ['NAME', 'MODE', 'AMOUNT'], 'No extra deductions.', isDark)),
              ],
            ),
            SizedBox(height: Responsive.h(16)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildExtraGridCard('Expense Claims', Icons.receipt_long, Colors.blueAccent, ['TYPE', 'AMOUNT', 'DATE', 'STATUS'], 'No expense claims.', isDark, hasSubmit: true)),
                SizedBox(width: Responsive.w(16)),
                Expanded(child: _buildExtraGridCard('Overtime', Icons.access_time, Colors.orangeAccent, ['DATE', 'HRS', 'AMT', 'STATUS'], 'No overtime records.', isDark)),
              ],
            ),
          ],
          SizedBox(height: Responsive.h(40)),
        ],
      ),
    );
  }

  Widget _buildTaxDeclarationCard(bool isDark, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Responsive.w(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tax Declaration', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    SizedBox(height: Responsive.h(4)),
                    Text('ACTIVE FY: 2025-2026', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.grey.shade500)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(10), vertical: Responsive.h(4)),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Responsive.r(4)),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Text('OPEN', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: Colors.green)),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
          Padding(
            padding: EdgeInsets.all(Responsive.w(20)),
            child: isMobile
                ? Column(
                    children: [
                      _buildTaxForm(isDark),
                      SizedBox(height: Responsive.h(32)),
                      _buildSubmittedDeclarationsList(isDark),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildTaxForm(isDark)),
                      SizedBox(width: Responsive.w(40)),
                      Expanded(child: _buildSubmittedDeclarationsList(isDark)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildInputDropdown('Old Regime', isDark)),
            SizedBox(width: Responsive.w(12)),
            Expanded(child: _buildInputDropdown('Section 80C', isDark)),
          ],
        ),
        SizedBox(height: Responsive.h(12)),
        _buildInputField('Investment type', isDark),
        SizedBox(height: Responsive.h(12)),
        Row(
          children: [
            Expanded(child: _buildInputField('Declared amount', isDark)),
            SizedBox(width: Responsive.w(12)),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Responsive.h(14)),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? Colors.white24 : Colors.grey.shade400, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(Responsive.r(6)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_rounded, size: Responsive.w(14), color: isDark ? Colors.white54 : Colors.grey.shade600),
                    SizedBox(width: Responsive.w(8)),
                    Text('Upload proof document', style: TextStyle(fontSize: Responsive.sp(10), color: isDark ? Colors.white54 : Colors.grey.shade600)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.h(20)),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.black87,
            foregroundColor: isDark ? Colors.black87 : Colors.white,
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24), vertical: Responsive.h(14)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(8))),
          ),
          child: Text('Submit Declaration', style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildInputDropdown(String hint, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(14)),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(6)),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white : Colors.black87)),
          Icon(Icons.keyboard_arrow_down_rounded, size: Responsive.w(16), color: isDark ? Colors.white54 : Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildInputField(String hint, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(14)),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(6)),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
      ),
      child: Text(hint, style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white38 : Colors.grey.shade500)),
    );
  }

  Widget _buildSubmittedDeclarationsList(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SUBMITTED DECLARATIONS', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.grey.shade500)),
        SizedBox(height: Responsive.h(12)),
        Container(
          padding: EdgeInsets.all(Responsive.w(16)),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(Responsive.r(8)),
            border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('zddfsd', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  Text('₹2,323', style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                ],
              ),
              SizedBox(height: Responsive.h(4)),
              Text('SECTION 80C - OLD', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: isDark ? Colors.white54 : Colors.grey.shade600)),
              SizedBox(height: Responsive.h(12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(4)),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Responsive.r(4)),
                    ),
                    child: Text('PENDING', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: Colors.orange)),
                  ),
                  Text('VIEW PROOF', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExtraGridCard(String title, IconData icon, Color iconColor, List<String> columns, String emptyMessage, bool isDark, {bool hasSubmit = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Responsive.w(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor, size: Responsive.w(18)),
                    SizedBox(width: Responsive.w(8)),
                    Text(title, style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  ],
                ),
                if (hasSubmit)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(8), vertical: Responsive.h(4)),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.black87,
                      borderRadius: BorderRadius.circular(Responsive.r(4)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, size: Responsive.w(12), color: isDark ? Colors.black87 : Colors.white),
                        SizedBox(width: Responsive.w(4)),
                        Text('SUBMIT', style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: isDark ? Colors.black87 : Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: columns.map((col) => Text(col, style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.grey.shade500))).toList(),
            ),
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Responsive.h(32)),
            child: Center(
              child: Text(emptyMessage, style: TextStyle(fontSize: Responsive.sp(10), color: isDark ? Colors.white54 : Colors.grey.shade500)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bank Account Tab ───
  Widget _buildBankAccountTab(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('bank_account'),
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(24), vertical: Responsive.h(8)),
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF13131A) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(12)),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
          boxShadow: [
            if (!isDark)
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
            Padding(
              padding: EdgeInsets.all(Responsive.w(20)),
              child: Text(
                'SALARY ACCOUNT DETAILS',
                style: TextStyle(
                  fontSize: Responsive.sp(14),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
            Padding(
              padding: EdgeInsets.all(Responsive.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBankDetailRow(
                    isDark,
                    label1: 'ACCOUNT HOLDER',
                    value1: 'YASH RAJ',
                    label2: 'BANK NAME',
                    value2: 'SADFASDFGASDFSDGFSDF',
                    label3: 'ACCOUNT NUMBER',
                    value3: '54353454353',
                  ),
                  SizedBox(height: Responsive.h(24)),
                  _buildBankDetailRow(
                    isDark,
                    label1: 'IFSC CODE',
                    value1: 'NOT UPDATED',
                    label2: 'BRANCH',
                    value2: 'SDDASDASDSDSD',
                    label3: 'CITY',
                    value3: 'NOT UPDATED',
                  ),
                  SizedBox(height: Responsive.h(24)),
                  _buildBankDetailRow(
                    isDark,
                    label1: 'PAN NUMBER',
                    value1: 'DXNPA6705B',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetailRow(
    bool isDark, {
    required String label1,
    required String value1,
    String? label2,
    String? value2,
    String? label3,
    String? value3,
  }) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBankDetailItem(label1, value1, isDark),
          if (label2 != null && value2 != null) ...[
            SizedBox(height: Responsive.h(16)),
            _buildBankDetailItem(label2, value2, isDark),
          ],
          if (label3 != null && value3 != null) ...[
            SizedBox(height: Responsive.h(16)),
            _buildBankDetailItem(label3, value3, isDark),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildBankDetailItem(label1, value1, isDark)),
        Expanded(child: label2 != null && value2 != null ? _buildBankDetailItem(label2, value2, isDark) : const SizedBox()),
        Expanded(child: label3 != null && value3 != null ? _buildBankDetailItem(label3, value3, isDark) : const SizedBox()),
      ],
    );
  }

  Widget _buildBankDetailItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.sp(9),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white38 : Colors.grey.shade500,
          ),
        ),
        SizedBox(height: Responsive.h(4)),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.sp(12),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}
