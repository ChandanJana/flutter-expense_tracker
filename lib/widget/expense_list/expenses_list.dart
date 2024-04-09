import 'package:flutter/material.dart';
import 'package:tracker_app/widget/expense_list/expense_item.dart';

import '../../models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(this.expenseList, {super.key, required this.onRemove});

  final List<Expense> expenseList;
  final void Function(Expense expense) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Dismissible(
        /// swipe to remove/dismiss widget
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(.5),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        key: ValueKey(expenseList[index]),

        /// set unique key to identify, ValueKey use for set unique key
        onDismissed: (direction) {
          onRemove(expenseList[index]);
        },
        child: ExpenseItem(expense: expenseList[index]),
      ),
      itemCount: expenseList.length,
    );
  }
}
