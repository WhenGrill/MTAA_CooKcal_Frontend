
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