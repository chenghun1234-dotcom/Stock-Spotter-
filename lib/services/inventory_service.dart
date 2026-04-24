import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inventory_model.dart';

class InventoryService {
  // Replace this with your actual raw JSON URL (e.g., GitHub Raw URL)
  static const String _dataSourceUrl = 'https://raw.githubusercontent.com/username/repo/main/inventory.json';

  Future<List<InventoryItem>> fetchInventory() async {
    try {
      // In a real scenario, you would fetch from the URL
      // For now, I'll return mock data to demonstrate the flow
      
      // final response = await http.get(Uri.parse(_dataSourceUrl));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   return data.map((json) => InventoryItem.fromJson(json)).toList();
      // }
      
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
      
      return [
        InventoryItem(
          id: '1',
          name: 'Hwang-cheese Chip',
          storeName: 'GS25 Gangnam Star',
          latitude: 37.4979,
          longitude: 127.0276,
          quantity: 25,
          updatedAt: DateTime.now(),
        ),
        InventoryItem(
          id: '2',
          name: 'Yogurt Cookie',
          storeName: 'CU Yeoneok',
          latitude: 37.4985,
          longitude: 127.0280,
          quantity: 5,
          updatedAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        InventoryItem(
          id: '3',
          name: 'Butter Beer',
          storeName: '7-Eleven Central',
          latitude: 37.4960,
          longitude: 127.0260,
          quantity: 0,
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];
    } catch (e) {
      print('Error fetching inventory: $e');
      return [];
    }
  }
}
