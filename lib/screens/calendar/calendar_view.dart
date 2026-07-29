import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/calendar_event.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../widgets/calendar_event_tile.dart';
import 'event_creation.dart';
import 'event_detail.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final ScrollController _dayScrollController = ScrollController();
  bool _appliedDefaultView = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_appliedDefaultView) return;
    _appliedDefaultView = true;
    final prefs = context.read<SettingsPrefsProvider>();
    final mode = switch (prefs.calendarDefaultView) {
      'week' => CalendarViewMode.week,
      'day' => CalendarViewMode.day,
      'agenda' => CalendarViewMode.agenda,
      _ => CalendarViewMode.month,
    };
    context.read<CalendarProvider>().setViewMode(mode);
  }

  @override
  void dispose() {
    _dayScrollController.dispose();
    super.dispose();
  }

  void _openCreate({DateTime? date, TimeOfDay? time}) {
    final provider = context.read<CalendarProvider>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventCreation(
          initialDate: date ?? provider.selectedDate,
          initialTime: time,
        ),
      ),
    );
  }

  void _openDetail(CalendarEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        title: const Text('📅 Calendar', style: BethTypography.heading),
        actions: [
          if (provider.viewMode == CalendarViewMode.day) ...[
            IconButton(
              icon: const Icon(Icons.chevron_left, color: BethColours.primary),
              onPressed: () => provider.shiftFocusedDay(-1),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: BethColours.primary),
              onPressed: () => provider.shiftFocusedDay(1),
            ),
          ] else
            TextButton(
              onPressed: provider.goToToday,
              child: Text(
                'Today',
                style: BethTypography.button.copyWith(
                  color: BethColours.primary,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.primary,
        onPressed: () => _openCreate(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: provider.syncFromBackend,
              child: _buildBody(provider),
            ),
          ),
          _ViewToggle(
            mode: provider.viewMode,
            onChanged: provider.setViewMode,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(CalendarProvider provider) {
    switch (provider.viewMode) {
      case CalendarViewMode.month:
        return _MonthView(
          onOpenCreate: _openCreate,
          onOpenDetail: _openDetail,
        );
      case CalendarViewMode.week:
        return _WeekView(onOpenDetail: _openDetail, onOpenCreate: _openCreate);
      case CalendarViewMode.day:
        return _DayView(
          scrollController: _dayScrollController,
          onOpenCreate: _openCreate,
          onOpenDetail: _openDetail,
        );
      case CalendarViewMode.agenda:
        return _AgendaView(onOpenDetail: _openDetail, onOpenCreate: _openCreate);
    }
  }
}

// ---------------------------------------------------------------------------
// View toggle
// ---------------------------------------------------------------------------

class _ViewToggle extends StatelessWidget {
  final CalendarViewMode mode;
  final ValueChanged<CalendarViewMode> onChanged;

  const _ViewToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: BethColours.surface,
        border: Border(
          top: BorderSide(color: BethColours.textMuted.withOpacity(0.15)),
        ),
      ),
      child: SegmentedButton<CalendarViewMode>(
        segments: const [
          ButtonSegment(value: CalendarViewMode.month, label: Text('Month')),
          ButtonSegment(value: CalendarViewMode.week, label: Text('Week')),
          ButtonSegment(value: CalendarViewMode.day, label: Text('Day')),
          ButtonSegment(value: CalendarViewMode.agenda, label: Text('Agenda')),
        ],
        selected: {mode},
        onSelectionChanged: (s) => onChanged(s.first),
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          textStyle: WidgetStatePropertyAll(
            BethTypography.caption.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Month view
// ---------------------------------------------------------------------------

class _MonthView extends StatelessWidget {
  final void Function({DateTime? date, TimeOfDay? time}) onOpenCreate;
  final void Function(CalendarEvent) onOpenDetail;

  const _MonthView({
    required this.onOpenCreate,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();
    final month = provider.currentMonth;
    final monthName = DateFormat('MMMM yyyy').format(month).toUpperCase();

    return Column(
      children: [
        // Month selector / collapse header
        InkWell(
          onTap: provider.toggleMonthCollapsed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            color: BethColours.surface,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 22),
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: provider.goToPreviousMonth,
                ),
                Expanded(
                  child: Text(
                    provider.monthCollapsed
                        ? '📆 $monthName'
                        : monthName,
                    textAlign: TextAlign.center,
                    style: BethTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: BethColours.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    provider.monthCollapsed
                        ? Icons.expand_more
                        : Icons.expand_less,
                    size: 22,
                  ),
                  tooltip: provider.monthCollapsed ? 'Expand' : 'Collapse',
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: provider.toggleMonthCollapsed,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 22),
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: provider.goToNextMonth,
                ),
              ],
            ),
          ),
        ),
        if (provider.monthCollapsed)
          _MiniDateStrip(provider: provider)
        else
          _MonthGrid(provider: provider),
        const Divider(height: 1),
        Expanded(
          child: _DayDetailPanel(
            provider: provider,
            onOpenCreate: onOpenCreate,
            onOpenDetail: onOpenDetail,
          ),
        ),
      ],
    );
  }
}

class _MiniDateStrip extends StatelessWidget {
  final CalendarProvider provider;

  const _MiniDateStrip({required this.provider});

  @override
  Widget build(BuildContext context) {
    final month = provider.currentMonth;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final selected = provider.selectedDate;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: daysInMonth,
        itemBuilder: (context, i) {
          final day = i + 1;
          final date = DateTime(month.year, month.month, day);
          final isSelected = date.year == selected.year &&
              date.month == selected.month &&
              date.day == selected.day;
          final isToday = _isSameDay(date, DateTime.now());
          return GestureDetector(
            onTap: () => provider.selectDate(date),
            child: Container(
              width: 36,
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? BethColours.primary
                    : isToday
                        ? BethColours.primary.withOpacity(0.15)
                        : null,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : BethColours.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final CalendarProvider provider;

  /// Fixed row height so the grid never scrolls and stays compact.
  static const double _rowHeight = 36;

  const _MonthGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    final month = provider.currentMonth;
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDay.weekday; // Mon=1
    final daysInMonth = lastDay.day;
    final today = DateTime.now();
    final selected = provider.selectedDate;
    final leading = firstWeekday - 1;
    final cellCount = leading + daysInMonth;
    final weeks = (cellCount / 7).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 4, 0),
          child: Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: BethTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(
          height: weeks * _rowHeight,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: _rowHeight,
            ),
            itemCount: weeks * 7,
            itemBuilder: (context, index) {
              final dayNumber = index - leading + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(month.year, month.month, dayNumber);
              final dayEvents = provider.eventsForDate(date);
              final isToday = _isSameDay(date, today);
              final isSelected = _isSameDay(date, selected);

              return GestureDetector(
                onTap: () => provider.selectDate(date),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? BethColours.primary
                            : isToday
                                ? BethColours.primary.withOpacity(0.2)
                                : null,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1,
                          fontWeight: isToday || isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : BethColours.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                      child: dayEvents.isEmpty
                          ? null
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var i = 0;
                                    i < dayEvents.take(3).length;
                                    i++)
                                  Container(
                                    width: 4,
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 0.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: provider.getCategoryColour(
                                        dayEvents[i].categoryId,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayDetailPanel extends StatelessWidget {
  final CalendarProvider provider;
  final void Function({DateTime? date, TimeOfDay? time}) onOpenCreate;
  final void Function(CalendarEvent) onOpenDetail;

  const _DayDetailPanel({
    required this.provider,
    required this.onOpenCreate,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final date = provider.selectedDate;
    final events = provider.eventsForSelectedDate;
    final header =
        '📅 ${DateFormat('EEEE d MMMM').format(date)}'.toUpperCase();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        Text(header, style: BethTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w700,
          color: BethColours.textPrimary,
        )),
        const SizedBox(height: 12),
        if (events.isEmpty)
          TextButton(
            onPressed: () => onOpenCreate(date: date),
            child: const Text(
              'Nothing scheduled for this day. Add an event?',
            ),
          )
        else
          ...events.map(
            (e) => CalendarEventTile(
              event: e,
              onTap: () => onOpenDetail(e),
            ),
          ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => onOpenCreate(date: date),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add event'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Week view (basic — 1C polish later)
// ---------------------------------------------------------------------------

class _WeekView extends StatelessWidget {
  final void Function(CalendarEvent) onOpenDetail;
  final void Function({DateTime? date, TimeOfDay? time}) onOpenCreate;

  const _WeekView({
    required this.onOpenDetail,
    required this.onOpenCreate,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();
    final focus = provider.focusedDay;
    final monday = focus.subtract(Duration(days: focus.weekday - 1));
    final days = List.generate(7, (i) => monday.add(Duration(days: i)));
    final weekLabel =
        'Week ${DateFormat('w').format(focus)} · ${DateFormat('MMM yyyy').format(focus)}';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: BethColours.surface,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: provider.goToPreviousWeek,
              ),
              Expanded(
                child: Text(
                  weekLabel,
                  textAlign: TextAlign.center,
                  style: BethTypography.subheading,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: provider.goToNextWeek,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
            itemCount: days.length,
            itemBuilder: (context, i) {
              final day = days[i];
              final events = provider.eventsForDate(day);
              final isToday = _isSameDay(day, DateTime.now());
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: BethColours.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: isToday
                      ? Border.all(color: BethColours.primary.withOpacity(0.4))
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('EEE d').format(day),
                          style: BethTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isToday
                                ? BethColours.primary
                                : BethColours.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () => onOpenCreate(date: day),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    if (events.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Nothing scheduled.',
                          style: BethTypography.caption,
                        ),
                      )
                    else
                      ...events.map(
                        (e) => CalendarEventTile(
                          event: e,
                          compact: true,
                          onTap: () => onOpenDetail(e),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Day view
// ---------------------------------------------------------------------------

class _DayView extends StatelessWidget {
  final ScrollController scrollController;
  final void Function({DateTime? date, TimeOfDay? time}) onOpenCreate;
  final void Function(CalendarEvent) onOpenDetail;

  const _DayView({
    required this.scrollController,
    required this.onOpenCreate,
    required this.onOpenDetail,
  });

  static const double _hourHeight = 64;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();
    final date = provider.selectedDate;
    final events = provider.eventsForSelectedDate;
    final now = DateTime.now();
    final isToday = _isSameDay(date, now);
    final allDay = events.where((e) => e.isAllDay).toList();
    final timed = events.where((e) => !e.isAllDay).toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: BethColours.surface,
          child: Text(
            DateFormat('EEEE d MMMM').format(date).toUpperCase(),
            style: BethTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: BethColours.textPrimary,
            ),
          ),
        ),
        if (allDay.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: BethColours.surfaceAlt,
            child: Column(
              children: allDay
                  .map(
                    (e) => CalendarEventTile(
                      event: e,
                      compact: true,
                      onTap: () => onOpenDetail(e),
                    ),
                  )
                  .toList(),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 100),
            child: SizedBox(
              height: 24 * _hourHeight,
              child: Stack(
                children: [
                  // Hour lines + empty tap targets
                  Column(
                    children: List.generate(24, (hour) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onOpenCreate(
                          date: date,
                          time: TimeOfDay(hour: hour, minute: 0),
                        ),
                        child: SizedBox(
                          height: _hourHeight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 56,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, top: 0),
                                  child: Text(
                                    _hourLabel(hour),
                                    style: BethTypography.caption,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: BethColours.textMuted
                                            .withOpacity(0.12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  // Events positioned by time
                  ...timed.map((e) {
                    final startMin = e.startTime.hour * 60 + e.startTime.minute;
                    final end = e.endTime ??
                        e.startTime.add(const Duration(minutes: 30));
                    final endMin = end.hour * 60 + end.minute;
                    final duration = (endMin - startMin).clamp(20, 24 * 60);
                    final top = startMin / 60 * _hourHeight;
                    final height = duration / 60 * _hourHeight;
                    final colour = provider.getCategoryColour(e.categoryId);
                    final past = isToday && end.isBefore(now);
                    return Positioned(
                      top: top,
                      left: 56,
                      right: 8,
                      height: height,
                      child: Opacity(
                        opacity: past ? 0.55 : 1,
                        child: GestureDetector(
                          onTap: () => onOpenDetail(e),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colour.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(8),
                              border: Border(
                                left: BorderSide(color: colour, width: 3),
                              ),
                            ),
                            child: Text(
                              '${e.emoji != null ? '${e.emoji} ' : ''}${e.title}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: BethTypography.caption.copyWith(
                                color: BethColours.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  // NOW line
                  if (isToday)
                    Positioned(
                      top: (now.hour * 60 + now.minute) / 60 * _hourHeight,
                      left: 48,
                      right: 0,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: BethColours.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: BethColours.red.withOpacity(0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              'NOW ${DateFormat('h:mm a').format(now)}',
                              style: BethTypography.caption.copyWith(
                                color: BethColours.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _hourLabel(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }
}

// ---------------------------------------------------------------------------
// Agenda view
// ---------------------------------------------------------------------------

class _AgendaView extends StatelessWidget {
  final void Function(CalendarEvent) onOpenDetail;
  final void Function({DateTime? date, TimeOfDay? time}) onOpenCreate;

  const _AgendaView({
    required this.onOpenDetail,
    required this.onOpenCreate,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();
    final groups = provider.agendaGroups;
    final hasAny = groups.values.any((l) => l.isNotEmpty);

    if (!hasAny) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Nothing scheduled.',
              style: BethTypography.body.copyWith(color: BethColours.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => onOpenCreate(),
            child: const Text('Add an event?'),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        for (final entry in groups.entries)
          if (entry.value.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Text(
                '─── ${entry.key.toUpperCase()} ───',
                style: BethTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            ...entry.value.map(
              (e) => Column(
                children: [
                  CalendarEventTile(
                    event: e,
                    showDate: entry.key != 'Today' && entry.key != 'Tomorrow',
                    onTap: () => onOpenDetail(e),
                  ),
                  Divider(
                    height: 1,
                    color: BethColours.textMuted.withOpacity(0.12),
                  ),
                ],
              ),
            ),
          ],
      ],
    );
  }
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
