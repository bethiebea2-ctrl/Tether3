import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/calendar_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../models/calendar_event.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  String _viewMode = 'month';
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        title: const Text('Calendar', style: BethTypography.heading),
        actions: [
          IconButton(
            icon: Icon(
              _viewMode == 'month' ? Icons.view_week : Icons.calendar_month,
              color: BethColours.primary,
            ),
            onPressed: () {
              setState(() {
                if (_viewMode == 'month') {
                  _viewMode = 'week';
                } else if (_viewMode == 'week') {
                  _viewMode = 'agenda';
                } else {
                  _viewMode = 'month';
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: BethColours.primary),
            onPressed: () => provider.syncFromBackend(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMonthHeader(),
                    Expanded(
            child: RefreshIndicator(
              onRefresh: () => provider.syncFromBackend(),
              child: _viewMode == 'month'
                  ? _buildMonthGrid(provider)
                  : _viewMode == 'week'
                      ? _buildWeekView(provider)
                      : _buildAgendaView(provider),
            ),
          ),
        ], 
      ),
    );
  }

  Widget _buildMonthHeader() {
    final monthName = DateFormat('MMMM yyyy').format(_currentMonth);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: BethColours.surface,
        border: Border(bottom: BorderSide(color: BethColours.textMuted.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
            }),
          ),
          Text(monthName, style: BethTypography.subheading),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(CalendarProvider provider) {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDay.weekday;
    final daysInMonth = lastDay.day;
    final today = DateTime.now();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d, style: BethTypography.caption?.copyWith(
                          fontWeight: FontWeight.w600, color: BethColours.textMuted,
                        )),
                      ),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemCount: firstWeekday - 1 + daysInMonth,
            itemBuilder: (context, index) {
              final dayNumber = index - (firstWeekday - 1) + 1;
              if (dayNumber < 1) return const SizedBox.shrink();

              final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final dateKey = date.toIso8601String().split('T')[0];
              final dayEvents = provider.events.where((e) {
                return e.date.toIso8601String().split('T')[0] == dateKey;
              }).toList();
              final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

              return GestureDetector(
                onTap: () => provider.selectDate(date),
                child: Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: isToday ? BethColours.amber.withOpacity(0.1) : null,
                  borderRadius: BorderRadius.circular(6),
                  border: isToday ? Border.all(color: BethColours.amber, width: 1.5) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text('$dayNumber', style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      color: isToday ? BethColours.amber : BethColours.textPrimary,
                    )),
                    if (dayEvents.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dayEvents.take(3).map((e) => Container(
                          width: 5, height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: const BoxDecoration(color: BethColours.primary, shape: BoxShape.circle),
                        )).toList(),
                      ),
                                    ],
                ),
              ),
              );
            },
          ),
        ),
                Consumer<CalendarProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Waking up server..."),
                      const SizedBox(height: 8),
                      Text(
                        "Render free tier may take 30-60 seconds.",
                        style: BethTypography.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            final events = provider.eventsForSelectedDate;

            if (events.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text("No events for this day"),
                ),
              );
            }

            return Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: BethColours.surface,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -1))],
              ),
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: events.map((event) {
                  final timeStr = event.startTime != null ? DateFormat('h:mm a').format(event.startTime!) : '';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(width: 3, height: 30, color: BethColours.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title, style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                              Text(timeStr, style: BethTypography.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeekView(CalendarProvider provider) {
    final start = _currentMonth;
    final days = List.generate(7, (i) => start.add(Duration(days: i)));
    return ListView(
      padding: const EdgeInsets.all(12),
      children: days.map((day) {
        final key = day.toIso8601String().split('T')[0];
        final dayEvents = provider.groupedEvents[key] ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('EEE d MMM').format(day), style: BethTypography.subheading),
            if (dayEvents.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text('No events', style: BethTypography.caption),
              )
            else
              ...dayEvents.map(
                (e) => ListTile(
                  dense: true,
                  title: Text(e.title),
                  subtitle: Text(DateFormat.jm().format(e.startTime)),
                ),
              ),
            const Divider(),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAgendaView(CalendarProvider provider) {
    if (provider.events.isEmpty) {
      return Center(child: Text('No events', style: BethTypography.body?.copyWith(color: BethColours.textMuted)));
    }
    final sorted = List<CalendarEvent>.from(provider.events)..sort((a, b) => a.date.compareTo(b.date));
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final event = sorted[index];
        final dateStr = DateFormat('EEE, MMM d').format(event.date);
        final timeStr = event.startTime != null ? DateFormat('h:mm a').format(event.startTime!) : '';
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: BethColours.surface, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(width: 3, height: 50, color: BethColours.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                      Text('$dateStr ${timeStr.isNotEmpty ? '· $timeStr' : ''}', style: BethTypography.caption),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}