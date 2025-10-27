import 'package:drift/drift.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  TextColumn get accountId => text().unique()();
  TextColumn get name => text().nullable()();
  RealColumn get balance => real().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get userId => text().nullable()();
  TextColumn get familyId => text().nullable()();
  TextColumn get accessibleToUsers => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get category => text().nullable()();
  BoolColumn get isExpense => boolean()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get accountId => text().nullable()();
  TextColumn get userId => text().nullable()();
  TextColumn get familyId => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get geoTag => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get role => text().nullable()();
  TextColumn get familyId => text().nullable()();
  TextColumn get permissions => text().nullable()();
  TextColumn get deviceModel => text().nullable()();
  TextColumn get deviceLocation => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
  DateTimeColumn get lastSync => dateTime().nullable()();
  DateTimeColumn get lastOnline => dateTime().nullable()();
}

class Families extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text().unique()();
  TextColumn get name => text().nullable()();
  TextColumn get adminId => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
  TextColumn get inviteCode => text().nullable()();
  TextColumn get pendingMembers => text().nullable()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isExpense => boolean()(); // true для витрат, false для доходів
  TextColumn get userId => text().nullable()();
  TextColumn get familyId => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}