import 'dart:math' as math;

enum StockStatus { high, mid, low, outOfStock }

class InventoryItem {
  final String id;
  final String name;
  final String storeName;
  final String countryCode;
  final double latitude;
  final double longitude;
  final int quantity;
  final bool isTrend;
  final DateTime updatedAt;
  double? distance;

  InventoryItem({
    required this.id,
    required this.name,
    required this.storeName,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.quantity,
    this.isTrend = false,
    required this.updatedAt,
    this.distance,
  });

  StockStatus get status {
    if (quantity > 10) return StockStatus.high;
    if (quantity > 0) return StockStatus.mid;
    return StockStatus.outOfStock;
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Item',
      storeName: json['store_name'] ?? 'Store',
      countryCode: json['country_code'] ?? 'KR',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      isTrend: json['is_trend'] as bool? ?? false,
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  void calculateDistance(double userLat, double userLon) {
    // Basic Haversine distance calculation
    const double p = 0.017453292519943295;
    final double a = 0.5 -
        math.cos((latitude - userLat) * p) / 2 +
        math.cos(userLat * p) *
            math.cos(latitude * p) *
            (1 - math.cos((longitude - userLon) * p)) /
            2;
    distance = 12742 * math.asin(math.sqrt(a));
  }
}
