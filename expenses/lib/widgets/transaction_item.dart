import 'package:expenses/model/Transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction _transaction;
  final Function _deleteTransaction;

  const TransactionItem(this._transaction, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 9,
      ),
      elevation: 6,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(child: Text("\$ ${_transaction.amount}")),
          ),
        ),
        title: Text(
          "${_transaction.title}",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          "${DateFormat("dd MMM yyyy").format(_transaction.dateTime)}",
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Delete",
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                  DeleteBtn(_transaction.id, _deleteTransaction),
                ],
              )
            : DeleteBtn(_transaction.id, _deleteTransaction),
      ),
    );
  }
}

class DeleteBtn extends StatefulWidget {
  final Function _deleteTransaction;
  final String transactionId;

  DeleteBtn(
    this.transactionId,
    this._deleteTransaction,
  );

  @override
  _DeleteBtnState createState() => _DeleteBtnState();
}

class _DeleteBtnState extends State<DeleteBtn> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => widget._deleteTransaction(widget.transactionId),
      icon: Icon(
        Icons.delete,
        color: Theme.of(context).errorColor,
      ),
    );
  }
}
