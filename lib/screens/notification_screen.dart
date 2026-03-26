import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notification_empty_state.dart';
import '../utils/app_color_extension.dart';
import '../utils/constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgColors,
      appBar: AppBar(
        title: Text('Notifications', style: AppTextStyles.heading2),
        backgroundColor: context.appColors.navBar,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: AppSizes.iconSizeS,
            color: context.appColors.backIcon,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              if (provider.notifications.isEmpty)
                return const SizedBox.shrink();

              return TextButton(
                onPressed: () {
                  // Show confirmation dialog before clearing
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Clear All', style: AppTextStyles.heading3),
                      content: Text(
                        'Are you sure you want to clear all notifications?',
                        style: AppTextStyles.body1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: context.appColors.textSecondary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.clearAll();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Clear',
                            style: TextStyle(color: context.appColors.alert2),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: context.appColors.brandColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.notifications.isEmpty) {
            return NotificationEmptyState(
              onRefresh: () => provider.fetchNotifications(refresh: true),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchNotifications(refresh: true),
            color: context.appColors.brandColor,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () {
                    provider.markAsRead(notification.id);
                    // Handle specific notification taps here (e.g., navigation)
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
