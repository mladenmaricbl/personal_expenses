import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:personal_expenses_app/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.userTransaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction userTransaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
      elevation: 6,
      child: ListTile(
        leading: CircleAvatar(
            child: Padding(
                padding: EdgeInsets.all(6),
                child: FittedBox(
                  child: Text('\$${userTransaction.amount}'),
                )
            )
        ),
        title:Text(
          '${userTransaction.title}',
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(userTransaction.date),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        trailing: MediaQuery.of(context).size.width < 400 ?
        IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => deleteTransaction(userTransaction.id),
        )
            :
        FlatButton.icon(
            onPressed: () => deleteTransaction(userTransaction.id),
            icon: Icon(Icons.delete),
            textColor: Theme.of(context).errorColor,
            label: Text('Delete')
        ),
      ),
    );
  }
}