import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:personal_expenses_app/models/transaction.dart';
import 'transaction_item.dart';


class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  Function deleteTransaction;

  TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: userTransactions.isEmpty ? LayoutBuilder(builder: (ctx, constrains){
        return Column(
          children: [
            Text(
              'No transactions yet!',
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: constrains.maxHeight * 0.6,
              child: Image.asset('assets/images/waiting.png',
                fit: BoxFit.cover,
              ),
            )
          ],
        );
      })
        :
      ListView.builder(
          itemBuilder: (ctx, index) {
            return TransactionItem(userTransaction: userTransactions[index], deleteTransaction: deleteTransaction);
          },
        itemCount: userTransactions.length,
      ),
    );
  }
}
