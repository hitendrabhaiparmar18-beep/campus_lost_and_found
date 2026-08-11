enum ItemType { lost, found }

enum ItemStatus { active, returned }

class ItemReport {
  final String id;
  final String title;
  final String description;
  final String category;
  final ItemType type;
  final ItemStatus status;
  final DateTime date;
  final String locationId;
  final String locationName;
  final String specificLocation;
  final String reporterName;
  final String reporterPhone;
  final String reporterEmail;
  final String imageUrl;
  final String? reward;
  final DateTime? returnedAt;

  ItemReport({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.status,
    required this.date,
    required this.locationId,
    required this.locationName,
    required this.specificLocation,
    required this.reporterName,
    required this.reporterPhone,
    required this.reporterEmail,
    required this.imageUrl,
    this.reward,
    this.returnedAt,
  });

  ItemReport copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    ItemType? type,
    ItemStatus? status,
    DateTime? date,
    String? locationId,
    String? locationName,
    String? specificLocation,
    String? reporterName,
    String? reporterPhone,
    String? reporterEmail,
    String? imageUrl,
    String? reward,
    DateTime? returnedAt,
  }) {
    return ItemReport(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      specificLocation: specificLocation ?? this.specificLocation,
      reporterName: reporterName ?? this.reporterName,
      reporterPhone: reporterPhone ?? this.reporterPhone,
      reporterEmail: reporterEmail ?? this.reporterEmail,
      imageUrl: imageUrl ?? this.imageUrl,
      reward: reward ?? this.reward,
      returnedAt: returnedAt ?? this.returnedAt,
    );
  }
}
