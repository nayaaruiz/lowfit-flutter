class PlanResponse {
  final int id;
  final String name;
  final String? description;
  final double? price;

  PlanResponse({
    required this.id,
    required this.name,
    this.description,
    this.price,
  });

  factory PlanResponse.fromJson(Map<String, dynamic> json) {
    return PlanResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
    );
  }
}