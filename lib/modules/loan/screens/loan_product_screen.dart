import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/providers/loan_provider_v2.dart';
import 'package:janseva/modules/loan/widgets/loan_application_personal_details.dart';
import 'package:janseva/modules/loan/widgets/loan_category_display_card.dart';
import 'package:provider/provider.dart';

import '../../../routes/arguments.dart';
import '../../../routes/navigator.dart';
import '../../../routes/routes.dart';

class LoanProductScreen extends StatefulWidget {
  const LoanProductScreen({super.key});

  @override
  State<LoanProductScreen> createState() => _LoanProductScreenState();
}

class _LoanProductScreenState extends State<LoanProductScreen> {
  @override
  void initState() {
    //post frame callback
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<LoanProviderV2>().getLoanProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Loan Type')),
      body: Consumer(
        builder: (context, LoanProviderV2 loanProvider, child) {
          var products = loanProvider.loanProducts;

          return loanProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : products.isEmpty
              ? Center(child: Text('No products found'))
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () {
                          push(
                            NamedRoutes.loanApplicationScreenv2,
                            arguments: LoanApplicationScreenV2Arguments(
                              loan: products[index],
                            ),
                          );

                          //forward to next screen
                        },
                        child: LoanProductDisplayCard(product: products[index]),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
