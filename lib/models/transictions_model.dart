class TransictionModel {
  String? status;
  String? message;
  List<Data>? data;

  TransictionModel({this.status, this.message, this.data});

  TransictionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? progress;
  String? sId;
  String? title;
  String? month;
  int? year;
  int? amount;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.progress,
    this.sId,
    this.title,
    this.month,
    this.year,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    progress = json['progress'];
    sId = json['_id'];
    title = json['title'];
    month = json['month'];
    year = json['year'];
    amount = json['amount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['progress'] = this.progress;
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['month'] = this.month;
    data['year'] = this.year;
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
