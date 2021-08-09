import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
//import 'package:flutter/services.dart';

import 'package:personal_expenses_app/widgets/chart.dart';
import 'package:personal_expenses_app/widgets/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';
import 'package:personal_expenses_app/models/transaction.dart';

void main() {
  /*
  *** Na ovaj nacin se moze rijesiti problem landscape u aplikaciji
  tako sto dozvolimo samo portret. ***

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.textScaleFactorOf(context);

    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.purpleAccent,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(title: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 18 * curScaleFactor,
          fontWeight: FontWeight.bold,
        )),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(title: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20 * curScaleFactor,
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransaction = [];
  bool _showChart = false;
  static const String appTitle ='Personal Expenses';

  void _addTransactionToList(String title, double amount, DateTime choosenDate){
    int rn = _userTransaction.length + 1;
    String id = 't'+ rn.toString();
    DateTime date = choosenDate;

    final tr = Transaction(id: id, title: title, amount: amount, date: date);
    setState(() {
      _userTransaction.add(tr);
    });
  }

  void _showInputTransaction(BuildContext ctx){

    /* showModalBottomSheet(context: ctx, builder: (_){
        return GestureDetector(
          onTap: (){},
          child: NewTransaction(addTransactionToList: _addTransactionToList),
          behavior: HitTestBehavior.opaque,
        );
    });*/
     showModalBottomSheet(
         context: context,
         isScrollControlled: true,
         builder: (context) =>  Padding(
             padding: EdgeInsets.only(
               left: 10,
               top: 10,
               right: 10,
               bottom: MediaQuery.of(ctx).viewInsets.bottom + 10,
             ),
             child: NewTransaction(addTransactionToList: _addTransactionToList),
           )
     );
  }

  void _removeTransactionFromList(String id){
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  ObstructingPreferredSizeWidget _buildCupertinoNavBar(){
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.systemGrey.withOpacity(0.5),
      middle: const Text(appTitle),
    );
  }

  List<Transaction> get _recentTransactions{
    return _userTransaction.where((transaction) {
      return transaction.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    var appBar = AppBar(
      title: Text(
        appTitle,
      ),
      actions: [
        IconButton(
            onPressed: () => _showInputTransaction(context),
            icon: Icon(Icons.add)
        ),
      ],
    );

    var txList = Container(
      height: (mediaQuery.size.height - (mediaQuery.padding.top + appBar.preferredSize.height)) * 0.7,
      child: TransactionList(_userTransaction, _removeTransactionFromList),
    );

    var chartWidget = Container(
      height: isLandscape ?
      (mediaQuery.size.height - (mediaQuery.padding.top + appBar.preferredSize.height)) * 0.75
          :
      (mediaQuery.size.height - (mediaQuery.padding.top + appBar.preferredSize.height)) * 0.3,
      child: Chart(_recentTransactions),
    );

    var switchWidget = Container(
      height: (mediaQuery.size.height - (mediaQuery.padding.top + appBar.preferredSize.height)) * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Show chart'),
          Switch.adaptive(
              value: _showChart,
              onChanged: (val){
                setState(() {
                  _showChart = val;
                });
          })
        ],
      ),
    );

    var appBody = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(isLandscape) switchWidget,
          if(isLandscape && !_showChart) txList,
          if(isLandscape && _showChart) chartWidget,
          if(!isLandscape) chartWidget,
          if(!isLandscape)txList,
        ],
      ),
    );

    return Platform.isIOS ?
    CupertinoPageScaffold(
      navigationBar: _buildCupertinoNavBar(),
      child: appBody,
    )
        :
    Scaffold(
      appBar: appBar,
      body: appBody,
      floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showInputTransaction(context),
      ),
    );
  }
}
