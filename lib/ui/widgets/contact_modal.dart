import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';

class ContactModal extends StatelessWidget {
  final ItemReport report;

  const ContactModal({super.key, required this.report});

  static void show(BuildContext context, ItemReport report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ContactModal(report: report),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.slate600 : AppColors.slate300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Title & Avatar Header
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                child: Text(
                  report.reporterName.isNotEmpty ? report.reporterName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact ${report.reporterName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.slate900,
                      ),
                    ),
                    Text(
                      'Reporter of "${report.title}"',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.slate400 : AppColors.slate600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Action Tiles
          _buildActionTile(
            context,
            icon: Icons.phone,
            color: Colors.green,
            title: 'Call Reporter',
            subtitle: report.reporterPhone,
            onTap: () async {
              final uri = Uri.parse('tel:${report.reporterPhone}');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                if (context.mounted) {
                  _showToast(context, 'Calling ${report.reporterPhone}');
                }
              }
            },
          ),
          const SizedBox(height: 12),

          _buildActionTile(
            context,
            icon: Icons.email_rounded,
            color: Colors.blue,
            title: 'Send Email',
            subtitle: report.reporterEmail,
            onTap: () async {
              final uri = Uri.parse(
                'mailto:${report.reporterEmail}?subject=Regarding Lost/Found Item: ${report.title}',
              );
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                if (context.mounted) {
                  _showToast(context, 'Emailing ${report.reporterEmail}');
                }
              }
            },
          ),
          const SizedBox(height: 12),

          _buildActionTile(
            context,
            icon: Icons.chat_rounded,
            color: const Color(0xFF25D366), // WhatsApp green
            title: 'Instant Campus Chat / WhatsApp',
            subtitle: 'Direct message regarding location & pickup',
            onTap: () {
              Navigator.pop(context);
              _showChatDialog(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate900 : AppColors.slate100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppTheme.cardBorderDark : AppColors.slate200,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.slate900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.slate400 : AppColors.slate600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.slate500 : AppColors.slate400,
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showChatDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Message ${report.reporterName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Item: "${report.title}"',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Type your message (e.g. "Hi, I think this is my item...")',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.send_rounded, size: 16),
            label: const Text('Send Message'),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Message sent to ${report.reporterName}!'),
                  backgroundColor: AppTheme.foundColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
