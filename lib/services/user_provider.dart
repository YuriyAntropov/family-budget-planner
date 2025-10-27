import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  String? _familyId;
  String? _role;
  String? _displayName;
  UserPermissions? _permissions;
  bool _isLoading = false;
  bool _initialized = false;
  bool _isSynced = false;
  bool _useGeoLocation = false;
  bool get useGeoLocation => _useGeoLocation;
  String? get userId => _userId;
  String? get familyId => _familyId;
  String? get role => _role;
  String? get displayName => _displayName;
  UserPermissions? get permissions => _permissions;
  bool get isLoading => _isLoading;
  bool canUseChat() => _permissions?.canUseChat ?? true;
  bool get isHeadOfFamily {
    return isAdmin || role == 'head';
  }
  bool get isAdmin {
    return role == 'admin';
  }
  bool get isChild => _role == 'child';
  bool get initialized => _initialized;
  bool get isSynced => _isSynced;
  String? selectedUserId = 'all';

  void setSelectedUserId(String userId) {
    selectedUserId = userId;
    notifyListeners();
  }

  void setUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      if (userId != null) {
        _initialized = false;
      } else {
        _clearData();
      }
    }
  }

  void _clearData() {
    _familyId = null;
    _role = null;
    _displayName = null;
    _permissions = null;
    _initialized = false;
    _isSynced = false;
    notifyListeners();
  }

  Future<bool> checkSyncStatus() async {
    if (_userId == null || _familyId == null) return false;

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data();
      if (userData == null) return false;
      _isSynced = userData['lastSync'] != null;
      notifyListeners();
      return _isSynced;
    } catch (e) {
      print('Помилка перевірки синхронізації: $e');
      return false;
    }
  }

  Future<void> setUseGeoLocation(bool value) async {
    if (_userId == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(_userId).update({
        'useGeoLocation': value,
      });
      _useGeoLocation = value;
      notifyListeners();
    } catch (e) {
      print('Помилка оновлення налаштувань геолокації: $e');
    }
  }

  //bool isAdmin() {
  //  return _role == 'admin';
  //}

  Future<void> initialize() async {
    if (_userId != null && !_initialized) {
      await _loadUserData();
    }
  }

  Future<void> setRole(String role) async {
    _role = role;
    notifyListeners();
  }

  Future<void> updateDisplayName(String name) async {
    if (_userId == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(_userId).update({
        'displayName': name,
      });
      _displayName = name;
      notifyListeners();
    } catch (e) {
      print('Ошибка обновления имени: $e');
    }
  }

  Future<void> _loadUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          _useGeoLocation = userData['useGeoLocation'] ?? false;
        }
      }
    } catch (e) {
      print('Помилка отримання налаштувань геолокації: $e');
    }
    if (_userId == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          _familyId = userData['familyId'];
          _role = userData['role'];
          _displayName = userData['displayName'] ?? userData['email']?.toString().split('@').first;
          if (_role == 'admin') {
            _permissions = UserPermissions.fromRole(UserRole.admin);
          } else if (_role == 'child') {
            _permissions = UserPermissions.fromRole(UserRole.child);
          } else {
            _permissions = UserPermissions();
          }
          _isSynced = userData['lastSync'] != null;
        }
      }
    } catch (e) {
      print('Помилка завантаження даних користувача: $e');
    } finally {
      _isLoading = false;
      _initialized = true;
      notifyListeners();
    }
  }

  bool canAddExpense() => _permissions?.canAddExpense ?? false;
  bool canAddIncome() => _permissions?.canAddIncome ?? true; // true за замовчуванням
  bool canViewAllAccounts() => _permissions?.canViewAllAccounts ?? true;
  bool canEditAccounts() => _permissions?.canEditAccounts ?? false;
  bool canViewStatistics() => _permissions?.canViewStatistics ?? true;
  bool canInviteMembers() => _permissions?.canInviteMembers ?? false;
  bool canManageRoles() => _permissions?.canManageRoles ?? false;
}
