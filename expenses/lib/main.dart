import 'package:expenses/widgets/chart.dart';
import 'package:expenses/widgets/new_transaction.dart';
import 'package:expenses/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/Transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
        errorColor: Colors.deepOrangeAccent,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        ),
      ),
      home: Scaffold(
        body: MyScaffoldBody(),
      ),
    );
  }
}

class MyScaffoldBody extends StatefulWidget {
  @override
  _MyScaffoldBodyState createState() => _MyScaffoldBodyState();
}

class _MyScaffoldBodyState extends State<MyScaffoldBody> {
  var _showCharts = true;

  final List<Transaction> _transactionList = [
    Transaction(
        id: "t1", title: "New shoes", amount: 29.91, dateTime: DateTime.now()),
    Transaction(
        id: "t2", title: "New shoes", amount: 33.45, dateTime: DateTime.now()),
    Transaction(
        id: "t3", title: "New shoes", amount: 65.15, dateTime: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return _transactionList.where((tx) {
      return tx.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  void _addNewTransaction(String title, double amount, DateTime selectedDate) {
    var newTransaction = Transaction(
      id: '${DateTime.now().toString()}',
      dateTime: selectedDate,
      title: '$title',
      amount: amount,
    );

    setState(() {
      _transactionList.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionList.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        "Personal Expenses",
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add),
        )
      ],
    );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_transactionList, _deleteTransaction),
    );

    final displayChartSwitch = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Show chart"),
        Switch(
          value: _showCharts,
          onChanged: (val) {
            setState(() {
              _showCharts = val;
            });
          },
        ),
      ],
    );

    final portraitChart = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.3,
      child: Chart(_recentTransactions),
    );

    final landscapeChart = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.6,
      child: Chart(_recentTransactions),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isLandscape) portraitChart,
            if (!isLandscape) txListWidget,
            if (isLandscape) displayChartSwitch,
            if (isLandscape) _showCharts ? landscapeChart : txListWidget,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
