import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class AIService {
  final String apiKey = String.fromEnvironment('OPENROUTER_API_KEY');
  final String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  Future<String> getChatResponse(String message, List<Transaction> transactions) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://family-budget-planner.app',
          'X-Title': 'Family Budget Planner',
        },
        body: jsonEncode({
          'model': 'mistralai/mistral-small-3.1-24b-instruct:free',
          'messages': [
            {
              'role': 'system',
              'content': 'Ви фінансовий помічник, який допомагає аналізувати сімейний бюджет.',
            },
            {
              'role': 'user',
              'content': '$message\n\nДані про транзакції:\n${_prepareTransactionsData(transactions)}',
            }
          ],
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        final errorData = jsonDecode(response.body);
        return 'Помилка отримання відповіді: ${response.statusCode}\nДеталі: ${errorData['error']['message'] ?? 'Невідома помилка'}';
      }
    } catch (e) {
      return 'Помилка з\'єднання з сервером ШІ: $e';
    }
  }

  Future<String> getFinancialAdvice(List<Transaction> transactions) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://family-budget-planner.app',
          'X-Title': 'Family Budget Planner',
        },
        body: jsonEncode({
          'model': 'mistralai/mistral-small-3.1-24b-instruct:free',
          'messages': [
            {
              'role': 'system',
              'content': 'Ви фінансовий помічник, який допомагає аналізувати сімейний бюджет.',
            },
            {
              'role': 'user',
              'content': _prepareTransactionsData(transactions),
            }
          ],
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        final errorData = jsonDecode(response.body);
        return 'Помилка отримання рекомендацій: ${response.statusCode}\nДеталі: ${errorData['error']['message'] ?? 'Невідома помилка'}';
      }
    } catch (e) {
      return 'Помилка з\'єднання з сервером ШІ: $e';
    }
  }

  String _prepareTransactionsData(List<Transaction> transactions) {
    final expensesByCategory = <String, double>{};
    double totalExpenses = 0;
    double totalIncome = 0;
    for (var transaction in transactions) {
      if (transaction.isExpense) {
        expensesByCategory[transaction.category] =
            (expensesByCategory[transaction.category] ?? 0) + (transaction.amount ?? 0);
        totalExpenses += transaction.amount ?? 0;
      } else {
        totalIncome += transaction.amount ?? 0;
      }
    }

    final prompt = '''
    Проаналізуй фінансові дані сім'ї та надай рекомендації щодо оптимізації бюджету:
    
    Загальний дохід: $totalIncome
    Загальні витрати: $totalExpenses
    
    Витрати за категоріями:
    ${expensesByCategory.entries.map((e) => '${e.key}: ${e.value}').join('\n')}
    
    Будь ласка, надай рекомендації щодо:
    1. Оптимізації витрат
    2. Можливостей для заощадження
    3. Балансування бюджету
    4. Пріоритезації витрат
    ''';
    return prompt;
  }
}