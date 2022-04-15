
class FoodlistIn {
  final int id_food;
  final double amount;

  FoodlistIn({
    required this.id_food,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'id_food': id_food,
    'amount': amount
  };
}

class FoodListOut {
  final int id;
  final String title;
  final double kcal_100g;
  final double amount;

  FoodListOut({
    required this.id,
    required this.title,
    required this.kcal_100g,
    required this.amount
  });

  factory FoodListOut.fromJson(Map<String, dynamic> json) {
    return FoodListOut(
      id: json['id'],
      title: json['title'],
      kcal_100g: json['kcal_100g'],
      amount: json['amount'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'kcal_100g': kcal_100g,
    'amount': amount,
  };


  static List<FoodListOut> listFromJson(List<dynamic> list) =>
      List<FoodListOut>.from(list.map((x) => FoodListOut.fromJson(x)));

}