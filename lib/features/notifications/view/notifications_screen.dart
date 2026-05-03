import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Sample data
    final notifications = [
      {
        'title': 'Leave Request Approved',
        'message': 'Your sick leave for 22nd April has been approved by HR.',
        'time': '10 mins ago',
        'isUnread': true,
        'icon': Icons.check_circle_rounded,
        'color': Colors.green,
      },
      {
        'title': 'Salary Processed',
        'message': 'Your salary for the month of April has been processed successfully.',
        'time': '2 hours ago',
        'isUnread': true,
        'icon': Icons.account_balance_wallet_rounded,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'title': 'Upcoming Public Holiday',
        'message': 'Reminder: Office will remain closed on May 1st for Labor Day.',
        'time': '1 day ago',
        'isUnread': false,
        'icon': Icons.event_available_rounded,
        'color': Colors.orange,
      },
      {
        'title': 'System Maintenance',
        'message': 'The HR portal will be down for scheduled maintenance this Saturday night.',
        'time': '2 days ago',
        'isUnread': false,
        'icon': Icons.build_rounded,
        'color': Colors.blueGrey,
      },
      {
        'title': 'New Policy Update',
        'message': 'Please review the updated remote work policy in the documents section.',
        'time': '1 week ago',
        'isUnread': false,
        'icon': Icons.policy_rounded,
        'color': Colors.blue,
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: Responsive.w(20),
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: Responsive.sp(18),
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.done_all_rounded,
              size: Responsive.w(22),
              color: const Color(0xFF8B5CF6),
            ),
            tooltip: 'Mark all as read',
            onPressed: () {
              Get.snackbar(
                'Success',
                'All notifications marked as read',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: isDark ? const Color(0xFF13131A) : Colors.white,
                colorText: isDark ? Colors.white : Colors.black87,
                margin: EdgeInsets.all(Responsive.w(16)),
                borderRadius: Responsive.r(12),
              );
            },
          ),
          SizedBox(width: Responsive.w(8)),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(20),
          vertical: Responsive.h(16),
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => SizedBox(height: Responsive.h(12)),
        itemBuilder: (context, index) {
          final item = notifications[index];
          final isUnread = item['isUnread'] as bool;
          final iconColor = item['color'] as Color;

          return Container(
            padding: EdgeInsets.all(Responsive.w(16)),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A24) : Colors.white,
              borderRadius: BorderRadius.circular(Responsive.r(16)),
              border: Border.all(
                color: isUnread
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.3)
                    : (isDark ? Colors.white10 : Colors.grey.shade200),
                width: isUnread ? 1.5 : 1.0,
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.w(10)),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: iconColor,
                    size: Responsive.w(20),
                  ),
                ),
                SizedBox(width: Responsive.w(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: TextStyle(
                                fontSize: Responsive.sp(14),
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: Responsive.w(8),
                              height: Responsive.w(8),
                              margin: EdgeInsets.only(top: Responsive.h(4), left: Responsive.w(8)),
                              decoration: const BoxDecoration(
                                color: Color(0xFF8B5CF6),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(6)),
                      Text(
                        item['message'] as String,
                        style: TextStyle(
                          fontSize: Responsive.sp(12),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.6)
                              : Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: Responsive.h(10)),
                      Text(
                        item['time'] as String,
                        style: TextStyle(
                          fontSize: Responsive.sp(10),
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
