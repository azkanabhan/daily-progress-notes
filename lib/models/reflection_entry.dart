import 'mood.dart';

class ReflectionEntry {
  final int? id;
  final String whatMadeBetter;
  final String whatToImprove;
  final Mood? mood;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReflectionEntry({
    this.id,
    required this.whatMadeBetter,
    required this.whatToImprove,
    this.mood,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'what_made_better': whatMadeBetter,
      'what_to_improve': whatToImprove,
      'mood': mood?.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ReflectionEntry.fromMap(Map<String, dynamic> map) {
    return ReflectionEntry(
      id: map['id'] as int?,
      whatMadeBetter: map['what_made_better'] as String,
      whatToImprove: map['what_to_improve'] as String,
      mood: map['mood'] != null ? Mood.fromValue(map['mood'] as int) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  ReflectionEntry copyWith({
    int? id,
    String? whatMadeBetter,
    String? whatToImprove,
    Mood? mood,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReflectionEntry(
      id: id ?? this.id,
      whatMadeBetter: whatMadeBetter ?? this.whatMadeBetter,
      whatToImprove: whatToImprove ?? this.whatToImprove,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

