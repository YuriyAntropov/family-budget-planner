import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BackupService {
  final DbService dbService;

  BackupService(this.dbService);

  Future<void> exportToJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/family_budget_backup.json');
      // отримання
      final data = await _collectBackupData();
      // запис
      await file.writeAsString(jsonEncode(data));
      // шерім
      await Share.shareFiles([file.path], text: 'Бекап семейного бюджета');
      debugPrint('Экспорт данных в JSON успешно выполнен');
    } catch (e) {
      debugPrint('Ошибка экспорта данных: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _collectBackupData() async {
    try {
      // ID корист напрямую з Firebase
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return {'error': 'Пользователь не авторизован'};
      final familyId = await dbService.getFamilyIdForUser(userId);
      if (familyId == null) return {'error': 'Пользователь не в семье'};
      final accounts = await dbService.getAccounts(familyId);
      final transactions = await dbService.getTransactions(familyId);
      // категории
      final expenseCategories = await dbService.getCategories(familyId, true);
      final incomeCategories = await dbService.getCategories(familyId, false);

      return {
        'timestamp': DateTime.now().toIso8601String(),
        'userId': userId,
        'familyId': familyId,
        'accounts': accounts.map((a) => {
          'accountId': a.accountId,
          'name': a.name,
          'balance': a.balance,
          'currency': a.currency,
          'userId': a.userId,
        }).toList(),
        'transactions': transactions.map((t) => {
          'amount': t.amount,
          'category': t.category,
          'isExpense': t.isExpense,
          'date': t.date?.toIso8601String(),
          'accountId': t.accountId,
          'userId': t.userId,
          'notes': t.notes,
        }).toList(),
        'categories': {
          'expense': expenseCategories,
          'income': incomeCategories,
        },
      };
    } catch (e) {
      print('Ошибка сбора данных для бекапа: $e');
      return {'error': e.toString()};
    }
  }
}
