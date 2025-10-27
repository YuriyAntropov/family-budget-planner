import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';

class NfcService {
  static Future<bool> isAvailable() async {
    try {
      return await NfcManager.instance.isAvailable();
    } catch (e) {
      print('NFC error: $e');
      return false;
    }
  }

  static Future<void> startNfcSession({
    required String familyId,
    required String inviteCode,
    required Function(String, String) onDetected,
  }) async {
    if (!await isAvailable()) {
      return;
    }
    try {
      // Спрощ
      onDetected(familyId, inviteCode);
    } catch (e) {
      print('NFC error: $e');
    }
  }

  static Future<void> readNfcTag({
    required Function(String, String) onDataRead,
  }) async {
    if (!await isAvailable()) {
      return;
    }
    try {
      // Спрощ!!!
    } catch (e) {
      print('NFC error: $e');
    }
  }
}
