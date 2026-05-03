import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class CompanyOverviewScreen extends StatefulWidget {
  const CompanyOverviewScreen({super.key});

  @override
  State<CompanyOverviewScreen> createState() => _CompanyOverviewScreenState();
}

class _CompanyOverviewScreenState extends State<CompanyOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Custom App Bar with gradient header ───
          SliverAppBar(
            expandedHeight: Responsive.h(220),
            floating: false,
            pinned: true,
            backgroundColor: isDark
                ? const Color(0xFF1A1A24)
                : AppColors.primary,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: Responsive.w(22),
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                        : [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.8),
                            const Color(0xFF6A3DE8),
                          ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Responsive.w(20),
                      bottom: Responsive.h(64), // Prevent overlap with TabBar
                      right: Responsive.w(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COMPANY PROFILE',
                          style: TextStyle(
                            fontSize: Responsive.sp(11),
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.6),
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: Responsive.h(6)),
                        Text(
                          'Capyngen HRMS',
                          style: TextStyle(
                            fontSize: Responsive.sp(24),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
              labelStyle: TextStyle(
                fontSize: Responsive.sp(14),
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: Responsive.sp(14),
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Address'),
                Tab(text: 'Policies'),
              ],
            ),
          ),

          // ─── Tab Body ───
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(isDark: isDark, theme: theme),
                _AddressTab(isDark: isDark, theme: theme),
                _PoliciesTab(isDark: isDark, theme: theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// OVERVIEW TAB
// ══════════════════════════════════════════════════════════════
class _OverviewTab extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _OverviewTab({required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Company Card ───
          _buildCompanyCard(),
          SizedBox(height: Responsive.h(20)),

          // ─── Overview Details ───
          _buildSectionTitle('Overview'),
          SizedBox(height: Responsive.h(12)),
          _buildInfoCard([
            _InfoRow(
              label: 'REGISTERED COMPANY NAME',
              value: 'Capyngen Private Limited',
            ),
            _InfoRow(label: 'BRAND NAME', value: 'Capyngen HRMS'),
            _InfoRow(
              label: 'COMPANY OFFICIAL EMAIL',
              value: 'arpit@capyngen.com',
            ),
            _InfoRow(
              label: 'COMPANY OFFICIAL CONTACT',
              value: 'Not set',
              isPlaceholder: true,
            ),
            _InfoRow(
              label: 'WEBSITE',
              value: 'https://capyngen.com',
              isLink: true,
            ),
            _InfoRow(label: 'INDUSTRY TYPE', value: 'Technology'),
            _InfoRow(label: 'TEAM SIZE', value: '1-50'),
            _InfoRow(label: 'FOUNDED YEAR', value: '2018'),
          ]),
          SizedBox(height: Responsive.h(20)),

          // ─── Contact Channels ───
          _buildSectionTitle('Contact Channels'),
          SizedBox(height: Responsive.h(12)),
          Row(
            children: [
              Expanded(
                child: _buildContactChip(
                  icon: Icons.language_rounded,
                  label: 'WEBSITE',
                  value: 'https://capyngen.com',
                ),
              ),
              SizedBox(width: Responsive.w(12)),
              Expanded(
                child: _buildContactChip(
                  icon: Icons.email_rounded,
                  label: 'EMAIL',
                  value: 'arpit@capyngen.com',
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(40)),
        ],
      ),
    );
  }

  Widget _buildCompanyCard() {
    return Container(
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
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
        children: [
          Container(
            width: Responsive.w(90),
            height: Responsive.w(90),
            padding: EdgeInsets.all(Responsive.w(12)),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.business_rounded,
                  size: Responsive.w(40),
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          Text(
            'Capyngen HRMS',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: Responsive.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Responsive.h(4)),
          Text(
            'Technology',
            style: TextStyle(
              fontSize: Responsive.sp(13),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconBtn(Icons.language_rounded),
              SizedBox(width: Responsive.w(12)),
              _buildIconBtn(Icons.email_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(10)),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Responsive.r(12)),
      ),
      child: Icon(icon, color: AppColors.primary, size: Responsive.w(20)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontSize: Responsive.sp(16),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(List<_InfoRow> rows) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
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
      child: Padding(
        padding: EdgeInsets.all(Responsive.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows.map((row) {
            return Padding(
              padding: EdgeInsets.only(bottom: Responsive.h(16)),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.label,
                      style: TextStyle(
                        fontSize: Responsive.sp(10),
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.35)
                            : Colors.grey.shade500,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: Responsive.h(4)),
                    Text(
                      row.value,
                      style: TextStyle(
                        fontSize: Responsive.sp(14),
                        fontWeight: FontWeight.w600,
                        color: row.isLink
                            ? AppColors.primary
                            : row.isPlaceholder
                            ? (isDark
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : Colors.grey.shade400)
                            : theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContactChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(14),
        vertical: Responsive.h(14),
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(8)),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Responsive.r(8)),
            ),
            child: Icon(icon, color: AppColors.primary, size: Responsive.w(16)),
          ),
          SizedBox(width: Responsive.w(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: Responsive.sp(9),
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.35)
                        : Colors.grey.shade500,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: Responsive.h(2)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: Responsive.sp(11),
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ADDRESS TAB
// ══════════════════════════════════════════════════════════════
class _AddressTab extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _AddressTab({required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddressCard(
            title: 'REGISTERED OFFICE',
            addressLines: [
              '427A, Tower B, Spaze Edge',
              'Malibu Town, Sector 47',
              'Gurugram, Haryana',
              'India - 122018',
            ],
          ),
          SizedBox(height: Responsive.h(20)),
          _buildAddressCard(
            title: 'DEMO CHECK',
            addressLines: [
              'visit test role',
              'demo role check',
              'gurugram, Haryana',
              'India - 122012',
              'Landmark: demo',
            ],
          ),
          SizedBox(height: Responsive.h(40)),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required String title,
    required List<String> addressLines,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
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
          Padding(
            padding: EdgeInsets.only(
              left: Responsive.w(20),
              right: Responsive.w(20),
              top: Responsive.h(16),
              bottom: Responsive.h(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Responsive.sp(13),
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.orange.shade700,
                  size: Responsive.w(20),
                ),
              ],
            ),
          ),
          if (isDark)
            Divider(
              color: Colors.white.withValues(alpha: 0.05),
              height: Responsive.h(1),
            )
          else
            Divider(color: Colors.grey.shade100, height: Responsive.h(1)),
          Padding(
            padding: EdgeInsets.only(
              left: Responsive.w(20),
              right: Responsive.w(20),
              top: Responsive.h(16),
              bottom: Responsive.h(20),
            ),
            child: Text(
              addressLines.join('\n'),
              style: TextStyle(
                fontSize: Responsive.sp(13),
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.grey.shade700,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// POLICIES TAB
// ══════════════════════════════════════════════════════════════
class _PoliciesTab extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _PoliciesTab({required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.w(20)),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Company Notes Card ───
          _buildCard(
            title: 'Company Notes',
            icon: Icons.description_outlined,
            child: Text(
              'No company policy notes or narrative overview have been added yet.',
              style: TextStyle(
                fontSize: Responsive.sp(13),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: Responsive.h(20)),

          // ─── Compliance Details Card ───
          _buildCard(
            title: 'Compliance Details',
            icon: Icons.verified_user_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildComplianceRow('CIN', 'Not set'),
                SizedBox(height: Responsive.h(16)),
                _buildComplianceRow('GSTIN', 'Not set'),
                SizedBox(height: Responsive.h(16)),
                _buildComplianceRow('PAN', 'Not set'),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(40)),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
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
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: Responsive.sp(15),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          if (isDark)
            Divider(
              color: Colors.white.withValues(alpha: 0.05),
              height: Responsive.h(1),
            )
          else
            Divider(color: Colors.grey.shade100, height: Responsive.h(1)),
          SizedBox(height: Responsive.h(16)),
          child,
        ],
      ),
    );
  }

  Widget _buildComplianceRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.sp(11),
            fontWeight: FontWeight.w700,
            color: isDark
                ? Colors.white.withValues(alpha: 0.35)
                : Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: Responsive.h(4)),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.sp(13),
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.grey.shade400,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// ─── Helper model ─────────────────────────────────────────────
class _InfoRow {
  final String label;
  final String value;
  final bool isLink;
  final bool isPlaceholder;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLink = false,
    this.isPlaceholder = false,
  });
}
