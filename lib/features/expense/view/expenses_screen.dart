import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../core/utils/responsive.dart';

class ExpensesScreen extends StatefulWidget {
  final bool showBackButton;

  const ExpensesScreen({super.key, this.showBackButton = true});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Widget _staggered(int index, Widget child) {
    final start = (index * 0.1).clamp(0.0, 1.0);
    final end = (start + 0.5).clamp(0.0, 1.0);
    
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

  void _showNewClaimDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Responsive.w(360),
            padding: EdgeInsets.all(Responsive.w(24)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF13131A) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(24)),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SUBMIT NEW CLAIM',
                          style: TextStyle(
                            fontSize: Responsive.sp(18),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: Responsive.h(4)),
                        Text(
                          'ENTER DETAILS AND OPTIONALLY ATTACH RECEIPT.',
                          style: TextStyle(
                            fontSize: Responsive.sp(10),
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? Colors.white38 : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(24)),

                Row(
                  children: [
                    Expanded(child: _buildFieldLabel('EXPENSE TYPE *', isDark)),
                    SizedBox(width: Responsive.w(16)),
                    Expanded(
                      child: _buildFieldLabel('DATE INCURRED *', isDark),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(8)),
                Row(
                  children: [
                    Expanded(child: _buildDropdownField('Meal', isDark)),
                    SizedBox(width: Responsive.w(16)),
                    Expanded(child: _buildDateField('mm/dd/yyyy', isDark)),
                  ],
                ),
                SizedBox(height: Responsive.h(20)),

                _buildFieldLabel('AMOUNT (₹) *', isDark),
                SizedBox(height: Responsive.h(8)),
                _buildTextField('0.00', isDark),
                SizedBox(height: Responsive.h(20)),

                _buildFieldLabel('DESCRIPTION *', isDark),
                SizedBox(height: Responsive.h(8)),
                _buildTextField('Provide details...', isDark, maxLines: 3),
                SizedBox(height: Responsive.h(20)),

                _buildFieldLabel('ATTACH RECEIPT (Optional)', isDark),
                SizedBox(height: Responsive.h(8)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: Responsive.h(32)),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.02)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(Responsive.r(12)),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: const Color(0xFF8B5CF6),
                        size: Responsive.w(32),
                      ),
                      SizedBox(height: Responsive.h(12)),
                      Text(
                        'Click to upload receipt',
                        style: TextStyle(
                          fontSize: Responsive.sp(12),
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Responsive.h(32)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.h(16),
                          ),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Responsive.r(12),
                            ),
                          ),
                        ),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.w(16)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.snackbar(
                            'Success',
                            'Expense claim submitted successfully',
                            backgroundColor: Colors.green.withValues(
                              alpha: 0.8,
                            ),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.h(16),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Responsive.r(12),
                            ),
                          ),
                        ),
                        child: const Text(
                          'SUBMIT CLAIM',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: Responsive.sp(10),
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white54 : Colors.grey.shade600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField(String hint, bool isDark, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: Responsive.sp(14),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.white24 : Colors.grey.shade400,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1A1A23) : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Responsive.r(12)),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Responsive.r(12)),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        contentPadding: EdgeInsets.all(Responsive.w(16)),
      ),
    );
  }

  Widget _buildDropdownField(String value, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(16),
        vertical: Responsive.h(12),
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A23) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: Responsive.sp(14),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? Colors.white38 : Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String hint, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(16),
        vertical: Responsive.h(12),
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A23) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: TextStyle(
              color: isDark ? Colors.white24 : Colors.grey.shade400,
              fontSize: Responsive.sp(14),
            ),
          ),
          Icon(
            Icons.calendar_month_rounded,
            color: isDark ? Colors.white38 : Colors.grey.shade400,
            size: Responsive.w(18),
          ),
        ],
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
              'Expenses',
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
        actions: [
          if (!widget.showBackButton)
            Padding(
              padding: EdgeInsets.only(right: Responsive.w(8)),
              child: Center(
                child: GestureDetector(
                  onTap: _showNewClaimDialog,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.w(12),
                      vertical: Responsive.h(8),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Responsive.r(8)),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          color: const Color(0xFF8B5CF6),
                          size: Responsive.w(18),
                        ),
                        SizedBox(width: Responsive.w(4)),
                        Text(
                          'NEW CLAIM',
                          style: TextStyle(
                            color: const Color(0xFF8B5CF6),
                            fontSize: Responsive.sp(10),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
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
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Stat Cards ───
                _staggered(0, SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                  child: Row(
                    children: [
                      _buildStatCard(
                        'SUBMITTED',
                        '₹0',
                        Icons.account_balance_wallet_rounded,
                        Colors.blue,
                        isDark,
                      ),
                      SizedBox(width: Responsive.w(16)),
                      _buildStatCard(
                        'PENDING CLAIMS',
                        '0',
                        Icons.pending_actions_rounded,
                        Colors.orange,
                        isDark,
                      ),
                      SizedBox(width: Responsive.w(16)),
                      _buildStatCard(
                        'APPROVED VALUE',
                        '₹0',
                        Icons.currency_rupee_rounded,
                        Colors.green,
                        isDark,
                      ),
                      SizedBox(width: Responsive.w(16)),
                      _buildStatCard(
                        'POLICY COVERAGE',
                        '4',
                        Icons.article_rounded,
                        Colors.purple,
                        isDark,
                      ),
                    ],
                  ),
                )),
                SizedBox(height: Responsive.h(32)),

                // ─── Available Policies ───
                _staggered(1, Padding(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AVAILABLE POLICIES',
                        style: TextStyle(
                          fontSize: Responsive.sp(12),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'SPEND WITHIN THESE LIMITS.',
                        style: TextStyle(
                          fontSize: Responsive.sp(10),
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(height: Responsive.h(16)),
                _staggered(2, SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                  child: Row(
                    children: [
                      _buildPolicyCard(
                        'Travel Fare',
                        'Transport | Auto-approved',
                        '₹5,000',
                        'TRIP',
                        isDark,
                      ),
                      SizedBox(width: Responsive.w(16)),
                      _buildPolicyCard(
                        'Daily Meal',
                        'Meal | HR Approved',
                        '₹800',
                        'DAY',
                        isDark,
                      ),
                      SizedBox(width: Responsive.w(16)),
                      _buildPolicyCard(
                        'Team Lunch',
                        'Entertainment | Manager',
                        '₹3,000',
                        'MONTH',
                        isDark,
                      ),
                      SizedBox(width: Responsive.w(16)),
                      _buildPolicyCard(
                        'Broadband',
                        'Utilities | Auto-approved',
                        '₹1,500',
                        'MONTH',
                        isDark,
                      ),
                    ],
                  ),
                )),
                SizedBox(height: Responsive.h(32)),

                // ─── Claim History ───
                _staggered(3, Padding(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CLAIM HISTORY',
                        style: TextStyle(
                          fontSize: Responsive.sp(12),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'REVIEW STATUS AND RECEIPTS.',
                        style: TextStyle(
                          fontSize: Responsive.sp(10),
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),

          // ─── Empty State for History ───
          SliverFillRemaining(
            hasScrollBody: false,
            child: _staggered(4, Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lotties/unav.json',
                  height: Responsive.h(200),
                  width: Responsive.w(200),
                  repeat: true,
                ),
                SizedBox(height: Responsive.h(60)),
              ],
            )),
          ),
        ],
      ),
      floatingActionButton: widget.showBackButton
          ? FloatingActionButton.extended(
              onPressed: _showNewClaimDialog,
              backgroundColor: const Color(0xFF8B5CF6),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text(
                'NEW CLAIM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      width: Responsive.w(160),
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(6)),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Responsive.r(8)),
            ),
            child: Icon(icon, size: Responsive.w(18), color: color),
          ),
          SizedBox(height: Responsive.h(12)),
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: Responsive.h(4)),
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
    );
  }

  Widget _buildPolicyCard(
    String title,
    String subtitle,
    String amount,
    String period,
    bool isDark,
  ) {
    return Container(
      width: Responsive.w(220),
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(20)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: Responsive.sp(16),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: Responsive.sp(11),
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(6),
                  vertical: Responsive.h(2),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(4)),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: Responsive.sp(8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          Text(
            amount,
            style: TextStyle(
              fontSize: Responsive.sp(24),
              fontWeight: FontWeight.w900,
              color: const Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }
}
