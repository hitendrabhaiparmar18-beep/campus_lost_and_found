import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../view_models/item_provider.dart';
import '../widgets/filter_bar.dart';
import '../widgets/item_card.dart';
import 'report_item_screen.dart';

class FoundItemsScreen extends StatelessWidget {
  const FoundItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter to found items only
    final foundReports = provider.filteredReports
        .where((r) => r.type == ItemType.found && r.status == ItemStatus.active)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Items & Handovers'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Banner Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.foundColor.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.foundColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppTheme.foundColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items Waiting for Owners',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.slate900,
                        ),
                      ),
                      Text(
                        'Found items handed over to Security, Admin, or Student Finder.',
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
                'Active Found Items (${foundReports.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.slate900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (foundReports.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: isDark ? AppColors.slate600 : AppColors.slate400,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'No found items reported right now.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Did you find something on campus? Report it to help out!',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            ...foundReports.map((report) => ItemCard(report: report)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.foundColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ReportItemScreen(initialType: ItemType.found),
            ),
          );
        },
        icon: const Icon(Icons.add_task_rounded),
        label: const Text(
          'REPORT FOUND ITEM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
