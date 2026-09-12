abstract class Endpoints {
  static const baseUrl =
      "https://crudcrud.com/api/420eb8b4d4434e49ac55908e6bdf28e1";
  static const expenses = "/expenses";
  static String expenseByID(String id) => "/expenses/$id";
}
