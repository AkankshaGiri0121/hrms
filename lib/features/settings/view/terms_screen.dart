import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
        title: Text('Terms of Service',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: Responsive.sp(18),
            )),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.w(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last Updated: May 2026',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: Responsive.sp(12),
                )),
            SizedBox(height: Responsive.h(24)),
            _buildSection(
              theme,
              '1. Acceptance of Terms',
              'By accessing and using Capyngen HRMS, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the application.',
            ),
            _buildSection(
              theme,
              '2. User Obligations',
              'Users are responsible for maintaining the confidentiality of their account information and for all activities that occur under their account. You agree to provide accurate and complete information when registering.',
            ),
            _buildSection(
              theme,
              '3. Prohibited Activities',
              'You may not use the app for any illegal or unauthorized purpose. You must not, in the use of the service, violate any laws in your jurisdiction.',
            ),
            _buildSection(
              theme,
              '4. Limitation of Liability',
              'Capyngen HRMS shall not be liable for any direct, indirect, incidental, special, or consequential damages resulting from the use or the inability to use the service.',
            ),
            _buildSection(
              theme,
              '5. Modifications',
              'We reserve the right to modify or terminate the service for any reason, without notice at any time.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.h(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: Responsive.sp(16),
              )),
          SizedBox(height: Responsive.h(8)),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              fontSize: Responsive.sp(14),
            ),
          ),
        ],
      ),
    );
  }
}
