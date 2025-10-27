import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import '../models/account.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/currency_service.dart';

class BudgetCircle extends StatefulWidget {
  final String familyId;
  final String? userId;

  const BudgetCircle({super.key, required this.familyId, this.userId});

  @override
  BudgetCircleState createState() => BudgetCircleState();
}

class BudgetCircleState extends State<BudgetCircle> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    final currencyService = Provider.of<CurrencyService>(context);

    return FutureBuilder<List<Account>>(
      future: widget.userId != null
          ? dbService.getFilteredAccounts(widget.familyId, widget.userId, false)
          : dbService.getAccounts(widget.familyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Немає рахунків'));
        }

        final accounts = snapshot.data!;

        return FutureBuilder<String>(
          future: currencyService.getPreferredCurrency(),
          builder: (context, currencySnapshot) {
            if (!currencySnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final preferredCurrency = currencySnapshot.data!;
            double totalBalance = 0.0;

            for (var account in accounts) {
              final accountCurrency = account.currency ?? 'UAH';
              final convertedBalance = currencyService.convert(
                account.balance ?? 0,
                accountCurrency,
                preferredCurrency,
              );
              totalBalance += convertedBalance;
            }
            // Групп (< 2%)
            List<Account> mainAccounts = [];
            List<Account> smallAccounts = [];
            for (var account in accounts) {
              final convertedBalance = currencyService.convert(
                account.balance ?? 0,
                account.currency ?? 'UAH',
                preferredCurrency,
              );
              final percentage = totalBalance > 0 ? (convertedBalance / totalBalance * 100) : 0;
              if (percentage >= 2.0) {
                mainAccounts.add(account);
              } else {
                smallAccounts.add(account);
              }
            }
            double smallTotal = 0.0;
            for (var account in smallAccounts) {
              final convertedBalance = currencyService.convert(
                account.balance ?? 0,
                account.currency ?? 'UAH',
                preferredCurrency,
              );
              smallTotal += convertedBalance;
            }
            List<PieChartSectionData> sections = [];
            final colors = [Colors.blue, Colors.green, Colors.red, Colors.orange, Colors.purple, Colors.teal];

            for (int i = 0; i < mainAccounts.length; i++) {
              final account = mainAccounts[i];
              final convertedBalance = currencyService.convert(
                account.balance ?? 0,
                account.currency ?? 'UAH',
                preferredCurrency,
              );
              final percentage = totalBalance > 0 ? convertedBalance / totalBalance : 0;

              // якщо сектор > 8%)
              final showTitle = percentage > 0.08;

              sections.add(
                PieChartSectionData(
                  color: colors[i % colors.length],
                  value: convertedBalance,
                  title: showTitle ? '${account.name}' : '',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }
            if (smallTotal > 0) {
              sections.add(
                PieChartSectionData(
                  color: Colors.grey,
                  value: smallTotal,
                  title: smallTotal / totalBalance > 0.08 ? 'Інші' : '',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  width: 200,
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                      centerSpaceColor: Colors.white,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${totalBalance.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.grey,
                      ),
                    ),
                    Text(
                      preferredCurrency,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
