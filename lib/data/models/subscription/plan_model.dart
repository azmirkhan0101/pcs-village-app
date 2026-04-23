class PlanModel {
  final String id;
  final String name;
  final String description;
  final String slug;
  final double price;
  final String currency;
  final String interval;
  final String stripePriceId;
  final List<String> features;
  final bool isActive;

  PlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.slug,
    required this.price,
    required this.currency,
    required this.interval,
    required this.stripePriceId,
    required this.features,
    required this.isActive,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      slug: json['slug'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      interval: json['interval'] as String,
      stripePriceId: json['stripePriceId'] as String,
      features: List<String>.from(json['features'] ?? []),
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'slug': slug,
      'price': price,
      'currency': currency,
      'interval': interval,
      'stripePriceId': stripePriceId,
      'features': features,
      'isActive': isActive,
    };
  }
}