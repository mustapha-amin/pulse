import 'package:intl/intl.dart';

enum ExpenseCategory { 
  food, 
  transport, 
  bills, 
  other;
}

class Expense {
  final String? id;
  final String title;
  final int amountKobo;
  final ExpenseCategory category;
  final DateTime createdAt;

  Expense({
    this.id,
    required this.title,
    required this.amountKobo,
    required this.category,
    required this.createdAt,
  }) : assert(title.trim().isNotEmpty, 'title is required and cannot be empty'),
       assert(amountKobo > 0, 'amountKobo must be greater than 0');

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String? ?? json['_id'] as String?,
      title: json['title'] as String,
      amountKobo: json['amountKobo'] as int,
      category: ExpenseCategory.values.firstWhere((e) => e == json['category']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Body for POST/PUT requests. Deliberately omits `id` — the server
  /// assigns it on create.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amountKobo': amountKobo,
      'category': category.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  double get amountNaira => amountKobo / 100;

  Expense copyWith({
    String? id,
    String? title,
    int? amountKobo,
    ExpenseCategory? category,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amountKobo: amountKobo ?? this.amountKobo,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}