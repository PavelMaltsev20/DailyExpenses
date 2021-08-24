import 'package:expenses/model/Transaction.dart';
import 'package:expenses/widgets/chart_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValue {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var totalSum = 0.0;

      for (var transaction in recentTransactions) {
        var currentDate = transaction.dateTime;

        if (currentDate.day == weekDay.day &&
            currentDate.month == weekDay.month &&
            currentDate.year == weekDay.year) {
          totalSum += transaction.amount;
        }
      }

      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum,
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValue.fold(0.0, (sum, item) {
      return sum + double.parse(item["amount"].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValue.map((data) {
            var title = data["day"].toString();
            var amount = double.parse(data["amount"].toString());
            var totalSpending = amount / (maxSpending == 0 ? 1 : maxSpending);
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(title, amount, totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
