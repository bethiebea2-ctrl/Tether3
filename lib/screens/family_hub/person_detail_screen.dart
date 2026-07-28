import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/family/person_age_utils.dart';
import '../../database/family_care_dao.dart';
import '../../models/person.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'school_hub_screen.dart';

class PersonDetailScreen extends StatefulWidget {
  final Person person;
  const PersonDetailScreen({super.key, required this.person});

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  final FamilyCareDao _dao = FamilyCareDao();
  List<Map<String, dynamic>> _meds = [];
  List<Map<String, dynamic>> _activity = [];
  List<int> _feedChart = [];
  bool _loading = true;
  Map<String, bool> _teenPrivacy = {
    'hide_mood_from_parents': false,
    'hide_journal': false,
    'limit_partner_visibility': false,
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.person.ageStage == 'baby') {
      await _dao.seedDefaultMedsIfEmpty(widget.person.id);
    }
    final meds = await _dao.getMedications(widget.person.id);
    final activity = await _dao.getRecentActivity(widget.person.id);
    final chart = await _dao.feedsPerDayLast7Days(widget.person.id);
    if (mounted) {
      setState(() {
        _meds = meds;
        _activity = activity;
        _feedChart = chart;
        _loading = false;
      });
    }
  }

  List<({String label, String icon, String type})> get _quickButtons {
    switch (widget.person.ageStage) {
      case 'baby':
        return [
          (label: 'Feed', icon: '🍼', type: 'feed'),
          (label: 'Nap', icon: '😴', type: 'nap'),
          (label: 'Nappy', icon: '🧷', type: 'nappy'),
          (label: 'Bath', icon: '🛁', type: 'bath'),
          (label: 'Tummy', icon: '👶', type: 'tummy'),
          (label: 'Other', icon: '📌', type: 'other'),
        ];
      case 'toddler':
        return [
          (label: 'Meal', icon: '🍽', type: 'meal'),
          (label: 'Nap', icon: '😴', type: 'nap'),
          (label: 'Nappy', icon: '🧷', type: 'nappy'),
          (label: 'Play', icon: '🧸', type: 'play'),
        ];
      case 'child':
        return [
          (label: 'School', icon: '🏫', type: 'school'),
          (label: 'Homework', icon: '📚', type: 'homework'),
          (label: 'Activity', icon: '⚽', type: 'activity'),
        ];
      case 'teen':
        return [
          (label: 'Mood', icon: '💭', type: 'mood'),
          (label: 'Study', icon: '📖', type: 'study'),
          (label: 'Out', icon: '🚪', type: 'out'),
        ];
      default:
        return [(label: 'Note', icon: '📌', type: 'other')];
    }
  }

  Color _medColour(Map<String, dynamic> med) {
    final last = med['last_given'] as String?;
    final hours = med['minimum_interval_hours'] as int? ?? 4;
    if (last == null) return BethColours.green;
    final lastDt = DateTime.tryParse(last);
    if (lastDt == null) return BethColours.green;
    final next = lastDt.add(Duration(hours: hours));
    final now = DateTime.now();
    if (now.isAfter(next)) return BethColours.green;
    if (next.difference(now).inMinutes <= 60) return BethColours.amber;
    return BethColours.red;
  }

  String _medLabel(Map<String, dynamic> med) {
    final c = _medColour(med);
    if (c == BethColours.green) return 'Available';
    if (c == BethColours.amber) return 'Soon';
    return 'Wait';
  }

  @override
  Widget build(BuildContext context) {
    final person = widget.person;
    final name = personDisplayName(person);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          if (person.dateOfBirth != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(ageDisplayLabel(person), style: BethTypography.caption),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (person.ageStage == 'child' || person.ageStage == 'teen')
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.school_outlined),
                        title: const Text('School hub'),
                        subtitle: const Text('Timetable and notes (placeholder)'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SchoolHubScreen(person: person),
                          ),
                        ),
                      ),
                    ),
                  if (person.isTeen) ...[
                    Text('Privacy (on device)', style: BethTypography.subheading),
                    SwitchListTile(
                      title: const Text('Hide mood check-ins from parents'),
                      value: _teenPrivacy['hide_mood_from_parents']!,
                      onChanged: (v) => setState(() => _teenPrivacy['hide_mood_from_parents'] = v),
                    ),
                    SwitchListTile(
                      title: const Text('Keep journal private'),
                      value: _teenPrivacy['hide_journal']!,
                      onChanged: (v) => setState(() => _teenPrivacy['hide_journal'] = v),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_meds.isNotEmpty) ...[
                    Text('Medications', style: BethTypography.subheading),
                    const SizedBox(height: 8),
                    ..._meds.map((med) {
                      final colour = _medColour(med);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: BethColours.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border(left: BorderSide(color: colour, width: 3)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    med['name'] as String? ?? 'Med',
                                    style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${med['dose']} ${med['dose_unit'] ?? ''}',
                                    style: BethTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                            Text(_medLabel(med), style: TextStyle(color: colour, fontSize: 11)),
                            IconButton(
                              onPressed: () async {
                                await _dao.logMedicationGiven(med['id'] as String);
                                await _load();
                              },
                              icon: const Icon(Icons.check_circle_outline, color: BethColours.green),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                  if (person.ageStage == 'baby') ...[
                    Text('7-day feeds', style: BethTypography.subheading),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: BarChart(
                        BarChartData(
                          maxY: (_feedChart.isEmpty ? 1 : _feedChart.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) {
                                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                  final i = v.toInt();
                                  if (i < 0 || i >= 7) return const SizedBox.shrink();
                                  return Text(days[i], style: const TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(
                            7,
                            (i) => BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: (i < _feedChart.length ? _feedChart[i] : 0).toDouble(),
                                  color: BethColours.primary,
                                  width: 12,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text('Quick log', style: BethTypography.subheading),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickButtons
                        .map((b) => _quickChip(b.label, b.icon, b.type))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Text('Recent activity', style: BethTypography.subheading),
                  const SizedBox(height: 8),
                  if (_activity.isEmpty)
                    Text('Nothing logged yet.', style: BethTypography.caption)
                  else
                    ..._activity.take(10).map((e) {
                      final at = DateTime.tryParse(e['logged_at'] as String? ?? '');
                      final time = at != null
                          ? '${at.hour}:${at.minute.toString().padLeft(2, '0')}'
                          : '';
                      return ListTile(
                        dense: true,
                        leading: Text(_iconFor(e['log_type'] as String? ?? '')),
                        title: Text(e['detail'] as String? ?? ''),
                        trailing: Text(time, style: BethTypography.caption),
                      );
                    }),
                ],
              ),
            ),
    );
  }

  String _iconFor(String type) {
    switch (type) {
      case 'feed':
        return '🍼';
      case 'nap':
        return '😴';
      case 'nappy':
        return '🧷';
      case 'medication':
        return '💊';
      default:
        return '📌';
    }
  }

  Widget _quickChip(String label, String icon, String type) {
    return ActionChip(
      avatar: Text(icon),
      label: Text(label),
      onPressed: () async {
        await _dao.logActivity(
          personId: widget.person.id,
          logType: type,
          detail: '$label logged for ${personDisplayName(widget.person)}',
        );
        await _load();
      },
    );
  }
}
