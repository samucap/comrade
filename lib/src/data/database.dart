import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import '../core/rive_controller.dart';

part 'database.g.dart';

/// Drift database for storing chat messages
@DriftDatabase(tables: [Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _populateInitialData();
        },
      );

  /// Get all messages ordered by timestamp
  Future<List<Message>> getAllMessages() {
    return (select(messages)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
        .get();
  }

  /// Insert a new message
  Future<int> insertMessage(MessagesCompanion message) {
    return into(messages).insert(message);
  }

  /// Delete all messages
  Future<int> deleteAllMessages() {
    return delete(messages).go();
  }

  /// Get messages after a specific timestamp
  Future<List<Message>> getMessagesAfter(DateTime timestamp) {
    return (select(messages)
          ..where((t) => t.timestamp.isBiggerThanValue(timestamp))
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]))
        .get();
  }

  /// Pre-populate database with mock conversation
  Future<void> _populateInitialData() async {
    final mockMessages = [
      MessagesCompanion.insert(
        content: 'Hey there! I\'m your voice companion. How are you feeling today?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        emotion: const Value(0), // AvatarEmotion.happy
      ),
      MessagesCompanion.insert(
        content: 'I\'m doing great, thanks for asking! This is such a cool app.',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      MessagesCompanion.insert(
        content: 'That\'s awesome! I\'m glad you\'re enjoying our conversation. What would you like to talk about?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        emotion: const Value(1), // AvatarEmotion.smirk
      ),
      MessagesCompanion.insert(
        content: 'Tell me something interesting about yourself!',
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      MessagesCompanion.insert(
        content: 'Well, I love learning new things and having meaningful conversations. My favorite hobbies include listening to music and exploring new ideas!',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        emotion: const Value(4), // AvatarEmotion.heartEyes
      ),
    ];

    for (final message in mockMessages) {
      await into(messages).insert(message);
    }
  }
}

/// Messages table definition
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  BoolColumn get isUser => boolean()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get emotion => integer().nullable()();
}

/// Extension to convert between AvatarEmotion enum and database int
extension AvatarEmotionDatabaseExtension on AvatarEmotion {
  int toDatabaseValue() => index;

  static AvatarEmotion? fromDatabaseValue(int? value) {
    if (value == null) return null;
    return AvatarEmotion.values[value];
  }
}

/// LazyDatabase connection using path_provider
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'comrade.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

