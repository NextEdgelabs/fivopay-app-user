import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
Map<dynamic, dynamic> localNotificationIds = {};

class LocalNotificationService {
  LocalNotificationService._();

  factory LocalNotificationService() => _instance;
  static final LocalNotificationService _instance =
      LocalNotificationService._();
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  // static ReceivePort? receivePort;

  Future<void> initialize() async {
    await awesomeNotifications.initialize(
      'resource://drawable/logo',
      [
        NotificationChannel(
            channelKey: 'transaction_channel',
            channelName: 'Transaction Notifications',
            channelDescription: 'All Transaction notifications for JanSeva App',
            importance: NotificationImportance.Max,
            defaultColor: const Color(0xFF34B53A),
            ledColor: Colors.white,
            playSound: true,
            enableVibration: true,
            criticalAlerts: true,
            channelShowBadge: true,
            defaultPrivacy: NotificationPrivacy.Public,
            // soundSource: 'resource://raw/notification'
            ),
            NotificationChannel(
            channelKey: 'notification_channel',
            channelName: 'Janseva Notifications',
            channelDescription: 'All Transactions for JanSeva App',
            importance: NotificationImportance.Max,
            defaultColor: const Color(0xFF34B53A),
            ledColor: Colors.white,
            playSound: true,
            enableVibration: true,
            criticalAlerts: true,
            channelShowBadge: true,
            defaultPrivacy: NotificationPrivacy.Public,
            // soundSource: 'resource://raw/notification'
            ),
      ],
     
      
      debug: true,
    );

    // Set up listeners with static methods
    _setListeners();
  }

  void _setListeners() {
    awesomeNotifications.setListeners(
      onActionReceivedMethod: onActionReceivedMethod, // Static method
      onNotificationCreatedMethod: onNotificationCreatedMethod, // Static method
      onNotificationDisplayedMethod:
          onNotificationDisplayedMethod, // Static method
      onDismissActionReceivedMethod:
          onDismissActionReceivedMethod, // Static method
    );
  }

  // Static callback methods
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('Notification action received: ${receivedAction.buttonKeyPressed}');
    print('Notification payload: ${receivedAction.payload}');

    try {
      // Handle notification tap (when no button is pressed)
      // String buttonKey = receivedAction.buttonKeyPressed;
      // if (buttonKey.isEmpty) {
      //   print('Notification tapped - checking for navigation');

      //   // Check notification type and navigate accordingly
      //   String? notificationType = receivedAction.payload?['type'];

      //   switch (notificationType) {
      //     case 'visitor_entry':
      //       print('Navigating to activity details for visitor_entry');
      //       await _navigateToActivityDetails(receivedAction.payload);
      //       break;
      //     case 'notice':
      //       print('Navigating to notice screen');
      //       await _navigateToNoticeScreen(receivedAction.payload);
      //       break;
      //     case 'event':
      //       print('Navigating to event screen');
      //       await _navigateToEventScreen(receivedAction.payload);
      //       break;
      //     case 'bill':
      //       print('Navigating to bills screen');
      //       await _navigateToBillsScreen(receivedAction.payload);
      //       break;
      //     case 'maintenance':
      //       print('Navigating to services screen for maintenance');
      //       await _navigateToServicesScreen(receivedAction.payload);
      //       break;
      //     case 'complaint':
      //       print('Navigating to community screen for complaint');
      //       await _navigateToCommunityScreen(receivedAction.payload);
      //       break;
      //     case 'chat':
      //       print('Navigating to chat screen');
      //       await _navigateToChatScreen(receivedAction.payload);
      //       break;
      //     case 'emergency':
      //       print('Navigating to emergency contacts');
      //       await _navigateToEmergencyContacts(receivedAction.payload);
      //       break;
      //     default:
      //       print(
      //           'Unknown notification type: $notificationType, navigating to home');
      //       await _navigateToHomeScreen(receivedAction.payload);
      //       break;
      //   }
      //   return;
    
      // }

      // // Handle door notification button actions
      // if (buttonKey == 'APPROVE') {
      //   print('Door access approved');

      //   // Access providers through global context
      //   if (bContext.mounted) {
      //     // Show loading feedback
      //     // _showProcessingFeedback('Approving visitor access...');

      //     try {
      //       // Make API call to approve visitor
      //       await bContext.read<HomeProvider>().allowVisitor(
      //         accessToken: bContext.read<AuthProvider>().user!.accessToken,
      //         body: {
      //           'id': receivedAction.payload?['id'] ?? '',
      //         },
      //       );

      //       // Show success feedback
      //       // _showSuccessFeedback('Visitor access approved successfully!');

      //       // Navigate to activity details screen after approval
      //       await _navigateToActivityDetails(receivedAction.payload,
      //           fromOption: 'APPROVE');
      //     } catch (e) {
      //       print('Error approving visitor: $e');
      //       // _showErrorFeedback('Failed to approve visitor access');
      //     }
      //   }
      // } else if (buttonKey == 'DENY') {
      //   print('Door access denied');

      //   if (bContext.mounted) {
      //     // Show loading feedback
      //     // _showProcessingFeedback('Denying visitor access...');

      //     try {
      //       // Make API call to deny visitor
      //       final homeProvider =
      //           Provider.of<HomeProvider>(bContext, listen: false);
      //       await homeProvider.cancelVisitor(
      //         accessToken: bContext.read<AuthProvider>().user!.accessToken,
      //         body: {
      //           'id': receivedAction.payload?['id'] ?? '',
      //         },
      //       );

      //       // Show success feedback
      //       // _showSuccessFeedback('Visitor access denied successfully!');

      //       // Navigate to activities screen after denial
      //       await _navigateToActivitiesScreen();
      //     } catch (e) {
      //       print('Error denying visitor: $e');
      //       // _showErrorFeedback('Failed to deny visitor access');
      //     }
      //   }
      // }
    } catch (e) {
      print('Error handling notification action: $e');
    }
  }

  // Helper method to create a mock visitor from notification payload

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    print('Notification created: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    print('Notification displayed: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('Notification dismissed: ${receivedAction.id}');
  }

  void checkingPermission() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();

      }
    });
  }

  Future<void> display(RemoteMessage message) async {
    try {
      var id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      debugPrint('Displaying notification: ${message.notification?.title}');
      debugPrint('Notification data: ${message.data}');
      debugPrint('Notification body: ${message.notification?.body}');

      // Determine notification properties based on type
      String notificationType = message.data['type'] ?? 'general';
      bool isCriticalNotification = _isCriticalNotification(notificationType);
      bool shouldAutoDismiss = !_shouldPersistNotification(notificationType);
      NotificationCategory category =
          _getNotificationCategory(notificationType);

     

      await awesomeNotifications.createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'sw_notification_channel',
          title:
              message.notification?.title ??  message.data['title'] ?? _getDefaultTitle(notificationType),
          body: message.notification?.body ?? message.data['body'] ?? 'New notification',
          payload: {
            "type": notificationType,
            "id": message.data['id'] ?? '',
            // Add all message data to payload
            ...message.data,
          },
          notificationLayout: message.data['photo_urls'] != null
              ? NotificationLayout.BigPicture
              : NotificationLayout.Default,
          bigPicture: message.data['photo_urls'] ??
              "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          color: const Color(0xFF34B53A),
          backgroundColor: const Color(0xFF34B53A),
          autoDismissible: shouldAutoDismiss,
          showWhen: true,
          customSound: 'resource://raw/notification',
          criticalAlert: isCriticalNotification,
          wakeUpScreen: isCriticalNotification,
          category: category,
        ),
        actionButtons: _getActionButtons(notificationType, message.data),
      );
 
    } catch (e) {
      debugPrint('Error displaying notification: $e');
    }
  }

  bool _isCriticalNotification(String type) {
    return type == 'visitor_entry' || type == 'emergency' || type == 'security';
  }

  bool _shouldPersistNotification(String type) {
    return type == 'visitor_entry' || type == 'emergency';
  }

  NotificationCategory _getNotificationCategory(String type) {
    switch (type) {
      case 'visitor_entry':
      case 'security':
        return NotificationCategory.Call;
      case 'emergency':
        return NotificationCategory.Alarm;
      case 'chat':
      case 'message':
        return NotificationCategory.Message;
      case 'maintenance_bill':
        return NotificationCategory.Reminder;
      default:
        return NotificationCategory.Event;
    }
  }

  String _getDefaultTitle(String type) {
    switch (type) {
      case 'visitor_entry':
        return 'Visitor at Door';
      case 'notice':
        return 'New Notice';
      case 'event':
        return 'Event Update';
      case 'bill':
        return 'Bill Update';
      case 'maintenance':
        return 'Maintenance Update';
      case 'complaint':
        return 'Complaint Update';
      case 'chat':
        return 'New Message';
      case 'emergency':
        return 'Emergency Alert';
      default:
        return 'SW Resident App';
    }
  }

  List<NotificationActionButton>? _getActionButtons(
      String type, Map<String, dynamic> data) {
    if (type == 'visitor_entry') {
      return [
        NotificationActionButton(
          key: 'APPROVE',
          label: 'Approve',
          color: Colors.green,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: 'DENY',
          label: 'Deny',
          color: Colors.red,
          autoDismissible: true,
        ),
      ];
    }
    return null;
  }

  Future<void> cancelNotification(int id) async {
    await awesomeNotifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await awesomeNotifications.cancelAll();
  }


}
