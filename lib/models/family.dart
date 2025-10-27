class Family {
  int? id;
  String? serverId;
  String? name;
  String? adminId;
  String? inviteCode;
  List<String>? pendingMembers;
  bool synced;
  DateTime? lastUpdated;

  Family({
    this.id,
    this.serverId,
    this.name,
    this.adminId,
    this.inviteCode,
    this.pendingMembers,
    this.synced = false,
    this.lastUpdated,
  });
}
