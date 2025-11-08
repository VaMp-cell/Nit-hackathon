        import 'dart:async';
        import 'package:uuid/uuid.dart';
        import '../models/issue_model.dart';

        class MockService {
  static final MockService _instance = MockService._internal();
  factory MockService() => _instance;
  MockService._internal() {
    // seed with some issues
    _issues.addAll([
      Issue(id: Uuid().v4(), title: 'Pothole on Main St', description: 'Large pothole near the bus stop', category: 'Road', lat: 28.6, lng: 77.2, priority: 8),
      Issue(id: Uuid().v4(), title: 'Broken streetlight', description: 'Streetlight not working since 2 days', category: 'Lighting', lat: 28.61, lng: 77.21, status: 'in_progress', priority: 5),
      Issue(id: Uuid().v4(), title: 'Overflowing garbage', description: 'Garbage pile near market', category: 'Sanitation', lat: 28.62, lng: 77.22, status: 'open', priority: 6),
    ]);
    _pushUpdates();
  }

  final _controller = StreamController<List<Issue>>.broadcast();
  final List<Issue> _issues = [];

  Stream<List<Issue>> get issuesStream => _controller.stream;

  void _pushUpdates() {
    _controller.add(List.unmodifiable(_issues));
  }

  Future<void> createIssue(Issue issue) async {
    _issues.insert(0, issue);
    _pushUpdates();
  }

  Future<void> updateStatus(String id, String status) async {
    final idx = _issues.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _issues[idx].status = status;
      _pushUpdates();
    }
  }

  Future<void> upvote(String id) async {
    final idx = _issues.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _issues[idx].upvotes += 1;
      _pushUpdates();
    }
  }
}
