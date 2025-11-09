enum Mood {
  veryHappy('😄', 'Sangat Bahagia', 5),
  happy('😊', 'Bahagia', 4),
  neutral('😐', 'Biasa Saja', 3),
  sad('😔', 'Sedih', 2),
  verySad('😢', 'Sangat Sedih', 1);

  final String emoji;
  final String label;
  final int value;

  const Mood(this.emoji, this.label, this.value);

  static Mood fromValue(int value) {
    return Mood.values.firstWhere(
      (mood) => mood.value == value,
      orElse: () => Mood.neutral,
    );
  }
}

