import 'package:flutter/material.dart';
import '../../services/mock_service.dart';
import '../../widgets/issue_card.dart';

class MyIssuesScreen extends StatelessWidget {
  const MyIssuesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = MockService();
    return Scaffold(
      appBar: AppBar(title: const Text('My Issues')),
      body: StreamBuilder(
        stream: service.issuesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final issues = snapshot.data as List;
          // in mock all issues are shown; filter by reporterId if needed
          return ListView(children: issues.map((i) => IssueCard(issue: i)).toList());
        },
      ),
    );
  }
}
