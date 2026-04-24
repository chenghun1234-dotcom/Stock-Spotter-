import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inventory_model.dart';

class InventoryService {
  // Replace this with your actual raw JSON URL (e.g., GitHub Raw URL)
  static const String _dataSourceUrl = 'https://raw.githubusercontent.com/username/repo/main/inventory.json';

  Future<List<InventoryItem>> fetchInventory() async {
    try {
      // In production, this would be your GitHub Raw URL or relative path
      // For GitHub Pages, use: 'inventory.json' (relative)
      final response = await http.get(Uri.parse('inventory.json')).timeout(const Duration(seconds: 3));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => InventoryItem.fromJson(json)).toList();
      }
    } catch (e) {
      print('Network fetch failed, using fallback mock data: $e');
    }
    
    // Fallback Mock Data
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockData();
  }

  List<InventoryItem> _getMockData() {
    return [
      InventoryItem(
        id: '1',
        name: 'Hwang-cheese Chip',
        storeName: 'GS25 Gangnam Star',
        countryCode: 'KR',
        latitude: 37.4979,
        longitude: 127.0276,
        quantity: 25,
        isTrend: true,
        updatedAt: DateTime.now(),
      ),
      InventoryItem(
        id: '2',
        name: 'Yogurt Cookie',
        storeName: 'CU Yeoneok',
        countryCode: 'KR',
        latitude: 37.4985,
        longitude: 127.0280,
        quantity: 5,
        isTrend: false,
        updatedAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      InventoryItem(
        id: '3',
        name: 'Butter Beer',
        storeName: '7-Eleven Central',
        countryCode: 'KR',
        latitude: 37.4960,
        longitude: 127.0260,
        quantity: 0,
        isTrend: false,
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }
}
