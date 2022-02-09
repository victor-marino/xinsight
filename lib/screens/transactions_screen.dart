// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/account.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:indexax/models/account_dropdown_items.dart';
import 'package:indexax/widgets/transactions_screen/transaction_tile.dart';
import 'package:indexax/widgets/transactions_screen/pending_transactions_card.dart';

const int nbsp = 0x00A0;

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    Key key,
    this.accountData,
    this.userAccounts,
    this.refreshData,
    this.reloadPage,
    this.currentAccountNumber,
  }) : super(key: key);
  final Account accountData;
  final List<String> userAccounts;
  final Function refreshData;
  final Function reloadPage;
  final int currentAccountNumber;

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with AutomaticKeepAliveClientMixin<TransactionsScreen> {
  // The Mixin keeps state of the page instead of reloading it every time
  // It requires this 'wantKeepAlive', as well as the 'super' in the build method down below
  @override
  bool get wantKeepAlive => true;

  int currentPage = 3;
  Account accountData;
  Function refreshData;
  int currentAccountNumber;
  List<DropdownMenuItem> dropdownItems = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    try {
      accountData = await refreshData(currentAccountNumber);
    } on Exception catch (e) {
      print("Couldn't refresh data");
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    setState(() {});
    _refreshController.refreshCompleted();
  }
  
  @override
  void initState() {
    super.initState();
    currentAccountNumber = widget.currentAccountNumber;
    accountData = widget.accountData;
    refreshData = widget.refreshData;

    dropdownItems = AccountDropdownItems(userAccounts: widget.userAccounts).dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    // This super call is required for the Mixin that keeps the page state
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.accountData.hasPendingTransactions) Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: (PendingTransactionsCard()),
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                controller: _refreshController,
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
                  } else if (widget.accountData.transactionList[index].date.month != widget.accountData.transactionList[index-1].date.month) {
                    firstTransactionOfMonth = true;
                  }
                  if (index == (widget.accountData.transactionList.length - 1)) {
                    lastTransactionOfMonth = true;
                  } else if (widget.accountData.transactionList[index].date.month != widget.accountData.transactionList[index+1].date.month) {
                    lastTransactionOfMonth = true;
                  }
                    return Container(
                      child: TransactionTile(transactionData: widget.accountData.transactionList[index], firstTransaction: firstTransaction, firstTransactionOfMonth: firstTransactionOfMonth, lastTransactionOfMonth: lastTransactionOfMonth),
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
