class DataModel {
  DataModel({
    required this.amount,
    required this.category,
    required this.desc,
    required this.date,
  });
  final String amount;
  final String category;
  final String desc;
  final DateTime date;
}

class ExpenseBarData {
  final String month;
  final double amount;
  ExpenseBarData(this.month, this.amount);
}
