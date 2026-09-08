/// Built-in affirmations (Phase 2B). Marlowe curation uses a subset for now.
class AffirmationLibrary {
  static const builtIn = [
    'You have everything you need for today.',
    'Small steps still move you forward.',
    'Your pace is valid.',
    'You are allowed to rest without earning it.',
    'Kindness to yourself counts.',
    'One thing at a time is enough.',
    'You have survived every hard day so far.',
    'Progress is not always visible.',
    'You deserve gentleness today.',
    'Showing up counts — even quietly.',
  ];

  static const marlowe = [
    'Beth, you are building something meaningful — one ordinary day at a time.',
    'Your household runs on care, not perfection.',
    'Rest is part of the work.',
    'You do not have to hold everything at once.',
    'What you notice matters. What you nurture grows.',
  ];

  static String pickForDay({required String source, DateTime? on}) {
    final list = source == 'marlowe' ? marlowe : builtIn;
    if (list.isEmpty) return builtIn.first;
    final day = on ?? DateTime.now();
    final index = (day.year * 1000 + day.month * 50 + day.day) % list.length;
    return list[index];
  }
}
