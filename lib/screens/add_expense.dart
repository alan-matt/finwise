import 'package:finwise/validator/validator.dart';
import 'package:finwise/widget/dropdown_widget.dart';
import 'package:finwise/widget/field_widget.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

final List<String> category = [
  'Food',
  'Bills',
  'Entertainment',
  'Transportation',
  'Health',
  'Shopping',
  'Other',
];

final List<String> fieldType = ['Income', 'Expense'];
TextEditingController selectedType = TextEditingController();
final TextEditingController _dateController = TextEditingController();

class _AddExpenseState extends State<AddExpense> {
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Amount"),
              const SizedBox(height: 5),
              TextFieldComponent(
                controller: TextEditingController(),
                hintText: 'Enter Amount',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              Text("Select Category"),
              const SizedBox(height: 5),
              dropDownButton(
                context,
                hintText: 'Select',
                dropDownList: category,
                selectedValue: selectedType,
                validator: validate,
                labelText: 'Type',
              ),
              const SizedBox(height: 10),
              Text("Select Type"),
              const SizedBox(height: 5),
              dropDownButton(
                context,
                hintText: 'Select',
                dropDownList: fieldType,
                selectedValue: selectedType,
                validator: validate,
                labelText: 'Type',
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: () => _pickDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Select Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Add Expense"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
