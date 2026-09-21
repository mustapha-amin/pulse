abstract class Endpoints {
  static const baseUrl =
      "https://crudcrud.com/api/773dff8c390c4fa4a761d62492a6f709";
  static const expenses = "/expenses";
  static String expenseByID(String id) => "/expenses/$id";
}
