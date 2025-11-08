import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/models/eStamp/esign_params.dart';
import 'package:janseva/modules/loan/providers/loan_provider_v2.dart';
import 'package:janseva/modules/loan/screens/esign/view_pdf.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../providers/user_provider.dart';

class EsignLoanScreen extends StatefulWidget {
  final EsignLoanArguments args;
  const EsignLoanScreen({super.key, required this.args});

  @override
  State<EsignLoanScreen> createState() => _EsignLoanScreenState();
}

class _EsignLoanScreenState extends State<EsignLoanScreen> {
  bool _isAgreed = false;

  Future<void> _handleSign() async {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show bottom sheet to collect signer details
    final signer = await _showSignerDetailsBottomSheet();

    if (signer == null) return; // User cancelled

    if (!mounted) return;

    final provider = context.read<LoanProviderV2>();

    // Call the sign logic from provider with signer details
    await provider.esignLoanDocuments(
      signer: signer,
      url: widget.args.loan.agreement?.document ?? "",
      estampId: widget.args.loan.agreement?.estampId,
      loanId: widget.args.loan.id,
    );

    if (!mounted) return;

    // Check for errors
    // if (provider.esignError.isNotEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Error: ${provider.esignError}'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    //   return;
    // }

    // If URL is available, open it in webview/browser
    if (provider.esignurl != null && provider.esignurl!.isNotEmpty) {
      await _openSigningUrl(provider.esignurl!);
    }
  }

  Future<Signer?> _showSignerDetailsBottomSheet() async {
    return showModalBottomSheet<Signer>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          _SignerDetailsBottomSheet(loanName: widget.args.loan.product!.name!),
    );
  }

  Future<void> _openSigningUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open signing URL'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening URL: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.args.loan;

    return Consumer<LoanProviderV2>(
      builder: (context, loanProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('E-Sign Document'), elevation: 0),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoCard(
                            title: 'Loan Application Details',
                            icon: Icons.receipt_long,
                            children: [
                              _InfoRow(
                                label: 'Product Name',
                                value: loan.product!.name,
                              ),
                              _InfoRow(
                                label: 'Loan Amount',
                                value: '₹${loan.amount.toStringAsFixed(2)}',
                              ),
                              _InfoRow(
                                label: 'Status',
                                value: loan.approvalStatus.toUpperCase(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final url = loan.agreement?.document;
                              if (url == null || url.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No document available'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              //navigate
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                     PdfViewScreen(url: url),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Document Preview',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // _InfoCard(
                          //   title: 'Document Preview',
                          //   icon: Icons.description,
                          //   children: [
                          //     const Text(
                          //       'Loan Agreement Document',
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //     // Container(
                          //     //   height: 200,
                          //     //   decoration: BoxDecoration(
                          //     //     color: Colors.grey.shade100,
                          //     //     borderRadius: BorderRadius.circular(8),
                          //     //     border: Border.all(
                          //     //       color: Colors.grey.shade300,
                          //     //     ),
                          //     //   ),
                          //     //   child: Center(
                          //     //     child: Column(
                          //     //       mainAxisAlignment: MainAxisAlignment.center,
                          //     //       children: [
                          //     //         Icon(
                          //     //           Icons.picture_as_pdf,
                          //     //           size: 64,
                          //     //           color: Colors.grey.shade400,
                          //     //         ),
                          //     //         const SizedBox(height: 8),
                          //     //         Text(
                          //     //           'Loan Agreement Document',
                          //     //           style: TextStyle(
                          //     //             color: Colors.grey.shade600,
                          //     //             fontSize: 14,
                          //     //           ),
                          //     //         ),
                          //     //       ],
                          //     //     ),
                          //     //   ),
                          //     // ),
                          //   ],
                          // ),
                          const SizedBox(height: 16),
                          _InfoCard(
                            title: 'Terms & Conditions',
                            icon: Icons.gavel,
                            children: [
                              _TermItem(
                                text:
                                    'I have read and understood the loan agreement',
                              ),
                              _TermItem(
                                text:
                                    'I agree to the interest rate and repayment terms',
                              ),
                              _TermItem(
                                text:
                                    'All information provided is accurate and complete',
                              ),
                              _TermItem(
                                text:
                                    'I authorize the disbursement of the loan amount',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isAgreed,
                                  onChanged: (value) {
                                    setState(() {
                                      _isAgreed = value ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    'I agree to all terms and conditions mentioned above',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: loanProvider.isEsignLoading
                              ? null
                              : _handleSign,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isAgreed
                                ? Colors.blue
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: loanProvider.isEsignLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Sign Document',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (loanProvider.isEsignLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Preparing signature...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _TermItem extends StatelessWidget {
  final String text;

  const _TermItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignerDetailsBottomSheet extends StatefulWidget {
  final String loanName;
  const _SignerDetailsBottomSheet({required this.loanName});

  @override
  State<_SignerDetailsBottomSheet> createState() =>
      _SignerDetailsBottomSheetState();
}

class _SignerDetailsBottomSheetState extends State<_SignerDetailsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var user = context.read<UserProvider>().currentUser!;
    _nameController.text = user.name!;
    _emailController.text = user.email!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final signer = Signer(
        signerName: _nameController.text.trim(),
        signerEmail: _emailController.text.trim(),
        signerPurpose: "${widget.loanName} Loan Agreement",
        signCoordinates: [SignCoordinate(pageNum: 1, xCoord: 10, yCoord: 10)],
        signerCity: "Delhi",
      );
      Navigator.pop(context, signer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Signer Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Please provide the signer information',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'Enter signer full name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter signer name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  hintText: 'Enter email address',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email address';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 16),
              // TextFormField(
              //   controller: _cityController,
              //   decoration: InputDecoration(
              //     labelText: 'City (Optional)',
              //     hintText: 'Enter city name',
              //     prefixIcon: const Icon(Icons.location_city_outlined),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   textCapitalization: TextCapitalization.words,
              // ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: "${widget.loanName} Loan Agreement",
                enabled: false,
                // controller: _purposeController,
                decoration: InputDecoration(
                  labelText: 'Purpose (Optional)',
                  hintText: 'Enter signing purpose',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue to Sign',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
