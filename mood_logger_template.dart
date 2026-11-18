/// Lab 2 Individual Assignment (A2) -- CLI Mood Logger (TEMPLATE)
///
/// Build a command-line mood tracking application.
/// Implement all the TODO sections below.
///
/// Run with: dart run mood_logger_template.dart
///
/// Requirements:
///   - MoodEntry class to represent a single mood log
///   - MoodLogger class to manage a collection of entries
///   - Interactive CLI with a menu loop
///
/// Do NOT use AI tools. Write all code yourself.

import 'dart:io';

// ============================================================================
// MoodEntry Class
// ============================================================================

/// Represents a single mood log entry.
///
/// Fields:
///   - DateTime createdAt  -- when the entry was created
///   - int score           -- mood score from 1 (very bad) to 10 (excellent)
///   - String? note        -- an optional short description of the mood;
///                            null when the user wrote nothing
///
/// The Flutter Mood Tracker you build from Lab 3 onwards uses the same three
/// fields, so this class carries over almost unchanged.
class MoodEntry {
  // TODO: declare final fields (createdAt, score, note)
  late final DateTime createdAt;
  final int score;
  final String? note;

  // TODO: create a constructor that takes score and an optional note,
  //       and sets createdAt to DateTime.now()
  MoodEntry(this.score, [this.note]) {
    createdAt = DateTime.now();
  }

  /// Returns a formatted string representation of this entry.
  /// Format: "[YYYY-MM-DD HH:MM] Score: <score>/10 - <note>"
  /// When there is no note, show "(no note)" in its place.
  ///
  /// Examples:
  ///   "[2026-02-22 14:30] Score: 7/10 - Productive day at the lab"
  ///   "[2026-02-22 21:05] Score: 4/10 - (no note)"
  @override
  String toString() {
    // TODO: implement
    // Hint: use createdAt.year, .month, .day, .hour, .minute
    //       and ?? to substitute "(no note)" for a null note
    //       and .toString().padLeft(2, '0') to format with leading zeros
    return '[${createdAt.toString().substring(0, 16)}] Score: $score/10 - ${note ?? "(no note)"}';
  }
}

// ============================================================================
// MoodLogger Class
// ============================================================================

/// Manages a collection of MoodEntry objects.
class MoodLogger {
  // TODO: declare a private list to store MoodEntry objects
  final List<MoodEntry> _entries = [];

  /// Adds a new mood entry with the given score and optional note.
  ///
  /// Validates that score is between 1 and 10 (inclusive).
  /// If invalid, prints an error message and does NOT add the entry.
  /// A note that is empty or only spaces is stored as null.
  void addEntry(int score, String? note) {
    if (score <= 10 && score >= 1) {
      if (note != null && note.trim().isEmpty) note = null;
      _entries.add(MoodEntry(score, note));
    } else {
      print("Error");
    }
  }

  /// Returns a copy of all entries.
  List<MoodEntry> getAllEntries() {
    // TODO: return a copy of the entries list
    // Hint: return List.from(_entries);
    return List.from(_entries);
  }

  /// Calculates and returns the average mood score.
  ///
  /// Returns null if there are no entries: there is no average to report,
  /// and 0.0 would look like a real (very bad) score.
  double? getAverageScore() {
    // TODO: implement
    // Hint: return null for an empty list; otherwise use fold() to sum
    //       the scores, then divide by length
    if (_entries.isEmpty) return null;
    return _entries.fold(0, (a, b) => a + b.score) / _entries.length;
  }

  /// Returns all entries with a score greater than or equal to [threshold].
  List<MoodEntry> getEntriesAbove(int threshold) {
    // TODO: implement using .where()
    return _entries.where((a) => a.score >= threshold).toList();
  }

  /// Returns the total number of entries.
  int get entryCount {
    // TODO: implement
    return _entries.length;
  }
}

// ============================================================================
// Main -- Interactive CLI
// ============================================================================

void main() {
  final logger = MoodLogger();
  bool quit = false;
  print('=== Mood Logger ===');
  print('Track your daily mood on a scale of 1-10.\n');

  // TODO: implement a loop that displays a menu and handles user input.
  while (quit == false) {
    print('''Menu options:
     1. Add mood entry
     2. View all entries
     3. View average mood
     4. Filter by minimum score
     5. Quit''');
    stdout.write('\nChoose an option: ');
    String? input = stdin.readLineSync();
    int? choice = int.tryParse(input ?? '');
    switch (choice) {
      case 1:
        stdout.write("\nEnter the new entry's score: ");
        input = stdin.readLineSync();
        int score = int.tryParse(input ?? '0') ?? 0;
        stdout.write("\nEnter note: ");
        String? note = stdin.readLineSync();
        logger.addEntry(score, note);
        stdout.write("\nNew entry added.");
        break;

      case 2:
        if (logger.getAllEntries().isEmpty) {
          print("No entries added yet.");
        } else {
          List<MoodEntry> entries = logger.getAllEntries();
          String result = '';
          for (MoodEntry entry in entries) {
            result += "$entry\n";
          }
          print(result);
        }
        break;

      case 3:
        if (logger.getAverageScore() == null) {
          print("No entries yet.");
        } else {
          print("Average score: ${logger.getAverageScore()}");
        }
        break;

      case 4:
        stdout.write("\nEnter minimum score: ");
        input = stdin.readLineSync();
        int threshold = int.tryParse(input ?? '0') ?? 0;
        if (logger.getEntriesAbove(threshold).isEmpty) {
          print("No entries with a score above $threshold.");
        } else {
          List<MoodEntry> entries = logger.getEntriesAbove(threshold);
          String result = '';
          for (MoodEntry entry in entries) {
            result += "$entry\n";
          }
          print(result);
        }

        break;

      case 5:
        quit = true;
        print("Exiting app...");
        break;

      default:
        print("Invalid option");
        break;
    }
  }
  // Menu options:
  //   1. Add mood entry
  //   2. View all entries
  //   3. View average mood
  //   4. Filter by minimum score
  //   5. Quit
  //
  // Use stdin.readLineSync() to read user input.
  // Use int.tryParse() to safely convert string input to int.
  //
  // Skeleton:
  //
  // bool running = true;
  // while (running) {
  //   print('1. Add mood entry');
  //   print('2. View all entries');
  //   print('3. View average mood');
  //   print('4. Filter by minimum score');
  //   print('5. Quit');
  //   stdout.write('\nChoose an option: ');
  //
  //   String? input = stdin.readLineSync();
  //   int? choice = int.tryParse(input ?? '');
  //
  //   switch (choice) {
  //     case 1:
  //       // TODO: prompt for score and note (Enter for no note),
  //       //       call logger.addEntry()
  //       break;
  //     case 2:
  //       // TODO: get all entries, print each one (or "No entries yet.")
  //       break;
  //     case 3:
  //       // TODO: print the average score, or a message when
  //       //       getAverageScore() returns null
  //       break;
  //     case 4:
  //       // TODO: prompt for threshold, get filtered entries, print them
  //       break;
  //     case 5:
  //       running = false;
  //       print('Goodbye!');
  //       break;
  //     default:
  //       print('Invalid option. Please choose 1-5.');
  //   }
  //   print('');
  // }

  print('(Implement the interactive menu above)');
}
