import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../view_models/item_provider.dart';
import '../widgets/filter_bar.dart';
import '../widgets/item_card.dart';
import '../widgets/stat_chip.dart';
import 'campus_map_screen.dart';
import 'report_item_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = provider.filteredReports;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.find_in_page_rounded,
                color: AppTheme.primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Campus Lost & Found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Centralized Student Portal',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.slate400 : AppColors.slate600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? const Color(0xFFF59E0B) : const Color(0xFF4F46E5),
            ),
            tooltip: 'Toggle Dark/Light Mode',
            onPressed: onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.map_rounded),
            tooltip: 'Campus Map',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CampusMapScreen()),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Statistics Header Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StatChip(
                    label: 'Lost Items',
                    value: '${provider.totalLostCount}',
                    icon: Icons.search_rounded,
                    color: AppTheme.lostColor,
                    onTap: () {
                      provider.setTypeFilter(ItemType.lost);
                      provider.setStatusFilter(ItemStatus.active);
                    },
                  ),
                  const SizedBox(width: 10),
                  StatChip(
                    label: 'Found Items',
                    value: '${provider.totalFoundCount}',
                    icon: Icons.auto_awesome,
                    color: AppTheme.foundColor,
                    onTap: () {
                      provider.setTypeFilter(ItemType.found);
                      provider.setStatusFilter(ItemStatus.active);
                    },
                  ),
                  const SizedBox(width: 10),
                  StatChip(
                    label: 'Returned',
                    value: '${provider.totalReturnedCount}',
                    icon: Icons.verified_rounded,
                    color: AppTheme.returnedColor,
                    onTap: () {
                      provider.setTypeFilter(null);
                      provider.setStatusFilter(ItemStatus.returned);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search & Filter Bar
            const FilterBar(),
            const SizedBox(height: 16),

            // Campus Map Banner Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CampusMapScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                        : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.explore_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore Campus Map Hotspots',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                            ),
                          ),
                          Text(
                            'Identify exact pin locations across library, labs & canteen',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.slate300 : const Color(0xFF4338CA),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Feed Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Item Reports (${filtered.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.slate900,
                  ),
                ),
                if (provider.searchQuery.isNotEmpty ||
                    provider.selectedCategory != 'All' ||
                    provider.typeFilter != null ||
                    provider.statusFilter != null ||
                    provider.selectedLocationId != null)
                  TextButton(
                    onPressed: () => provider.resetFilters(),
                    child: const Text('Clear Filters', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Item List or Empty State
            if (filtered.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: isDark ? AppColors.slate600 : AppColors.slate400,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'No item reports match your search criteria.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.slate300 : AppColors.slate700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try adjusting your category filter, keyword, or campus location.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.slate500 : AppColors.slate500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.resetFilters(),
                      child: const Text('Reset All Filters'),
                    ),
                  ],
                ),
              )
            else
              ...filtered.map((report) => ItemCard(report: report)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showReportChoiceDialog(context),
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text(
          'REPORT ITEM',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
    );
  }

  void _showReportChoiceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What would you like to report?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Select an option below to submit a campus report.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.lostColor),
              ),
              tileColor: AppTheme.lostColor.withValues(alpha: 0.08),
              leading: const CircleAvatar(
                backgroundColor: AppTheme.lostColor,
                child: Icon(Icons.search, color: Colors.white),
              ),
              title: const Text(
                'I Lost Something',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.lostColor),
              ),
              subtitle: const Text('Report a missing personal item to alert campus students'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportItemScreen(initialType: ItemType.lost),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.foundColor),
              ),
              tileColor: AppTheme.foundColor.withValues(alpha: 0.08),
              leading: const CircleAvatar(
                backgroundColor: AppTheme.foundColor,
                child: Icon(Icons.auto_awesome, color: Colors.white),
              ),
              title: const Text(
                'I Found Something',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.foundColor),
              ),
              subtitle: const Text('Report an item you found so the owner can reach you'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportItemScreen(initialType: ItemType.found),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
