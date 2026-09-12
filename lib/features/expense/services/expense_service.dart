import 'package:dio/dio.dart';
import 'package:pulse/api/endpoints.dart';
import 'package:pulse/features/expense/models/expense.dart';
import 'package:pulse/utils/dio_exception_handler.dart';

class ExpenseServiceException implements Exception {
  final String message;
  final int? statusCode;

  ExpenseServiceException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ExpenseService {
  final Dio dio;
  ExpenseService({required this.dio});

  Future<List<Expense>> fetchAll() async {
    final response = await _send(() => dio.get(Endpoints.expenses));
    final data = response.data as List<dynamic>;
    return data
        .map((json) => Expense.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Expense> createExpense(Expense expense) async {
    final response = await _send(
      () => dio.post(Endpoints.expenses, data: expense.toJson()),
    );
    return Expense.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Expense> updateExpense(Expense expense) async {
    final id = expense.id;
    if (id == null) {
      throw ExpenseServiceException('Cannot update an expense without an id');
    }
    await _send(
      () => dio.put(Endpoints.expenseByID(id), data: expense.toJson()),
    );
    return expense;
  }

  Future<void> deleteExpense(String id) async {
    await _send(() => dio.delete(Endpoints.expenseByID(id)));
  }

  Future<Response> _send(Future<Response> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw CustomDioException.fromDioError(e);
    }
  }
}
