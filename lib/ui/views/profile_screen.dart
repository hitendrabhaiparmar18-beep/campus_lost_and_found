import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../view_models/item_provider.dart';
import '../widgets/item_card.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const ProfileScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter reports created by Ayush Kumar (or Rohan Sharma sample)
    final myReports = provider.reports.where(
      (r) => r.reporterName.contains('Ayush') || r.reporterName.contains('Rohan'),
    ).toList();

    final myActiveCount = myReports.where((r) => r.status == ItemStatus.active).length;
    final myReturnedCount = myReports.where((r) => r.status == ItemStatus.returned).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile & Activity'),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? const Color(0xFFF59E0B) : const Color(0xFF4F46E5),
            ),
            tooltip: 'Toggle Theme Mode',
            onPressed: onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Digital Student ID Card Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF3730A3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFE0E7FF),
                        child: Text(
                          'AK',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Ayush Kumar',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'VERIFIED',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'B.Tech Computer Science & Engg.',
                            style: TextStyle(fontSize: 12, color: Color(0xFFC7D2FE)),
                          ),
                          const Text(
                            'Reg ID: CS2024-882 • Semester 5',
                            style: TextStyle(fontSize: 11, color: Color(0xFFA5B4FC)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: Color(0xFF6366F1), height: 1),
                const SizedBox(height: 14),

                // Student Contact Info Teaser
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: Color(0xFFC7D2FE)),
                        SizedBox(width: 6),
                        Text(
                          '+91 98765 00000',
                          style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.email, size: 14, color: Color(0xFFC7D2FE)),
                        SizedBox(width: 6),
                        Text(
                          'ayush.cs@college.edu',
                          style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // User Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  context,
                  label: 'My Total Reports',
                  value: '${myReports.length}',
                  icon: Icons.assignment_outlined,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(
                  context,
                  label: 'Active Listings',
                  value: '$myActiveCount',
                  icon: Icons.search_rounded,
                  color: AppTheme.lostColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(
                  context,
                  label: 'Reunited Items',
                  value: '$myReturnedCount',
                  icon: Icons.verified_rounded,
                  color: AppTheme.foundColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Section Title: My Reported Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Reported Belongings (${myReports.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.slate900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (myReports.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppTheme.cardBorderDark : AppColors.slate200,
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'You haven\'t posted any items yet.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap "REPORT ITEM" on the bottom bar to submit a lost or found report.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...myReports.map((report) => ItemCard(report: report)),

          const SizedBox(height: 24),

          // Campus Help & Security Desk Box
          Container(
            padding: const EdgeInsets.all(16),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEF3C7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield_outlined, color: Color(0xFFD97706), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Campus Security Desk',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.slate900,
                            ),
                          ),
                          const Text(
                            'Main Gate Gate 1 • Open 24x7',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
                  label: const Text('Call Campus Security Helpline'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Calling Campus Security Desk (+91 91234 56789)...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.cardBorderDark : AppColors.slate200,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.slate900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.slate400 : AppColors.slate600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
