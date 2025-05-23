import 'package:finwise/models/goals_model.dart';
import 'package:finwise/service/api_ser.dart';
import 'package:finwise/validator/validator.dart';
import 'package:finwise/widget/dropdown_widget.dart';
import 'package:finwise/widget/field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

final List<String> expCategory = [
  'Food',
  'Bills',
  'Entertainment',
  'Transportation',
  'Health',
  'Shopping',
  'Goal',
  'Other',
];

final List<String> incomeCategory = [
  'Salary',
  'Sold something',
  'Lottery',
  'Prize',
  'Other',
];

final List<String> fieldType = ['Income', 'Expense'];
TextEditingController selectedType = TextEditingController();
final TextEditingController _dateController = TextEditingController();
final TextEditingController _amountController = TextEditingController();
final TextEditingController _catController = TextEditingController();
final TextEditingController _goalController = TextEditingController();

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
        _dateController.text = "$picked";
      });
    }
  }

  late final GoalsModel goals;
  bool loading = false;
  String? selectedGoal;

  final ApiService apiService = ApiService(baseUrl: 'http://192.168.8.17:4000');

  @override
  void initState() {
    selectedGoal = null;
    _dateController.clear();
    _amountController.clear();
    _catController.clear();
    _amountController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        loading = true;
      });
      fetchGoals().then((value) {
        setState(() {
          goals = value;
          loading = false;
        });
      });
    });
    super.initState();
  }

  Future<GoalsModel> fetchGoals() async {
    final response = await apiService.get('/api/finance/getGoals');
    return GoalsModel.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Amount"),
                      const SizedBox(height: 5),
                      TextFieldComponent(
                        controller: _amountController,
                        formatter: [FilteringTextInputFormatter.digitsOnly],
                        hintText: 'Enter Amount',
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 10),
                      Text("Select Type"),
                      const SizedBox(height: 5),
                      dropDownButton(
                        onSelect: (s) {
                          setState(() {});
                          _catController.clear();
                        },
                        context,
                        hintText: 'Select',
                        dropDownList: fieldType,
                        selectedValue: selectedType,
                        validator: validate,
                        labelText: 'Type',
                      ),
                      const SizedBox(height: 10),

                      Text("Select Category"),
                      const SizedBox(height: 5),
                      dropDownButton(
                        onSelect: (s) {
                          setState(() {});
                        },
                        context,
                        hintText: 'Select',
                        dropDownList:
                            selectedType.text.isEmpty
                                ? []
                                : selectedType.text == 'Income'
                                ? incomeCategory
                                : expCategory,
                        selectedValue: _catController,
                        validator: validate,
                        labelText: 'Type',
                      ),
                      const SizedBox(height: 10),

                      if (_catController.text == 'Goal') ...[
                        Text("Select Goal"),
                        const SizedBox(height: 5),
                        dropDownButton(
                          onSelect: (s) {
                            setState(() {
                              selectedGoal =
                                  goals.data!
                                      .firstWhere(
                                        (element) => element.title == s,
                                      )
                                      .sId;
                            });
                          },
                          context,
                          hintText: 'Select',
                          dropDownList:
                              goals.data!.map((e) => e.title ?? "").toList(),

                          selectedValue: _goalController,
                          validator: validate,
                          labelText: 'Type',
                        ),
                        const SizedBox(height: 10),
                      ],

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
                          onPressed: () {
                            if (_validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please fill all fields"),
                                ),
                              );
                              return;
                            }
                            Map<String, dynamic> body = {
                              "amount": num.tryParse(_amountController.text),

                              "type": selectedType.text,

                              "category": _catController.text,
                              "date": _dateController.text,
                            };
                            if (_catController.text == 'Goal') {
                              body['goalId'] = selectedGoal;
                            }
                            apiService
                                .post(
                                  '/api/finance/addTransaction',
                                  payload: body,
                                )
                                .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Transaction added successfully',
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                })
                                .catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to add Transaction',
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text("Add Transaction"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  _validate() {
    if (_amountController.text.isEmpty ||
        _catController.text.isEmpty ||
        selectedType.text.isEmpty ||
        _dateController.text.isEmpty) {
      return true;
    }
    if (_catController.text == 'Goal' && selectedGoal == null) {
      return true;
    }
    return false;
  }
}
