import 'package:finwise/models/exp_model.dart';
import 'package:finwise/screens/add_expense.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finwise'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpense()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Income: 50000 \$'),
                        Text('Total Expenses: 43214 \$'),
                        Text('Remaining Balance: ${50000 - 43214} \$'),
                      ],
                    ),
                  ),
                ),
                SfCircularChart(
                  title: ChartTitle(text: 'Monthly Sales'),
                  legend: Legend(isVisible: true),
                  series: <PieSeries<DataModel, String>>[
                    PieSeries<DataModel, String>(
                      dataSource: <DataModel>[
                        ExpenseModel(
                          amount: '2430',
                          category: 'food',
                          desc: 'ANC',
                          date: DateTime(2023, 10, 1),
                        ),
                        ExpenseModel(
                          amount: '1900',
                          category: 'bills',
                          desc: 'ANC',
                          date: DateTime(2023, 10, 2),
                        ),
                        ExpenseModel(
                          amount: '100',
                          category: 'food',
                          desc: 'ANC',
                          date: DateTime(2023, 10, 3),
                        ),
                        ExpenseModel(
                          amount: '500',
                          category: 'food',
                          desc: 'ANC',
                          date: DateTime(2023, 10, 5),
                        ),
                        ExpenseModel(
                          amount: '15000',
                          category: 'food',
                          desc: 'ANC',
                          date: DateTime(2023, 10, 5),
                        ),
                      ],
                      xValueMapper: (DataModel sales, _) => sales.category,
                      yValueMapper:
                          (DataModel sales, _) => num.tryParse(sales.amount),
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
