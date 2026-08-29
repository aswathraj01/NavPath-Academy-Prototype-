import 'package:flutter/foundation.dart';

/// Simple in-memory enrollment state.
/// Uses a ValueNotifier so widgets can listen for changes without Provider.
class EnrollmentState {
  EnrollmentState._();

  /// Singleton instance
  static final EnrollmentState instance = EnrollmentState._();

  /// Notifier holding the set of enrolled course IDs
  final ValueNotifier<Set<String>> enrolledIds =
      ValueNotifier<Set<String>>({});

  /// Enrol in a course
  void enroll(String courseId) {
    final updated = Set<String>.from(enrolledIds.value)..add(courseId);
    enrolledIds.value = updated;
  }

  /// Check if a course is enrolled
  bool isEnrolled(String courseId) => enrolledIds.value.contains(courseId);
}
