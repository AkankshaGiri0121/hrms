import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        title: Text('Privacy Policy',
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
            Text('Effective Date: May 1, 2026',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: Responsive.sp(12),
                )),
            SizedBox(height: Responsive.h(24)),
            _buildSection(
              theme,
              '1. Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, update your profile, or use our HRMS features. This may include your name, email address, employee ID, and attendance records.',
            ),
            _buildSection(
              theme,
              '2. How We Use Information',
              'We use the information we collect to provide, maintain, and improve our services, to process your requests, and to communicate with you about your account and HR-related matters.',
            ),
            _buildSection(
              theme,
              '3. Data Sharing',
              'We do not share your personal information with third parties except as described in this policy or as required by law. Your data is primarily used within your organization.',
            ),
            _buildSection(
              theme,
              '4. Data Security',
              'We take reasonable measures to protect your personal information from loss, theft, misuse, and unauthorized access, disclosure, alteration, and destruction.',
            ),
            _buildSection(
              theme,
              '5. Your Choices',
              'You may update or correct your account information at any time by logging into your account. You can also contact your HR department for data-related requests.',
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
