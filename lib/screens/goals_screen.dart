import 'package:finwise/service/api_ser.dart';
import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  GoalsScreen({super.key});
  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Goals'),
        actions: [
          IconButton(
            onPressed: () {
              _onTap(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Goal: Visit Paris in 2025 December'),
                      subtitle: Text('Plan: Save 10000 \$'),
                      trailing: Column(
                        children: [
                          Text('Progress: 5000 \$'),
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                showDragHandle: true,
                                context: context,
                                builder: (c) {
                                  return Scaffold();
                                },
                              );
                            },
                            child: Text('AI Analysis'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onTap(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    int? selectedMonth;
    int? selectedYear;
    showAdaptiveDialog(
      context: context,
      builder: (c) {
        return Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 20,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Add New Goal'),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Goal',
                        hintText: 'Enter your goal',
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<int>(
                            value: selectedMonth,
                            items: List.generate(12, (index) {
                              return DropdownMenuItem(
                                value: index + 1,
                                child: Text('${index + 1}'),
                              );
                            }),
                            onChanged: (val) {
                              setState(() {
                                selectedMonth = val!;
                              });
                            },
                            hint: Text('Month'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: DropdownButton<int>(
                            value: selectedYear,
                            items: List.generate(10, (index) {
                              int year = DateTime.now().year + index;
                              return DropdownMenuItem(
                                value: year,
                                child: Text('$year'),
                              );
                            }),
                            onChanged: (val) {
                              setState(() {
                                selectedYear = val!;
                              });
                              // setState needed if using StatefulWidget
                            },
                            hint: Text('Year'),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Planned Amount',
                        hintText: 'Enter your planned amount',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle the add goal action
                        if (titleController.text.isEmpty ||
                            amountController.text.isEmpty ||
                            selectedMonth == null ||
                            selectedYear == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all fields')),
                          );
                          return;
                        }
                        final body = {
                          "title": titleController.text,
                          "month": selectedMonth,
                          "year": selectedMonth,
                          "amount": amountController.text,
                        };
                        apiService
                            .post('/api/finance/addGoal', payload: body)
                            .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Goal added successfully'),
                                ),
                              );
                              Navigator.pop(context);
                            })
                            .catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to add goal')),
                              );
                            });
                      },
                      child: Text('Add Goal'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
