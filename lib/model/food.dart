

class FoodOut {
  final int id;
  final String title;
  final double kcal_100g;

  FoodOut({
    required this.id,
    required this.title,
    required this.kcal_100g,
  });

  factory FoodOut.fromJson(Map<String, dynamic> json) {
    return FoodOut(
      id: json['id'],
      title: json['title'],
      kcal_100g: json['kcal_100g'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'kcal_100g': kcal_100g,
  };


  static List<FoodOut> listFromJson(List<dynamic> list) =>
      List<FoodOut>.from(list.map((x) => FoodOut.fromJson(x)));

}