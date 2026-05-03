import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../home/view/home_screen.dart';
import '../../project/view/projects_screen.dart';
import '../../performance/view/performance_screen.dart';
import '../../profile/view/profile_screen.dart';
import '../../expense/view/expenses_screen.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    if (selectedIndex.value != index) {
      HapticFeedback.lightImpact();
    }
    selectedIndex.value = index;
  }
}

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    final AppDrawerController drawerCtrl = Get.put(AppDrawerController());

    final List<Widget> screens = [
      HomeScreen(drawerController: drawerCtrl),
      const ExpensesScreen(showBackButton: false),
      const PerformanceScreen(showBackButton: false),
      const ProjectsScreen(showBackButton: false),
      const ProfileScreen(showBackButton: false),
    ];

    return AppDrawer(
      drawerCtrl: drawerCtrl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBody: true,
        body: Obx(() => screens[controller.selectedIndex.value]),
        bottomNavigationBar: const _PremiumBottomNavBar(),
      ),
    );
  }
}

class _PremiumBottomNavBar extends StatelessWidget {
  const _PremiumBottomNavBar();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(
        left: Responsive.w(20),
        right: Responsive.w(20),
        bottom: Responsive.h(24),
      ),
      height: Responsive.h(70),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E2C).withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(Responsive.r(35)),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.2),
            blurRadius: Responsive.w(16),
            spreadRadius: 1,
            offset: Offset(0, Responsive.h(6)),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: Responsive.w(10),
            offset: Offset(0, Responsive.h(4)),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Responsive.r(35)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(12)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavBarItem(
                  index: 0,
                  icon: Icons.grid_view_rounded,
                  label: 'Home',
                ),
                _NavBarItem(
                  index: 1,
                  icon: Icons.receipt_long_rounded,
                  label: 'Expenses',
                ),
                _NavBarItem(
                  index: 2,
                  icon: Icons.insights_rounded,
                  label: 'Insights',
                ),
                _NavBarItem(
                  index: 3,
                  icon: Icons.folder_copy_outlined,
                  label: 'Projects',
                ),
                _NavBarItem(
                  index: 4,
                  icon: Icons.person_rounded,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;

  const _NavBarItem({
    required this.index,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return GestureDetector(
        onTap: () => controller.changeTabIndex(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? Responsive.w(14) : Responsive.w(8),
            vertical: Responsive.h(12),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(Responsive.r(25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  icon,
                  key: ValueKey<bool>(isSelected),
                  color: isSelected
                      ? AppColors.primary
                      : isDark
                      ? Colors.grey.shade500
                      : Colors.grey.shade400,
                  size: Responsive.w(24),
                ),
              ),
              if (isSelected) ...[
                SizedBox(width: Responsive.w(6)),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: Responsive.sp(12),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
