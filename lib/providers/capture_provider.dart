import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CaptureProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  final List<Map<String, dynamic>> _recentItems = [];
  final Map<String, DateTime> _itemTimestamps = {};

  List<Map<String, dynamic>> get recentItems => List.unmodifiable(_recentItems);

  void addRecentItem({required String type, required String summary}) {
    final icons = {
      'feed': '🍼',
      'medication': '💊',
      'nap': '😴',
      'nappy': '🧷',
      'task': '✅',
      'note': '📝',
      'event': '📅',
    };

    final id = _uuid.v4();
    _recentItems.insert(0, {
      'id': id,
      'type': type,
      'label': summary,
      'icon': icons[type] ?? '📌',
      'timestamp': DateTime.now(),
    });
    _itemTimestamps[id] = DateTime.now();

    if (_recentItems.length > 3) {
      final removed = _recentItems.removeLast();
      _itemTimestamps.remove(removed['id']);
    }

    Future.delayed(const Duration(seconds: 30), () {
      _recentItems.removeWhere((item) => item['id'] == id);
      _itemTimestamps.remove(id);
      notifyListeners();
    });

    notifyListeners();
  }

  void undoItem(String id) {
    _recentItems.removeWhere((item) => item['id'] == id);
    _itemTimestamps.remove(id);
    notifyListeners();
  }
}