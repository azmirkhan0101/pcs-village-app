class ActivePlanModel {
  final String id;
  final String user;
  final String stripeSubscriptionId;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final bool cancelAtPeriodEnd;
  final String stripeCustomerId;
  final String status;
  final String planName;
  final String planId;
  final String planSlug;
  final String planCurrency;
  final String planInterval;
  final List<String> features;

  ActivePlanModel({
    required this.id,
    required this.user,
    required this.stripeSubscriptionId,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
    required this.stripeCustomerId,
    required this.status,
    required this.planName,
    required this.planId,
    required this.planSlug,
    required this.planCurrency,
    required this.planInterval,
    required this.features,
  });

  factory ActivePlanModel.fromJson(Map<String, dynamic> json) {
    return ActivePlanModel(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      stripeSubscriptionId: json['stripeSubscriptionId'] ?? '',
      currentPeriodStart: DateTime.parse(json['currentPeriodStart']),
      currentPeriodEnd: DateTime.parse(json['currentPeriodEnd']),
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] ?? false,
      stripeCustomerId: json['stripeCustomerId'] ?? '',
      status: json['status'] ?? '',
      planName: json['planName'] ?? '',
      planId: json['planId'] ?? '',
      planSlug: json['planSlug'] ?? '',
      planCurrency: json['planCurrency'] ?? '',
      planInterval: json['planInterval'] ?? '',
      features: List<String>.from(json['features'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'stripeSubscriptionId': stripeSubscriptionId,
      'currentPeriodStart': currentPeriodStart.toIso8601String(),
      'currentPeriodEnd': currentPeriodEnd.toIso8601String(),
      'cancelAtPeriodEnd': cancelAtPeriodEnd,
      'stripeCustomerId': stripeCustomerId,
      'status': status,
      'planName': planName,
      'planId': planId,
      'planSlug': planSlug,
      'planCurrency': planCurrency,
      'planInterval': planInterval,
      'features': features,
    };
  }
}