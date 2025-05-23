import 'package:finwise/models/goals_model.dart';
import 'package:finwise/service/api_ser.dart';
import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late Future<GoalsModel> _goalsFuture;

  @override
  void initState() {
    super.initState();
    _goalsFuture = fetchGoals();
  }

  Future<GoalsModel> fetchGoals() async {
    final api = ApiService(baseUrl: 'http://192.168.8.18:4000');
    final response = await api.get('/api/finance/getGoals');
    return GoalsModel.fromJson(response.data);
  }

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
              child: FutureBuilder<GoalsModel>(
                future: _goalsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.data == null ||
                      snapshot.data!.data!.isEmpty) {
                    return Center(child: Text('No goals found.'));
                  }
                  final goals = snapshot.data!.data!;
                  return ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return Card(
                        child: ListTile(
                          title: Text(goal.title ?? 'No Title'),
                          subtitle: Text(
                            'Month: ${goal.month ?? ''} ${goal.year ?? ''}',
                          ),
                          trailing: Text('${goal.amount ?? 0} \$'),
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

  _onTap(BuildContext context) {
    int? selectedMonth;
    int? selectedYear;
    showAdaptiveDialog(
      context: context,
      builder: (c) {
        return Material(
          child: StatefulBuilder(
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
                    TextField(
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
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Planned Amount',
                        hintText: 'Enter your planned amount',
                      ),
                    ),
                    ElevatedButton(onPressed: () {}, child: Text('Add Goal')),
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
