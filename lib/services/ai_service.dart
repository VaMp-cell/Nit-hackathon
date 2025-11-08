        class AIService {
  String categorize(String title, String description) {
    final text = (title + ' ' + description).toLowerCase();
    if (text.contains('pothole') || text.contains('road')) return 'Road';
    if (text.contains('water') || text.contains('leak')) return 'Water';
    if (text.contains('garbage') || text.contains('trash')) return 'Sanitation';
    if (text.contains('light') || text.contains('streetlight')) return 'Lighting';
    return 'Other';
  }

  int scorePriority(String title, String description) {
    final t = (title + ' ' + description).length;
    return (t % 10) + 1;
  }
}
