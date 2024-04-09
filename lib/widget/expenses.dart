import 'package:flutter/material.dart';
import 'package:tracker_app/widget/chart/chart.dart';
import 'package:tracker_app/widget/expense_list/expenses_list.dart';
import 'package:tracker_app/widget/new_expense.dart';

import '../models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter course',
        amount: 199,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 234,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        context: context,

        /// by default it should show full screen. that is why set true.
        /// Enable scrolling if content is too tall.
        isScrollControlled: true,
        builder: (cxt) {
          return NewExpense(_addExpense);
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final indexExpense = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    /// Remove any previous snackbar that might have on the screen.
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expenses deleted'),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(indexExpense, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    /// Find available width on device
    final width = MediaQuery.of(context).size.width;
    Widget _mainWidget = Center(
      child: Text(
        'No Expenses Found,Start adding expense.',
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      _mainWidget = ExpensesList(
        _registeredExpenses,
        onRemove: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: _mainWidget,
                )
              ],
            )
          : Row(
              children: [
                /// Expanded use maximum available height instead as much as possible
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: _mainWidget,
                )
              ],
            ),
    );
  }
}
