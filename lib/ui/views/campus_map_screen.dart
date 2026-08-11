import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../view_models/item_provider.dart';
import '../widgets/campus_map_widget.dart';
import 'item_detail_screen.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  String? _selectedLocationId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedLoc = _selectedLocationId != null
        ? provider.getLocationById(_selectedLocationId!)
        : null;

    final itemsAtSelectedLoc = _selectedLocationId != null
        ? provider.reports.where((r) => r.locationId == _selectedLocationId).toList()
        : <ItemReport>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Locations & Map'),
        actions: [
          if (_selectedLocationId != null)
            TextButton(
              onPressed: () => setState(() => _selectedLocationId = null),
              child: const Text('Show All', style: TextStyle(color: AppTheme.primaryColor)),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Visual Campus Map Canvas Widget
          CampusMapWidget(
            selectedLocationId: _selectedLocationId,
            onLocationSelected: (loc) {
              setState(() {
                if (_selectedLocationId == loc.id) {
                  _selectedLocationId = null;
                } else {
                  _selectedLocationId = loc.id;
                }
              });
            },
          ),
          const SizedBox(height: 20),

          // Location Details Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedLoc != null ? selectedLoc.name : 'All Campus Hotspots',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.slate900,
                ),
              ),
              Text(
                '${provider.locations.length} Locations',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.slate400 : AppColors.slate600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Items at selected location OR list of all location cards
          if (selectedLoc != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppTheme.cardBorderDark : AppColors.slate300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedLoc.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.slate300 : AppColors.slate700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Active Reports Here (${itemsAtSelectedLoc.length}):',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (itemsAtSelectedLoc.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('No active reports for this location right now.'),
                    )
                  else
                    ...itemsAtSelectedLoc.map((report) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: report.type == ItemType.lost
                                ? AppTheme.lostColor.withValues(alpha: 0.2)
                                : AppTheme.foundColor.withValues(alpha: 0.2),
                            child: Icon(
                              report.type == ItemType.lost ? Icons.search : Icons.auto_awesome,
                              color: report.type == ItemType.lost
                                  ? AppTheme.lostColor
                                  : AppTheme.foundColor,
                              size: 18,
                            ),
                          ),
                          title: Text(
                            report.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Text(
                            '${report.specificLocation} • Reported by ${report.reporterName}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: const Icon(Icons.chevron_right, size: 18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ItemDetailScreen(reportId: report.id),
                              ),
                            );
                          },
                        )),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Grid of Campus Locations
          ...provider.locations.map((loc) {
            final locReports = provider.reports
                .where((r) => r.locationId == loc.id && r.status == ItemStatus.active)
                .toList();
            final isSelected = _selectedLocationId == loc.id;

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: isSelected
                  ? AppTheme.primaryColor.withValues(alpha: isDark ? 0.3 : 0.1)
                  : (isDark ? AppTheme.cardDark : Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : (isDark ? AppTheme.cardBorderDark : AppColors.slate200),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on_rounded, color: AppTheme.primaryColor),
                ),
                title: Text(
                  loc.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text(
                  loc.description,
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: locReports.isNotEmpty
                        ? AppTheme.lostColor.withValues(alpha: 0.15)
                        : (isDark ? AppColors.slate800 : AppColors.slate200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${locReports.length} Items',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: locReports.isNotEmpty
                          ? AppTheme.lostColor
                          : (isDark ? AppColors.slate400 : AppColors.slate600),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedLocationId = isSelected ? null : loc.id;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
