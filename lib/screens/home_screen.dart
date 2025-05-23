import 'package:finwise/models/exp_model.dart';
import 'package:finwise/models/transictions_model.dart';
import 'package:finwise/screens/add_expense.dart';
import 'package:finwise/screens/goals_screen.dart';
import 'package:finwise/service/api_ser.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<TransictionModel> _transictionFuture;

  @override
  void initState() {
    super.initState();
    _transictionFuture = fetchGoals();
  }

  Future<TransictionModel> fetchGoals() async {
    final api = ApiService(baseUrl: 'http://192.168.8.18:4000');
    final response = await api.get('/api/finance/getTransactions');
    return TransictionModel.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
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
                        DataModel(
                          amount: '2430',
                          category: 'food',
                          desc: 'ANC',
                          date: DateTime(2023, 10, 1),
                        ),
                        DataModel(
                          amount: '1900',
                          category: 'bills',
                          desc: 'ANC',
                          date: DateTime(2023, 10, 2),
                        ),
                        DataModel(
                          amount: '100',
                          category: 'food',
                          desc: 'ANC',
                          date: DateTime(2023, 10, 3),
                        ),
                        DataModel(
                          amount: '500',
                          category: 'entertainment',
                          desc: 'ANC',
                          date: DateTime(2023, 10, 5),
                        ),
                        DataModel(
                          amount: '15000',
                          category: 'health',
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
                SfCartesianChart(
                  title: ChartTitle(text: 'Monthly Expenses'),
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries<ExpenseBarData, String>>[
                    ColumnSeries<ExpenseBarData, String>(
                      dataSource: <ExpenseBarData>[
                        ExpenseBarData('Jan', 22000),
                        ExpenseBarData('Feb', 24000),
                        ExpenseBarData('Mar', 23445),
                        ExpenseBarData('Apr', 19982),
                        ExpenseBarData('May', 14000),
                      ],
                      xValueMapper: (ExpenseBarData data, _) => data.month,
                      yValueMapper: (ExpenseBarData data, _) => data.amount,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoalsScreen()),
                );
              },
              child: Text('Goals'),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<TransictionModel>(
                future: _transictionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.data == null ||
                      snapshot.data!.data!.isEmpty) {
                    return Center(child: Text('No transaction found.'));
                  }
                  final transiction = snapshot.data!.data!;
                  return ListView.builder(
                    itemCount: transiction.length,
                    itemBuilder: (context, index) {
                      final t = transiction[index];
                      return Card(
                        child: ListTile(
                          title: Text(t.title ?? 'No Title'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Month: ${t.month ?? ''} Year ${t.year ?? ''}',
                              ),
                              // Text('Progress: ${t.progress ?? 0}'),
                              Text('Created: ${t.createdAt ?? ''}'),
                            ],
                          ),
                          trailing: Text('${t.amount ?? 0} \$'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
