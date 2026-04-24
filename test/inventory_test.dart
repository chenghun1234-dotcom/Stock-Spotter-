import 'package:flutter_test/flutter_test.dart';
import 'package:what_to_eat_today/models/inventory_model.dart';

void main() {
  group('InventoryItem Logic Tests', () {
    test('Stock status calculation should be correct', () {
      final highStock = InventoryItem(
        id: '1',
        name: 'Test',
        storeName: 'Store',
        latitude: 0,
        longitude: 0,
        quantity: 15,
        updatedAt: DateTime.now(),
      );

      final lowStock = InventoryItem(
        id: '1',
        name: 'Test',
        storeName: 'Store',
        latitude: 0,
        longitude: 0,
        quantity: 5,
        updatedAt: DateTime.now(),
      );

      final outOfStock = InventoryItem(
        id: '1',
        name: 'Test',
        storeName: 'Store',
        latitude: 0,
        longitude: 0,
        quantity: 0,
        updatedAt: DateTime.now(),
      );

      expect(highStock.status, StockStatus.high);
      expect(lowStock.status, StockStatus.mid);
      expect(outOfStock.status, StockStatus.outOfStock);
    });

    test('Distance calculation should return reasonable values', () {
      final item = InventoryItem(
        id: '1',
        name: 'Test',
        storeName: 'Store',
        latitude: 37.5665, // Seoul
        longitude: 126.9780,
        quantity: 10,
        updatedAt: DateTime.now(),
      );

      // Distance from Seoul to Incheon (~27km)
      item.calculateDistance(37.4563, 126.7052);
      
      expect(item.distance, isNotNull);
      expect(item.distance!, closeTo(27.0, 5.0));
    });
  });
}
