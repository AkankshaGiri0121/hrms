import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class TrainingScreen extends StatefulWidget {
  final bool showBackButton;

  const TrainingScreen({super.key, this.showBackButton = true});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isJavaEnrolled = false;
  int javaProgress = 15;

  void _showDetailsDialog(String title, String category, String type, String date, String instructor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Responsive.w(340),
            padding: EdgeInsets.all(Responsive.w(24)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF13131A) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(24)),
              border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: TextStyle(fontSize: Responsive.sp(20), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                          SizedBox(height: Responsive.h(4)),
                          Text('$category • $type • Starts $date', style: TextStyle(fontSize: Responsive.sp(11), color: isDark ? Colors.white38 : Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close_rounded, color: isDark ? Colors.white38 : Colors.grey.shade400)),
                  ],
                ),
                SizedBox(height: Responsive.h(24)),
                Row(
                  children: [
                    Expanded(child: _buildDialogInfoCard('OVERVIEW', 'Course content overview and objectives...', isDark)),
                    SizedBox(width: Responsive.w(12)),
                    Expanded(child: _buildDialogInfoCard('CERTIFICATION', 'This program does not issue a certification.', isDark)),
                  ],
                ),
                SizedBox(height: Responsive.h(12)),
                Row(
                  children: [
                    Expanded(child: _buildDialogInfoCard('INSTRUCTOR', instructor, isDark)),
                    SizedBox(width: Responsive.w(12)),
                    Expanded(child: _buildDialogInfoCard('CAPACITY', '2 / 30', isDark)),
                  ],
                ),
                SizedBox(height: Responsive.h(12)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Responsive.w(16)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(Responsive.r(16)),
                    border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MY PROGRESS', style: TextStyle(fontSize: Responsive.sp(10), fontWeight: FontWeight.bold, color: const Color(0xFF8B5CF6))),
                      SizedBox(height: Responsive.h(4)),
                      Text('0% • enrolled', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.h(24)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                      foregroundColor: isDark ? Colors.white : Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(12))),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogInfoCard(String label, String value, bool isDark) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.grey.shade400)),
          SizedBox(height: Responsive.h(6)),
          Text(value, style: TextStyle(fontSize: Responsive.sp(12), fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87)),
        ],
      ),
    );
  }

  void _showUpdateProgressDialog(String title, int currentProgress) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double progress = currentProgress.toDouble();
    final controller = TextEditingController(text: currentProgress.toString());

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: Responsive.w(360),
                padding: EdgeInsets.all(Responsive.w(24)),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF13131A) : Colors.white,
                  borderRadius: BorderRadius.circular(Responsive.r(24)),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Update Training Progress', style: TextStyle(fontSize: Responsive.sp(20), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                              SizedBox(height: Responsive.h(4)),
                              Text(title, style: TextStyle(fontSize: Responsive.sp(13), color: isDark ? Colors.white38 : Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close_rounded, color: isDark ? Colors.white38 : Colors.grey.shade400)),
                      ],
                    ),
                    SizedBox(height: Responsive.h(24)),
                    Container(
                      padding: EdgeInsets.all(Responsive.w(20)),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(Responsive.r(16)),
                        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Completion', style: TextStyle(fontSize: Responsive.sp(14), fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                              Text('${progress.toInt()}%', style: TextStyle(fontSize: Responsive.sp(18), fontWeight: FontWeight.w900, color: const Color(0xFF8B5CF6))),
                            ],
                          ),
                          SizedBox(height: Responsive.h(12)),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: const Color(0xFF8B5CF6),
                              inactiveTrackColor: isDark ? Colors.white10 : Colors.grey.shade200,
                              thumbColor: const Color(0xFF8B5CF6),
                              overlayColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: progress,
                              min: 0,
                              max: 100,
                              onChanged: (val) {
                                setDialogState(() {
                                  progress = val;
                                  controller.text = val.toInt().toString();
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('0%', style: TextStyle(fontSize: Responsive.sp(10), color: Colors.grey)),
                              Text('50%', style: TextStyle(fontSize: Responsive.sp(10), color: Colors.grey)),
                              Text('100%', style: TextStyle(fontSize: Responsive.sp(10), color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(24)),
                    Text('OR ENTER EXACT VALUE', style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.bold, color: isDark ? Colors.white54 : Colors.grey.shade600, letterSpacing: 0.5)),
                    SizedBox(height: Responsive.h(8)),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        double? d = double.tryParse(val);
                        if (d != null && d >= 0 && d <= 100) {
                          setDialogState(() => progress = d);
                        }
                      },
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1A1A23) : Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Responsive.r(12)), borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200)),
                      ),
                    ),
                    SizedBox(height: Responsive.h(32)),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
                              side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(12))),
                            ),
                            child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                          ),
                        ),
                        SizedBox(width: Responsive.w(16)),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => javaProgress = progress.toInt());
                              Get.back();
                              Get.snackbar(
                                'Success',
                                'Training progress updated to ${progress.toInt()}%',
                                backgroundColor: Colors.green.withValues(alpha: 0.8),
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              padding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(12))),
                            ),
                            child: const Text('Save Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

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
          'Training',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: Responsive.sp(26),
          ),
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Responsive.h(16)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                  child: Text(
                    'Track your assigned programs, certifications, and growth paths in one place.',
                    style: TextStyle(
                      fontSize: Responsive.sp(11),
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(24)),

                // ─── Stat Cards ───
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                  child: Row(
                    children: [
                      _buildStatCard('ACTIVE PROGRAMS', isJavaEnrolled ? '2' : '1', Icons.menu_book_rounded, Colors.blue, isDark),
                      SizedBox(width: Responsive.w(16)),
                      _buildStatCard('COMPLETED', '0', Icons.assignment_turned_in_rounded, Colors.green, isDark),
                      SizedBox(width: Responsive.w(16)),
                      _buildStatCard('CERTIFICATIONS', '0', Icons.workspace_premium_rounded, Colors.orange, isDark),
                      SizedBox(width: Responsive.w(16)),
                      _buildStatCard('AVG. COMPLETION', '15%', Icons.analytics_rounded, Colors.teal, isDark),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.h(32)),

                // ─── Tabs ───
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
                  child: Row(
                    children: [
                      _buildPillTab('My Training', 0, isDark),
                      SizedBox(width: Responsive.w(12)),
                      _buildPillTab('Learning Paths', 1, isDark),
                      SizedBox(width: Responsive.w(12)),
                      _buildPillTab('My Certifications', 2, isDark),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.h(24)),
              ],
            ),
          ),

          // ─── Training List ───
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildTrainingCard(
                  'Java Developer',
                  'UPCOMING',
                  'SOFT SKILLS',
                  '3 MONTHS',
                  'IN-PERSON',
                  'STARTS MAR 15, 2026',
                  'Prabhanjan Kumar das',
                  6, 10,
                  javaProgress,
                  isDark,
                  onDetails: () => _showDetailsDialog('Java Developer', 'SOFT SKILLS', 'IN-PERSON', 'MAR 15, 2026', 'Prabhanjan Kumar das'),
                  onUpdate: () => _showUpdateProgressDialog('Java Developer', javaProgress),
                ),
                SizedBox(height: Responsive.h(20)),
                _buildTrainingCard(
                  'Test Visitor',
                  'UPCOMING',
                  'PRODUCT',
                  '6 MONTHS',
                  'ONLINE + IN-PERSON',
                  'STARTS MAR 25, 2026',
                  'Prabhanjan Kumar das',
                  2, 15,
                  0,
                  isDark,
                  showEnroll: !isJavaEnrolled,
                  onEnroll: () {
                    setState(() => isJavaEnrolled = true);
                    Get.snackbar(
                      'Success',
                      'Enrollment saved successfully',
                      backgroundColor: Colors.green.withValues(alpha: 0.8),
                      colorText: Colors.white,
                      icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                    );
                  },
                  onDetails: () => _showDetailsDialog('Test Visitor', 'PRODUCT', 'ONLINE + IN-PERSON', 'MAR 25, 2026', 'Prabhanjan Kumar das'),
                  onUpdate: () => _showUpdateProgressDialog('Test Visitor', 0),
                ),
                SizedBox(height: Responsive.h(20)),
                _buildTrainingCard(
                  'Role Based',
                  'ONGOING',
                  'COMPLIANCE',
                  '6 MONTHS',
                  'ONLINE + IN-PERSON',
                  'STARTS APR 12, 2026',
                  'Prabhanjan Kumar das',
                  1, 40,
                  0,
                  isDark,
                  showEnroll: true,
                  onEnroll: () {},
                  onDetails: () => _showDetailsDialog('Role Based', 'COMPLIANCE', 'ONLINE + IN-PERSON', 'APR 12, 2026', 'Prabhanjan Kumar das'),
                  onUpdate: () => _showUpdateProgressDialog('Role Based', 0),
                ),
                SizedBox(height: Responsive.h(40)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      width: Responsive.w(160),
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(16)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
        ),
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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(8)),
                ),
                child: Icon(icon, size: Responsive.w(18), color: color),
              ),
            ],
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

  Widget _buildPillTab(String text, int index, bool isDark) {
    final isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () => setState(() => _tabController.index = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(8)),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : (isDark ? const Color(0xFF13131A) : Colors.transparent),
          borderRadius: BorderRadius.circular(Responsive.r(8)),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : (isDark ? Colors.white10 : Colors.grey.shade300),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: Responsive.sp(12),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : (isDark ? Colors.white54 : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingCard(
    String title,
    String badgeText,
    String category,
    String duration,
    String type,
    String startDate,
    String instructor,
    int enrolled,
    int totalSlots,
    int myProgress,
    bool isDark, {
    bool showEnroll = false,
    VoidCallback? onEnroll,
    VoidCallback? onUpdate,
    VoidCallback? onDetails,
  }) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(20)),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13131A) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(20)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: Responsive.sp(18),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(width: Responsive.w(8)),
                        _buildBadge(badgeText, isDark),
                      ],
                    ),
                    SizedBox(height: Responsive.h(8)),
                    _buildMetaRow(category, duration, type, isDark),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(12)),
          Text(
            startDate,
            style: TextStyle(
              fontSize: Responsive.sp(10),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B5CF6),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: Responsive.h(20)),
          Container(
            height: 1,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha: 0.01),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.01),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(16)),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSimpleInfo('INSTRUCTOR', instructor, isDark),
              _buildProgressInfo('ENROLLMENT', '$enrolled / $totalSlots', enrolled / totalSlots, isDark),
            ],
          ),
          SizedBox(height: Responsive.h(20)),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProgressInfo('MY STATUS', myProgress > 0 ? 'IN-PROGRESS $myProgress%' : 'Not enrolled', myProgress / 100, isDark, isStatus: true),
              SizedBox(height: Responsive.h(16)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: showEnroll ? onEnroll : onUpdate,
                      child: _buildSmallButton(
                        showEnroll ? 'Enroll' : 'Update Progress',
                        showEnroll ? const Color(0xFF8B5CF6) : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100),
                        showEnroll ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.w(12)),
                  Expanded(
                    child: GestureDetector(
                      onTap: onDetails,
                      child: _buildSmallButton('View Details', isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100, isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, bool isDark) {
    final color = text == 'ONGOING' ? Colors.blue : Colors.orange;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(6), vertical: Responsive.h(2)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Responsive.r(4)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: Responsive.sp(9), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMetaRow(String cat, String dur, String type, bool isDark) {
    return Wrap(
      spacing: Responsive.w(12),
      children: [
        _buildMetaItem(Icons.label_outline_rounded, cat, isDark),
        _buildMetaItem(Icons.access_time_rounded, dur, isDark),
        _buildMetaItem(Icons.videocam_outlined, type, isDark),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: Responsive.w(12), color: isDark ? Colors.white38 : Colors.grey.shade400),
        SizedBox(width: Responsive.w(4)),
        Text(
          text,
          style: TextStyle(fontSize: Responsive.sp(10), color: isDark ? Colors.white38 : Colors.grey.shade500, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildSimpleInfo(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.grey.shade400, letterSpacing: 0.5),
        ),
        SizedBox(height: Responsive.h(4)),
        Text(
          value,
          style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.w700, color: isDark ? Colors.white70 : Colors.black87),
        ),
      ],
    );
  }

  Widget _buildProgressInfo(String label, String value, double progress, bool isDark, {bool isStatus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: Responsive.sp(9), fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.grey.shade400, letterSpacing: 0.5),
        ),
        SizedBox(height: Responsive.h(4)),
        Row(
          children: [
            if (isStatus && progress > 0)
              Container(
                margin: EdgeInsets.only(right: Responsive.w(6)),
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(4), vertical: Responsive.h(2)),
                decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Responsive.r(2))),
                child: Text('IN-PROGRESS', style: TextStyle(color: Colors.blue, fontSize: Responsive.sp(8), fontWeight: FontWeight.bold)),
              ),
            Text(
              value,
              style: TextStyle(fontSize: Responsive.sp(11), fontWeight: FontWeight.w700, color: isDark ? Colors.white70 : Colors.black87),
            ),
          ],
        ),
        SizedBox(height: Responsive.h(6)),
        SizedBox(
          width: Responsive.w(80),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: Responsive.h(4),
              backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(progress > 0 ? (isStatus ? Colors.blue : const Color(0xFF8B5CF6)) : Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton(String label, Color bg, Color text) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(12), vertical: Responsive.h(8)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Responsive.r(8)),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: Responsive.sp(11), fontWeight: FontWeight.bold),
      ),
    );
  }
}
