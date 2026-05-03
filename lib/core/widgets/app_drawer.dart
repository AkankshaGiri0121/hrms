import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../features/company/view/company_overview_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../features/attendance/view/attendance_screen.dart';
import '../../features/leave/view/leave_screen.dart';
import '../../features/task/view/tasks_screen.dart';
import '../../features/project/view/projects_screen.dart';
import '../../features/performance/view/performance_screen.dart';
import '../../features/payroll/view/payroll_screen.dart';
import '../../features/document/view/documents_screen.dart';
import '../../features/onboarding/view/my_onboarding_screen.dart';
import '../../features/training/view/training_screen.dart';
import '../../features/resource_management/view/resource_management_screen.dart';
import '../../features/expense/view/expenses_screen.dart';
import '../../features/settings/view/settings_screen.dart';
import '../../features/hr_dashboard/view/hr_dashboard_screen.dart';
import '../../features/departments/view/departments_screen.dart';
import '../../features/employee_hub/view/employee_hub_screen.dart';
import '../../features/exit_management/view/exit_management_screen.dart';
import '../../features/recruitment/view/recruitment_screen.dart';
import '../../features/attendance/view/admin_attendance_screen.dart';
import '../../features/payroll/view/admin_payroll_screen.dart';

class AppDrawerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> radiusAnimation;
  late Animation<Offset> slideAnimation;

  var isDrawerOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    scaleAnimation = Tween<double>(begin: 1.0, end: 0.75).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );

    radiusAnimation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );

    slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0.65, 0),
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.fastOutSlowIn,
          ),
        );
  }

  void toggleDrawer() {
    if (isDrawerOpen.value) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    isDrawerOpen.value = !isDrawerOpen.value;
  }

  void closeDrawer() {
    if (isDrawerOpen.value) {
      animationController.reverse();
      isDrawerOpen.value = false;
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class _DrawerMenuItem {
  final IconData? icon;
  final String title;
  final String? badge;
  final Color? badgeColor;
  final bool isSectionHeader;

  const _DrawerMenuItem({
    this.icon,
    required this.title,
    this.badge,
    this.badgeColor,
    this.isSectionHeader = false,
  });
}

class AppDrawer extends StatelessWidget {
  final Widget child;
  final AppDrawerController drawerCtrl;

  const AppDrawer({super.key, required this.child, required this.drawerCtrl});

  static const List<_DrawerMenuItem> _topMenuItems = [
    _DrawerMenuItem(title: 'MAIN', isSectionHeader: true),
    _DrawerMenuItem(icon: Icons.grid_view_rounded, title: 'Dashboard'),
    _DrawerMenuItem(icon: Icons.apartment_rounded, title: 'Company Overview'),

    _DrawerMenuItem(title: 'MY SPACE', isSectionHeader: true),
    _DrawerMenuItem(icon: Icons.person_rounded, title: 'Profile'),
    _DrawerMenuItem(icon: Icons.access_time_rounded, title: 'My Attendance'),
    _DrawerMenuItem(icon: Icons.beach_access_rounded, title: 'My Leave'),
    _DrawerMenuItem(icon: Icons.task_alt_rounded, title: 'My Tasks'),
    _DrawerMenuItem(icon: Icons.folder_rounded, title: 'My Projects'),
    _DrawerMenuItem(icon: Icons.bar_chart_rounded, title: 'My Performance'),
    _DrawerMenuItem(
      icon: Icons.account_balance_wallet_rounded,
      title: 'My Payroll',
    ),
    _DrawerMenuItem(icon: Icons.description_rounded, title: 'My Documents'),

    _DrawerMenuItem(title: 'HR ADMINISTRATION', isSectionHeader: true),
    _DrawerMenuItem(icon: Icons.grid_view_rounded, title: 'HR Dashboard'),
    _DrawerMenuItem(icon: Icons.apartment_rounded, title: 'Departments'),
    _DrawerMenuItem(icon: Icons.people_alt_rounded, title: 'Employee Hub'),
    _DrawerMenuItem(icon: Icons.assignment_ind_rounded, title: 'Onboarding'),
    _DrawerMenuItem(icon: Icons.school_rounded, title: 'Training'),
    _DrawerMenuItem(
      icon: Icons.directions_walk_rounded,
      title: 'Exit Management',
    ),
    _DrawerMenuItem(icon: Icons.person_add_alt_1_rounded, title: 'Recruitment'),

    _DrawerMenuItem(title: 'OPERATIONS & ASSETS', isSectionHeader: true),
    _DrawerMenuItem(icon: Icons.history_rounded, title: 'Admin Attendance'),
    _DrawerMenuItem(icon: Icons.currency_rupee_rounded, title: 'Admin Payroll'),
    _DrawerMenuItem(
      icon: Icons.inventory_2_rounded,
      title: 'Resource Management',
    ),
    _DrawerMenuItem(icon: Icons.receipt_long_rounded, title: 'Expense'),

    // _DrawerMenuItem(icon: Icons.health_and_safety_rounded, title: 'Insurance'),
    // _DrawerMenuItem(icon: Icons.inventory_2_rounded, title: 'Assets'),
    // _DrawerMenuItem(icon: Icons.description_rounded, title: 'Admin Documents'),
    // _DrawerMenuItem(icon: Icons.bar_chart_rounded, title: 'Team Performance'),
    _DrawerMenuItem(title: 'SUPPORT & CONFIG', isSectionHeader: true),
    _DrawerMenuItem(icon: Icons.headset_mic_rounded, title: 'Helpdesk'),
  ];

  static const List<_DrawerMenuItem> _bottomMenuItems = [
    _DrawerMenuItem(icon: Icons.settings_rounded, title: 'Settings'),
    _DrawerMenuItem(icon: Icons.logout_rounded, title: 'Logout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1035),
      body: Stack(
        children: [
          // ─── Drawer Background ───
          _buildDrawerContent(context),

          // ─── Main Content (Animated) ───
          AnimatedBuilder(
            animation: drawerCtrl.animationController,
            builder: (context, _) {
              return SlideTransition(
                position: drawerCtrl.slideAnimation,
                child: ScaleTransition(
                  scale: drawerCtrl.scaleAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      drawerCtrl.radiusAnimation.value,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (drawerCtrl.isDrawerOpen.value) {
                          drawerCtrl.closeDrawer();
                        }
                      },
                      onHorizontalDragUpdate: (details) {
                        if (details.delta.dx < -6 &&
                            drawerCtrl.isDrawerOpen.value) {
                          drawerCtrl.closeDrawer();
                        }
                        if (details.delta.dx > 6 &&
                            !drawerCtrl.isDrawerOpen.value) {
                          drawerCtrl.toggleDrawer();
                        }
                      },
                      child: AbsorbPointer(
                        absorbing: drawerCtrl.isDrawerOpen.value,
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerContent(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Profile Header ───
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFF2D1F5E),
                      child: Text(
                        'YR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Yash Raj',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID : EECP4556TY',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Divider ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Menu Items (Scrollable) ───
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                physics: const BouncingScrollPhysics(),
                itemCount: _topMenuItems.length,
                itemBuilder: (context, index) {
                  return _DrawerTile(
                    item: _topMenuItems[index],
                    index: index,
                    animationController: drawerCtrl.animationController,
                    isSelected: index == 0,
                    onTap: () {
                      drawerCtrl.closeDrawer();
                      final title = _topMenuItems[index].title;
                      if (title == 'Company Overview') {
                        Get.to(
                          () => const CompanyOverviewScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Profile') {
                        Get.to(
                          () => const ProfileScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'My Attendance') {
                        Get.to(
                          () => const AttendanceScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'My Leave') {
                        Get.to(
                          () => const LeaveScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'My Tasks') {
                        Get.to(
                          () => const TasksScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'My Projects') {
                        Get.to(
                          () => const ProjectsScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'My Performance') {
                        Get.to(
                          () => const PerformanceScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'My Payroll') {
                        Get.to(
                          () => const PayrollScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'My Documents') {
                        Get.to(
                          () => const DocumentsScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Onboarding') {
                        Get.to(
                          () => const MyOnboardingScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Training') {
                        Get.to(
                          () => const TrainingScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Expenses') {
                        Get.to(
                          () => const ExpensesScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'HR Dashboard') {
                        Get.to(
                          () => const HrDashboardScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Departments') {
                        Get.to(
                          () => const DepartmentsScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Employee Hub') {
                        Get.to(
                          () => const EmployeeHubScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Exit Management') {
                        Get.to(
                          () => const ExitManagementScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Recruitment') {
                        Get.to(
                          () => const RecruitmentScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Admin Attendance') {
                        Get.to(
                          () => const AdminAttendanceScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Admin Payroll') {
                        Get.to(
                          () => const AdminPayrollScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Resource Management') {
                        Get.to(
                          () => const ResourceManagementScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      } else if (title == 'Expense') {
                        Get.to(
                          () => const ExpensesScreen(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      }
                    },
                  );
                },
              ),
            ),

            // ─── Bottom Divider ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Bottom Actions ───
            ...List.generate(_bottomMenuItems.length, (index) {
              return _DrawerTile(
                item: _bottomMenuItems[index],
                index: _topMenuItems.length + index,
                animationController: drawerCtrl.animationController,
                isSelected: false,
                isLogout: _bottomMenuItems[index].title == 'Logout',
                onTap: () {
                  drawerCtrl.closeDrawer();
                  if (_bottomMenuItems[index].title == 'Settings') {
                    Get.to(
                      () => const SettingsScreen(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    );
                  } else if (_bottomMenuItems[index].title == 'Logout') {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              // TODO: Implement logout
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }),

            const SizedBox(height: 16),

            // ─── App Version ───
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 16),
              child: Text(
                'Capyngen HRMS v1.0.0',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.25),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final _DrawerMenuItem item;
  final int index;
  final AnimationController animationController;
  final bool isSelected;
  final bool isLogout;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.item,
    required this.index,
    required this.animationController,
    required this.isSelected,
    this.isLogout = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Stagger the animation for each item
    final double start = (index * 0.02).clamp(0.0, 0.8);
    final double end = (start + 0.2).clamp(0.0, 1.0);

    final slideAnim =
        Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        );

    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnim,
          child: SlideTransition(position: slideAnim, child: child),
        );
      },
      child: item.isSectionHeader
          ? Padding(
              padding: const EdgeInsets.fromLTRB(26, 24, 20, 8),
              child: Text(
                item.title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(12),
                  splashColor: AppColors.primary.withValues(alpha: 0.15),
                  highlightColor: AppColors.primary.withValues(alpha: 0.08),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          color: isLogout
                              ? Colors.redAccent
                              : isSelected
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.7),
                          size: 20,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: isLogout
                                  ? Colors.redAccent
                                  : isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.75),
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (item.badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: item.badgeColor ?? AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.badge!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
