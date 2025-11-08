import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/issue_model.dart';
import '../../services/mock_service.dart';
import '../../services/ai_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final titleC = TextEditingController();
  final descC = TextEditingController();
  bool loading = false;
  final ai = AIService();
  final service = MockService();

  Future submit() async {
    setState(() => loading = true);
    final cat = ai.categorize(titleC.text, descC.text);
    final pr = ai.scorePriority(titleC.text, descC.text);
    final issue = Issue(id: Uuid().v4(), title: titleC.text, description: descC.text, category: cat, priority: pr);
    await service.createIssue(issue);
    setState(() => loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Issue')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          TextField(controller: titleC, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: descC, decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 8),
          const Spacer(),
          ElevatedButton(onPressed: submit, child: loading ? const CircularProgressIndicator() : const Text('Submit')),
        ]),
      ),
    );
  }
}
