import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import '../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  // Backend Integration: 
  // Tomorrow, replace this list with data fetched from your API using a GetX Controller.
  List<TaskModel> _tasks = [];
  
  // View toggle state
  int _selectedViewIndex = 0; // 0 = List, 1 = Grid, 2 = Calendar

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    // Simulate fetching tasks (currently empty to match design)
    // fetchTasksFromBackend();
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: theme.appBarTheme.foregroundColor,
              size: Responsive.w(22)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Tasks',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: Responsive.sp(18),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.w(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildAnimated(0, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tasks & Work',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(22),
                  ),
                ),
                SizedBox(height: Responsive.h(4)),
                Text(
                  'View your assigned tasks and track progress',
                  style: TextStyle(
                    color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade600,
                    fontSize: Responsive.sp(13),
                  ),
                ),
              ],
            )),
            SizedBox(height: Responsive.h(24)),

            // Stats Row
            _buildAnimated(1, child: _buildStatsRow(isDark)),
            SizedBox(height: Responsive.h(24)),

            // Search Bar & View Toggles
            _buildAnimated(2, child: _buildSearchBar(isDark)),
            SizedBox(height: Responsive.h(24)),

            // Main Content Area
            _buildAnimated(3, child: _buildTaskContent(isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    final bg = isDark ? const Color(0xFF13131A) : Colors.white;
    final border = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200;
    
    return Column(
      children: [
        Row(
          children: [
            _statCard('Total Tasks', '0', Icons.assignment_outlined, Colors.grey, isDark, bg, border),
            SizedBox(width: Responsive.w(12)),
            _statCard('In Progress', '0', Icons.timer_outlined, Colors.blue, isDark, bg, border),
          ],
        ),
        SizedBox(height: Responsive.h(12)),
        Row(
          children: [
            _statCard('Completed', '0', Icons.check_circle_outline, Colors.green, isDark, bg, border),
            SizedBox(width: Responsive.w(12)),
            _statCard('High Priority', '0', Icons.error_outline, Colors.red, isDark, bg, border),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, bool isDark, Color bg, Color border) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(16), vertical: Responsive.h(18)),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Responsive.r(14)),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.sp(10),
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white38 : Colors.grey.shade600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: Responsive.h(6)),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: Responsive.sp(26),
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(Responsive.w(8)),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Responsive.r(10)),
              ),
              child: Icon(icon, size: Responsive.w(18), color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A24) : Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          // Search TextField
          Expanded(
            child: TextField(
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: Responsive.sp(13),
              ),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey.shade500,
                  fontSize: Responsive.sp(13),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: Responsive.w(18),
                  color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade500,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: Responsive.h(16)),
              ),
            ),
          ),
          // Divider
          Container(
            width: 1,
            height: Responsive.h(24),
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade300,
          ),
          // View Toggles
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(12)),
            child: Row(
              children: [
                _buildViewToggle(Icons.format_list_bulleted, 0, isDark),
                SizedBox(width: Responsive.w(4)),
                _buildViewToggle(Icons.grid_view, 1, isDark),
                SizedBox(width: Responsive.w(4)),
                _buildViewToggle(Icons.calendar_today_outlined, 2, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(IconData icon, int index, bool isDark) {
    final isSelected = _selectedViewIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedViewIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(Responsive.w(6)),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Responsive.r(6)),
        ),
        child: Icon(
          icon,
          size: Responsive.w(16),
          color: isSelected
              ? (isDark ? Colors.white : Colors.black87)
              : (isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey.shade500),
        ),
      ),
    );
  }

  Widget _buildTaskContent(bool isDark) {
    if (_tasks.isEmpty) {
      // Empty State
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Responsive.h(80)),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF13131A) : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(16)),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
          ),
        ),
        child: Center(
          child: Text(
            'No tasks found matching your criteria.',
            style: TextStyle(
              fontSize: Responsive.sp(13),
              color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey.shade500,
            ),
          ),
        ),
      );
    }

    // Backend Integration: Build actual ListView here using _tasks
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return ListTile(
          title: Text(task.title),
          // Render task details based on the view
        );
      },
    );
  }

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
