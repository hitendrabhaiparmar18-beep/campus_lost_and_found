import 'models/campus_location.dart';
import 'models/item_report.dart';

class MockData {
  static const List<CampusLocation> campusLocations = [
    CampusLocation(
      id: 'loc_lib',
      name: 'Central Library',
      code: 'LIB',
      description: 'Main 3-story library building & quiet study zone',
      dx: 0.28,
      dy: 0.35,
    ),
    CampusLocation(
      id: 'loc_caf',
      name: 'Student Cafeteria',
      code: 'CAF',
      description: 'Central dining hall & outdoor food court',
      dx: 0.52,
      dy: 0.48,
    ),
    CampusLocation(
      id: 'loc_tech',
      name: 'Science & Tech Block',
      code: 'STB',
      description: 'Physics, Chemistry & Computer Science labs',
      dx: 0.72,
      dy: 0.25,
    ),
    CampusLocation(
      id: 'loc_eng',
      name: 'Engineering Block',
      code: 'ENG',
      description: 'Civil, Mechanical & Electrical lecture halls',
      dx: 0.38,
      dy: 0.68,
    ),
    CampusLocation(
      id: 'loc_sports',
      name: 'Sports Complex',
      code: 'SPT',
      description: 'Basketball court, gymnasium & football ground',
      dx: 0.82,
      dy: 0.75,
    ),
    CampusLocation(
      id: 'loc_gate',
      name: 'Main Gate Security Desk',
      code: 'SEC',
      description: 'Campus entrance security kiosk and visitor center',
      dx: 0.15,
      dy: 0.85,
    ),
    CampusLocation(
      id: 'loc_audit',
      name: 'Grand Auditorium',
      code: 'AUD',
      description: 'Main event hall and cultural center',
      dx: 0.65,
      dy: 0.60,
    ),
  ];

  static List<ItemReport> initialReports = [
    ItemReport(
      id: 'rep_101',
      title: 'Student ID Card - Rohan Sharma',
      description:
          'Blue lanyard with Computer Science Dept ID card (Reg: CS2024-882). Left near computer workstation #14.',
      category: 'ID Card',
      type: ItemType.lost,
      status: ItemStatus.active,
      date: DateTime.now().subtract(const Duration(hours: 3)),
      locationId: 'loc_tech',
      locationName: 'Science & Tech Block',
      specificLocation: 'Lab 3, 2nd Floor, Workstation 14',
      reporterName: 'Rohan Sharma',
      reporterPhone: '+91 98765 43210',
      reporterEmail: 'rohan.cs24@college.edu',
      imageUrl:
          'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600&auto=format&fit=crop&q=80',
      reward: 'Free Coffee @ Canteen!',
    ),
    ItemReport(
      id: 'rep_102',
      title: 'Sony Wireless Headphones (Black)',
      description:
          'Found Sony WH-1000XM4 noise cancelling headphones in a black carrying case on a desk in reading room 2.',
      category: 'Electronics',
      type: ItemType.found,
      status: ItemStatus.active,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      locationId: 'loc_lib',
      locationName: 'Central Library',
      specificLocation: 'Reading Room 2, Desk near East Window',
      reporterName: 'Priya Verma (Library Volunteer)',
      reporterPhone: '+91 98123 45678',
      reporterEmail: 'pverma.lib@college.edu',
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
    ),
    ItemReport(
      id: 'rep_103',
      title: 'Leather Wallet with Driving License',
      description:
          'Brown Timberland leather wallet containing student ID, DL, and metro card. Crucial to recover!',
      category: 'Wallet',
      type: ItemType.lost,
      status: ItemStatus.active,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      locationId: 'loc_caf',
      locationName: 'Student Cafeteria',
      specificLocation: 'Juice counter seating table #5',
      reporterName: 'Aman Deep',
      reporterPhone: '+91 99887 76655',
      reporterEmail: 'aman.d@college.edu',
      imageUrl:
          'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600&auto=format&fit=crop&q=80',
    ),
    ItemReport(
      id: 'rep_104',
      title: 'Steel Hydro Water Bottle (Navy Blue)',
      description:
          'Milton stainless steel insulated bottle with custom stickers (NASA & GitHub logos). Left near bench.',
      category: 'Bottle',
      type: ItemType.found,
      status: ItemStatus.active,
      date: DateTime.now().subtract(const Duration(hours: 12)),
      locationId: 'loc_sports',
      locationName: 'Sports Complex',
      specificLocation: 'Basketball Bleachers, Row 3',
      reporterName: 'Coach Vikram Singh',
      reporterPhone: '+91 97112 23344',
      reporterEmail: 'sports@college.edu',
      imageUrl:
          'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&auto=format&fit=crop&q=80',
    ),
    ItemReport(
      id: 'rep_105',
      title: 'Engineering Mathematics Textbook (Kreyszig)',
      description:
          'Hardcover Advanced Engineering Mathematics 10th Ed. Has handwritten notes on page 140.',
      category: 'Books',
      type: ItemType.found,
      status: ItemStatus.returned,
      date: DateTime.now().subtract(const Duration(days: 2)),
      locationId: 'loc_eng',
      locationName: 'Engineering Block',
      specificLocation: 'Room E-201, Front Row Desk',
      reporterName: 'Prof. Alok Gupta',
      reporterPhone: '+91 98450 12345',
      reporterEmail: 'agupta.eng@college.edu',
      imageUrl:
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop&q=80',
      returnedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    ItemReport(
      id: 'rep_106',
      title: 'Black HP Laptop Backpack',
      description:
          'Contains notebooks, charger, and a blue pencil pouch. Handed over to Security Desk at Main Gate.',
      category: 'Bag',
      type: ItemType.found,
      status: ItemStatus.active,
      date: DateTime.now().subtract(const Duration(hours: 1)),
      locationId: 'loc_gate',
      locationName: 'Main Gate Security Desk',
      specificLocation: 'Lost & Found Storage Box A',
      reporterName: 'Security Officer Ramesh',
      reporterPhone: '+91 91234 56789',
      reporterEmail: 'security.gate1@college.edu',
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&auto=format&fit=crop&q=80',
    ),
  ];

  static const List<String> categories = [
    'All',
    'ID Card',
    'Electronics',
    'Books',
    'Wallet',
    'Bag',
    'Bottle',
    'Keys',
    'Other',
  ];
}
