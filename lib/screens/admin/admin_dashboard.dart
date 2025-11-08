import 'package:flutter/material.dart';
import '../../services/mock_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = MockService();
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard (Mock)')),
      body: StreamBuilder(
        stream: service.issuesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final issues = snapshot.data as List;
          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(issues[i].title),
              subtitle: Text(issues[i].status),
              trailing: PopupMenuButton<String>(
                onSelected: (val) => service.updateStatus(issues[i].id, val),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'open', child: Text('Open')),
                  PopupMenuItem(value: 'in_progress', child: Text('In Progress')),
                  PopupMenuItem(value: 'resolved', child: Text('Resolved')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
