import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_app/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.addExpense, {super.key});

  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  var _title = '';
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _pickedDate;
  Category _selectedCategory = Category.leisure;

  void _saveTitle(String title) {
    _title = title;
  }

  void _datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _pickedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text('Inavlid input'),
          content: Text(
            'Please make sure valid title, amount, adte and category was entered.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Ok'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Inavlid input'),
          content: Text(
            'Please make sure valid title, amount, adte and category was entered.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Ok'),
            )
          ],
        ),
      );
    }
  }

  void _saveData() {
    final _amount = double.tryParse(_amountController.text);
    final _isValidAmount = _amount == null || _amount <= 0;
    if (_titleController.text.trim().isEmpty ||
        _isValidAmount ||
        _pickedDate == null) {
      _showDialog();
      return;
    }
    widget.addExpense(Expense(
        title: _titleController.text,
        amount: _amount!,
        date: _pickedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  ///  It is used to perform cleanup operations when a stateful
  ///  widget is removed from the widget tree, typically when the
  ///  widget is no longer needed or when the widget is being
  ///  removed from the screen.
  ///
  ///  It's important to call super.dispose() at the end of your
  ///  dispose() method to ensure that the parent class's dispose()
  ///  method is also executed properly.
  @override
  void dispose() {
    _titleController.dispose(); // release memory for this controller
    _amountController.dispose(); // release memory for this controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// viewInsets object contain information about UI elements that might be
    /// overlapping certain part of UI
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    /// The LayoutBuilder widget in Flutter is a powerful tool that
    /// allows you to create widgets whose sizes are dependent on
    /// the constraints they are given. It's especially useful for
    /// creating responsive layouts and widgets that adapt to the
    /// available screen space.
    return LayoutBuilder(
      builder: (ctx, constraint) {
        final width = constraint.maxWidth;
        return SizedBox(
          height: double.infinity,

          /// SingleChildScrollView used for scroll the screen
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            /// Collect text from TextField option 1
                            /*onChanged: (tt) {
                              _saveTitle(tt);
                          },*/

                            /// option 2
                            controller: _titleController,
                            maxLength: 50,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            maxLength: 50,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        )
                      ],
                    )
                  else
                    TextField(
                      /// Collect text from TextField option 1
                      /*onChanged: (tt) {
              _saveTitle(tt);
            },*/

                      /// option 2
                      controller: _titleController,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((category) => DropdownMenuItem(
                                    value: category,

                                    /// value set to each item and it will get in onChanged
                                    child: Text(category.name.toUpperCase()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _pickedDate == null
                                    ? 'No Date Selected'
                                    : formatter.format(_pickedDate!),
                              ),
                              IconButton(
                                onPressed: _datePicker,
                                icon: const Icon(Icons.calendar_month),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            maxLength: 50,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _pickedDate == null
                                    ? 'No Date Selected'
                                    : formatter.format(_pickedDate!),
                              ),
                              IconButton(
                                onPressed: _datePicker,
                                icon: const Icon(Icons.calendar_month),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            /// pop method help remove overlay from the screen
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        //Spacer(),
                        ElevatedButton(
                          onPressed: _saveData,
                          child: Text('Save'),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((category) => DropdownMenuItem(
                                    value: category,

                                    /// value set to each item and it will get in onChanged
                                    child: Text(category.name.toUpperCase()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            /// pop method help remove overlay from the screen
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        //Spacer(),
                        ElevatedButton(
                          onPressed: _saveData,
                          child: Text('Save'),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
