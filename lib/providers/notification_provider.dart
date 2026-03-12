import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import 'package:uuid/uuid.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    _loadInitialMockData();
  }

  void _loadInitialMockData() {
    final uuid = const Uuid();
    final now = DateTime.now();

    _notifications = [
      NotificationModel(
        id: uuid.v4(),
        title: 'Loan Approved!',
        message:
            'Your personal loan application has been successfully approved.',
        createdAt: now.subtract(const Duration(hours: 2)),
        type: 'success',
        isRead: false,
      ),
      NotificationModel(
        id: uuid.v4(),
        title: 'Payment Reminder',
        message: 'Your upcoming EMI payment of ₹5,400 is due in 3 days.',
        createdAt: now.subtract(const Duration(days: 1)),
        type: 'warning',
        isRead: false,
      ),
      NotificationModel(
        id: uuid.v4(),
        title: 'Profile Updated',
        message:
            'Your address details have been successfully verified and updated.',
        createdAt: now.subtract(const Duration(days: 2)),
        type: 'info',
        isRead: true,
      ),
      NotificationModel(
        id: uuid.v4(),
        title: 'New Feature Available',
        message: 'Check out our new ethical banking investment options.',
        createdAt: now.subtract(const Duration(days: 5)),
        type: 'info',
        isRead: true,
      ),
      NotificationModel(
        id: uuid.v4(),
        title: 'Failed Transaction',
        message:
            'Your recent attempt to verify your bank account failed. Please try again.',
        createdAt: now.subtract(const Duration(days: 7)),
        type: 'error',
        isRead: true,
      ),
    ];
    notifyListeners();
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (refresh) {
      notifyListeners();
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app we'd fetch from an API here.
    // We already have mock data loaded inside the constructor using _loadInitialMockData

    _isLoading = false;
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();

      // Real app update API logic here
    }
  }

  void markAllAsRead() {
    bool hasChanges = false;
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
        hasChanges = true;
      }
    }

    if (hasChanges) {
      notifyListeners();
      // Real app update API logic here
    }
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
    // Real app deletion API logic here
  }
}
