import 'dart:developer';

import 'package:janseva/config/api_config.dart';
import 'package:janseva/main.dart';
import 'package:janseva/modules/wallet_module/models/deposit_params.dart';
import 'package:janseva/modules/wallet_module/models/deposit_response.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:janseva/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/razorpay_order.dart';

class RazorpayService {
  static final RazorpayService _instance = RazorpayService._internal();
  factory RazorpayService() => _instance;
  RazorpayService._internal();
  static var user = bContext.read<UserProvider>().currentUser;
  static late Razorpay _razorpay;
  static Function(PaymentSuccessResponse)? _onPaymentSuccess;
  static Function(PaymentFailureResponse)? _onPaymentError;
  static Function(ExternalWalletResponse)? _onExternalWallet;

  void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log('Payment Success: ${response.paymentId}');
    _onPaymentSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('Payment Error: ${response.code} - ${response.message}');
    _onPaymentError?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('External Wallet: ${response.walletName}');
    _onExternalWallet?.call(response);
  }

  static Future<DepositResponse> createDepositOrder(
    DepositParams params,
    String accessToken,
  ) async {
    try {
      var url = "${ApiConfig.domain}${ApiConfig.createDeposit}";
      var res = await ApiService.post(
        url,
        body: params.toJson(),
        accessToken: accessToken,
      );
      if (res['success']) {
        return DepositResponse.fromJson(res['data']);
      } else {
        throw Exception(res['message']);
      }
    } catch (e) {
      log('Error creating deposit order: $e');
      rethrow;
      // throw Exception('Error creating deposit order: $e');
    }
  }

  static void openCheckoutWithModel({
    required RazorpayOrder razorpayOrder,
    required Function(PaymentSuccessResponse) onPaymentSuccess,
    required Function(PaymentFailureResponse) onPaymentError,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    // Set callbacks
    _onPaymentSuccess = onPaymentSuccess;
    _onPaymentError = onPaymentError;
    _onExternalWallet = onExternalWallet;

    var options = {
      'key':
          razorpayOrder.razorpayKeyId ??
          ApiConfig.razorpayKeyId, // Replace with your Razorpay key
      // 'amount': razorpayOrder.amount, // Amount already in paise from API
      'order_id': razorpayOrder.id, // Use Razorpay order ID
      'name': 'SW Resident App',
      'description': 'Order #${razorpayOrder.notes.orderId}',
      'timeout': 300, // 5 minutes timeout
      'prefill': {
        'contact': user?.phoneNumber,
        'email': user?.email,
        'name': user?.name,
      },
      'theme': {'color': '#2196F3'},
      'notes': {
        'member_id': razorpayOrder.notes.memberId,
        'order_id': razorpayOrder.notes.orderId,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      log('Error opening Razorpay: $e');
      _onPaymentError?.call(
        PaymentFailureResponse(1, 'Failed to open payment gateway', null),
      );
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
