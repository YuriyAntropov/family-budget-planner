import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/database.dart';
import '../models/account.dart' as model_account;
import '../models/transaction.dart' as model_transaction;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user.dart' as model_user;
import '../models/family.dart' as model_family;
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:firebase_auth/firebase_auth.dart';
import '../services/encryption_service.dart';
import 'dart:math';
import 'dart:convert';
import 'cache_service.dart';

class DbService {
  final AppDatabase database;
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  final _uuid = const Uuid();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final EncryptionService _encryptionService = EncryptionService();
  final CacheService _cache = CacheService();

  DbService(this.database) {
    _encryptionService.initialize();
  }
  // інфа про пристрій
  Future<String> getDeviceModel() async {
    try {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      return '${androidInfo.brand} ${androidInfo.model}';
    } catch (e) {
      return 'Невідомий пристрій';
    }
  }

  Future<bool> requestJoinFamily(String inviteCode, String userId, String email) async {
    try {
      // Шук сім'ю за кодом без авторизації!
      final querySnapshot = await _firestore.collection('families')
          .where('inviteCode', isEqualTo: inviteCode)
          .get();
      if (querySnapshot.docs.isEmpty) {
        print('Сім\'ю з кодом $inviteCode не знайдено');
        return false;
      }

      final familyDoc = querySnapshot.docs.first;
      final familyData = familyDoc.data();

      // існує pendingMembers?
      List<dynamic> pendingMembers = List.from(familyData['pendingMembers'] ?? []);

      // до списку очікування
      final deviceModel = await getDeviceModel();
      final deviceLocation = await getDeviceLocation();

      pendingMembers.add({
        'userId': userId,
        'email': email,
        'deviceModel': deviceModel,
        'deviceLocation': deviceLocation,
        'requestDate': DateTime.now().toIso8601String(),
      });
      await familyDoc.reference.update({
        'pendingMembers': pendingMembers,
      });
      return true;
    } catch (e) {
      print('Помилка запиту на приєднання до сім\'ї: $e');
      return false;
    }
  }

  Future<model_account.Account?> getAccountById(String accountId) async {
    try {
      final account = await database.getAccountByAccountId(accountId);
      if (account == null) return null;
      return model_account.Account(
        id: account.id,
        serverId: account.serverId,
        accountId: account.accountId,
        name: account.name,
        balance: account.balance,
        currency: account.currency,
        userId: account.userId,
        familyId: account.familyId,
        synced: account.synced,
        lastUpdated: account.lastUpdated,
      );
    } catch (e) {
      print('Помилка отримання рахунку: $e');
      return null;
    }
  }

  Future<void> updateTransaction({
    required String transactionId,
    required double amount,
    required String category,
    required DateTime date,
    required String userId,
    required String familyId,
    required String accountId,
    required bool isExpense,
    String? notes,
    String? geoTag,
    String? currency,
  }) async {
    try {
      final transactionDoc = await _firestore.collection('transactions').doc(transactionId).get();
      if (!transactionDoc.exists) {
        print('Транзакцію не знайдено: $transactionId');
        return;
      }
      final oldData = transactionDoc.data();
      if (oldData == null) return;
      final oldAmount = oldData['amount'] as double;
      // рахунок
      final account = await database.getAccountByAccountId(accountId);
      if (account == null) {
        print('Рахунок не знайдено: $accountId');
        return;
      }
      final balanceDifference = isExpense
          ? oldAmount - amount  // Для витрат: нова сума більша? різниця -
          : amount - oldAmount; // Для доходів: нова сума більша? різниця+
      final newBalance = account.balance! + balanceDifference;

      // аптд баланс в локальній бд
      await database.updateAccount(
        AccountsCompanion(
          id: Value(account.id),
          accountId: Value(account.accountId),
          balance: Value(newBalance),
          lastUpdated: Value(DateTime.now()),
          synced: const Value(false),
        ),
      );
      await database.updateTransactionByServerId(
        transactionId,
        TransactionsCompanion(
          amount: Value(amount),
          category: Value(category),
          date: Value(date),
          notes: Value(notes),
          lastUpdated: Value(DateTime.now()),
          synced: const Value(false),
        ),
      );
      if (account.serverId != null) {
        await _firestore.collection('accounts').doc(account.serverId).update({
          'balance': newBalance,
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      }
      await _firestore.collection('transactions').doc(transactionId).update({
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'notes': notes,
        'currency': currency ?? 'UAH',
        'geoTag': geoTag,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
      await database.updateTransactionByServerId(
        transactionId,
        TransactionsCompanion(
          synced: const Value(true),
        ),
      );
    } catch (e) {
      print('Помилка оновлення транзакції: $e');
    }
  }

  Future<void> updateAccount({
    required String accountId,
    String? serverId,
    required String name,
    required double balance,
    required String currency,
    String? userId,
    required bool isShared,
  }) async {
    try {
      // разунок из локальной бд
      final account = await database.getAccountByAccountId(accountId);

      if (account == null) {
        print('Рахунок не знайдено');
        return;
      }
      // Онов рах в локальной базе
      await database.updateAccount(
        AccountsCompanion(
          id: Value(account.id),
          accountId: Value(accountId),
          name: Value(name),
          balance: Value(balance),
          currency: Value(currency),
          userId: userId != null ? Value(userId) : Value(account.userId),
          lastUpdated: Value(DateTime.now()),
          synced: const Value(false),
        ),
      );
      // Онов рах на серв
      if (account.serverId != null) {
        final updateData = {
          'name': name,
          'balance': balance,
          'currency': currency,
          'lastUpdated': DateTime.now().toIso8601String(),
        };
        if (userId != null) {
          updateData['userId'] = userId;
        }
        if (isShared != null) {
          updateData['isShared'] = isShared;
        }
        await _firestore.collection('accounts').doc(account.serverId).update(updateData);
        // синхронизований
        await database.updateAccount(
          AccountsCompanion(
            id: Value(account.id),
            accountId: Value(accountId),
            synced: const Value(true),
          ),
        );
      }
    } catch (e) {
      print('Помилка оновлення рахунку: $e');
    }
  }

  Future<bool> checkSyncStatus(String userId) async {
    try {
      // всі локальні дані синхронізовані????
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;
      await _firestore.collection('users').doc(userId).update({
        'lastSync': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Помилка перевірки синхронізації: $e');
      return false;
    }
  }

  Future<bool> acceptJoinRequest(
      String familyId,
      String userId,
      String email,
      String role,
      model_user.UserPermissions permissions,
      ) async {
    try {
      final familyDoc = await _firestore.collection('families').doc(familyId).get();

      if (!familyDoc.exists) {
        print('Сім\'ю не знайдено');
        return false;
      }
      final familyData = familyDoc.data();
      if (familyData == null) return false;
      final List<dynamic> pendingMembers = List.from(familyData['pendingMembers'] ?? []);
      final List<dynamic> members = List.from(familyData['members'] ?? []);

      int index = pendingMembers.indexWhere((member) => member['userId'] == userId);
      if (index == -1) {
        print('Користувача не знайдено в списку очікування');
        return false;
      }

      final memberData = pendingMembers[index];

      members.add({
        'userId': userId,
        'email': email,
        'role': role,
        'deviceModel': memberData['deviceModel'],
        'deviceLocation': memberData['deviceLocation'],
        'joinDate': DateTime.now().toIso8601String(),
      });
      pendingMembers.removeAt(index);
      await familyDoc.reference.update({
        'pendingMembers': pendingMembers,
        'members': members,
      });

      // КРИТИЧН!!! оновлюємо документ користувача
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'familyId': familyId,
        'role': role,
        'lastUpdated': DateTime.now().toIso8601String(),
      }, firestore.SetOptions(merge: true));
      print('Користувача $email успішно додано до сім\'ї $familyId');
      return true;
    } catch (e) {
      print('Помилка прийняття запиту на приєднання: $e');
      return false;
    }
  }

  Future<void> saveCategories(String familyId, List<String> categories, bool isExpense) async {
    try {
      await _firestore.collection('categories').doc(familyId).set({
        isExpense ? 'expenseCategories' : 'incomeCategories': categories,
        'lastUpdated': DateTime.now().toIso8601String(),
      }, firestore.SetOptions(merge: true));
      print('Категории успешно сохранены: $categories');
    } catch (e) {
      print('Ошибка при сохранении категорий: $e');
    }
  }

  Future<String> getFamilyEncryptionKey(String familyId) async {
    try {
      final doc = await _firestore.collection('families').doc(familyId).get();
      final data = doc.data();

      if (data != null && data.containsKey('encryptionKey')) {
        return data['encryptionKey'] as String;
      } else {
        // новий ключ
        final random = Random.secure();
        final newKey = base64Encode(List<int>.generate(32, (_) => random.nextInt(256)));
        await _firestore.collection('families').doc(familyId).update({
          'encryptionKey': newKey
        });
        return newKey;
      }
    } catch (e) {
      print('Помилка отримання ключа шифрування: $e');
      // Пов резервний ключ у випадку помилки
      return 'FamilyBudgetPlannerSecretKey123456789012';
    }
  }

  Future<void> syncTransactionsFromFirestore(String familyId) async {
    try {
      final querySnapshot = await _firestore.collection('transactions')
          .where('familyId', isEqualTo: familyId)
          .get();
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final existingTransactions = await database.getTransactionByServerId(doc.id);

        DateTime transactionDate;
        try {
          if (data['date'] != null) {
            if (data['date'] is String) {
              transactionDate = DateTime.parse(data['date']);
            } else {
              // Timestamp???
              transactionDate = data['date'].toDate();
            }
          } else {
            transactionDate = DateTime.now();
          }
        } catch (e) {
          transactionDate = DateTime.now();
        }
        DateTime lastUpdated;
        try {
          if (data['lastUpdated'] != null) {
            if (data['lastUpdated'] is String) {
              lastUpdated = DateTime.parse(data['lastUpdated']);
            } else {
              // Timestamp????
              lastUpdated = data['lastUpdated'].toDate();
            }
          } else {
            lastUpdated = DateTime.now();
          }
        } catch (e) {
          lastUpdated = DateTime.now();
        }
        if (existingTransactions.isEmpty) {
          await database.insertTransaction(
            TransactionsCompanion(
              serverId: Value(doc.id),
              amount: Value(data['amount']),
              category: Value(data['category']),
              isExpense: Value(data['isExpense']),
              date: Value(transactionDate),
              accountId: Value(data['accountId']),
              userId: Value(data['userId']),
              familyId: Value(data['familyId']),
              notes: Value(data['notes']),
              geoTag: Value(data['geoTag']),
              synced: const Value(true),
              lastUpdated: Value(lastUpdated),
            ),
          );
        }
      }
    } catch (e) {
      print('Помилка синхронізації транзакцій з Firestore: $e');
    }
  }

  Future<bool> forceSyncAllData(String familyId) async {
    try {
      await syncAccountsFromFirestore(familyId);
      await syncTransactionsFromFirestore(familyId);

      final familyMembers = await getFamilyMembers(familyId);
      for (var member in familyMembers) {
        if (member['userId'] != null) {
          await _firestore.collection('users').doc(member['userId']).update({
            'lastSync': DateTime.now().toIso8601String(),
          });
        }
      }
      return true;
    } catch (e) {
      print('Помилка примусової синхронізації: $e');
      return false;
    }
  }

  Future<bool> removeUserFromFamily(String familyId, String userId) async {
    try {
      final familyDoc = await _firestore.collection('families').doc(familyId).get();

      if (!familyDoc.exists) {
        print('Сім\'ю не знайдено');
        return false;
      }
      final familyData = familyDoc.data();
      if (familyData == null) return false;
      final List<dynamic> members = List.from(familyData['members'] ?? []);
      final initialLength = members.length;
      members.removeWhere((member) => member['userId'] == userId);

      // був видалений користувач???
      if (members.length == initialLength) {
        print('Користувача не знайдено в списку членів сім\'ї');
        return false;
      }
      await familyDoc.reference.update({
        'members': members,
      });
      await _firestore.collection('users').doc(userId).update({
        'familyId': firestore.FieldValue.delete(),
        'role': firestore.FieldValue.delete(),
        'lastUpdated': DateTime.now().toIso8601String(),
      });
      print('Користувача успішно видалено з сім\'ї');
      return true;
    } catch (e) {
      print('Помилка видалення користувача з сім\'ї: $e');
      return false;
    }
  }

  Future<void> syncAccountsFromFirestore(String familyId) async {
    try {
      final querySnapshot = await _firestore.collection('accounts')
          .where('familyId', isEqualTo: familyId)
          .get();
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final existingAccount = await database.getAccountByAccountId(data['accountId']);
        DateTime lastUpdated;
        try {
          if (data['lastUpdated'] != null) {
            if (data['lastUpdated'] is String) {
              lastUpdated = DateTime.parse(data['lastUpdated']);
            } else {
              lastUpdated = data['lastUpdated'].toDate();
            }
          } else {
            lastUpdated = DateTime.now();
          }
        } catch (e) {
          lastUpdated = DateTime.now();
        }
        if (existingAccount == null) {
          await database.insertAccount(
            AccountsCompanion(
              serverId: Value(doc.id),
              accountId: Value(data['accountId']),
              name: Value(data['name']),
              balance: Value(data['balance']),
              currency: Value(data['currency']),
              userId: Value(data['userId']),
              familyId: Value(data['familyId']),
              synced: const Value(true),
              lastUpdated: Value(lastUpdated),
            ),
          );
        } else {
          await database.updateAccount(
            AccountsCompanion(
              id: Value(existingAccount.id),
              accountId: Value(existingAccount.accountId),
              serverId: Value(doc.id),
              name: Value(existingAccount.name),
              balance: Value(data['balance']),
              currency: Value(existingAccount.currency),
              userId: Value(existingAccount.userId),
              familyId: Value(existingAccount.familyId),
              lastUpdated: Value(lastUpdated),
              synced: const Value(true),
            ),
          );
        }
      }
    } catch (e) {
      print('Помилка синхронізації рахунків з Firestore: $e');
    }
  }

  Future<void> syncAllData(String familyId) async {
    await syncAccountsFromFirestore(familyId);
    await syncTransactionsFromFirestore(familyId);
  }

  Future<List<Map<String, dynamic>>> getFamilyMembers(String familyId) async {
    try {
      final familyDoc = await _firestore.collection('families').doc(familyId).get();
      if (!familyDoc.exists) {
        return [];
      }
      final familyData = familyDoc.data();
      if (familyData == null) return [];
      final List<dynamic> members = familyData['members'] ?? [];

      return members.map<Map<String, dynamic>>((member) {
        return {
          'userId': member['userId'],
          'email': member['email'],
          'role': member['role'],
          'deviceModel': member['deviceModel'] ?? 'Невідомий пристрій',
          'joinDate': member['joinDate'],
        };
      }).toList();
    } catch (e) {
      print('Помилка отримання членів сім\'ї: $e');
      return [];
    }
  }

  Future<String?> getCurrentUserId() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      return currentUser?.uid;
    } catch (e) {
      print('Ошибка получения ID пользователя: $e');
      return null;
    }
  }

  Future<List<model_account.Account>> getAllAccountsForUser(String familyId, String userId) async {
    try {
      final personalAccounts = await getFilteredAccounts(familyId, userId, false);
      final sharedAccounts = await getFilteredAccounts(familyId, null, true);

      return [...personalAccounts, ...sharedAccounts];
    } catch (e) {
      print('Помилка отримання всіх рахунків: $e');
      return [];
    }
  }

  Future<String?> getUserRole(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return null;
      final userData = userDoc.data();
      if (userData == null) return null;
      return userData['role'] as String?;
    } catch (e) {
      print('Помилка отримання ролі користувача: $e');
      return null;
    }
  }

  Future<List<String>> getCategories(String familyId, bool isExpense) async {
    try {
      final doc = await _firestore.collection('categories').doc(familyId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          final field = isExpense ? 'expenseCategories' : 'incomeCategories';
          if (data.containsKey(field)) {
            final categories = List<String>.from(data[field]);
            return categories;
          }
        }
      }
      // категорий нема????
      if (isExpense) {
        return ['Продукти', 'Транспорт', 'Розваги', 'Комунальні', 'Інше'];
      } else {
        return ['Зарплата', 'Подарунки', 'Дивіденди', 'Підробіток', 'Продаж', 'Інше'];
      }
    } catch (e) {
      print('Ошибка при получении категорий: $e');
      if (isExpense) {
        return ['Продукти', 'Транспорт', 'Розваги', 'Комунальні', 'Інше'];
      } else {
        return ['Зарплата', 'Подарунки', 'Дивіденди', 'Підробіток', 'Продаж', 'Інше'];
      }
    }
  }

  Future<bool> rejectJoinRequest(String familyId, String userId) async {
    try {
      final familyDoc = await _firestore.collection('families').doc(familyId).get();
      if (!familyDoc.exists) {
        return false;
      }
      final familyData = familyDoc.data();
      if (familyData == null) return false;
      final List<dynamic> pendingMembers = List.from(familyData['pendingMembers'] ?? []);
      pendingMembers.removeWhere((member) => member['userId'] == userId);
      await familyDoc.reference.update({
        'pendingMembers': pendingMembers,
      });
      return true;
    } catch (e) {
      print('Помилка відхилення запиту на приєднання: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getPendingRequests(String familyId) async {
    try {
      final familyDoc = await _firestore.collection('families').doc(familyId).get();
      if (!familyDoc.exists) {
        return [];
      }
      final familyData = familyDoc.data();
      if (familyData == null) return [];
      final List<dynamic> pendingMembers = familyData['pendingMembers'] ?? [];

      return pendingMembers.map<Map<String, dynamic>>((member) {
        return {
          'userId': member['userId'],
          'email': member['email'],
          'deviceModel': member['deviceModel'],
          'deviceLocation': member['deviceLocation'],
          'requestDate': member['requestDate'],
        };
      }).toList();
    } catch (e) {
      print('Помилка отримання запитів на приєднання: $e');
      return [];
    }
  }

  Future<bool> deleteTransaction(String transactionId) async {
    try {
      final transactions = await database.getTransactionByServerId(transactionId);
      if (transactions.isEmpty) {
        return false;
      }
      final transaction = transactions.first;
      if (transaction.accountId == null) {
        return false;
      }
      final account = await database.getAccountByAccountId(transaction.accountId!);
      if (account == null) {
        return false;
      }

      double balanceChange = 0;
      if (transaction.isExpense && transaction.amount != null) {
        balanceChange = transaction.amount!;
      } else if (!transaction.isExpense && transaction.amount != null) {
        balanceChange = -transaction.amount!;
      }

      double newBalance = (account.balance ?? 0) + balanceChange;

      await database.updateAccount(
        AccountsCompanion(
          id: Value(account.id),
          accountId: Value(account.accountId),
          balance: Value(newBalance),
          lastUpdated: Value(DateTime.now()),
          synced: const Value(false),
        ),
      );
      await database.deleteTransaction(transaction.id);
      await _firestore.collection('transactions').doc(transactionId).delete();
      if (account.serverId != null) {
        await _firestore.collection('accounts').doc(account.serverId).update({
          'balance': newBalance,
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      }
      return true;
    } catch (e) {
      print('Error deleting transaction: $e');
      return false;
    }
  }

  Future<bool> deleteAccount(String accountId) async {
    try {
      final account = await database.getAccountByAccountId(accountId);
      if (account == null) {
        return false;
      }

      await database.deleteAccount(account.id);

      // Е serverId????
      if (account.serverId != null) {
        await _firestore.collection('accounts').doc(account.serverId).delete();
      }
      return true;
    } catch (e) {
      print('Помилка видалення рахунку: $e');
      return false;
    }
  }

  Future<List<model_family.Family>> findLocalFamilies() async {
    try {
      final querySnapshot = await _firestore.collection('families').get();
      if (querySnapshot.docs.isEmpty) {
        print('Сім\'ї не знайдено');
        return [];
      }
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return model_family.Family(
          serverId: doc.id,
          name: data['name'] ?? 'Сім\'я без назви',
          adminId: data['adminId'],
          inviteCode: data['inviteCode'],
        );
      }).toList();
    } catch (e) {
      print('Помилка пошуку сімей: $e');
      return [];
    }
  }

  Future<model_family.Family?> getFamilyById(String familyId) async {
    try {
      final familyDoc = await _firestore.collection('families').doc(familyId).get();
      if (!familyDoc.exists) {
        return null;
      }
      final data = familyDoc.data();
      if (data == null) return null;

      return model_family.Family(
        serverId: familyDoc.id,
        name: data['name'],
        adminId: data['adminId'],
        inviteCode: data['inviteCode'],
      );
    } catch (e) {
      print('Помилка отримання інформації про сім\'ю: $e');
      return null;
    }
  }

  Future<String> getDeviceLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return 'Геолокація вимкнена';
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Дозвіл на геолокацію відхилено';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return 'Дозвіл на геолокацію відхилено назавжди';
      }
      Position position = await Geolocator.getCurrentPosition();
      return '${position.latitude}, ${position.longitude}';
    } catch (e) {
      return 'Неможливо отримати геолокацію';
    }
  }

  Future<Map<String, dynamic>> getUserById(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return {'email': 'Невідомий користувач'};
      final userData = userDoc.data();
      if (userData == null) return {'email': 'Невідомий користувач'};

      return {
        'email': userData['email'] ?? 'Невідомий користувач',
        'name': userData['displayName'] ?? userData['email'] ?? 'Невідомий користувач',
      };
    } catch (e) {
      print('Помилка отримання даних користувача: $e');
      return {'email': 'Невідомий користувач'};
    }
  }

  Future<Map<String, String>> createFamily({
    required String name,
    required String adminId,
  }) async {
    // унікальний код запрошення
    final inviteCode = _uuid.v4().substring(0, 8).toUpperCase();
    String familyId = '';
    try {
      final userDoc = await _firestore.collection('users').doc(adminId).get();
      String? userEmail;
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          userEmail = userData['email'] as String?;
        }
      }
      final docRef = await _firestore.collection('families').add({
        'name': name,
        'adminId': adminId,
        'inviteCode': inviteCode,
        'pendingMembers': [],
        'members': [{
          'userId': adminId,
          'email': userEmail,
          'role': 'admin',
          'joinDate': DateTime.now().toIso8601String(),
        }],
        'createdAt': DateTime.now().toIso8601String(),
        'lastUpdated': DateTime.now().toIso8601String(),
      });

      familyId = docRef.id;

      // !!!!!
      await _firestore.collection('users').doc(adminId).set({
        'familyId': familyId,
        'role': 'admin',
        'lastUpdated': DateTime.now().toIso8601String(),
      }, firestore.SetOptions(merge: true));
      print('Сім\'ю створено з ID: $familyId та кодом запрошення: $inviteCode');
      return {'inviteCode': inviteCode, 'familyId': familyId};
    } catch (e) {
      print('Помилка створення сім\'ї: $e');
      return {'inviteCode': inviteCode, 'familyId': familyId};
    }
  }

  Future<bool> isUserInFamily(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return false;
      final userData = userDoc.data();
      if (userData == null) return false;

      return userData.containsKey('familyId') && userData['familyId'] != null;
    } catch (e) {
      print('Помилка перевірки користувача в сім\'ї: $e');
      return false;
    }
  }

  Future<String?> getFamilyIdForUser(String userId) async {
try {
final userDoc = await _firestore.collection('users').doc(userId).get();
if (!userDoc.exists) {
return null;
}
final userData = userDoc.data();
return userData?['familyId'];
} catch (e) {
print('Помилка отримання ID сім\'ї: $e');
return null;
}
}

  Future<List<model_account.Account>> getFilteredAccounts(String familyId, String? ownerId, bool isShared) async {
    try {
      final querySnapshot = await _firestore.collection('accounts')
          .where('familyId', isEqualTo: familyId)
          .get();

      List<model_account.Account> accounts = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final accountId = data['accountId'] as String;
        final localAccount = await database.getAccountByAccountId(accountId);

        if (localAccount != null) {
          accounts.add(model_account.Account(
            id: localAccount.id,
            serverId: doc.id,
            accountId: accountId,
            name: data['name'] as String?,
            balance: data['balance'] as double?,
            currency: data['currency'] as String?,
            userId: data['userId'] as String?,
            familyId: data['familyId'] as String?,
            synced: localAccount.synced,
            lastUpdated: localAccount.lastUpdated,
            isShared: data['isShared'] as bool? ?? false,
          ));
        }
      }
      if (isShared) {
        // тільки рахунки с isShared=true
        return accounts.where((account) => account.isShared == true).toList();
      } else if (ownerId != null) {
        // Дтільки з userId=ownerId и isShared=false
        return accounts.where((account) =>
        account.userId == ownerId &&
            account.isShared != true
        ).toList();
      } else {
        return accounts.where((account) =>
        account.isShared != true
        ).toList();
      }
    } catch (e) {
      print('Помилка фільтрації рахунків: $e');
      return [];
    }
  }

  Future<List<model_account.Account>> getAccounts(String familyId) async {
    final cacheKey = 'accounts_$familyId';
    final cached = _cache.get<List<model_account.Account>>(cacheKey);
    if (cached != null) return cached;

    try {
      final snapshot = await _firestore
          .collection('accounts')
          .where('familyId', isEqualTo: familyId)
          .get();

      final accounts = <model_account.Account>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final localAccount = await database.getAccountByAccountId(data['accountId']);

        if (localAccount != null) {
          accounts.add(model_account.Account(
            id: localAccount.id,
            serverId: doc.id,
            accountId: data['accountId'],
            name: data['name'],
            balance: data['balance']?.toDouble(),
            currency: data['currency'],
            userId: data['userId'],
            familyId: data['familyId'],
            synced: localAccount.synced,
            lastUpdated: localAccount.lastUpdated,
            isShared: data['isShared'] ?? false,
          ));
        }
      }

      _cache.set(cacheKey, accounts);
      return accounts;
    } catch (e) {
      return [];
    }
  }

  Future<List<model_transaction.Transaction>> getTransactions(String familyId) async {
    final cacheKey = 'transactions_$familyId';
    final cached = _cache.get<List<model_transaction.Transaction>>(cacheKey);
    if (cached != null) return cached;

    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('familyId', isEqualTo: familyId)
          .orderBy('date', descending: true)
          .limit(100)
          .get();

      final transactions = <model_transaction.Transaction>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        DateTime transactionDate;
        try {
          if (data['date'] is String) {
            transactionDate = DateTime.parse(data['date']);
          } else {
            transactionDate = data['date'].toDate();
          }
        } catch (e) {
          transactionDate = DateTime.now();
        }

        transactions.add(model_transaction.Transaction(
          serverId: doc.id,
          amount: data['amount']?.toDouble(),
          category: data['category'] ?? '',
          isExpense: data['isExpense'] ?? true,
          date: transactionDate,
          accountId: data['accountId'],
          userId: data['userId'],
          familyId: data['familyId'],
          notes: data['notes'],
          geoTag: data['geoTag'],
        ));
      }

      _cache.set(cacheKey, transactions);
      return transactions;
    } catch (e) {
      return [];
    }
  }

  void _clearCache(String familyId) {
    _cache.remove('transactions_$familyId');
    _cache.remove('accounts_$familyId');
    _cache.remove('categories_expense_$familyId');
    _cache.remove('categories_income_$familyId');
  }

  Future<void> addTransaction({
    required double amount,
    required String category,
    required bool isExpense,
    required String accountId,
    required String userId,
    required String familyId,
    DateTime? date,
    String? notes,
    String? geoTag,
    String? currency,
  }) async {
    try {
      // Шифрнотатк
      String? encryptedNotes;
      if (notes != null && notes.isNotEmpty) {
        encryptedNotes = _encryptionService.encrypt(notes);
      }
      final account = await database.getAccountByAccountId(accountId);
      if (account == null) {
        print('Рахунок не знайдено: $accountId');
        return;
      }
      final transactionCurrency = currency ?? account.currency;
      final newBalance = account.balance! + (isExpense ? -amount : amount);
      final transactionDate = date ?? DateTime.now();

      await database.updateAccount(
        AccountsCompanion(
          id: Value(account.id),
          accountId: Value(account.accountId),
          balance: Value(newBalance),
          lastUpdated: Value(DateTime.now()),
          synced: const Value(false),
        ),
      );

      final transactionId = _uuid.v4();

      await database.insertTransaction(
        TransactionsCompanion(
          serverId: Value(transactionId),
          amount: Value(amount),
          date: Value(transactionDate),
          category: Value(category),
          isExpense: Value(isExpense),
          synced: const Value(false),
          lastUpdated: Value(DateTime.now()),
          userId: Value(userId),
          familyId: Value(familyId),
          accountId: Value(accountId),
          notes: Value(notes), // оригінальні нотатки локально
          geoTag: Value(geoTag),
        ),
      );
      if (account.serverId != null) {
        await _firestore.collection('accounts').doc(account.serverId).update({
          'balance': newBalance,
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      }

      final docRef = await _firestore.collection('transactions').add({
        'amount': amount,
        'date': transactionDate.toIso8601String(),
        'category': category,
        'isExpense': isExpense,
        'userId': userId,
        'familyId': familyId,
        'accountId': accountId,
        'notes': encryptedNotes,
        'geoTag': geoTag,
        'currency': transactionCurrency,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
      await database.updateTransactionByServerId(
        transactionId,
        TransactionsCompanion(
          serverId: Value(docRef.id),
          synced: const Value(true),
        ),
      );
    } catch (e) {
      print('Помилка додавання транзакції: $e');
      // бекап влок БД
      final account = await database.getAccountByAccountId(accountId);
      if (account != null) {
        await database.updateAccount(
          AccountsCompanion(
            id: Value(account.id),
            accountId: Value(account.accountId),
            balance: Value(account.balance!), // оригінальний баланс
            lastUpdated: Value(DateTime.now()),
            synced: const Value(false),
          ),
        );
      }
      rethrow;
    }
    _clearCache(familyId);
  }

  Future<void> addAccount({
    required String name,
    required double balance,
    required String currency,
    required String userId,
    required String familyId,
    bool? isShared,
  }) async {
    final accountId = _uuid.v4();
    final encryptedBalance = _encryptionService.encrypt(balance.toString());
    final account = AccountsCompanion(
      accountId: Value(accountId),
      name: Value(name),
      balance: Value(balance),
      currency: Value(currency),
      userId: Value(userId),
      familyId: Value(familyId),
      synced: Value(false),
      lastUpdated: Value(DateTime.now()),
    );

    await database.insertAccount(account);
    try {
      await _firestore.collection('accounts').add({
        'name': name,
        'balance': balance,
        'encryptedBalance': encryptedBalance,
        'currency': currency,
        'userId': userId,
        'familyId': familyId,
        'accountId': accountId,
        'isShared': isShared ?? false,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Помилка синхронізації рахунку: $e');
    }
  }

  Future<void> addUserToFamily({
    required String email,
    required String role,
    required String familyId,
    model_user.UserPermissions? permissions,
  }) async {
    final deviceModel = await getDeviceModel();
    final deviceLocation = await getDeviceLocation();

    try {
      await _firestore.collection('users').add({
        'email': email,
        'role': role,
        'familyId': familyId,
        'deviceModel': deviceModel,
        'deviceLocation': deviceLocation,
        'lastUpdated': DateTime.now(),
      });
    } catch (e) {
      print('Помилка додавання користувача до сім\'ї: $e');
    }
  }
}



