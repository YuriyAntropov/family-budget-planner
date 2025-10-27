// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        accountId,
        name,
        balance,
        currency,
        userId,
        familyId,
        synced,
        lastUpdated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance']),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated']),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String? serverId;
  final String accountId;
  final String? name;
  final double? balance;
  final String? currency;
  final String? userId;
  final String? familyId;
  final bool synced;
  final DateTime? lastUpdated;
  const Account(
      {required this.id,
      this.serverId,
      required this.accountId,
      this.name,
      this.balance,
      this.currency,
      this.userId,
      this.familyId,
      required this.synced,
      this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || balance != null) {
      map['balance'] = Variable<double>(balance);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || familyId != null) {
      map['family_id'] = Variable<String>(familyId);
    }
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      accountId: Value(accountId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      balance: balance == null && nullToAbsent
          ? const Value.absent()
          : Value(balance),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      familyId: familyId == null && nullToAbsent
          ? const Value.absent()
          : Value(familyId),
      synced: Value(synced),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      name: serializer.fromJson<String?>(json['name']),
      balance: serializer.fromJson<double?>(json['balance']),
      currency: serializer.fromJson<String?>(json['currency']),
      userId: serializer.fromJson<String?>(json['userId']),
      familyId: serializer.fromJson<String?>(json['familyId']),
      synced: serializer.fromJson<bool>(json['synced']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'accountId': serializer.toJson<String>(accountId),
      'name': serializer.toJson<String?>(name),
      'balance': serializer.toJson<double?>(balance),
      'currency': serializer.toJson<String?>(currency),
      'userId': serializer.toJson<String?>(userId),
      'familyId': serializer.toJson<String?>(familyId),
      'synced': serializer.toJson<bool>(synced),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  Account copyWith(
          {int? id,
          Value<String?> serverId = const Value.absent(),
          String? accountId,
          Value<String?> name = const Value.absent(),
          Value<double?> balance = const Value.absent(),
          Value<String?> currency = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          Value<String?> familyId = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastUpdated = const Value.absent()}) =>
      Account(
        id: id ?? this.id,
        serverId: serverId.present ? serverId.value : this.serverId,
        accountId: accountId ?? this.accountId,
        name: name.present ? name.value : this.name,
        balance: balance.present ? balance.value : this.balance,
        currency: currency.present ? currency.value : this.currency,
        userId: userId.present ? userId.value : this.userId,
        familyId: familyId.present ? familyId.value : this.familyId,
        synced: synced ?? this.synced,
        lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('userId: $userId, ')
          ..write('familyId: $familyId, ')
          ..write('synced: $synced, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serverId, accountId, name, balance,
      currency, userId, familyId, synced, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.balance == this.balance &&
          other.currency == this.currency &&
          other.userId == this.userId &&
          other.familyId == this.familyId &&
          other.synced == this.synced &&
          other.lastUpdated == this.lastUpdated);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String?> serverId;
  final Value<String> accountId;
  final Value<String?> name;
  final Value<double?> balance;
  final Value<String?> currency;
  final Value<String?> userId;
  final Value<String?> familyId;
  final Value<bool> synced;
  final Value<DateTime?> lastUpdated;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.userId = const Value.absent(),
    this.familyId = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required String accountId,
    this.name = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.userId = const Value.absent(),
    this.familyId = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  }) : accountId = Value(accountId);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? accountId,
    Expression<String>? name,
    Expression<double>? balance,
    Expression<String>? currency,
    Expression<String>? userId,
    Expression<String>? familyId,
    Expression<bool>? synced,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
      if (userId != null) 'user_id': userId,
      if (familyId != null) 'family_id': familyId,
      if (synced != null) 'synced': synced,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  AccountsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? serverId,
      Value<String>? accountId,
      Value<String?>? name,
      Value<double?>? balance,
      Value<String?>? currency,
      Value<String?>? userId,
      Value<String?>? familyId,
      Value<bool>? synced,
      Value<DateTime?>? lastUpdated}) {
    return AccountsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      userId: userId ?? this.userId,
      familyId: familyId ?? this.familyId,
      synced: synced ?? this.synced,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('userId: $userId, ')
          ..write('familyId: $familyId, ')
          ..write('synced: $synced, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isExpenseMeta =
      const VerificationMeta('isExpense');
  @override
  late final GeneratedColumn<bool> isExpense = GeneratedColumn<bool>(
      'is_expense', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_expense" IN (0, 1))'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _geoTagMeta = const VerificationMeta('geoTag');
  @override
  late final GeneratedColumn<String> geoTag = GeneratedColumn<String>(
      'geo_tag', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        amount,
        category,
        isExpense,
        date,
        accountId,
        userId,
        familyId,
        notes,
        geoTag,
        synced,
        lastUpdated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_expense')) {
      context.handle(_isExpenseMeta,
          isExpense.isAcceptableOrUnknown(data['is_expense']!, _isExpenseMeta));
    } else if (isInserting) {
      context.missing(_isExpenseMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('geo_tag')) {
      context.handle(_geoTagMeta,
          geoTag.isAcceptableOrUnknown(data['geo_tag']!, _geoTagMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      isExpense: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_expense'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      geoTag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}geo_tag']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final String? serverId;
  final double? amount;
  final String? category;
  final bool isExpense;
  final DateTime? date;
  final String? accountId;
  final String? userId;
  final String? familyId;
  final String? notes;
  final String? geoTag;
  final bool synced;
  final DateTime? lastUpdated;
  const Transaction(
      {required this.id,
      this.serverId,
      this.amount,
      this.category,
      required this.isExpense,
      this.date,
      this.accountId,
      this.userId,
      this.familyId,
      this.notes,
      this.geoTag,
      required this.synced,
      this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['is_expense'] = Variable<bool>(isExpense);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || familyId != null) {
      map['family_id'] = Variable<String>(familyId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || geoTag != null) {
      map['geo_tag'] = Variable<String>(geoTag);
    }
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      isExpense: Value(isExpense),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      familyId: familyId == null && nullToAbsent
          ? const Value.absent()
          : Value(familyId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      geoTag:
          geoTag == null && nullToAbsent ? const Value.absent() : Value(geoTag),
      synced: Value(synced),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      amount: serializer.fromJson<double?>(json['amount']),
      category: serializer.fromJson<String?>(json['category']),
      isExpense: serializer.fromJson<bool>(json['isExpense']),
      date: serializer.fromJson<DateTime?>(json['date']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      userId: serializer.fromJson<String?>(json['userId']),
      familyId: serializer.fromJson<String?>(json['familyId']),
      notes: serializer.fromJson<String?>(json['notes']),
      geoTag: serializer.fromJson<String?>(json['geoTag']),
      synced: serializer.fromJson<bool>(json['synced']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'amount': serializer.toJson<double?>(amount),
      'category': serializer.toJson<String?>(category),
      'isExpense': serializer.toJson<bool>(isExpense),
      'date': serializer.toJson<DateTime?>(date),
      'accountId': serializer.toJson<String?>(accountId),
      'userId': serializer.toJson<String?>(userId),
      'familyId': serializer.toJson<String?>(familyId),
      'notes': serializer.toJson<String?>(notes),
      'geoTag': serializer.toJson<String?>(geoTag),
      'synced': serializer.toJson<bool>(synced),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  Transaction copyWith(
          {int? id,
          Value<String?> serverId = const Value.absent(),
          Value<double?> amount = const Value.absent(),
          Value<String?> category = const Value.absent(),
          bool? isExpense,
          Value<DateTime?> date = const Value.absent(),
          Value<String?> accountId = const Value.absent(),
          Value<String?> userId = const Value.absent(),
          Value<String?> familyId = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> geoTag = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastUpdated = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        serverId: serverId.present ? serverId.value : this.serverId,
        amount: amount.present ? amount.value : this.amount,
        category: category.present ? category.value : this.category,
        isExpense: isExpense ?? this.isExpense,
        date: date.present ? date.value : this.date,
        accountId: accountId.present ? accountId.value : this.accountId,
        userId: userId.present ? userId.value : this.userId,
        familyId: familyId.present ? familyId.value : this.familyId,
        notes: notes.present ? notes.value : this.notes,
        geoTag: geoTag.present ? geoTag.value : this.geoTag,
        synced: synced ?? this.synced,
        lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('isExpense: $isExpense, ')
          ..write('date: $date, ')
          ..write('accountId: $accountId, ')
          ..write('userId: $userId, ')
          ..write('familyId: $familyId, ')
          ..write('notes: $notes, ')
          ..write('geoTag: $geoTag, ')
          ..write('synced: $synced, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serverId, amount, category, isExpense,
      date, accountId, userId, familyId, notes, geoTag, synced, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.isExpense == this.isExpense &&
          other.date == this.date &&
          other.accountId == this.accountId &&
          other.userId == this.userId &&
          other.familyId == this.familyId &&
          other.notes == this.notes &&
          other.geoTag == this.geoTag &&
          other.synced == this.synced &&
          other.lastUpdated == this.lastUpdated);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String?> serverId;
  final Value<double?> amount;
  final Value<String?> category;
  final Value<bool> isExpense;
  final Value<DateTime?> date;
  final Value<String?> accountId;
  final Value<String?> userId;
  final Value<String?> familyId;
  final Value<String?> notes;
  final Value<String?> geoTag;
  final Value<bool> synced;
  final Value<DateTime?> lastUpdated;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.isExpense = const Value.absent(),
    this.date = const Value.absent(),
    this.accountId = const Value.absent(),
    this.userId = const Value.absent(),
    this.familyId = const Value.absent(),
    this.notes = const Value.absent(),
    this.geoTag = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    required bool isExpense,
    this.date = const Value.absent(),
    this.accountId = const Value.absent(),
    this.userId = const Value.absent(),
    this.familyId = const Value.absent(),
    this.notes = const Value.absent(),
    this.geoTag = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  }) : isExpense = Value(isExpense);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<bool>? isExpense,
    Expression<DateTime>? date,
    Expression<String>? accountId,
    Expression<String>? userId,
    Expression<String>? familyId,
    Expression<String>? notes,
    Expression<String>? geoTag,
    Expression<bool>? synced,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (isExpense != null) 'is_expense': isExpense,
      if (date != null) 'date': date,
      if (accountId != null) 'account_id': accountId,
      if (userId != null) 'user_id': userId,
      if (familyId != null) 'family_id': familyId,
      if (notes != null) 'notes': notes,
      if (geoTag != null) 'geo_tag': geoTag,
      if (synced != null) 'synced': synced,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? serverId,
      Value<double?>? amount,
      Value<String?>? category,
      Value<bool>? isExpense,
      Value<DateTime?>? date,
      Value<String?>? accountId,
      Value<String?>? userId,
      Value<String?>? familyId,
      Value<String?>? notes,
      Value<String?>? geoTag,
      Value<bool>? synced,
      Value<DateTime?>? lastUpdated}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      isExpense: isExpense ?? this.isExpense,
      date: date ?? this.date,
      accountId: accountId ?? this.accountId,
      userId: userId ?? this.userId,
      familyId: familyId ?? this.familyId,
      notes: notes ?? this.notes,
      geoTag: geoTag ?? this.geoTag,
      synced: synced ?? this.synced,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isExpense.present) {
      map['is_expense'] = Variable<bool>(isExpense.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (geoTag.present) {
      map['geo_tag'] = Variable<String>(geoTag.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('isExpense: $isExpense, ')
          ..write('date: $date, ')
          ..write('accountId: $accountId, ')
          ..write('userId: $userId, ')
          ..write('familyId: $familyId, ')
          ..write('notes: $notes, ')
          ..write('geoTag: $geoTag, ')
          ..write('synced: $synced, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncMeta =
      const VerificationMeta('lastSync');
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
      'last_sync', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastOnlineMeta =
      const VerificationMeta('lastOnline');
  @override
  late final GeneratedColumn<DateTime> lastOnline = GeneratedColumn<DateTime>(
      'last_online', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        email,
        role,
        familyId,
        synced,
        lastUpdated,
        lastSync,
        lastOnline
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    if (data.containsKey('last_sync')) {
      context.handle(_lastSyncMeta,
          lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta));
    }
    if (data.containsKey('last_online')) {
      context.handle(
          _lastOnlineMeta,
          lastOnline.isAcceptableOrUnknown(
              data['last_online']!, _lastOnlineMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role']),
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated']),
      lastSync: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync']),
      lastOnline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_online']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String? serverId;
  final String? email;
  final String? role;
  final String? familyId;
  final bool synced;
  final DateTime? lastUpdated;
  final DateTime? lastSync;
  final DateTime? lastOnline;
  const User(
      {required this.id,
      this.serverId,
      this.email,
      this.role,
      this.familyId,
      required this.synced,
      this.lastUpdated,
      this.lastSync,
      this.lastOnline});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || familyId != null) {
      map['family_id'] = Variable<String>(familyId);
    }
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    if (!nullToAbsent || lastOnline != null) {
      map['last_online'] = Variable<DateTime>(lastOnline);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      familyId: familyId == null && nullToAbsent
          ? const Value.absent()
          : Value(familyId),
      synced: Value(synced),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
      lastOnline: lastOnline == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOnline),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      email: serializer.fromJson<String?>(json['email']),
      role: serializer.fromJson<String?>(json['role']),
      familyId: serializer.fromJson<String?>(json['familyId']),
      synced: serializer.fromJson<bool>(json['synced']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
      lastOnline: serializer.fromJson<DateTime?>(json['lastOnline']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'email': serializer.toJson<String?>(email),
      'role': serializer.toJson<String?>(role),
      'familyId': serializer.toJson<String?>(familyId),
      'synced': serializer.toJson<bool>(synced),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
      'lastOnline': serializer.toJson<DateTime?>(lastOnline),
    };
  }

  User copyWith(
          {int? id,
          Value<String?> serverId = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> role = const Value.absent(),
          Value<String?> familyId = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastUpdated = const Value.absent(),
          Value<DateTime?> lastSync = const Value.absent(),
          Value<DateTime?> lastOnline = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        serverId: serverId.present ? serverId.value : this.serverId,
        email: email.present ? email.value : this.email,
        role: role.present ? role.value : this.role,
        familyId: familyId.present ? familyId.value : this.familyId,
        synced: synced ?? this.synced,
        lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
        lastSync: lastSync.present ? lastSync.value : this.lastSync,
        lastOnline: lastOnline.present ? lastOnline.value : this.lastOnline,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('familyId: $familyId, ')
          ..write('synced: $synced, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('lastSync: $lastSync, ')
          ..write('lastOnline: $lastOnline')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serverId, email, role, familyId, synced,
      lastUpdated, lastSync, lastOnline);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.email == this.email &&
          other.role == this.role &&
          other.familyId == this.familyId &&
          other.synced == this.synced &&
          other.lastUpdated == this.lastUpdated &&
          other.lastSync == this.lastSync &&
          other.lastOnline == this.lastOnline);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String?> serverId;
  final Value<String?> email;
  final Value<String?> role;
  final Value<String?> familyId;
  final Value<bool> synced;
  final Value<DateTime?> lastUpdated;
  final Value<DateTime?> lastSync;
  final Value<DateTime?> lastOnline;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.familyId = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.lastOnline = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.familyId = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.lastOnline = const Value.absent(),
  });
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? email,
    Expression<String>? role,
    Expression<String>? familyId,
    Expression<bool>? synced,
    Expression<DateTime>? lastUpdated,
    Expression<DateTime>? lastSync,
    Expression<DateTime>? lastOnline,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (familyId != null) 'family_id': familyId,
      if (synced != null) 'synced': synced,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (lastSync != null) 'last_sync': lastSync,
      if (lastOnline != null) 'last_online': lastOnline,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String?>? serverId,
      Value<String?>? email,
      Value<String?>? role,
      Value<String?>? familyId,
      Value<bool>? synced,
      Value<DateTime?>? lastUpdated,
      Value<DateTime?>? lastSync,
      Value<DateTime?>? lastOnline}) {
    return UsersCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      email: email ?? this.email,
      role: role ?? this.role,
      familyId: familyId ?? this.familyId,
      synced: synced ?? this.synced,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastSync: lastSync ?? this.lastSync,
      lastOnline: lastOnline ?? this.lastOnline,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (lastOnline.present) {
      map['last_online'] = Variable<DateTime>(lastOnline.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('familyId: $familyId, ')
          ..write('synced: $synced, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('lastSync: $lastSync, ')
          ..write('lastOnline: $lastOnline')
          ..write(')'))
        .toString();
  }
}

class $FamiliesTable extends Families with TableInfo<$FamiliesTable, Family> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamiliesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _adminIdMeta =
      const VerificationMeta('adminId');
  @override
  late final GeneratedColumn<String> adminId = GeneratedColumn<String>(
      'admin_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, serverId, name, adminId, synced, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'families';
  @override
  VerificationContext validateIntegrity(Insertable<Family> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('admin_id')) {
      context.handle(_adminIdMeta,
          adminId.isAcceptableOrUnknown(data['admin_id']!, _adminIdMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Family map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Family(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      adminId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}admin_id']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated']),
    );
  }

  @override
  $FamiliesTable createAlias(String alias) {
    return $FamiliesTable(attachedDatabase, alias);
  }
}

class Family extends DataClass implements Insertable<Family> {
  final int id;
  final String serverId;
  final String? name;
  final String? adminId;
  final bool synced;
  final DateTime? lastUpdated;
  const Family(
      {required this.id,
      required this.serverId,
      this.name,
      this.adminId,
      required this.synced,
      this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_id'] = Variable<String>(serverId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || adminId != null) {
      map['admin_id'] = Variable<String>(adminId);
    }
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  FamiliesCompanion toCompanion(bool nullToAbsent) {
    return FamiliesCompanion(
      id: Value(id),
      serverId: Value(serverId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      adminId: adminId == null && nullToAbsent
          ? const Value.absent()
          : Value(adminId),
      synced: Value(synced),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory Family.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Family(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      name: serializer.fromJson<String?>(json['name']),
      adminId: serializer.fromJson<String?>(json['adminId']),
      synced: serializer.fromJson<bool>(json['synced']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String>(serverId),
      'name': serializer.toJson<String?>(name),
      'adminId': serializer.toJson<String?>(adminId),
      'synced': serializer.toJson<bool>(synced),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  Family copyWith(
          {int? id,
          String? serverId,
          Value<String?> name = const Value.absent(),
          Value<String?> adminId = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastUpdated = const Value.absent()}) =>
      Family(
        id: id ?? this.id,
        serverId: serverId ?? this.serverId,
        name: name.present ? name.value : this.name,
        adminId: adminId.present ? adminId.value : this.adminId,
        synced: synced ?? this.synced,
        lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('Family(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('adminId: $adminId, ')
          ..write('synced: $synced, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, serverId, name, adminId, synced, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Family &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.adminId == this.adminId &&
          other.synced == this.synced &&
          other.lastUpdated == this.lastUpdated);
}

class FamiliesCompanion extends UpdateCompanion<Family> {
  final Value<int> id;
  final Value<String> serverId;
  final Value<String?> name;
  final Value<String?> adminId;
  final Value<bool> synced;
  final Value<DateTime?> lastUpdated;
  const FamiliesCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.adminId = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  FamiliesCompanion.insert({
    this.id = const Value.absent(),
    required String serverId,
    this.name = const Value.absent(),
    this.adminId = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  }) : serverId = Value(serverId);
  static Insertable<Family> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? name,
    Expression<String>? adminId,
    Expression<bool>? synced,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (adminId != null) 'admin_id': adminId,
      if (synced != null) 'synced': synced,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  FamiliesCompanion copyWith(
      {Value<int>? id,
      Value<String>? serverId,
      Value<String?>? name,
      Value<String?>? adminId,
      Value<bool>? synced,
      Value<DateTime?>? lastUpdated}) {
    return FamiliesCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      adminId: adminId ?? this.adminId,
      synced: synced ?? this.synced,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (adminId.present) {
      map['admin_id'] = Variable<String>(adminId.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamiliesCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('adminId: $adminId, ')
          ..write('synced: $synced, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $FamiliesTable families = $FamiliesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [accounts, transactions, users, families];
}
