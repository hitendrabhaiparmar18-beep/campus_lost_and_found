import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/campus_location.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../view_models/item_provider.dart';

class CampusMapWidget extends StatelessWidget {
  final ValueChanged<CampusLocation>? onLocationSelected;
  final String? selectedLocationId;

  const CampusMapWidget({
    super.key,
    this.onLocationSelected,
    this.selectedLocationId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: 1.4,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF020617) : AppColors.slate200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppTheme.cardBorderDark : AppColors.slate300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              blurRadius: 10,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Stack(
              children: [
                // Background Styled Campus Map Canvas Grid & Pathways
                CustomPaint(
                  size: Size(width, height),
                  painter: CampusMapPainter(isDark: isDark),
                ),

                // Map Header Overlay
                Positioned(
                  top: 12,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isDark ? AppTheme.cardDark : Colors.white).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppTheme.cardBorderDark : AppColors.slate300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.map_outlined, size: 14, color: AppTheme.primaryColor),
                        const SizedBox(width: 6),
                        Text(
                          'Interactive Campus Map',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.slate800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Location Pins
                ...provider.locations.map((location) {
                  final itemsAtLocation = provider.reports.where(
                    (r) => r.locationId == location.id && r.status == ItemStatus.active,
                  );
                  final lostCount = itemsAtLocation.where((r) => r.type == ItemType.lost).length;
                  final foundCount = itemsAtLocation.where((r) => r.type == ItemType.found).length;
                  final isSelected = selectedLocationId == location.id ||
                      provider.selectedLocationId == location.id;

                  final leftPos = location.dx * width;
                  final topPos = location.dy * height;

                  return Positioned(
                    left: leftPos - 20,
                    top: topPos - 36,
                    child: GestureDetector(
                      onTap: () {
                        if (onLocationSelected != null) {
                          onLocationSelected!(location);
                        } else {
                          if (provider.selectedLocationId == location.id) {
                            provider.setLocationFilter(null);
                          } else {
                            provider.setLocationFilter(location.id);
                          }
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Pin Badge
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : (isDark ? AppTheme.cardDark : Colors.white),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : (lostCount > 0
                                        ? AppTheme.lostColor
                                        : (foundCount > 0
                                            ? AppTheme.foundColor
                                            : AppTheme.primaryColor)),
                                width: isSelected ? 2.5 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: isSelected ? 8 : 4,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  location.code,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? Colors.white : AppColors.slate900),
                                  ),
                                ),
                                if (itemsAtLocation.isNotEmpty) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: lostCount > 0
                                          ? AppTheme.lostColor
                                          : AppTheme.foundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${itemsAtLocation.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Icon(
                            Icons.location_on,
                            size: isSelected ? 24 : 18,
                            color: isSelected
                                ? AppTheme.primaryColor
                                : (lostCount > 0
                                    ? AppTheme.lostColor
                                    : (foundCount > 0
                                        ? AppTheme.foundColor
                                        : AppTheme.primaryColor)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CampusMapPainter extends CustomPainter {
  final bool isDark;

  CampusMapPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = isDark ? AppColors.slate800 : AppColors.slate300
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final greenPaint = Paint()
      ..color = (isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7)).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final buildingPaint = Paint()
      ..color = (isDark ? AppColors.slate700 : Colors.white).withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    // Green campus zones
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, size.height * 0.1, size.width * 0.35, size.height * 0.35),
        const Radius.circular(16),
      ),
      greenPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.5, size.width * 0.38, size.height * 0.4),
        const Radius.circular(16),
      ),
      greenPaint,
    );

    // Main Campus Road paths
    final path = Path()
      ..moveTo(size.width * 0.05, size.height * 0.85)
      ..lineTo(size.width * 0.4, size.height * 0.68)
      ..lineTo(size.width * 0.4, size.height * 0.35)
      ..lineTo(size.width * 0.8, size.height * 0.25)
      ..moveTo(size.width * 0.4, size.height * 0.48)
      ..lineTo(size.width * 0.85, size.height * 0.48);

    canvas.drawPath(path, roadPaint);

    // Building Blocks visuals
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.22, size.height * 0.28, 60, 38),
        const Radius.circular(8),
      ),
      buildingPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.66, size.height * 0.18, 65, 42),
        const Radius.circular(8),
      ),
      buildingPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.32, size.height * 0.62, 70, 45),
        const Radius.circular(8),
      ),
      buildingPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
