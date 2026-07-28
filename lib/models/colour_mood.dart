/// Colour Card mood options for the Dashboard (spec v3.0).
enum ColourMood {
  green,
  yellow,
  orange,
  red,
  purple,
  black,
  brown,
  sparkle,
}

extension ColourMoodX on ColourMood {
  String get id => name;

  String get label {
    switch (this) {
      case ColourMood.green:
        return 'Green';
      case ColourMood.yellow:
        return 'Yellow';
      case ColourMood.orange:
        return 'Orange';
      case ColourMood.red:
        return 'Red';
      case ColourMood.purple:
        return 'Purple';
      case ColourMood.black:
        return 'Black';
      case ColourMood.brown:
        return 'Brown';
      case ColourMood.sparkle:
        return 'Sparkle';
    }
  }

  String get meaning {
    switch (this) {
      case ColourMood.green:
        return 'Open to talk';
      case ColourMood.yellow:
        return 'Guarded · Keep it light';
      case ColourMood.orange:
        return 'On edge · Fragile';
      case ColourMood.red:
        return 'Stop · Need space';
      case ColourMood.purple:
        return 'Connect · Closeness';
      case ColourMood.black:
        return 'Shutdown · Unavailable';
      case ColourMood.brown:
        return 'Process · Need time';
      case ColourMood.sparkle:
        return 'Productive · In the zone';
    }
  }

  String get emoji {
    switch (this) {
      case ColourMood.green:
        return '🟢';
      case ColourMood.yellow:
        return '🟡';
      case ColourMood.orange:
        return '🟠';
      case ColourMood.red:
        return '🔴';
      case ColourMood.purple:
        return '🟣';
      case ColourMood.black:
        return '⚫';
      case ColourMood.brown:
        return '🟤';
      case ColourMood.sparkle:
        return '✨';
    }
  }

  static ColourMood fromId(String? id) {
    return ColourMood.values.firstWhere(
      (m) => m.id == id,
      orElse: () => ColourMood.green,
    );
  }
}
