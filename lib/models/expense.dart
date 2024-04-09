import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};

class Expense {
  /// When constructor called id will initialised by unique string value
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String title;
  final double amount;
  final String id;
  final DateTime date;
  final Category category;

  String getFormattedDate() {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  /// forcategory also a constructor of ExpenseBucket it is called utility constructor
  /// now the idea behind this extra constructor function
  /// is that we add some logic to this constructor function
  /// to Go through all the expenses we got
  /// and then filter out the ones that belong to this category
  /// so that we can set the expenses for this ExpenseBucket,
  /// which is tied to one specific category
  /// to a list of expenses that only are for that category.

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)

            /// where is used for filtering purpose
            .toList();

  final Category category;
  final List<Expense> expenses;

  /// double totalExpense (){} equal to below function
  double get totalExpense {
    double sum = 0;

    for (final expense in expenses) sum += expense.amount;

    return sum;
  }
}
