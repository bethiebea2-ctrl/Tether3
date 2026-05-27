import '../enums/shared_enums.dart';

/// A task as seen by the resolver engine.
///
/// This is NOT the full task model used by the Tasks module.
/// It is a lightweight, resolver-specific view containing only
/// the fields that resolver rules need to evaluate.
///
/// The resolver doesn't need description, assignee, category tags,
/// or audit history. It needs: what's the priority, what energy does
/// it require, how sensitive is it, and who can see it.
class SharedTask {
  final String id;
  final String title;
  final String? description;

  final TaskPriority priority;
  final EnergyLevel energyLevel;

  final SensitivityLevel sensitivityLevel;
  final PrivacyScope privacyScope;

  final String? sourceModule;

  final DateTime createdAt;
  final DateTime? dueDate;

  const SharedTask({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.energyLevel,
    required this.sensitivityLevel,
    required this.privacyScope,
    this.sourceModule,
    required this.createdAt,
    this.dueDate,
  });
}