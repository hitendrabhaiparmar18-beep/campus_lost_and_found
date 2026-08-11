import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../view_models/item_provider.dart';
import '../widgets/contact_modal.dart';

class ItemDetailScreen extends StatelessWidget {
  final String reportId;

  const ItemDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Find report
    ItemReport? report;
    try {
      report = provider.reports.firstWhere((r) => r.id == reportId);
    } catch (_) {
      report = null;
    }

    if (report == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Item Details')),
        body: const Center(
          child: Text('Report not found or has been deleted.'),
        ),
      );
    }

    final currentReport = report;
    final isReturned = currentReport.status == ItemStatus.returned;
    final isLost = currentReport.type == ItemType.lost;

    Color badgeColor = isReturned
        ? AppTheme.returnedColor
        : (isLost ? AppTheme.lostColor : AppTheme.foundColor);
    String badgeText = isReturned
        ? 'RESOLVED & RETURNED'
        : (isLost ? 'LOST ITEM' : 'FOUND ITEM');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar with Large Image Hero
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    currentReport.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: isDark ? AppTheme.cardDark : AppColors.slate300,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 64,
                        color: isDark ? AppColors.slate600 : AppColors.slate400,
                      ),
                    ),
                  ),
                  // Bottom gradient overlay for readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Badge tag overlay
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: badgeColor.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (val) {
                  if (val == 'delete') {
                    _confirmDelete(context, provider, currentReport);
                  } else if (val == 'returned' && !isReturned) {
                    _confirmMarkReturned(context, provider, currentReport);
                  }
                },
                itemBuilder: (ctx) => [
                  if (!isReturned)
                    const PopupMenuItem(
                      value: 'returned',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: AppTheme.foundColor),
                          SizedBox(width: 10),
                          Text('Mark as Returned'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.redAccent),
                        SizedBox(width: 10),
                        Text('Delete Report'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Details Body Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Date Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.category, size: 14, color: AppTheme.primaryColor),
                        label: Text(
                          currentReport.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.12),
                        side: BorderSide.none,
                      ),
                      Text(
                        DateFormat('EEEE, MMM d • h:mm a').format(currentReport.date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.slate400 : AppColors.slate600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    currentReport.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reward Card (if applicable)
                  if (currentReport.reward != null && !isReturned) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF59E0B)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.stars, color: Color(0xFFF59E0B), size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Reward Offered by Owner!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                                Text(
                                  currentReport.reward!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : AppColors.slate900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Location Info Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.cardDark : AppColors.slate100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppTheme.cardBorderDark : AppColors.slate200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEE2E2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentReport.locationName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.slate900,
                                    ),
                                  ),
                                  Text(
                                    currentReport.specificLocation,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? AppColors.slate400 : AppColors.slate600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description Section
                  Text(
                    'Item Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentReport.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark ? AppColors.slate300 : AppColors.slate700,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reporter Info Tile
                  Text(
                    'Reported By',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppTheme.cardBorderDark : AppColors.slate300,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                          child: Text(
                            currentReport.reporterName.isNotEmpty
                                ? currentReport.reporterName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentReport.reporterName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.slate900,
                                ),
                              ),
                              Text(
                                '${currentReport.reporterPhone} • ${currentReport.reporterEmail}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.slate400 : AppColors.slate600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Primary Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            ContactModal.show(context, currentReport);
                          },
                          icon: const Icon(Icons.connect_without_contact_rounded),
                          label: const Text(
                            'Contact Reporter',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                      if (!isReturned) ...[
                        const SizedBox(width: 12),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme.foundColor.withValues(alpha: 0.2),
                            foregroundColor: AppTheme.foundColor,
                            padding: const EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle_rounded, size: 24),
                          tooltip: 'Mark as Returned',
                          onPressed: () => _confirmMarkReturned(context, provider, currentReport),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmMarkReturned(BuildContext context, ItemProvider provider, ItemReport report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark as Returned?'),
        content: Text('This will mark "${report.title}" as resolved and returned to its owner.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.foundColor),
            onPressed: () {
              provider.markAsReturned(report.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Item status updated to Returned!'),
                  backgroundColor: AppTheme.foundColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Confirm Returned', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ItemProvider provider, ItemReport report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Report?'),
        content: Text('Are you sure you want to permanently delete "${report.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              provider.deleteReport(report.id);
              Navigator.pop(ctx); // close dialog
              Navigator.pop(context); // pop detail screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report deleted successfully.'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
