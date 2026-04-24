import 'dart:async';
import 'package:flutter/material.dart';
import '../models/inventory_model.dart';
import '../utils/style_constants.dart';
import '../services/inventory_service.dart';

class InventoryFeedScreen extends StatefulWidget {
  const InventoryFeedScreen({super.key});

  @override
  State<InventoryFeedScreen> createState() => _InventoryFeedScreenState();
}

class _InventoryFeedScreenState extends State<InventoryFeedScreen> {
  final InventoryService _service = InventoryService();
  List<InventoryItem> _items = [];
  List<InventoryItem> _filteredItems = [];
  bool _isLoading = true;
  String _searchQuery = "";
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _fetchInventory();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchInventory() async {
    final newItems = await _service.fetchInventory();
    if (mounted) {
      setState(() {
        _items = newItems;
        _applyFilter(_searchQuery);
        _isLoading = false;
      });
    }
  }

  void _applyFilter(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredItems = _items;
      } else {
        _filteredItems = _items.where((item) =>
            item.name.toLowerCase().contains(query.toLowerCase()) ||
            item.storeName.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  void _startPolling() {
    // Poll for updates every 60 seconds (Zero Cost alternative to WebSockets)
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _fetchInventory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildSearchBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: _isLoading
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _InventoryCard(
                        item: _filteredItems[index],
                        onReport: (type) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Reported as $type! Updating community data...')),
                          );
                        },
                      ),
                      childCount: _filteredItems.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          decoration: AppStyles.glassDecoration.copyWith(
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            onChanged: _applyFilter,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search stores or items (e.g. GS25, Cheese)',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        centerTitle: false,
        title: Text('Food Feed', style: AppStyles.heading.copyWith(fontSize: 22)),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.2), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 40,
                child: Icon(Icons.notifications_active, size: 120, color: Colors.white.withOpacity(0.05)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final Function(String) onReport;

  const _InventoryCard({required this.item, required this.onReport});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    bool isTrend = item.name.contains('Hwang-cheese'); // Context-aware trend logic

    switch (item.status) {
      case StockStatus.high:
        statusColor = AppColors.stockHigh;
        statusText = 'In Stock';
        break;
      case StockStatus.mid:
        statusColor = AppColors.stockMid;
        statusText = 'Low Stock';
        break;
      case StockStatus.outOfStock:
        statusColor = AppColors.stockLow;
        statusText = 'Sold Out';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppStyles.glassDecoration,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(item.name, style: AppStyles.subHeading),
                          if (isTrend) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.orange.withOpacity(0.5)),
                              ),
                              child: const Text('🔥 TREND', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(item.storeName, style: AppStyles.body),
                      const SizedBox(height: 12),
                      Text(
                        '$statusText (${item.quantity})',
                        style: AppStyles.body.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(_formatTime(item.updatedAt), style: AppStyles.body.copyWith(fontSize: 12)),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => onReport('In Stock'),
                  icon: const Icon(Icons.check_circle_outline, size: 16, color: AppColors.stockHigh),
                  label: const Text('Here!', style: TextStyle(color: Colors.white70)),
                ),
              ),
              const VerticalDivider(color: Colors.white10, width: 1),
              Expanded(
                child: TextButton.icon(
                  onPressed: () => onReport('Sold Out'),
                  icon: const Icon(Icons.highlight_off, size: 16, color: AppColors.stockLow),
                  label: const Text('Sold Out', style: TextStyle(color: Colors.white70)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    return '${diff.inHours}h';
  }
}
