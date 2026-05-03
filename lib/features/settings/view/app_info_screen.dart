import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        title: Text('App Version',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: Responsive.sp(18),
            )),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.w(20)),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Responsive.r(30)),
              ),
              child: Image.asset(
                'assets/logo.png',
                width: Responsive.w(80),
                height: Responsive.w(80),
              ),
            ),
            SizedBox(height: Responsive.h(24)),
            Text(
              'Capyngen HRMS',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: Responsive.sp(22),
              ),
            ),
            SizedBox(height: Responsive.h(8)),
            Text(
              'Version 1.0.0',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: Responsive.sp(14),
              ),
            ),
            SizedBox(height: Responsive.h(48)),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Responsive.w(40)),
              child: Text(
                '© 2026 Capyngen HRMS. All rights reserved. Built for modern enterprise excellence.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: Responsive.sp(12),
                ),
              ),
            ),
            SizedBox(height: Responsive.h(20)),
            TextButton(
              onPressed: () {},
              child: Text(
                'Check for Updates',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
