import 'package:finwise/models/exp_model.dart';
import 'package:finwise/models/transictions_model.dart';
import 'package:finwise/screens/add_expense.dart';
import 'package:finwise/screens/goals_screen.dart';
import 'package:finwise/service/api_ser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<TransictionModel> _transictionFuture;
  late final num totalIncome;
  late final num totalExpense;

  @override
  void initState() {
    super.initState();
    _transictionFuture = fetchTransactions();
  }

  Future<TransictionModel> fetchTransactions() async {
    final api = ApiService(baseUrl: 'http://192.168.8.17:4000');
    final response = await api.get('/api/finance/getTransactions');
    return TransictionModel.fromJson(response.data);
  }

  String formatDate(String? date) {
    if (date == null) return '';
    try {
      final dt = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            useSafeArea: false,
            isScrollControlled: true,
            showDragHandle: true,
            context: context,
            builder: (c) {
              return BottomSheetContent();
            },
          );
        },
        icon: Icon(Icons.analytics, color: Colors.white),
        label: Text('AI Analysis', style: TextStyle(color: Colors.white)),
        backgroundColor: theme.primaryColor,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Finwise',
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpense()),
              );
            },
            icon: Icon(Icons.add, color: theme.primaryColor),
            tooltip: "Add Expense",
          ),
        ],
      ),
      body: FutureBuilder<TransictionModel>(
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
          final expenseData =
              transiction
                  .where((e) => e.type!.toLowerCase() == 'expense')
                  .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Balance Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Income',
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '50,000 \$',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Total Expenses',
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '43,214 \$',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Balance',
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${50000 - 43214} \$',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Charts Row
                  Column(
                    children: [
                      Container(
                        width: 220,
                        height: 180,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SfCircularChart(
                          title: ChartTitle(
                            text: 'Monthly Sales',
                            textStyle: TextStyle(fontSize: 12),
                          ),
                          legend: Legend(isVisible: true),
                          series: <PieSeries<Data, String>>[
                            PieSeries<Data, String>(
                              dataSource: expenseData,
                              xValueMapper: (Data sales, _) => sales.category,
                              yValueMapper: (Data sales, _) => sales.amount,
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 220,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SfCartesianChart(
                          title: ChartTitle(
                            text: 'Monthly Expenses',
                            textStyle: TextStyle(fontSize: 12),
                          ),
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
                              xValueMapper:
                                  (ExpenseBarData data, _) => data.month,
                              yValueMapper:
                                  (ExpenseBarData data, _) => data.amount,
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GoalsScreen()),
                      );
                    },
                    icon: Icon(Icons.flag, color: Colors.white),
                    label: Text(
                      'Goals',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: transiction.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final t = transiction[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.07),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.primaryColor.withOpacity(
                              0.15,
                            ),
                            child: Icon(
                              Icons.account_balance_wallet,
                              color: theme.primaryColor,
                            ),
                          ),
                          title: Text(
                            (t.type ?? 'No Title').toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Transaction Date: ${DateTime.parse(t.date!).day}-${DateTime.parse(t.date!).month}-${DateTime.parse(t.date!).year}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.category_rounded,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    (t.category ?? '').toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${t.amount ?? 0} \$',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  bool loading = true;
  String? suggestion;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final api = ApiService(baseUrl: 'http://192.168.8.17:4000');

      final value = await api.get('/api/finance/aiAnalyzer3');
      if (!mounted) return;
      setState(() {
        print(value.data['data']);
        suggestion = value.data['data']['suggestion'];
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Failed to load suggestion.';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return SizedBox(height: 300, child: Center(child: Text(error!)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: MarkdownBody(data: suggestion ?? ''),
    );
  }
}
