import 'package:flutter/material.dart';
import '../../services/mock_service.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = MockService();
    return Scaffold(
      appBar: AppBar(title: const Text('City Map (Mock)')),
      body: StreamBuilder(
        stream: service.issuesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final issues = snapshot.data as List;
          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(issues[i].title),
              subtitle: Text('${issues[i].category} • ${issues[i].status}'),
              trailing: Text('Votes: ${issues[i].upvotes}'),
            ),
          );
        },
      ),
    );
  }
}
