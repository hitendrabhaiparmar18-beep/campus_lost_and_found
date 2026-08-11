import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../view_models/item_provider.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input field
        TextField(
          onChanged: (val) => provider.setSearchQuery(val),
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search items, locations, IDs, descriptions...',
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            suffixIcon: provider.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () => provider.setSearchQuery(''),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),

        // Type Filter Chips (All, Lost, Found, Returned)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTypeChip(
                context,
                label: 'All Items',
                isSelected: provider.typeFilter == null && provider.statusFilter == null,
                color: AppTheme.primaryColor,
                onTap: () {
                  provider.setTypeFilter(null);
                  provider.setStatusFilter(null);
                },
              ),
              const SizedBox(width: 8),
              _buildTypeChip(
                context,
                label: '🔍 Lost Items',
                isSelected: provider.typeFilter == ItemType.lost && provider.statusFilter != ItemStatus.returned,
                color: AppTheme.lostColor,
                onTap: () {
                  provider.setTypeFilter(ItemType.lost);
                  provider.setStatusFilter(ItemStatus.active);
                },
              ),
              const SizedBox(width: 8),
              _buildTypeChip(
                context,
                label: '✨ Found Items',
                isSelected: provider.typeFilter == ItemType.found && provider.statusFilter != ItemStatus.returned,
                color: AppTheme.foundColor,
                onTap: () {
                  provider.setTypeFilter(ItemType.found);
                  provider.setStatusFilter(ItemStatus.active);
                },
              ),
              const SizedBox(width: 8),
              _buildTypeChip(
                context,
                label: '✅ Returned',
                isSelected: provider.statusFilter == ItemStatus.returned,
                color: AppTheme.returnedColor,
                onTap: () {
                  provider.setTypeFilter(null);
                  provider.setStatusFilter(ItemStatus.returned);
                },
              ),
              if (provider.selectedLocationId != null) ...[
                const SizedBox(width: 8),
                Chip(
                  avatar: const Icon(Icons.location_on, size: 16, color: Colors.white),
                  label: Text(
                    provider.getLocationById(provider.selectedLocationId!)?.name ?? 'Location Filter',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: AppTheme.primaryColor,
                  deleteIcon: const Icon(Icons.cancel, size: 16, color: Colors.white),
                  onDeleted: () => provider.setLocationFilter(null),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Category Horizontal Selector
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: MockData.categories.length,
            itemBuilder: (context, index) {
              final cat = MockData.categories[index];
              final isSelected = provider.selectedCategory == cat;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.slate300 : AppColors.slate700),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: isDark ? AppTheme.cardDark : AppColors.slate200,
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : (isDark ? AppTheme.cardBorderDark : AppColors.slate300),
                    ),
                  ),
                  onSelected: (_) => provider.setCategory(cat),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : (isDark ? AppTheme.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : (isDark ? AppTheme.cardBorderDark : AppColors.slate300),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.slate300 : AppColors.slate700),
          ),
        ),
      ),
    );
  }
}
