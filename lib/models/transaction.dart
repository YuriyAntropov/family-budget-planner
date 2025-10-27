class Transaction {
  int? id;
  String? serverId;
  double? amount;
  String category;
  bool isExpense;
  DateTime? date;
  String? accountId;
  String? userId;
  String? familyId;
  String? notes;
  String? geoTag;
  bool synced;
  DateTime? lastUpdated;
  String? currency;

  Transaction({
    this.id,
    this.serverId,
    this.amount,
    required this.category,
    required this.isExpense,
    this.date,
    this.accountId,
    this.userId,
    this.familyId,
    this.notes,
    this.geoTag,
    this.synced = false,
    this.lastUpdated,
    this.currency,
  });
}
