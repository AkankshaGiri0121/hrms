import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class DocumentsScreen extends StatefulWidget {
  final bool showBackButton;

  const DocumentsScreen({super.key, this.showBackButton = true});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
        title: Text(
          'Documents',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: Responsive.sp(26),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Responsive.h(16)),
                      // ─── Stat Cards Row ───
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(24),
                        ),
                        child: Row(
                          children: [
                            _buildStatCard(
                              'TOTAL DOCUMENTS',
                              '1',
                              Icons.description_rounded,
                              Colors.blue,
                              isDark,
                            ),
                            SizedBox(width: Responsive.w(16)),
                            _buildStatCard(
                              'ASSIGNED BY HR',
                              '0',
                              Icons.admin_panel_settings_rounded,
                              Colors.cyan,
                              isDark,
                            ),
                            SizedBox(width: Responsive.w(16)),
                            _buildStatCard(
                              'MY UPLOADS',
                              '1',
                              Icons.account_circle_rounded,
                              Colors.green,
                              isDark,
                            ),
                            SizedBox(width: Responsive.w(16)),
                            _buildStatCard(
                              'GENERATED LETTERS',
                              '0',
                              Icons.auto_awesome_rounded,
                              Colors.orange,
                              isDark,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Responsive.h(24)),

                      // ─── Tabs ───
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(24),
                        ),
                        child: Row(
                          children: [
                            _buildPillTab('All Documents', 0, isDark),
                            SizedBox(width: Responsive.w(12)),
                            _buildPillTab('Assigned by HR', 1, isDark),
                            SizedBox(width: Responsive.w(12)),
                            _buildPillTab('My Uploads', 2, isDark),
                            SizedBox(width: Responsive.w(12)),
                            _buildPillTab('Generated Letters', 3, isDark),
                          ],
                        ),
                      ),
                      SizedBox(height: Responsive.h(24)),
                    ],
                  ),
                ),

                // ─── Document List ───
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                  sliver: _tabController.index == 1 || _tabController.index == 3
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(isDark),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: Responsive.h(16),
                                ),
                                child: _buildDocumentCard(isDark),
                              );
                            },
                            childCount: 1, // Example count
                          ),
                        ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: Responsive.h(100))),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF8B5CF6),
        icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
        label: Text(
          'UPLOAD',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: Responsive.sp(12),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
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
            padding: EdgeInsets.all(Responsive.w(8)),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Responsive.r(10)),
            ),
            child: Icon(icon, size: Responsive.w(20), color: color),
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
            count,
            style: TextStyle(
              fontSize: Responsive.sp(24),
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade200,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(fontSize: Responsive.sp(14)),
        decoration: InputDecoration(
          hintText: 'Search documents...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.grey.shade400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Colors.white38 : Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: Responsive.w(16),
            vertical: Responsive.h(14),
          ),
        ),
      ),
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
              ? const Color(0xFF8B5CF6)
              : (isDark ? const Color(0xFF13131A) : Colors.transparent),
          borderRadius: BorderRadius.circular(Responsive.r(8)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : (isDark ? Colors.white10 : Colors.grey.shade300),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: Responsive.sp(12),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white54 : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(20)),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(10)),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(10)),
                ),
                child: Icon(
                  Icons.insert_drive_file_rounded,
                  color: const Color(0xFF8B5CF6),
                  size: Responsive.w(24),
                ),
              ),
              SizedBox(width: Responsive.w(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'asdfasdf',
                      style: TextStyle(
                        fontSize: Responsive.sp(16),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      'Uploaded by you',
                      style: TextStyle(
                        fontSize: Responsive.sp(12),
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(8),
                  vertical: Responsive.h(4),
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(4)),
                ),
                child: Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: Responsive.sp(10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          Row(
            children: [
              _buildTag('ID PROOF', isDark),
              SizedBox(width: Responsive.w(8)),
              _buildTag('SELF UPLOAD', isDark),
            ],
          ),
          SizedBox(height: Responsive.h(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFileDetail('FILE', 'career.jpg', isDark),
              _buildFileDetail('SIZE', '221.63 KB', isDark),
              _buildFileDetail('UPLOADED', '24 Mar 2026', isDark),
            ],
          ),
          SizedBox(height: Responsive.h(24)),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'View',
                  Icons.visibility_rounded,
                  isDark,
                ),
              ),
              SizedBox(width: Responsive.w(12)),
              Expanded(
                child: _buildActionButton(
                  'Download',
                  Icons.download_rounded,
                  isDark,
                  isPrimary: true,
                ),
              ),
              SizedBox(width: Responsive.w(12)),
              _buildIconButton(
                Icons.delete_outline_rounded,
                Colors.red,
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(8),
        vertical: Responsive.h(4),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Responsive.r(4)),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF8B5CF6),
          fontSize: Responsive.sp(10),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFileDetail(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.sp(9),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white38 : Colors.grey.shade400,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: Responsive.h(4)),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.sp(11),
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    bool isDark, {
    bool isPrimary = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(10)),
      decoration: BoxDecoration(
        color: isPrimary
            ? const Color(0xFF8B5CF6)
            : (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(Responsive.r(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: Responsive.w(16),
            color: isPrimary
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
          ),
          SizedBox(width: Responsive.w(8)),
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.sp(12),
              fontWeight: FontWeight.bold,
              color: isPrimary
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(10)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Responsive.r(8)),
      ),
      child: Icon(icon, size: Responsive.w(20), color: color),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.folder_open_rounded,
          size: Responsive.w(64),
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        SizedBox(height: Responsive.h(16)),
        Text(
          'No matching documents',
          style: TextStyle(
            fontSize: Responsive.sp(16),
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : Colors.grey.shade700,
          ),
        ),
        SizedBox(height: Responsive.h(8)),
        Text(
          'Try another search or switch tabs',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Responsive.sp(12),
            color: isDark ? Colors.white24 : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
