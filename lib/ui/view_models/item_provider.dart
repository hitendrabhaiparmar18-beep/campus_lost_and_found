import 'dart:collection';
import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../data/models/campus_location.dart';
import '../../data/models/item_report.dart';

class ItemProvider extends ChangeNotifier {
  final List<ItemReport> _reports = List.from(MockData.initialReports);
  final List<CampusLocation> _locations = MockData.campusLocations;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  ItemType? _typeFilter;
  ItemStatus? _statusFilter;
  String? _selectedLocationId;

  // Getters
  List<ItemReport> get reports => UnmodifiableListView(_reports);
  List<CampusLocation> get locations => UnmodifiableListView(_locations);
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  ItemType? get typeFilter => _typeFilter;
  ItemStatus? get statusFilter => _statusFilter;
  String? get selectedLocationId => _selectedLocationId;

  // Counters
  int get totalLostCount =>
      _reports.where((r) => r.type == ItemType.lost && r.status == ItemStatus.active).length;

  int get totalFoundCount =>
      _reports.where((r) => r.type == ItemType.found && r.status == ItemStatus.active).length;

  int get totalReturnedCount =>
      _reports.where((r) => r.status == ItemStatus.returned).length;

  int get totalActiveCount =>
      _reports.where((r) => r.status == ItemStatus.active).length;

  // Filtered List
  List<ItemReport> get filteredReports {
    return _reports.where((item) {
      // 1. Search Query filter (matches title, description, category, location, reporter)
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesQuery = item.title.toLowerCase().contains(q) ||
            item.description.toLowerCase().contains(q) ||
            item.category.toLowerCase().contains(q) ||
            item.locationName.toLowerCase().contains(q) ||
            item.specificLocation.toLowerCase().contains(q) ||
            item.reporterName.toLowerCase().contains(q);
        if (!matchesQuery) return false;
      }

      // 2. Category filter
      if (_selectedCategory != 'All' && item.category != _selectedCategory) {
        return false;
      }

      // 3. Item Type filter (Lost / Found)
      if (_typeFilter != null && item.type != _typeFilter) {
        return false;
      }

      // 4. Status filter (Active / Returned)
      if (_statusFilter != null && item.status != _statusFilter) {
        return false;
      }

      // 5. Location filter
      if (_selectedLocationId != null && item.locationId != _selectedLocationId) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first
  }

  // Action methods
  void addReport(ItemReport report) {
    _reports.insert(0, report);
    notifyListeners();
  }

  void markAsReturned(String id) {
    final index = _reports.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(
        status: ItemStatus.returned,
        returnedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void deleteReport(String id) {
    _reports.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setTypeFilter(ItemType? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void setStatusFilter(ItemStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setLocationFilter(String? locationId) {
    _selectedLocationId = locationId;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _typeFilter = null;
    _statusFilter = null;
    _selectedLocationId = null;
    notifyListeners();
  }

  CampusLocation? getLocationById(String id) {
    try {
      return _locations.firstWhere((loc) => loc.id == id);
    } catch (_) {
      return null;
    }
  }
}
