import 'package:expenses/model/Transaction.dart';
import 'package:expenses/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionList;
  final Function _deleteTransaction;

  TransactionList(this.transactionList, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: transactionList.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(children: [
                  Text(
                    "No transaction added yet",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.1,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ]);
              },
            )
          : ListView.builder(
              itemCount: transactionList.length,
              itemBuilder: (ctx, index) {
                return TransactionItem(
                    transactionList[index], _deleteTransaction);
              },
            ),
    );
  }
}
