class Issue {
  String id;
  String title;
  String description;
  String category;
  String status; // open, in_progress, resolved
  double lat;
  double lng;
  List<String> images;
  String reporterId;
  int upvotes;
  DateTime createdAt;
  int priority;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    this.category = 'Other',
    this.status = 'open',
    this.lat = 0.0,
    this.lng = 0.0,
    this.images = const [],
    this.reporterId = 'anonymous',
    this.upvotes = 0,
    DateTime? createdAt,
    this.priority = 1,
  }) : createdAt = createdAt ?? DateTime.now();
}
