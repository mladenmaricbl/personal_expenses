import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget{
  final Function addTransactionToList;

  NewTransaction({
    required this.addTransactionToList,
  });

  @override
  _NewTransaction createState() => _NewTransaction();
}

class _NewTransaction extends State<NewTransaction>{

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _onSubmitData(){
    final titleText = titleController.text;
    final amountText = double.parse(amountController.text);

    if(titleText.isEmpty || amountText <=0 || _selectedDate == null) {
      return;
    }
    widget.addTransactionToList(titleText, amountText, _selectedDate);

    Navigator.of(context).pop();
  }

  void _openDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now()
    ).then((choosenDate){
      if(choosenDate == null){
        return;
      }
     setState(() {
       _selectedDate = choosenDate;
     });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                  autocorrect: true,
                  autofocus: true,
                  controller: titleController,
                  onSubmitted:(_) {
                    final titleText = titleController.text;
                    final amountText = double.parse(amountController.text);

                    if(titleText.isEmpty || amountText <=0 || _selectedDate == null) {
                      return;
                    }
                    widget.addTransactionToList(titleText, amountText, _selectedDate);
                    Navigator.of(context).pop();
                  }, // (_) se koristi kad moras proslijediti neku vrijednost u funkciju, a ne koristis je. Konvencija.
                  decoration: InputDecoration(
                    labelText: 'Title',
                  )
              ),
              TextField(
                  autocorrect: true,
                  controller: amountController,
                  onSubmitted:(_) {
                    final titleText = titleController.text;
                    final amountText = double.parse(amountController.text);

                    if(titleText.isEmpty || amountText <=0 || _selectedDate == null) {
                      return;
                    }
                    widget.addTransactionToList(titleText, amountText, _selectedDate);
                    Navigator.of(context).pop();
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                  )
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Text(
                      _selectedDate == null ? 'No date choosen!': 'Choosen date: ${DateFormat.yMMMd().format(_selectedDate)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: _openDatePicker,
                        icon: Icon(
                          Icons.date_range_rounded,
                          color: Theme.of(context).accentColor,
                        ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _onSubmitData,
                  child: Text(
                    'Add transaction',
                  )),
            ],
          ),
        )
    );
  }
}
