import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../views/item_detail_screen.dart';

class ItemCard extends StatelessWidget {
  final ItemReport report;

  const ItemCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReturned = report.status == ItemStatus.returned;
    final isLost = report.type == ItemType.lost;

    Color badgeColor;
    String badgeText;
    if (isReturned) {
      badgeColor = AppTheme.returnedColor;
      badgeText = 'RETURNED';
    } else if (isLost) {
      badgeColor = AppTheme.lostColor;
      badgeText = 'LOST';
    } else {
      badgeColor = AppTheme.foundColor;
      badgeText = 'FOUND';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ItemDetailScreen(reportId: report.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Thumbnail with Badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      report.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 90,
                          height: 90,
                          color: isDark ? AppColors.slate700 : AppColors.slate200,
                          child: Icon(
                            _getCategoryIcon(report.category),
                            size: 36,
                            color: AppTheme.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Content Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Time Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            report.category,
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          _formatTimeAgo(report.date),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.slate400 : AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title
                    Text(
                      report.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.slate900,
                        decoration: isReturned ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Location Pin
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${report.locationName} (${report.specificLocation})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.slate400 : AppColors.slate600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Reward badge or Reporter Info
                    if (report.reward != null && !isReturned)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFF59E0B), width: 0.8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.card_giftcard, size: 12, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 4),
                            Text(
                              'Reward: ${report.reward}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        'Reported by ${report.reporterName}',
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: isDark ? AppColors.slate500 : AppColors.slate500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'id card':
        return Icons.badge_outlined;
      case 'electronics':
        return Icons.devices_other;
      case 'books':
        return Icons.menu_book;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      case 'bag':
        return Icons.backpack_outlined;
      case 'bottle':
        return Icons.water_drop_outlined;
      case 'keys':
        return Icons.vpn_key_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
