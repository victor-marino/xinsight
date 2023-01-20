import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:indexax/widgets/transactions_screen/pending_transactions_card.dart';
import 'package:indexax/widgets/transactions_screen/transaction_tile.dart';
import 'package:indexax/models/account.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    Key? key,
    required this.accountData,
    required this.userAccounts,
    required this.landscapeOrientation,
    required this.availableWidth,
    required this.refreshData,
    required this.currentAccountIndex,
  }) : super(key: key);
  final Account accountData;
  final List<Map<String, String>> userAccounts;
  final bool landscapeOrientation;
  final double availableWidth;
  final Function refreshData;
  final int currentAccountIndex;

  @override
  TransactionsScreenState createState() => TransactionsScreenState();
}

class TransactionsScreenState extends State<TransactionsScreen>
    with AutomaticKeepAliveClientMixin<TransactionsScreen> {
  // The Mixin keeps state of the page instead of reloading it every time
  // It requires this 'wantKeepAlive', as well as the 'super' in the build method down below
  @override
  bool get wantKeepAlive => true;

  Future<void> _onRefresh() async {
    // Monitor network fetch
    try {
      await widget.refreshData(accountIndex: widget.currentAccountIndex);
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Couldn't refresh data");
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This super call is required for the Mixin that keeps the page state
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: widget.landscapeOrientation && widget.availableWidth > 1000
                ? widget.availableWidth * 0.7
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.accountData.hasPendingTransactions)
                  const Padding(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: (PendingTransactionsCard()),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: widget.accountData.transactionList.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool firstTransaction = false;
                          bool firstTransactionOfMonth = false;
                          bool lastTransactionOfMonth = false;
                          if (index == 0) {
                            firstTransaction = true;
                            firstTransactionOfMonth = true;
                          } else if (widget.accountData.transactionList[index]
                                  .date.month !=
                              widget.accountData.transactionList[index - 1]
                                  .date.month) {
                            firstTransactionOfMonth = true;
                          }
                          if (index ==
                              (widget.accountData.transactionList.length -
                                  1)) {
                            lastTransactionOfMonth = true;
                          } else if (widget.accountData.transactionList[index]
                                  .date.month !=
                              widget.accountData.transactionList[index + 1]
                                  .date.month) {
                            lastTransactionOfMonth = true;
                          }
                          return TransactionTile(
                              transactionData:
                                  widget.accountData.transactionList[index],
                              firstTransaction: firstTransaction,
                              firstTransactionOfMonth:
                                  firstTransactionOfMonth,
                              lastTransactionOfMonth: lastTransactionOfMonth,
                              landscapeOrientation:
                                  widget.landscapeOrientation);
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
