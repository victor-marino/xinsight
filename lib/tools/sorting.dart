import 'package:indexax/models/portfolio_datapoint.dart';
import 'package:indexax/models/transaction.dart';

// Function to sort assets in the portfolio
int compareInstruments(
    PortfolioDataPoint instrumentA, PortfolioDataPoint instrumentB) {
  // Sorts assets by type first, held amount second.
  if (instrumentA.instrumentType != instrumentB.instrumentType) {
    return instrumentA.instrumentType
        .toString()
        .compareTo(instrumentB.instrumentType.toString());
  } else {
    return instrumentB.amount.compareTo(instrumentA.amount);
  }
}

// Function to sort transactions
int compareTransactions(Transaction transactionA, Transaction transactionB) {
  // Sorts transactions by date, amount and account type.
  if (transactionA.date != transactionB.date) {
    return transactionB.date.compareTo(transactionA.date);
  } else if (transactionA.amount.abs() != transactionB.amount.abs()) {
    return transactionB.amount.abs().compareTo(transactionA.amount.abs());
  } else {
    return transactionB.accountType
        .toString()
        .compareTo(transactionA.accountType.toString());
  }
}
