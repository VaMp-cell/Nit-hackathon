import 'package:flutter/material.dart';
import '../../services/mock_service.dart';
import '../../widgets/issue_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final service = MockService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CityPulse (Mock)')),
      body: StreamBuilder(
        stream: service.issuesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final issues = snapshot.data as List;
          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, i) => IssueCard(issue: issues[i]),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Report'),
        ],
        onTap: (idx) {
          if (idx == 1) Navigator.pushNamed(context, '/map');
          if (idx == 2) Navigator.pushNamed(context, '/report');
        },
      ),
    );
  }
}
