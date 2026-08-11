import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../view_models/item_provider.dart';
import '../widgets/filter_bar.dart';
import '../widgets/item_card.dart';
import 'report_item_screen.dart';

class LostItemsScreen extends StatefulWidget {
  const LostItemsScreen({super.key});

  @override
  State<LostItemsScreen> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  bool _showOnlyRewards = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter to lost items only
    var lostReports = provider.filteredReports
        .where((r) => r.type == ItemType.lost && r.status == ItemStatus.active)
        .toList();

    if (_showOnlyRewards) {
      lostReports = lostReports.where((r) => r.reward != null).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Items Feed'),
        actions: [
          FilterChip(
            avatar: Icon(
              Icons.stars,
              size: 14,
              color: _showOnlyRewards ? Colors.white : const Color(0xFFF59E0B),
            ),
            label: Text(
              'Rewards',
              style: TextStyle(
                fontSize: 12,
                color: _showOnlyRewards ? Colors.white : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            selected: _showOnlyRewards,
            selectedColor: const Color(0xFFF59E0B),
            onSelected: (val) => setState(() => _showOnlyRewards = val),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Banner Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lostColor.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lostColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppTheme.lostColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Missing Personal Belongings',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.slate900,
                        ),
                      ),
                      Text(
                        'Help fellow students recover their lost ID cards, wallets & electronics.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.slate300 : AppColors.slate600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filter bar
          const FilterBar(),
          const SizedBox(height: 16),

          // Count title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Lost Items (${lostReports.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.slate900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (lostReports.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: AppTheme.foundColor,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'No active lost items matching your search!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Try resetting category or keyword filters.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            ...lostReports.map((report) => ItemCard(report: report)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.lostColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ReportItemScreen(initialType: ItemType.lost),
            ),
          );
        },
        icon: const Icon(Icons.add_location_alt_rounded),
        label: const Text(
          'REPORT LOST ITEM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
