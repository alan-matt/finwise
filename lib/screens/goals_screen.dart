// import 'package:finwise/models/goals_model.dart';
// import 'package:finwise/service/api_ser.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// class GoalsScreen extends StatefulWidget {
//   GoalsScreen({super.key});

//   @override
//   State<GoalsScreen> createState() => _GoalsScreenState();
// }

// class _GoalsScreenState extends State<GoalsScreen> {
//   final ApiService apiService = ApiService();

//   late Future<GoalsModel> _goalsFuture;
//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _goalsFuture = fetchGoals();
//   }

//   Future<GoalsModel> fetchGoals() async {
//     final api = ApiService(baseUrl: 'http://192.168.8.17:4000');
//     final response = await api.get('/api/finance/getGoals');
//     return GoalsModel.fromJson(response.data);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         title: Text('Goals'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               _onTap(context);
//             },
//             icon: Icon(Icons.add),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child:
//             loading
//                 ? Center(child: CircularProgressIndicator())
//                 : Column(
//                   children: [
//                     Expanded(
//                       child: FutureBuilder<GoalsModel>(
//                         future: _goalsFuture,
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(
//                               child: Text('Error: ${snapshot.error}'),
//                             );
//                           } else if (!snapshot.hasData ||
//                               snapshot.data!.data == null ||
//                               snapshot.data!.data!.isEmpty) {
//                             return Center(child: Text('No goals found.'));
//                           }
//                           final goals = snapshot.data!.data!;
//                           return ListView.builder(
//                             itemCount: goals.length,
//                             itemBuilder: (context, index) {
//                               final goal = goals[index];
//                               return Card(
//                                 child: ListTile(
//                                   leading: ElevatedButton(
//                                     onPressed: () {
//                                       showModalBottomSheet(
//                                         constraints: BoxConstraints(
//                                           maxHeight:
//                                               MediaQuery.of(
//                                                 context,
//                                               ).size.height *
//                                               0.8,
//                                         ),
//                                         useSafeArea: false,
//                                         isScrollControlled: true,
//                                         showDragHandle: true,
//                                         context: context,
//                                         builder: (c) {
//                                           return BottomSheetContent(
//                                             goalId: goal.sId!,
//                                           );
//                                         },
//                                       );
//                                     },
//                                     child: Text('AI Analysis'),
//                                   ),
//                                   title: Text(goal.title ?? 'No Title'),
//                                   subtitle: Text(
//                                     'Achieve By: ${goal.month ?? ''}/${goal.year ?? ''}',
//                                   ),
//                                   trailing: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         'Total Amount: ${goal.amount ?? 0} \$',
//                                       ),
//                                       Text(
//                                         'Progress: ${goal.progress ?? 0} \$',
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//       ),
//     );
//   }

//   _onTap(BuildContext context) {
//     final titleController = TextEditingController();
//     final amountController = TextEditingController();
//     int? selectedMonth;
//     int? selectedYear;
//     showAdaptiveDialog(
//       context: context,
//       builder: (c) {
//         return Scaffold(
//           body: StatefulBuilder(
//             builder: (context, setState) {
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   spacing: 20,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Add New Goal'),
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: Icon(Icons.close),
//                         ),
//                       ],
//                     ),
//                     TextFormField(
//                       controller: titleController,
//                       decoration: InputDecoration(
//                         labelText: 'Goal',
//                         hintText: 'Enter your goal',
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: DropdownButton<int>(
//                             value: selectedMonth,
//                             items: List.generate(12, (index) {
//                               return DropdownMenuItem(
//                                 value: index + 1,
//                                 child: Text('${index + 1}'),
//                               );
//                             }),
//                             onChanged: (val) {
//                               setState(() {
//                                 selectedMonth = val!;
//                               });
//                             },
//                             hint: Text('Month'),
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: DropdownButton<int>(
//                             value: selectedYear,
//                             items: List.generate(10, (index) {
//                               int year = DateTime.now().year + index;
//                               return DropdownMenuItem(
//                                 value: year,
//                                 child: Text('$year'),
//                               );
//                             }),
//                             onChanged: (val) {
//                               setState(() {
//                                 selectedYear = val!;
//                               });
//                               // setState needed if using StatefulWidget
//                             },
//                             hint: Text('Year'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     TextFormField(
//                       controller: amountController,
//                       decoration: InputDecoration(
//                         labelText: 'Planned Amount',
//                         hintText: 'Enter your planned amount',
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         // Handle the add goal action
//                         if (titleController.text.isEmpty ||
//                             amountController.text.isEmpty ||
//                             selectedMonth == null ||
//                             selectedYear == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Please fill all fields')),
//                           );
//                           return;
//                         }
//                         final body = {
//                           "title": titleController.text,
//                           "month": selectedMonth,
//                           "year": selectedYear,
//                           "amount": amountController.text,
//                         };
//                         apiService
//                             .post('/api/finance/addGoal', payload: body)
//                             .then((value) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('Goal added successfully'),
//                                 ),
//                               );
//                               _goalsFuture = fetchGoals();
//                               Navigator.pop(context);
//                             })
//                             .catchError((error) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Failed to add goal')),
//                               );
//                             });
//                       },
//                       child: Text('Add Goal'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class BottomSheetContent extends StatefulWidget {
//   final String goalId;

//   const BottomSheetContent({super.key, required this.goalId});

//   @override
//   State<BottomSheetContent> createState() => _BottomSheetContentState();
// }

// class _BottomSheetContentState extends State<BottomSheetContent> {
//   bool loading = true;
//   String? suggestion;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     try {
//       final api = ApiService(baseUrl: 'http://192.168.8.17:4000');

//       final value = await api.get(
//         '/api/finance/aiAnalyzer2?goalId=${widget.goalId}',
//       );
//       if (!mounted) return;
//       setState(() {
//         print(value.data['data']);
//         suggestion = value.data['data']['suggestion'];
//         loading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         error = 'Failed to load suggestion.';
//         loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const SizedBox(
//         height: 300,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (error != null) {
//       return SizedBox(height: 300, child: Center(child: Text(error!)));
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: MarkdownBody(data: suggestion ?? ''),
//     );
//   }
// }

import 'package:finwise/models/goals_model.dart';
import 'package:finwise/service/api_ser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://192.168.8.17:4000');
  late Future<GoalsModel> _goalsFuture;

  @override
  void initState() {
    super.initState();
    _goalsFuture = fetchGoals();
  }

  Future<GoalsModel> fetchGoals() async {
    final response = await apiService.get('/api/finance/getGoals');
    return GoalsModel.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddGoalDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<GoalsModel>(
          future: _goalsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data!.data?.isEmpty == true) {
              return const Center(child: Text('No goals added yet.'));
            }

            final goals = snapshot.data!.data!;
            return ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.flag_rounded,
                      size: 32,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      goal.title ?? 'Untitled Goal',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Achieve by: ${goal.month}/${goal.year}'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total: \$${goal.amount}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Progress: \$${goal.progress}',
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ],
                    ),
                    onTap: () => _showGoalAnalysis(context, goal.sId!),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showGoalAnalysis(BuildContext context, String goalId) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BottomSheetContent(goalId: goalId),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    int? selectedMonth;
    int? selectedYear;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add New Goal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Goal Title'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(labelText: 'Month'),
                          value: selectedMonth,
                          items: List.generate(
                            12,
                            (i) => DropdownMenuItem(
                              value: i + 1,
                              child: Text('${i + 1}'),
                            ),
                          ),
                          onChanged:
                              (val) => setState(() => selectedMonth = val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(labelText: 'Year'),
                          value: selectedYear,
                          items: List.generate(10, (i) {
                            final year = DateTime.now().year + i;
                            return DropdownMenuItem(
                              value: year,
                              child: Text('$year'),
                            );
                          }),
                          onChanged:
                              (val) => setState(() => selectedYear = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Planned Amount',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (titleController.text.isEmpty ||
                          amountController.text.isEmpty ||
                          selectedMonth == null ||
                          selectedYear == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields'),
                          ),
                        );
                        return;
                      }

                      final body = {
                        "title": titleController.text,
                        "month": selectedMonth,
                        "year": selectedYear,
                        "amount": amountController.text,
                      };

                      try {
                        await apiService.post(
                          '/api/finance/addGoal',
                          payload: body,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Goal added successfully'),
                          ),
                        );
                        setState(() => _goalsFuture = fetchGoals());
                        Navigator.pop(context);
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to add goal')),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Goal'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  final String goalId;

  const BottomSheetContent({super.key, required this.goalId});

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
      final value = await api.get(
        '/api/finance/aiAnalyzer2?goalId=${widget.goalId}',
      );
      if (!mounted) return;
      setState(() {
        suggestion = value.data['data']['suggestion'];
        loading = false;
      });
    } catch (_) {
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
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: MarkdownBody(data: suggestion ?? ''),
    );
  }
}
