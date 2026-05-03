import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/utils/responsive.dart';
import 'app_info_screen.dart';
import 'terms_screen.dart';
import 'privacy_policy_screen.dart';
import '../../notifications/view/notifications_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeCtrl = Get.find();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: theme.appBarTheme.foregroundColor,
              size: Responsive.w(22)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: Responsive.sp(18),
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(20),
          vertical: Responsive.h(16),
        ),
        physics: const BouncingScrollPhysics(),
        children: [
          // ─── Appearance Section ─────────────────────────────
          _SectionHeader(title: 'Appearance', theme: theme),
          SizedBox(height: Responsive.h(12)),
          _SettingsCard(
            theme: theme,
            isDark: isDark,
            child: Column(
              children: [
                _buildThemeOption(context, themeCtrl, theme, isDark),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(28)),

          // ─── General Section ────────────────────────────────
          _SectionHeader(title: 'General', theme: theme),
          SizedBox(height: Responsive.h(12)),
          _SettingsCard(
            theme: theme,
            isDark: isDark,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'See all notifications here',
                  theme: theme,
                  onTap: () {
                    Get.to(() => const NotificationsScreen(),
                        transition: Transition.rightToLeft);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(28)),

          // ─── About Section ──────────────────────────────────
          _SectionHeader(title: 'About', theme: theme),
          SizedBox(height: Responsive.h(12)),
          _SettingsCard(
            theme: theme,
            isDark: isDark,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  subtitle: 'v1.0.0',
                  theme: theme,
                  showChevron: true,
                  onTap: () => Get.to(() => const AppInfoScreen()),
                ),
                _Divider(isDark: isDark),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  theme: theme,
                  onTap: () => Get.to(() => const TermsOfServiceScreen()),
                ),
                _Divider(isDark: isDark),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacy Policy',
                  theme: theme,
                  onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(40)),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, ThemeController themeCtrl,
      ThemeData theme, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(Responsive.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(8)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(10)),
                ),
                child: Icon(Icons.palette_rounded,
                    color: AppColors.primary, size: Responsive.w(20)),
              ),
              SizedBox(width: Responsive.w(14)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Theme',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: Responsive.sp(16),
                      )),
                  SizedBox(height: Responsive.h(2)),
                  Obx(() => Text(
                        themeCtrl.themeModeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: Responsive.sp(12),
                        ),
                      )),
                ],
              ),
            ],
          ),
          SizedBox(height: Responsive.h(20)),
          Obx(() => _ThemeModeSelector(
                selectedMode: themeCtrl.themeMode.value,
                isDark: isDark,
                onChanged: (mode) => themeCtrl.setThemeMode(mode),
              )),
        ],
      ),
    );
  }
}

// ─── Theme Mode Selector Widget ───────────────────────────────
class _ThemeModeSelector extends StatelessWidget {
  final int selectedMode;
  final bool isDark;
  final ValueChanged<int> onChanged;

  const _ThemeModeSelector({
    required this.selectedMode,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(4)),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(Responsive.r(14)),
      ),
      child: Row(
        children: [
          _buildModeChip(0, Icons.phone_android_rounded, 'System'),
          _buildModeChip(1, Icons.light_mode_rounded, 'Light'),
          _buildModeChip(2, Icons.dark_mode_rounded, 'Dark'),
        ],
      ),
    );
  }

  Widget _buildModeChip(int mode, IconData icon, String label) {
    final isActive = selectedMode == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: Responsive.h(12)),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(Responsive.r(12)),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: Responsive.w(8),
                      offset: Offset(0, Responsive.h(2)),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: Responsive.w(16),
                color: isActive
                    ? Colors.white
                    : isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.grey.shade600,
              ),
              SizedBox(width: Responsive.w(6)),
              Text(
                label,
                style: TextStyle(
                  fontSize: Responsive.sp(13),
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? Colors.white
                      : isDark
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Settings Components ─────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Responsive.w(4)),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: Responsive.sp(11),
          fontWeight: FontWeight.w700,
          color: theme.brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  final ThemeData theme;
  final bool isDark;

  const _SettingsCard({
    required this.child,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
      child: child,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final ThemeData theme;
  final bool showChevron;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.theme,
    this.showChevron = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Responsive.r(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(16),
            vertical: Responsive.h(14),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(8)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Responsive.r(10)),
                ),
                child: Icon(icon,
                    color: AppColors.primary, size: Responsive.w(20)),
              ),
              SizedBox(width: Responsive.w(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: Responsive.sp(16),
                        )),
                    if (subtitle != null) ...[
                      SizedBox(height: Responsive.h(2)),
                      Text(subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: Responsive.sp(12),
                          )),
                    ],
                  ],
                ),
              ),
              if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.grey.shade400,
                  size: Responsive.w(20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;

  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: Responsive.w(16)),
      color: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.grey.shade100,
    );
  }
}
