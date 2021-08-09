import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:personal_expenses_app/widgets/chart_bar.dart';
import 'package:personal_expenses_app/models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
        final dayInWeek = DateTime.now().subtract(Duration(days: index),);
        var amountSum = 0.0;

        for(var i = 0; i < recentTransactions.length; i++){
          if(recentTransactions[i].date.day == dayInWeek.day &&
             recentTransactions[i].date.month == dayInWeek.month &&
             recentTransactions[i].date.year == dayInWeek.year){
            amountSum += recentTransactions[i].amount;
          }
        }

        return {
          'day': DateFormat.E().format(dayInWeek).substring(0,1),
          'amount': amountSum
        };
    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Flexible(
        fit: FlexFit.tight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data){
            return ChartBar((data['day'] as String), (data['amount'] as double),  (totalSpending == 0.0)? 0.0 : (data['amount'] as double) / totalSpending);
          }).toList(),
        ),
      ),
    );
  }
}