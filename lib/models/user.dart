enum UserRole {
  admin,
  child,
  custom,
}

class UserPermissions {
  bool canAddExpense;
  bool canAddIncome;
  bool canViewAllAccounts;
  bool canEditAccounts;
  bool canViewStatistics;
  bool canInviteMembers;
  bool canManageRoles;
  bool canUseChat;

  UserPermissions({
    this.canAddExpense = true,
    this.canAddIncome = false,
    this.canViewAllAccounts = false,
    this.canEditAccounts = false,
    this.canViewStatistics = false,
    this.canInviteMembers = false,
    this.canManageRoles = false,
    this.canUseChat = true, // за замовчуванням дозв
  });

  // Створення дозволів за замовчуванням для ролі
  factory UserPermissions.fromRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return UserPermissions(
          canAddExpense: true,
          canAddIncome: true,
          canViewAllAccounts: true,
          canEditAccounts: true,
          canViewStatistics: true,
          canInviteMembers: true,
          canManageRoles: true,
          canUseChat: true,
        );
      case UserRole.child:
        return UserPermissions(
          canAddExpense: true,
          canAddIncome: false,
          canViewAllAccounts: false,
          canEditAccounts: false,
          canViewStatistics: false,
          canInviteMembers: false,
          canManageRoles: false,
          canUseChat: true,
        );
      case UserRole.custom:
        return UserPermissions();
    }
  }
}

class User {
  int? id;
  String? serverId;
  String? email;
  String? role;
  String? familyId;
  UserPermissions? permissions;
  String? deviceModel;
  String? deviceLocation;
  bool synced;
  DateTime? lastUpdated;
  DateTime? lastSync;
  DateTime? lastOnline;

  User({
    this.id,
    this.serverId,
    this.email,
    this.role,
    this.familyId,
    this.permissions,
    this.deviceModel,
    this.deviceLocation,
    this.synced = false,
    this.lastUpdated,
    this.lastSync,
    this.lastOnline,
  });
}
