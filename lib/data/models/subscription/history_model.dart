class HistoryModel {
  final String id;
  final String subscriberId;
  final String subscriberName;
  final String subscriberEmail;
  final String stripeCustomerId;
  final String stripeSubscriptionId;
  final String stripePriceId;
  final String status;
  final String eventType;
  final String planId;
  final String planName;
  final String planSlug;
  final int planPrice;
  final String planInterval;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final DateTime createdAt;

  HistoryModel({
    required this.id,
    required this.subscriberId,
    required this.subscriberName,
    required this.subscriberEmail,
    required this.stripeCustomerId,
    required this.stripeSubscriptionId,
    required this.stripePriceId,
    required this.status,
    required this.eventType,
    required this.planId,
    required this.planName,
    required this.planSlug,
    required this.planPrice,
    required this.planInterval,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.createdAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['_id'] ?? '',
      subscriberId: json['subscriberId'] ?? '',
      subscriberName: json['subscriberName'] ?? '',
      subscriberEmail: json['subscriberEmail'] ?? '',
      stripeCustomerId: json['stripeCustomerId'] ?? '',
      stripeSubscriptionId: json['stripeSubscriptionId'] ?? '',
      stripePriceId: json['stripePriceId'] ?? '',
      status: json['status'] ?? '',
      eventType: json['eventType'] ?? '',
      planId: json['planId'] ?? '',
      planName: json['planName'] ?? '',
      planSlug: json['planSlug'] ?? '',
      planPrice: json['planPrice']?.toInt() ?? 0,
      planInterval: json['planInterval'] ?? '',
      currentPeriodStart: DateTime.parse(json['currentPeriodStart']),
      currentPeriodEnd: DateTime.parse(json['currentPeriodEnd']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'subscriberId': subscriberId,
      'subscriberName': subscriberName,
      'subscriberEmail': subscriberEmail,
      'stripeCustomerId': stripeCustomerId,
      'stripeSubscriptionId': stripeSubscriptionId,
      'stripePriceId': stripePriceId,
      'status': status,
      'eventType': eventType,
      'planId': planId,
      'planName': planName,
      'planSlug': planSlug,
      'planPrice': planPrice,
      'planInterval': planInterval,
      'currentPeriodStart': currentPeriodStart.toIso8601String(),
      'currentPeriodEnd': currentPeriodEnd.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}