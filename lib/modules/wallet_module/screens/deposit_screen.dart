import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/wallet_provider.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  bool _submitted = false;
  String? _lastPaymentStatus;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _checkPaymentStatus(WalletProvider wallet) {
    // Check if payment status changed
    if (wallet.paymentStatus != null &&
        wallet.paymentStatus != _lastPaymentStatus) {
      _lastPaymentStatus = wallet.paymentStatus;

      if (wallet.paymentStatus == 'success') {
        _showPaymentSuccess();
      } else if (wallet.paymentStatus == 'failed') {
        _showPaymentFailed(wallet.error ?? 'Payment failed');
      }
    }
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _submitted = false;
      });
      return;
    }

    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
    final walletProvider = context.read<WalletProvider>();

    // Clear previous payment status
    walletProvider.clearPaymentStatus();

    await walletProvider.addMoney(amount: amount);

    setState(() {
      _submitted = false;
    });
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Payment Success'),
          ],
        ),
        content: Text(
          'Your payment was successful! Amount has been added to your wallet.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<WalletProvider>().clearPaymentStatus();
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Pop deposit screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPaymentFailed(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Payment Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              context.read<WalletProvider>().clearPaymentStatus();
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Pop deposit screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _amountValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter amount';
    final parsed = double.tryParse(value.replaceAll(',', ''));
    if (parsed == null) return 'Enter a valid number';
    if (parsed <= 0) return 'Amount must be greater than zero';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Money')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<WalletProvider>(
          builder: (context, wallet, child) {
            // Check payment status on each rebuild
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkPaymentStatus(wallet);
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Balance: ₹${wallet.balance.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '₹',
                      border: OutlineInputBorder(),
                    ),
                    validator: _amountValidator,
                  ),
                ),
                const SizedBox(height: 16),
                if (wallet.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text(wallet.error!)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            wallet.clearError();
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: wallet.isProcessing || _submitted
                        ? null
                        : _submit,
                    child: wallet.isProcessing || _submitted
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add Money'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
