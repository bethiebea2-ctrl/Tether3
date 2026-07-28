import 'package:flutter/material.dart';
import '../models/support_preset.dart';

/// Layer 1 support presets — architecture for Phase 1B+.
class SupportPresetProvider extends ChangeNotifier {
  static const List<SupportPreset> catalog = [
    // Neurodivergent
    SupportPreset(
      id: 'adhd_support',
      displayName: 'ADHD support',
      description: 'Reduces overwhelm and supports executive function.',
      category: 'neurodivergent',
      defaultToggleIds: ['reduce_notifications', 'one_next_step', 'shame_free_language', 'digest_mode'],
      currentStateShortcuts: ['overwhelmed', 'low_energy'],
    ),
    SupportPreset(
      id: 'autism_support',
      displayName: 'Autism support',
      description: 'Predictable structure and sensory-aware defaults.',
      category: 'neurodivergent',
      defaultToggleIds: ['reduce_motion', 'plain_language', 'routine_support'],
      currentStateShortcuts: ['overwhelmed', 'shutdown'],
    ),
    SupportPreset(
      id: 'dyslexia_support',
      displayName: 'Dyslexia support',
      description: 'Readable text and simpler language.',
      category: 'neurodivergent',
      defaultToggleIds: ['plain_language', 'short_summaries'],
    ),
    SupportPreset(
      id: 'dyscalculia_support',
      displayName: 'Dyscalculia support',
      description: 'Simplified numbers and visual budget cues.',
      category: 'neurodivergent',
      defaultToggleIds: ['simplified_numbers', 'visual_budget_bars'],
    ),
    SupportPreset(
      id: 'dyspraxia_support',
      displayName: 'Dyspraxia support',
      description: 'Larger targets and fewer precision demands.',
      category: 'neurodivergent',
      defaultToggleIds: ['large_buttons', 'reduced_precision'],
    ),
    // Emotional & mental health
    SupportPreset(
      id: 'depression_support',
      displayName: 'Depression support',
      description: 'Gentle language and bare-minimum focus.',
      category: 'emotional',
      defaultToggleIds: ['shame_free_language', 'one_next_step', 'gentle_language'],
      languageRules: {'You forgot': 'Still on the list.'},
      currentStateShortcuts: ['low_energy', 'grief_day'],
    ),
    SupportPreset(
      id: 'anxiety_support',
      displayName: 'Anxiety support',
      description: 'Calmer prompts and reduced urgency noise.',
      category: 'emotional',
      defaultToggleIds: ['reduce_notifications', 'gentle_language', 'digest_mode'],
      currentStateShortcuts: ['overwhelmed', 'panicking'],
    ),
    SupportPreset(
      id: 'trauma_informed',
      displayName: 'Trauma-informed',
      description: 'Trauma-aware wording and privacy defaults.',
      category: 'emotional',
      defaultToggleIds: ['trauma_informed', 'hide_sensitive_notes'],
      currentStateShortcuts: ['triggered'],
    ),
    SupportPreset(
      id: 'emotional_regulation',
      displayName: 'Emotional regulation',
      description: 'Cooling-off and repair-oriented communication.',
      category: 'emotional',
      defaultToggleIds: ['cooling_off', 'repair_prompt', 'tone_check'],
    ),
    SupportPreset(
      id: 'food_body_neutrality',
      displayName: 'Food/body neutrality',
      description: 'Neutral food and body language.',
      category: 'emotional',
      defaultToggleIds: ['no_diet_body', 'no_good_bad_food', 'no_diet_culture', 'hide_weight'],
    ),
    SupportPreset(
      id: 'panic_support',
      displayName: 'Panic support',
      description: 'Grounding-first when panic is active.',
      category: 'emotional',
      defaultToggleIds: ['reduce_notifications', 'simplified_dashboard'],
      currentStateShortcuts: ['panicking'],
    ),
    SupportPreset(
      id: 'dissociation_support',
      displayName: 'Dissociation support',
      description: 'Simpler screens and fewer demands.',
      category: 'emotional',
      defaultToggleIds: ['simplified_dashboard', 'one_next_step'],
      currentStateShortcuts: ['dissociating'],
    ),
    SupportPreset(
      id: 'ocd_support',
      displayName: 'OCD support',
      description: 'Avoid reassurance loops; keep prompts short.',
      category: 'emotional',
      defaultToggleIds: ['short_prompts', 'fewer_choices'],
      currentStateShortcuts: ['intrusive_thoughts'],
    ),
    SupportPreset(
      id: 'bipolar_support',
      displayName: 'Bipolar support',
      description: 'Stability-aware pacing and sleep sensitivity.',
      category: 'emotional',
      defaultToggleIds: ['reduce_notifications', 'routine_support'],
      currentStateShortcuts: ['low_energy'],
    ),
    SupportPreset(
      id: 'psychosis_support',
      displayName: 'Psychosis support',
      description: 'Clear, grounded language; reduced stimulation.',
      category: 'emotional',
      defaultToggleIds: ['plain_language', 'low_stim_theme', 'reduce_notifications'],
      riskLevel: 'amber',
    ),
    // Life stages & recovery
    SupportPreset(
      id: 'postpartum_support',
      displayName: 'Postpartum support',
      description: 'New-parent pacing and perinatal sensitivity.',
      category: 'life_stages',
      defaultToggleIds: ['pregnancy_postpartum', 'one_next_step', 'shame_free_language'],
      currentStateShortcuts: ['exhausted', 'low_energy'],
    ),
    SupportPreset(
      id: 'addiction_recovery',
      displayName: 'Addiction recovery',
      description: 'Relapse-aware check-ins without shame.',
      category: 'life_stages',
      defaultToggleIds: ['shame_free_language', 'trusted_checkin'],
      currentStateShortcuts: ['relapse_risk'],
    ),
    SupportPreset(
      id: 'chronic_health',
      displayName: 'Chronic health',
      description: 'Flare and low-energy aware defaults.',
      category: 'life_stages',
      defaultToggleIds: ['flare_mode', 'low_energy_mode', 'med_reminders'],
      currentStateShortcuts: ['flare', 'in_pain'],
    ),
    // Sensory & physical
    SupportPreset(
      id: 'low_stimulation',
      displayName: 'Low-stimulation',
      description: 'Quieter visuals and fewer interruptions.',
      category: 'sensory',
      defaultToggleIds: ['reduce_notifications', 'reduce_motion', 'low_stim_theme'],
      currentStateShortcuts: ['overwhelmed'],
    ),
    SupportPreset(
      id: 'blind_low_vision',
      displayName: 'Blind/low vision',
      description: 'Screen-reader and contrast-forward defaults.',
      category: 'sensory',
      defaultToggleIds: ['high_contrast', 'screen_reader', 'large_buttons'],
    ),
    SupportPreset(
      id: 'deaf_hard_of_hearing',
      displayName: 'Deaf/hard of hearing',
      description: 'Visual alerts and captions.',
      category: 'sensory',
      defaultToggleIds: ['visual_alerts_only', 'captions', 'no_sound'],
    ),
    SupportPreset(
      id: 'accessibility_mobility',
      displayName: 'Accessibility/mobility',
      description: 'One-handed and reduced-precision support.',
      category: 'sensory',
      defaultToggleIds: ['one_handed', 'large_buttons', 'reduced_precision'],
    ),
    SupportPreset(
      id: 'epilepsy_support',
      displayName: 'Epilepsy support',
      description: 'No flashing; post-seizure recovery shortcuts.',
      category: 'sensory',
      defaultToggleIds: ['no_flashing', 'disable_animations', 'reduce_motion'],
      currentStateShortcuts: ['post_seizure'],
      riskLevel: 'amber',
    ),
  ];

  static const categoryOrder = [
    'neurodivergent',
    'emotional',
    'life_stages',
    'sensory',
  ];

  static const categoryLabels = {
    'neurodivergent': 'Neurodivergent support',
    'emotional': 'Emotional & mental health',
    'life_stages': 'Life stages & recovery',
    'sensory': 'Sensory & physical',
  };

  final Set<String> _activePresetIds = {};
  final Set<String> _activeToggleIds = {};

  List<SupportPreset> get activePresets =>
      catalog.where((p) => _activePresetIds.contains(p.id)).toList();

  Set<String> get activeToggleIds => Set.unmodifiable(_activeToggleIds);

  bool get reduceNotifications =>
      _activeToggleIds.contains('reduce_notifications') ||
      activePresets.any((p) => p.defaultToggleIds.contains('reduce_notifications'));

  bool get simplifiedDashboard =>
      _activeToggleIds.contains('simplified_dashboard') ||
      activePresets.any((p) => p.defaultToggleIds.contains('simplified_dashboard'));

  void togglePreset(String id) {
    if (_activePresetIds.contains(id)) {
      _activePresetIds.remove(id);
      _rebuildToggleIds();
    } else {
      _activePresetIds.add(id);
      final preset = catalog.firstWhere((p) => p.id == id);
      _activeToggleIds.addAll(preset.defaultToggleIds);
    }
    notifyListeners();
  }

  void deactivatePreset(String id) {
    _activePresetIds.remove(id);
    _rebuildToggleIds();
    notifyListeners();
  }

  void _rebuildToggleIds() {
    _activeToggleIds
      ..clear()
      ..addAll(
        activePresets.expand((p) => p.defaultToggleIds),
      );
  }

  void toggleSensitivity(String toggleId) {
    if (_activeToggleIds.contains(toggleId)) {
      _activeToggleIds.remove(toggleId);
    } else {
      _activeToggleIds.add(toggleId);
    }
    notifyListeners();
  }

  bool isPresetActive(String id) => _activePresetIds.contains(id);
}
