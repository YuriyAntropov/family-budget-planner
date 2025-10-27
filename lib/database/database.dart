import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Accounts, Transactions, Users, Families])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  Table get categories => _Categories();

  @override
  int get schemaVersion => 1;

  // Методи для роботи з рахунками
  Future<List<Account>> getAccounts(String familyId) {
    return (select(accounts)..where((a) => a.familyId.equals(familyId))).get();
  }
  Future<Account?> getAccountByAccountId(String accountId) async {
    return (select(accounts)..where((a) => a.accountId.equals(accountId))).getSingleOrNull();
  }
  Future<void> deleteTransaction(int id) async {
    await (delete(transactions)..where((t) => t.id.equals(id))).go();
  }
  Future<List<Transaction>> getTransactionByServerId(String serverId) async {
    return (select(transactions)..where((t) => t.serverId.equals(serverId))).get();
  }
  Future<bool> updateTransactionByServerId(String serverId, TransactionsCompanion transaction) async {
    return (update(transactions)..where((t) => t.serverId.equals(serverId))).replace(transaction);
  }
  Future<int> deleteAccount(int id) async {
    return (delete(accounts)..where((a) => a.id.equals(id))).go();
  }
  Future<Account?> getAccountById(String accountId) {
    return (select(accounts)..where((a) => a.accountId.equals(accountId))).getSingleOrNull();
  }
  Future<int> insertAccount(AccountsCompanion account) {
    return into(accounts).insert(account);
  }
  Future<bool> updateAccount(AccountsCompanion account) {
    return update(accounts).replace(account);
  }

  // Методи для роботи з транзакціями
  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }
  Future<List<Transaction>> getTransactions(String familyId) {
    return (select(transactions)..where((t) => t.familyId.equals(familyId))).get();
  }

  // Методи для роботи з користувачами
  Future<User?> getUserByEmail(String email) {
    return (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();
  }
  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  // Методи для роботи з сім'ями
  Future<Family?> getFamilyById(String familyId) {
    return (select(families)..where((f) => f.serverId.equals(familyId))).getSingleOrNull();
  }
  Future<int> insertFamily(FamiliesCompanion family) {
    return into(families).insert(family);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'family_budget.sqlite'));
    return NativeDatabase(file);
  });
}

class _Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isExpense => boolean()();
  TextColumn get familyId => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
