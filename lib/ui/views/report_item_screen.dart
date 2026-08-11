import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_report.dart';
import '../theme/app_theme.dart';
import '../view_models/item_provider.dart';

class ReportItemScreen extends StatefulWidget {
  final ItemType initialType;

  const ReportItemScreen({super.key, this.initialType = ItemType.lost});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _formKey = GlobalKey<FormState>();

  late ItemType _reportType;
  late String _selectedCategory;
  late String _selectedLocationId;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _specificLocationController = TextEditingController();
  final _reporterNameController = TextEditingController();
  final _reporterPhoneController = TextEditingController();
  final _reporterEmailController = TextEditingController();
  final _rewardController = TextEditingController();

  // Preset sample image URLs
  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop&q=80',
  ];
  late String _selectedImageUrl;

  @override
  void initState() {
    super.initState();
    _reportType = widget.initialType;
    _selectedCategory = 'ID Card';
    _selectedLocationId = 'loc_lib';
    _selectedImageUrl = _sampleImages[0];
    _reporterNameController.text = 'Ayush Kumar';
    _reporterPhoneController.text = '+91 98765 00000';
    _reporterEmailController.text = 'ayush.student@college.edu';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _specificLocationController.dispose();
    _reporterNameController.dispose();
    _reporterPhoneController.dispose();
    _reporterEmailController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _reportType == ItemType.lost ? 'Report Lost Item' : 'Report Found Item',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Segmented Switch (LOST vs FOUND)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : AppColors.slate200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _reportType = ItemType.lost),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _reportType == ItemType.lost
                              ? AppTheme.lostColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '🔍 I LOST AN ITEM',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _reportType == ItemType.lost
                                  ? Colors.white
                                  : (isDark ? AppColors.slate400 : AppColors.slate600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _reportType = ItemType.found),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _reportType == ItemType.found
                              ? AppTheme.foundColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '✨ I FOUND AN ITEM',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _reportType == ItemType.found
                                  ? Colors.white
                                  : (isDark ? AppColors.slate400 : AppColors.slate600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Item Title Input
            _buildSectionHeader('Item Title'),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'e.g. Student ID Card, Blue Water Bottle, Black Earbuds',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter item title' : null,
            ),
            const SizedBox(height: 20),

            // Category & Location Row
            Row(
              children: [
                // Category Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Category'),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        items: ['ID Card', 'Electronics', 'Books', 'Wallet', 'Bag', 'Bottle', 'Keys', 'Other']
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedCategory = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Campus Location Dropdown
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Campus Location'),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedLocationId,
                        isExpanded: true,
                        items: provider.locations
                            .map((l) => DropdownMenuItem(
                                  value: l.id,
                                  child: Text(l.name, overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedLocationId = val!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Specific Sub-location input
            _buildSectionHeader('Specific Spot / Room Details'),
            TextFormField(
              controller: _specificLocationController,
              decoration: const InputDecoration(
                hintText: 'e.g. 2nd Floor Lab 3, Table #4 near window, Security Kiosk',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please specify exact location' : null,
            ),
            const SizedBox(height: 20),

            // Description Textarea
            _buildSectionHeader('Item Description & Distinguishing Marks'),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Provide details like color, brand, stickers, lanyard text, or contents...',
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please add a brief description' : null,
            ),
            const SizedBox(height: 20),

            // Reward Offered (Optional for lost items)
            if (_reportType == ItemType.lost) ...[
              _buildSectionHeader('Reward Offered (Optional)'),
              TextFormField(
                controller: _rewardController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Free Coffee, Treat, Eternal Gratitude!',
                  prefixIcon: Icon(Icons.stars, color: Color(0xFFF59E0B)),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Photo Selection Preview
            _buildSectionHeader('Select Item Photo'),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _sampleImages.length,
                itemBuilder: (context, idx) {
                  final url = _sampleImages[idx];
                  final isSelected = _selectedImageUrl == url;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedImageUrl = url),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.network(url, width: 80, height: 80, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Reporter Contact Details Card
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
                  _buildSectionHeader('Your Contact Details (Reporter)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reporterNameController,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _reporterPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined, size: 20),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter phone number' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _reporterEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'College Email ID',
                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter email address' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _reportType == ItemType.lost ? AppTheme.lostColor : AppTheme.foundColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              onPressed: () => _submitForm(provider),
              child: Text(
                _reportType == ItemType.lost ? 'POST LOST REPORT' : 'POST FOUND REPORT',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _submitForm(ItemProvider provider) {
    if (_formKey.currentState!.validate()) {
      final location = provider.getLocationById(_selectedLocationId)!;

      final newReport = ItemReport(
        id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        type: _reportType,
        status: ItemStatus.active,
        date: DateTime.now(),
        locationId: location.id,
        locationName: location.name,
        specificLocation: _specificLocationController.text.trim(),
        reporterName: _reporterNameController.text.trim(),
        reporterPhone: _reporterPhoneController.text.trim(),
        reporterEmail: _reporterEmailController.text.trim(),
        imageUrl: _selectedImageUrl,
        reward: _rewardController.text.trim().isNotEmpty ? _rewardController.text.trim() : null,
      );

      provider.addReport(newReport);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _reportType == ItemType.lost
                ? '🎉 Lost Item Report Published! Hope you find it soon.'
                : '🎉 Found Item Report Published! Thanks for helping out.',
          ),
          backgroundColor:
              _reportType == ItemType.lost ? AppTheme.lostColor : AppTheme.foundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
