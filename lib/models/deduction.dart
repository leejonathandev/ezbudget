class Deduction {
  String description;
  double amount;
  DateTime date;

  Deduction(this.description, this.amount, this.date);

  Deduction.fromJson(Map<String, dynamic> json)
      : description = json['description'] as String,
        amount = json['amount'] as double,
        date = DateTime.parse(json['date'] as String);

  Map<String, dynamic> toJson() => {
        'description': description,
        'amount': amount,
        'date': date.toIso8601String(),
      };
}
