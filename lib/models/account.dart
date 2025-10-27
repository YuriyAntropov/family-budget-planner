class Account {
  int? id;
  String? serverId;
  String? accountId;
  String? name;
  double? balance;
  String? currency;
  String? userId;
  String? familyId;
  List<String>? accessibleToUsers;
  bool synced;
  DateTime? lastUpdated;
  final bool? isShared;

  Account({
    this.id,
    this.serverId,
    this.accountId,
    this.name,
    this.balance,
    this.currency,
    this.userId,
    this.familyId,
    this.accessibleToUsers,
    this.synced = false,
    this.lastUpdated,
    this.isShared,
  });
}
