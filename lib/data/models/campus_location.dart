class CampusLocation {
  final String id;
  final String name;
  final String code;
  final String description;
  final double dx; // 0.0 to 1.0 relative horizontal offset on map canvas
  final double dy; // 0.0 to 1.0 relative vertical offset on map canvas
  final String iconName;

  const CampusLocation({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.dx,
    required this.dy,
    this.iconName = 'location_on',
  });
}
