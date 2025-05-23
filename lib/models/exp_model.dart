abstract class DataModel {
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

class ExpenseModel extends DataModel {
  ExpenseModel({
    required super.amount,
    required super.category,
    required super.desc,
    required super.date,
  });
}

class IncomeModel extends DataModel {
  IncomeModel({
    required super.amount,
    required super.category,
    required super.desc,
    required super.date,
  });
}
