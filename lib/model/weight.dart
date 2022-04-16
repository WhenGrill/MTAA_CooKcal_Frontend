
class WeightOut {
  final double weight;
  final String measure_time;

  WeightOut({
    required this.weight,
    required this.measure_time,
  });

  factory WeightOut.fromJson(Map<String, dynamic> json) {
    return WeightOut(
      weight: json['weight'],
      measure_time: json['measure_time'],
    );
  }
  Map<String, dynamic> toJson() => {
    'weight': weight,
    'measure_time': measure_time,
  };


  static List<WeightOut> listFromJson(List<dynamic> list) =>
      List<WeightOut>.from(list.map((x) => WeightOut.fromJson(x)));

}