import 'package:flutter/material.dart';
import '../models/issue_model.dart';
import '../services/mock_service.dart';

class IssueCard extends StatelessWidget {
  final Issue issue;
  const IssueCard({Key? key, required this.issue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = MockService();
    return Card(
      child: ListTile(
        title: Text(issue.title),
        subtitle: Text(issue.description),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Votes: ${issue.upvotes}'),
            IconButton(icon: const Icon(Icons.thumb_up), onPressed: () => service.upvote(issue.id)),
          ],
        ),
      ),
    );
  }
}
