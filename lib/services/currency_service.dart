import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  String _preferredCurrency = 'UAH';
  Map<String, double> _rates = {
    'UAH_USD': 0.025,
    'UAH_EUR': 0.023,
    'USD_UAH': 40.0,
    'USD_EUR': 0.92,
    'EUR_UAH': 43.5,
    'EUR_USD': 1.09,
  };
  DateTime? _lastUpdate;

  Future<String> getPreferredCurrency() async {
    return _preferredCurrency;
  }

  Future<void> setPreferredCurrency(String currency) async {
    _preferredCurrency = currency;
  }

  Future<void> updateRates() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.exchangerate-api.com/v4/latest/UAH'
      ));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['rates'];

        _rates = {
          'UAH_USD': 1 / rates['USD'],
          'UAH_EUR': 1 / rates['EUR'],
          'USD_UAH': rates['USD'],
          'USD_EUR': rates['USD'] / rates['EUR'],
          'EUR_UAH': rates['EUR'],
          'EUR_USD': rates['EUR'] / rates['USD'],
        };
        _lastUpdate = DateTime.now();
      }
    } catch (e) {
      print('Ошибка обновления курсов валют: $e');
    }
  }
  double convert(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;
    final key = '${fromCurrency}_${toCurrency}';
    final rate = _rates[key] ?? 1.0;
    return amount * rate;
  }
}
