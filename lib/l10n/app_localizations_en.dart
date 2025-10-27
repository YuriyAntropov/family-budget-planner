// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Family Budget Planner';

  @override
  String welcome(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get home => 'Home';

  @override
  String get income => 'Income';

  @override
  String get accounts => 'Accounts';

  @override
  String get expenses => 'Expenses';

  @override
  String get addAccount => 'Add Account';

  @override
  String get addCategory => 'Add Category';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get amount => 'Amount';

  @override
  String get currency => 'Currency';

  @override
  String get date => 'Date';

  @override
  String get category => 'Category';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Logout';

  @override
  String get familySettings => 'Family Settings';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get securitySettings => 'Security Settings';

  @override
  String get theme => 'Theme';

  @override
  String get sync => 'Synchronization';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get exportData => 'Export Data';

  @override
  String get login => 'Login';

  @override
  String get password => 'Password';

  @override
  String get fillAllFields => 'Fill all fields';

  @override
  String get loginError => 'Login error. Check your data.';

  @override
  String get userNotFound => 'User with this email not found';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get userDisabled => 'This account is disabled';

  @override
  String get signIn => 'Sign In';

  @override
  String get noAccount => 'Don\'t have an account? Register';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get enterEmailReset => 'Enter email to reset password';

  @override
  String get resetInstructions => 'Password reset instructions sent to email';

  @override
  String get signInGoogle => 'Sign in with Google';

  @override
  String get googleLoginError => 'Google login error';

  @override
  String get registration => 'Registration';

  @override
  String get createAccount => 'Create Account';

  @override
  String get yourName => 'Your Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get register => 'Register';

  @override
  String get emailInUse => 'This email is already in use';

  @override
  String get weakPassword => 'Password is too weak';

  @override
  String get registrationError => 'Registration error';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get familySettingsTitle => 'Family Settings';

  @override
  String get refreshData => 'Refresh Data';

  @override
  String get notFamilyMember => 'You are not a family member';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get restartApp => 'Restart app to update data';

  @override
  String get returnHome => 'Return to Home';

  @override
  String get createFamily => 'Create Family';

  @override
  String get familyName => 'Family Name';

  @override
  String get create => 'Create';

  @override
  String get joinFamily => 'Join Family';

  @override
  String get inviteCode => 'Invite Code';

  @override
  String get join => 'Join';

  @override
  String get findLocalFamilies => 'Find families in local network';

  @override
  String get joinNFC => 'Join via NFC';

  @override
  String get bringDeviceNFC => 'Bring device close to another NFC device';

  @override
  String get familyCreated => 'Family successfully created';

  @override
  String get joinRequestSent => 'Join request sent. Wait for confirmation.';

  @override
  String get familyNotFound => 'Family with this invite code not found';

  @override
  String get family => 'Family';

  @override
  String get copy => 'Copy';

  @override
  String get share => 'Share';

  @override
  String get shareNFC => 'Share via NFC';

  @override
  String get dataSentNFC => 'Data successfully sent via NFC';

  @override
  String get familyMembers => 'Family Members';

  @override
  String get unknownUser => 'Unknown user';

  @override
  String get role => 'Role';

  @override
  String get device => 'Device';

  @override
  String get unknown => 'Unknown';

  @override
  String get removeUser => 'Remove User';

  @override
  String removeUserConfirm(Object email) {
    return 'Do you really want to remove user $email from family?';
  }

  @override
  String get userRemoved => 'User removed from family';

  @override
  String get removeUserError => 'Error removing user';

  @override
  String get joinRequests => 'Join Requests';

  @override
  String get location => 'Location';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get leaveFamily => 'Leave Family';

  @override
  String get leaveFamilyConfirm =>
      'Do you really want to leave the family? All your data will be disconnected from the family budget.';

  @override
  String get leftFamily => 'You successfully left the family';

  @override
  String get leaveFamilyError => 'Error leaving family';

  @override
  String get restartRequired => 'Restart Required';

  @override
  String get restartMessage =>
      'You have been added to the family. To apply changes, you need to restart the app.';

  @override
  String get restart => 'Restart';

  @override
  String get userAdded => 'User added to family. Ask them to restart the app.';

  @override
  String get requestRejected => 'Request rejected';

  @override
  String get rejectError => 'Error rejecting request';

  @override
  String roleSelection(Object email) {
    return 'Role Selection for $email';
  }

  @override
  String get administrator => 'Administrator';

  @override
  String get fullAccess => 'Full access to all functions';

  @override
  String get child => 'Child';

  @override
  String get expensesOnly => 'Can only add expenses';

  @override
  String get customRole => 'Custom Role';

  @override
  String get configurePermissions => 'Configure access permissions';

  @override
  String get permissionsConfig => 'Access Permissions Configuration';

  @override
  String get canAddExpenses => 'Can add expenses';

  @override
  String get canUseChat => 'Can use chat';

  @override
  String get canAddIncome => 'Can add income';

  @override
  String get canViewAllAccounts => 'Can view all accounts';

  @override
  String get canEditAccounts => 'Can edit accounts';

  @override
  String get canViewStatistics => 'Can view statistics';

  @override
  String get canInviteMembers => 'Can invite members';

  @override
  String get canManageRoles => 'Can manage roles';

  @override
  String get noLocalFamilies => 'No families found in local network';

  @override
  String get availableFamilies => 'Available Families';

  @override
  String get familyNoName => 'Family without name';

  @override
  String get code => 'Code';

  @override
  String get searchError => 'Error searching families';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get ukrainian => 'Ukrainian';

  @override
  String get english => 'English';

  @override
  String get familySettingsDesc => 'Create, join and manage family';

  @override
  String get geoLocation => 'Transaction Geolocation';

  @override
  String get geoLocationDesc => 'Automatically add geotags to transactions';

  @override
  String get profileSettingsTitle => 'Profile Settings';

  @override
  String get securitySettingsDesc => 'App security login settings';

  @override
  String get light => 'Light';

  @override
  String get displayCurrency => 'Display Currency';

  @override
  String get currencyDesc =>
      'All amounts will be converted to selected currency';

  @override
  String get syncStatus => 'View Status';

  @override
  String get userNotInFamily => 'Error: user not in family';

  @override
  String get syncProgress => 'Checking sync status...';

  @override
  String get syncStatusTitle => 'Sync Status';

  @override
  String get syncSuccess => 'All data successfully synchronized';

  @override
  String get syncProblems => 'Problems occurred during synchronization';

  @override
  String get close => 'Close';

  @override
  String get dataExported => 'Data successfully exported';

  @override
  String get exportDesc => 'Save data to JSON file';

  @override
  String get securityTitle => 'Security Settings';

  @override
  String get useBiometrics => 'Use Biometrics';

  @override
  String get biometricsDesc => 'Face ID / Touch ID';

  @override
  String get usePinCode => 'Use PIN Code';

  @override
  String get pinCodeDesc => '4-digit code for login';

  @override
  String get biometricsNotSupported =>
      'Biometrics not supported on this device';

  @override
  String get setPinCode => 'Set PIN Code';

  @override
  String get enter4Digits => 'Enter 4-digit code';

  @override
  String get pinMust4Digits => 'PIN code must contain 4 digits';

  @override
  String get helpTitle => 'Help';

  @override
  String get howToUse => 'How to use the app';

  @override
  String get addIncomeHelp =>
      '1. Adding income: drag income category to account';

  @override
  String get addExpenseHelp =>
      '2. Adding expenses: drag expense category to account';

  @override
  String get viewStatsHelp =>
      '3. View statistics: tap category for detailed analysis';

  @override
  String get aboutTitle => 'About';

  @override
  String get familyBudget => 'Family Budget';

  @override
  String get version => 'Version 0.0.2';

  @override
  String get copyright => '© 2025 All rights reserved';

  @override
  String get accountName => 'Account Name';

  @override
  String get initialBalance => 'Initial Balance';

  @override
  String get accountOwner => 'Account Owner';

  @override
  String get personal => 'Personal';

  @override
  String get familyAccount => 'Family';

  @override
  String get add => 'Add';

  @override
  String get invalidBalance => 'Invalid balance';

  @override
  String get categoryName => 'Category Name';

  @override
  String get now => 'Now';

  @override
  String get selectDate => 'Select Date';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get comment => 'Comment';

  @override
  String get currentAccount => 'Current Account';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get deleteTransactionConfirm =>
      'Are you sure you want to delete this transaction?';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get invalidAmount => 'Invalid amount';

  @override
  String get noPermissionIncome => 'You don\'t have permission to add income';

  @override
  String get noAccounts => 'No accounts';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get noExpenses => 'No expenses';

  @override
  String get unknownAccount => 'Unknown account';

  @override
  String get familyIdError => 'Error getting family ID';

  @override
  String get transactionLocation => 'Transaction location:';

  @override
  String get mapDisplayError => 'Map display error';

  @override
  String get locationError => 'Location error';

  @override
  String get products => 'Products';

  @override
  String get transport => 'Transport';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get utilities => 'Utilities';

  @override
  String get clothing => 'Clothing';

  @override
  String get other => 'Other';

  @override
  String get selectUser => 'Select User';

  @override
  String get noOtherUsers => 'No other users';

  @override
  String get user => 'User';

  @override
  String get myAccounts => 'My Accounts';

  @override
  String get familyAccounts => 'Family Accounts';

  @override
  String get userAccounts => 'User Accounts';

  @override
  String accounts_count(Object count) {
    return '$count accounts';
  }

  @override
  String get addAccountTooltip => 'Add Account';

  @override
  String get noUserAccounts => 'User has no accounts';

  @override
  String get noTitle => 'No Title';

  @override
  String get balance => 'Balance';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String deleteAccountConfirm(Object name) {
    return 'Are you sure you want to delete account \"$name\"?';
  }

  @override
  String get adminOnly => 'Available only for administrators';

  @override
  String get noFamilyAccounts => 'No family accounts';

  @override
  String get noPersonalAccounts => 'No personal accounts';

  @override
  String userNoAccounts(Object name) {
    return 'User $name has no accounts';
  }

  @override
  String get transferBetweenAccounts => 'Transfer between accounts';

  @override
  String get fromAccount => 'From account';

  @override
  String get toAccount => 'To account';

  @override
  String get transfer => 'Transfer';

  @override
  String get transferNote => 'Transfer to another account';

  @override
  String get transferFromNote => 'Transfer from another account';

  @override
  String get otherUser => 'Other user';

  @override
  String get salary => 'Salary';

  @override
  String get gifts => 'Gifts';

  @override
  String get dividends => 'Dividends';

  @override
  String get partTime => 'Part-time';

  @override
  String get sale => 'Sale';

  @override
  String get editIncome => 'Edit Income';

  @override
  String get addIncome => 'Add Income';

  @override
  String get noIncomes => 'No incomes';

  @override
  String get statistics => 'Statistics';

  @override
  String get noAccessToStats => 'You don\'t have access to statistics';

  @override
  String get expenseStats => 'Expense Statistics';

  @override
  String get generalStats => 'General Statistics';

  @override
  String get incomeStats => 'Income Statistics';

  @override
  String get wholeFamily => 'Whole Family';

  @override
  String get allAccounts => 'All Accounts';

  @override
  String get totalEarned => 'Total earned';

  @override
  String get totalSpent => 'Total spent';

  @override
  String get totalBalance => 'Total balance';

  @override
  String get total => 'Total';

  @override
  String get spent => 'spent';

  @override
  String get received => 'received';

  @override
  String get averagePerDay => 'Average per day';

  @override
  String get noDataToDisplay => 'No data to display';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get expenseHistory => 'Expense History';

  @override
  String get incomeHistory => 'Income History';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get insufficientData =>
      'Insufficient data for analysis. Add more transactions.';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get chat => 'Chat';

  @override
  String get financialAssistant => 'Financial Assistant';

  @override
  String get personalizedRecommendations =>
      'Get personalized recommendations for optimizing your budget based on analysis of your expenses.';

  @override
  String get getRecommendations => 'Get Recommendations';

  @override
  String get recommendationsTitle => 'Recommendations';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get askFinances => 'Ask something about your finances...';

  @override
  String get aiThinking => 'AI is thinking...';

  @override
  String get familyChat => 'Family Chat';

  @override
  String get noMessages => 'No messages';

  @override
  String get message => 'Message';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String familyKeyError(Object error) {
    return 'Error loading family key: $error';
  }

  @override
  String messageProcessError(Object error) {
    return 'Error processing messages: $error';
  }

  @override
  String get enterBiometrics => 'Enter to access the app';

  @override
  String biometricAuthError(Object error) {
    return 'Biometric authentication error: $error';
  }

  @override
  String get incorrectPin => 'Incorrect PIN code';

  @override
  String get enterPin => 'Enter PIN code';

  @override
  String get enterWithBiometrics => 'Enter with biometrics';

  @override
  String get or => 'or';

  @override
  String get enter => 'Enter';

  @override
  String get loginProtectionNotSet => 'Login protection not set';

  @override
  String get continueAction => 'Continue';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get profilePhotoUpdated => 'Profile photo updated';

  @override
  String photoUploadError(String error) {
    return 'Photo upload error: $error';
  }

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get saveChanges => 'Save Changes';
}
