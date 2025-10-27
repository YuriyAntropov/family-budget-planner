import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  final _storage = FlutterSecureStorage();
  Encrypter? _encrypter;
  final IV _iv = IV.fromLength(16);

  String encrypt(String text, {String? ivString}) {
    if (_encrypter == null) return text;
    try {
      // унікальний IV для кожного
      final iv = ivString != null ? IV.fromBase64(ivString) : IV.fromSecureRandom(16);
      final encrypted = _encrypter!.encrypt(text, iv: iv);
      // IV разом зтекстом
      return "${iv.base64}:${encrypted.base64}";
    } catch (e) {
      return text;
    }
  }

  String decrypt(String combinedText) {
    if (_encrypter == null) return combinedText;
    try {
      // Розділяю
      final parts = combinedText.split(':');
      if (parts.length != 2) return combinedText;

      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      return _encrypter!.decrypt(encrypted, iv: iv);
    } catch (e) {
      return combinedText;
    }
  }

  Future<void> initialize() async {
    try {
      final tempKey = Key.fromLength(32);
      _encrypter = Encrypter(AES(tempKey));
      // фікс ключ для всіх пристроїв
      const fixedKey = 'FamilyBudgetPlannerSecretKey123456789012';
      _encrypter = Encrypter(AES(Key.fromUtf8(fixedKey.padRight(32))));
    } catch (e) {
      print('Помилка ініціалізації шифрування: $e');
    }
  }

  Future<void> initializeWithKey(String keyBase64) async {
    try {
      _encrypter = Encrypter(AES(Key.fromBase64(keyBase64)));
    } catch (e) {
      print('Помилка ініціалізації шифрування з ключем: $e');
    }
  }
}
