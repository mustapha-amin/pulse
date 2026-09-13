abstract class Endpoints {
  static const baseUrl =
      "https://crudcrud.com/api/325547117a6d4e519e97fb394e7b35d5";
  static const expenses = "/expenses";
  static String expenseByID(String id) => "/expenses/$id";
}
