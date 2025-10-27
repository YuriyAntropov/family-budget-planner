import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk')
  ];

  /// No description provided for @appTitle.
  ///
  /// In uk, this message translates to:
  /// **'Планувальник сімейного бюджету'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In uk, this message translates to:
  /// **'Вітаємо, {name}!'**
  String welcome(String name);

  /// No description provided for @settings.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In uk, this message translates to:
  /// **'Мова'**
  String get language;

  /// No description provided for @home.
  ///
  /// In uk, this message translates to:
  /// **'Головна'**
  String get home;

  /// No description provided for @income.
  ///
  /// In uk, this message translates to:
  /// **'Доходи'**
  String get income;

  /// No description provided for @accounts.
  ///
  /// In uk, this message translates to:
  /// **'Рахунки'**
  String get accounts;

  /// No description provided for @expenses.
  ///
  /// In uk, this message translates to:
  /// **'Витрати'**
  String get expenses;

  /// No description provided for @addAccount.
  ///
  /// In uk, this message translates to:
  /// **'Додати рахунок'**
  String get addAccount;

  /// No description provided for @addCategory.
  ///
  /// In uk, this message translates to:
  /// **'Додати категорію'**
  String get addCategory;

  /// No description provided for @cancel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get delete;

  /// No description provided for @amount.
  ///
  /// In uk, this message translates to:
  /// **'Сума'**
  String get amount;

  /// No description provided for @currency.
  ///
  /// In uk, this message translates to:
  /// **'Валюта'**
  String get currency;

  /// No description provided for @date.
  ///
  /// In uk, this message translates to:
  /// **'Дата'**
  String get date;

  /// No description provided for @category.
  ///
  /// In uk, this message translates to:
  /// **'Категорія'**
  String get category;

  /// No description provided for @account.
  ///
  /// In uk, this message translates to:
  /// **'Рахунок'**
  String get account;

  /// No description provided for @logout.
  ///
  /// In uk, this message translates to:
  /// **'Вийти'**
  String get logout;

  /// No description provided for @familySettings.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування сім\'ї'**
  String get familySettings;

  /// No description provided for @profileSettings.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування профілю'**
  String get profileSettings;

  /// No description provided for @securitySettings.
  ///
  /// In uk, this message translates to:
  /// **'Параметри входу'**
  String get securitySettings;

  /// No description provided for @theme.
  ///
  /// In uk, this message translates to:
  /// **'Тема'**
  String get theme;

  /// No description provided for @sync.
  ///
  /// In uk, this message translates to:
  /// **'Синхронізація'**
  String get sync;

  /// No description provided for @help.
  ///
  /// In uk, this message translates to:
  /// **'Допомога'**
  String get help;

  /// No description provided for @about.
  ///
  /// In uk, this message translates to:
  /// **'Про програму'**
  String get about;

  /// No description provided for @exportData.
  ///
  /// In uk, this message translates to:
  /// **'Експорт даних'**
  String get exportData;

  /// No description provided for @login.
  ///
  /// In uk, this message translates to:
  /// **'Вхід'**
  String get login;

  /// No description provided for @password.
  ///
  /// In uk, this message translates to:
  /// **'Пароль'**
  String get password;

  /// No description provided for @fillAllFields.
  ///
  /// In uk, this message translates to:
  /// **'Заповніть всі поля'**
  String get fillAllFields;

  /// No description provided for @loginError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка входу. Перевірте дані.'**
  String get loginError;

  /// No description provided for @userNotFound.
  ///
  /// In uk, this message translates to:
  /// **'Користувача з таким email не знайдено'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In uk, this message translates to:
  /// **'Неправильний пароль'**
  String get wrongPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In uk, this message translates to:
  /// **'Некоректний email'**
  String get invalidEmail;

  /// No description provided for @userDisabled.
  ///
  /// In uk, this message translates to:
  /// **'Цей обліковий запис відключено'**
  String get userDisabled;

  /// No description provided for @signIn.
  ///
  /// In uk, this message translates to:
  /// **'Увійти'**
  String get signIn;

  /// No description provided for @noAccount.
  ///
  /// In uk, this message translates to:
  /// **'Немає облікового запису? Зареєструватися'**
  String get noAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In uk, this message translates to:
  /// **'Забули пароль?'**
  String get forgotPassword;

  /// No description provided for @enterEmailReset.
  ///
  /// In uk, this message translates to:
  /// **'Введіть email для скидання пароля'**
  String get enterEmailReset;

  /// No description provided for @resetInstructions.
  ///
  /// In uk, this message translates to:
  /// **'Інструкції для скидання пароля відправлено на email'**
  String get resetInstructions;

  /// No description provided for @signInGoogle.
  ///
  /// In uk, this message translates to:
  /// **'Увійти через Google'**
  String get signInGoogle;

  /// No description provided for @googleLoginError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка входу через Google'**
  String get googleLoginError;

  /// No description provided for @registration.
  ///
  /// In uk, this message translates to:
  /// **'Реєстрація'**
  String get registration;

  /// No description provided for @createAccount.
  ///
  /// In uk, this message translates to:
  /// **'Створення облікового запису'**
  String get createAccount;

  /// No description provided for @yourName.
  ///
  /// In uk, this message translates to:
  /// **'Ваше ім\'я'**
  String get yourName;

  /// No description provided for @confirmPassword.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердження пароля'**
  String get confirmPassword;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In uk, this message translates to:
  /// **'Паролі не співпадають'**
  String get passwordsDontMatch;

  /// No description provided for @register.
  ///
  /// In uk, this message translates to:
  /// **'Зареєструватися'**
  String get register;

  /// No description provided for @emailInUse.
  ///
  /// In uk, this message translates to:
  /// **'Цей email вже використовується'**
  String get emailInUse;

  /// No description provided for @weakPassword.
  ///
  /// In uk, this message translates to:
  /// **'Пароль занадто слабкий'**
  String get weakPassword;

  /// No description provided for @registrationError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка реєстрації'**
  String get registrationError;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In uk, this message translates to:
  /// **'Вже маєте обліковий запис? Увійти'**
  String get alreadyHaveAccount;

  /// No description provided for @familySettingsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування сім\'ї'**
  String get familySettingsTitle;

  /// No description provided for @refreshData.
  ///
  /// In uk, this message translates to:
  /// **'Оновити дані'**
  String get refreshData;

  /// No description provided for @notFamilyMember.
  ///
  /// In uk, this message translates to:
  /// **'Ви не є членом сім\'ї'**
  String get notFamilyMember;

  /// No description provided for @updateStatus.
  ///
  /// In uk, this message translates to:
  /// **'Оновити статус'**
  String get updateStatus;

  /// No description provided for @restartApp.
  ///
  /// In uk, this message translates to:
  /// **'Перезапустити додаток для оновлення даних'**
  String get restartApp;

  /// No description provided for @returnHome.
  ///
  /// In uk, this message translates to:
  /// **'Повернутися на головну'**
  String get returnHome;

  /// No description provided for @createFamily.
  ///
  /// In uk, this message translates to:
  /// **'Створити сім\'ю'**
  String get createFamily;

  /// No description provided for @familyName.
  ///
  /// In uk, this message translates to:
  /// **'Назва сім\'ї'**
  String get familyName;

  /// No description provided for @create.
  ///
  /// In uk, this message translates to:
  /// **'Створити'**
  String get create;

  /// No description provided for @joinFamily.
  ///
  /// In uk, this message translates to:
  /// **'Приєднатися до сім\'ї'**
  String get joinFamily;

  /// No description provided for @inviteCode.
  ///
  /// In uk, this message translates to:
  /// **'Код запрошення'**
  String get inviteCode;

  /// No description provided for @join.
  ///
  /// In uk, this message translates to:
  /// **'Приєднатися'**
  String get join;

  /// No description provided for @findLocalFamilies.
  ///
  /// In uk, this message translates to:
  /// **'Знайти сім\'ї в локальній мережі'**
  String get findLocalFamilies;

  /// No description provided for @joinNFC.
  ///
  /// In uk, this message translates to:
  /// **'Приєднатися через NFC'**
  String get joinNFC;

  /// No description provided for @bringDeviceNFC.
  ///
  /// In uk, this message translates to:
  /// **'Піднесіть пристрій до іншого пристрою з NFC'**
  String get bringDeviceNFC;

  /// No description provided for @familyCreated.
  ///
  /// In uk, this message translates to:
  /// **'Сім\'ю успішно створено'**
  String get familyCreated;

  /// No description provided for @joinRequestSent.
  ///
  /// In uk, this message translates to:
  /// **'Запит на приєднання надіслано. Очікуйте підтвердження.'**
  String get joinRequestSent;

  /// No description provided for @familyNotFound.
  ///
  /// In uk, this message translates to:
  /// **'Сім\'ю з таким кодом запрошення не знайдено'**
  String get familyNotFound;

  /// No description provided for @family.
  ///
  /// In uk, this message translates to:
  /// **'Сім\'я'**
  String get family;

  /// No description provided for @copy.
  ///
  /// In uk, this message translates to:
  /// **'Копіювати'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In uk, this message translates to:
  /// **'Поділитися'**
  String get share;

  /// No description provided for @shareNFC.
  ///
  /// In uk, this message translates to:
  /// **'Поділитися через NFC'**
  String get shareNFC;

  /// No description provided for @dataSentNFC.
  ///
  /// In uk, this message translates to:
  /// **'Дані успішно передано через NFC'**
  String get dataSentNFC;

  /// No description provided for @familyMembers.
  ///
  /// In uk, this message translates to:
  /// **'Члени сім\'ї'**
  String get familyMembers;

  /// No description provided for @unknownUser.
  ///
  /// In uk, this message translates to:
  /// **'Невідомий користувач'**
  String get unknownUser;

  /// No description provided for @role.
  ///
  /// In uk, this message translates to:
  /// **'Роль'**
  String get role;

  /// No description provided for @device.
  ///
  /// In uk, this message translates to:
  /// **'Пристрій'**
  String get device;

  /// No description provided for @unknown.
  ///
  /// In uk, this message translates to:
  /// **'Невідомо'**
  String get unknown;

  /// No description provided for @removeUser.
  ///
  /// In uk, this message translates to:
  /// **'Видалити користувача'**
  String get removeUser;

  /// No description provided for @removeUserConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Ви дійсно хочете видалити користувача {email} з сім\'ї?'**
  String removeUserConfirm(Object email);

  /// No description provided for @userRemoved.
  ///
  /// In uk, this message translates to:
  /// **'Користувача видалено з сім\'ї'**
  String get userRemoved;

  /// No description provided for @removeUserError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка видалення користувача'**
  String get removeUserError;

  /// No description provided for @joinRequests.
  ///
  /// In uk, this message translates to:
  /// **'Запити на приєднання'**
  String get joinRequests;

  /// No description provided for @location.
  ///
  /// In uk, this message translates to:
  /// **'Локація'**
  String get location;

  /// No description provided for @accept.
  ///
  /// In uk, this message translates to:
  /// **'Прийняти'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In uk, this message translates to:
  /// **'Відхилити'**
  String get reject;

  /// No description provided for @leaveFamily.
  ///
  /// In uk, this message translates to:
  /// **'Вийти з сім\'ї'**
  String get leaveFamily;

  /// No description provided for @leaveFamilyConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Ви дійсно хочете вийти з сім\'ї? Всі ваші дані будуть відключені від сімейного бюджету.'**
  String get leaveFamilyConfirm;

  /// No description provided for @leftFamily.
  ///
  /// In uk, this message translates to:
  /// **'Ви успішно вийшли з сім\'ї'**
  String get leftFamily;

  /// No description provided for @leaveFamilyError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка виходу з сім\'ї'**
  String get leaveFamilyError;

  /// No description provided for @restartRequired.
  ///
  /// In uk, this message translates to:
  /// **'Перезапустіть додаток'**
  String get restartRequired;

  /// No description provided for @restartMessage.
  ///
  /// In uk, this message translates to:
  /// **'Вас було додано до сім\'ї. Для застосування змін необхідно перезапустити додаток.'**
  String get restartMessage;

  /// No description provided for @restart.
  ///
  /// In uk, this message translates to:
  /// **'Перезапустити'**
  String get restart;

  /// No description provided for @userAdded.
  ///
  /// In uk, this message translates to:
  /// **'Користувача додано до сім\'ї. Попросіть його перезапустити додаток.'**
  String get userAdded;

  /// No description provided for @requestRejected.
  ///
  /// In uk, this message translates to:
  /// **'Запит відхилено'**
  String get requestRejected;

  /// No description provided for @rejectError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка відхилення запиту'**
  String get rejectError;

  /// No description provided for @roleSelection.
  ///
  /// In uk, this message translates to:
  /// **'Вибір ролі для {email}'**
  String roleSelection(Object email);

  /// No description provided for @administrator.
  ///
  /// In uk, this message translates to:
  /// **'Адміністратор'**
  String get administrator;

  /// No description provided for @fullAccess.
  ///
  /// In uk, this message translates to:
  /// **'Повний доступ до всіх функцій'**
  String get fullAccess;

  /// No description provided for @child.
  ///
  /// In uk, this message translates to:
  /// **'Дитина'**
  String get child;

  /// No description provided for @expensesOnly.
  ///
  /// In uk, this message translates to:
  /// **'Може тільки додавати витрати'**
  String get expensesOnly;

  /// No description provided for @customRole.
  ///
  /// In uk, this message translates to:
  /// **'Своя роль'**
  String get customRole;

  /// No description provided for @configurePermissions.
  ///
  /// In uk, this message translates to:
  /// **'Налаштувати права доступу'**
  String get configurePermissions;

  /// No description provided for @permissionsConfig.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування прав доступу'**
  String get permissionsConfig;

  /// No description provided for @canAddExpenses.
  ///
  /// In uk, this message translates to:
  /// **'Може додавати витрати'**
  String get canAddExpenses;

  /// No description provided for @canUseChat.
  ///
  /// In uk, this message translates to:
  /// **'Може писати в чаті'**
  String get canUseChat;

  /// No description provided for @canAddIncome.
  ///
  /// In uk, this message translates to:
  /// **'Може додавати доходи'**
  String get canAddIncome;

  /// No description provided for @canViewAllAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Може бачити всі рахунки'**
  String get canViewAllAccounts;

  /// No description provided for @canEditAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Може редагувати рахунки'**
  String get canEditAccounts;

  /// No description provided for @canViewStatistics.
  ///
  /// In uk, this message translates to:
  /// **'Може бачити статистику'**
  String get canViewStatistics;

  /// No description provided for @canInviteMembers.
  ///
  /// In uk, this message translates to:
  /// **'Може запрошувати учасників'**
  String get canInviteMembers;

  /// No description provided for @canManageRoles.
  ///
  /// In uk, this message translates to:
  /// **'Може керувати ролями'**
  String get canManageRoles;

  /// No description provided for @noLocalFamilies.
  ///
  /// In uk, this message translates to:
  /// **'Сім\'ї в локальній мережі не знайдено'**
  String get noLocalFamilies;

  /// No description provided for @availableFamilies.
  ///
  /// In uk, this message translates to:
  /// **'Доступні сім\'ї'**
  String get availableFamilies;

  /// No description provided for @familyNoName.
  ///
  /// In uk, this message translates to:
  /// **'Сім\'я без назви'**
  String get familyNoName;

  /// No description provided for @code.
  ///
  /// In uk, this message translates to:
  /// **'Код'**
  String get code;

  /// No description provided for @searchError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка пошуку сімей'**
  String get searchError;

  /// No description provided for @settingsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settingsTitle;

  /// No description provided for @ukrainian.
  ///
  /// In uk, this message translates to:
  /// **'Українська'**
  String get ukrainian;

  /// No description provided for @english.
  ///
  /// In uk, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @familySettingsDesc.
  ///
  /// In uk, this message translates to:
  /// **'Створення, приєднання та управління сім\'єю'**
  String get familySettingsDesc;

  /// No description provided for @geoLocation.
  ///
  /// In uk, this message translates to:
  /// **'Геолокація транзакцій'**
  String get geoLocation;

  /// No description provided for @geoLocationDesc.
  ///
  /// In uk, this message translates to:
  /// **'Автоматично додавати геомітки до транзакцій'**
  String get geoLocationDesc;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування профілю'**
  String get profileSettingsTitle;

  /// No description provided for @securitySettingsDesc.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування безпеки входу в додаток'**
  String get securitySettingsDesc;

  /// No description provided for @light.
  ///
  /// In uk, this message translates to:
  /// **'Світла'**
  String get light;

  /// No description provided for @displayCurrency.
  ///
  /// In uk, this message translates to:
  /// **'Валюта для відображення'**
  String get displayCurrency;

  /// No description provided for @currencyDesc.
  ///
  /// In uk, this message translates to:
  /// **'Всі суми будуть конвертовані в обрану валюту'**
  String get currencyDesc;

  /// No description provided for @syncStatus.
  ///
  /// In uk, this message translates to:
  /// **'Переглянути статус'**
  String get syncStatus;

  /// No description provided for @userNotInFamily.
  ///
  /// In uk, this message translates to:
  /// **'Помилка: користувач не в сім\'ї'**
  String get userNotInFamily;

  /// No description provided for @syncProgress.
  ///
  /// In uk, this message translates to:
  /// **'Перевірка статусу синхронізації...'**
  String get syncProgress;

  /// No description provided for @syncStatusTitle.
  ///
  /// In uk, this message translates to:
  /// **'Статус синхронізації'**
  String get syncStatusTitle;

  /// No description provided for @syncSuccess.
  ///
  /// In uk, this message translates to:
  /// **'Всі дані успішно синхронізовано'**
  String get syncSuccess;

  /// No description provided for @syncProblems.
  ///
  /// In uk, this message translates to:
  /// **'Виникли проблеми при синхронізації'**
  String get syncProblems;

  /// No description provided for @close.
  ///
  /// In uk, this message translates to:
  /// **'Закрити'**
  String get close;

  /// No description provided for @dataExported.
  ///
  /// In uk, this message translates to:
  /// **'Дані успішно експортовано'**
  String get dataExported;

  /// No description provided for @exportDesc.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти дані в JSON файл'**
  String get exportDesc;

  /// No description provided for @securityTitle.
  ///
  /// In uk, this message translates to:
  /// **'Параметри входу'**
  String get securityTitle;

  /// No description provided for @useBiometrics.
  ///
  /// In uk, this message translates to:
  /// **'Використовувати біометрію'**
  String get useBiometrics;

  /// No description provided for @biometricsDesc.
  ///
  /// In uk, this message translates to:
  /// **'Face ID / Touch ID'**
  String get biometricsDesc;

  /// No description provided for @usePinCode.
  ///
  /// In uk, this message translates to:
  /// **'Використовувати PIN-код'**
  String get usePinCode;

  /// No description provided for @pinCodeDesc.
  ///
  /// In uk, this message translates to:
  /// **'4-значний код для входу'**
  String get pinCodeDesc;

  /// No description provided for @biometricsNotSupported.
  ///
  /// In uk, this message translates to:
  /// **'Біометрія не підтримується на цьому пристрої'**
  String get biometricsNotSupported;

  /// No description provided for @setPinCode.
  ///
  /// In uk, this message translates to:
  /// **'Встановіть PIN-код'**
  String get setPinCode;

  /// No description provided for @enter4Digits.
  ///
  /// In uk, this message translates to:
  /// **'Введіть 4-значний код'**
  String get enter4Digits;

  /// No description provided for @pinMust4Digits.
  ///
  /// In uk, this message translates to:
  /// **'PIN-код повинен містити 4 цифри'**
  String get pinMust4Digits;

  /// No description provided for @helpTitle.
  ///
  /// In uk, this message translates to:
  /// **'Допомога'**
  String get helpTitle;

  /// No description provided for @howToUse.
  ///
  /// In uk, this message translates to:
  /// **'Як користуватися додатком'**
  String get howToUse;

  /// No description provided for @addIncomeHelp.
  ///
  /// In uk, this message translates to:
  /// **'1. Додавання доходів: перетягніть категорію доходу на рахунок'**
  String get addIncomeHelp;

  /// No description provided for @addExpenseHelp.
  ///
  /// In uk, this message translates to:
  /// **'2. Додавання витрат: перетягніть категорію витрат на рахунок'**
  String get addExpenseHelp;

  /// No description provided for @viewStatsHelp.
  ///
  /// In uk, this message translates to:
  /// **'3. Перегляд статистики: натисніть на категорію для детального аналізу'**
  String get viewStatsHelp;

  /// No description provided for @aboutTitle.
  ///
  /// In uk, this message translates to:
  /// **'Про програму'**
  String get aboutTitle;

  /// No description provided for @familyBudget.
  ///
  /// In uk, this message translates to:
  /// **'Сімейний бюджет'**
  String get familyBudget;

  /// No description provided for @version.
  ///
  /// In uk, this message translates to:
  /// **'Версія 0.0.2'**
  String get version;

  /// No description provided for @copyright.
  ///
  /// In uk, this message translates to:
  /// **'© 2025 Всі права захищені'**
  String get copyright;

  /// No description provided for @accountName.
  ///
  /// In uk, this message translates to:
  /// **'Назва рахунку'**
  String get accountName;

  /// No description provided for @initialBalance.
  ///
  /// In uk, this message translates to:
  /// **'Початковий баланс'**
  String get initialBalance;

  /// No description provided for @accountOwner.
  ///
  /// In uk, this message translates to:
  /// **'Власник рахунку'**
  String get accountOwner;

  /// No description provided for @personal.
  ///
  /// In uk, this message translates to:
  /// **'Особистий'**
  String get personal;

  /// No description provided for @familyAccount.
  ///
  /// In uk, this message translates to:
  /// **'Сімейний'**
  String get familyAccount;

  /// No description provided for @add.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
  String get add;

  /// No description provided for @invalidBalance.
  ///
  /// In uk, this message translates to:
  /// **'Некоректний баланс'**
  String get invalidBalance;

  /// No description provided for @categoryName.
  ///
  /// In uk, this message translates to:
  /// **'Назва категорії'**
  String get categoryName;

  /// No description provided for @now.
  ///
  /// In uk, this message translates to:
  /// **'Зараз'**
  String get now;

  /// No description provided for @selectDate.
  ///
  /// In uk, this message translates to:
  /// **'Вибрати дату'**
  String get selectDate;

  /// No description provided for @addExpense.
  ///
  /// In uk, this message translates to:
  /// **'Додати витрату'**
  String get addExpense;

  /// No description provided for @editExpense.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати витрату'**
  String get editExpense;

  /// No description provided for @comment.
  ///
  /// In uk, this message translates to:
  /// **'Коментар'**
  String get comment;

  /// No description provided for @currentAccount.
  ///
  /// In uk, this message translates to:
  /// **'Поточний рахунок'**
  String get currentAccount;

  /// No description provided for @confirmation.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердження'**
  String get confirmation;

  /// No description provided for @deleteTransactionConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Ви впевнені, що хочете видалити цю транзакцію?'**
  String get deleteTransactionConfirm;

  /// No description provided for @transactionDeleted.
  ///
  /// In uk, this message translates to:
  /// **'Транзакцію видалено'**
  String get transactionDeleted;

  /// No description provided for @invalidAmount.
  ///
  /// In uk, this message translates to:
  /// **'Некоректна сума'**
  String get invalidAmount;

  /// No description provided for @noPermissionIncome.
  ///
  /// In uk, this message translates to:
  /// **'У вас немає прав для додавання доходів'**
  String get noPermissionIncome;

  /// No description provided for @noAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Немає рахунків'**
  String get noAccounts;

  /// No description provided for @noTransactions.
  ///
  /// In uk, this message translates to:
  /// **'Немає транзакцій'**
  String get noTransactions;

  /// No description provided for @noExpenses.
  ///
  /// In uk, this message translates to:
  /// **'Немає витрат'**
  String get noExpenses;

  /// No description provided for @unknownAccount.
  ///
  /// In uk, this message translates to:
  /// **'Невідомий рахунок'**
  String get unknownAccount;

  /// No description provided for @familyIdError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка отримання ID сім\'ї'**
  String get familyIdError;

  /// No description provided for @transactionLocation.
  ///
  /// In uk, this message translates to:
  /// **'Місце здійснення транзакції:'**
  String get transactionLocation;

  /// No description provided for @mapDisplayError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка відображення карти'**
  String get mapDisplayError;

  /// No description provided for @locationError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка отримання геолокації'**
  String get locationError;

  /// No description provided for @products.
  ///
  /// In uk, this message translates to:
  /// **'Продукти'**
  String get products;

  /// No description provided for @transport.
  ///
  /// In uk, this message translates to:
  /// **'Транспорт'**
  String get transport;

  /// No description provided for @entertainment.
  ///
  /// In uk, this message translates to:
  /// **'Розваги'**
  String get entertainment;

  /// No description provided for @utilities.
  ///
  /// In uk, this message translates to:
  /// **'Комунальні'**
  String get utilities;

  /// No description provided for @clothing.
  ///
  /// In uk, this message translates to:
  /// **'Одяг'**
  String get clothing;

  /// No description provided for @other.
  ///
  /// In uk, this message translates to:
  /// **'Інше'**
  String get other;

  /// No description provided for @selectUser.
  ///
  /// In uk, this message translates to:
  /// **'Вибрати користувача'**
  String get selectUser;

  /// No description provided for @noOtherUsers.
  ///
  /// In uk, this message translates to:
  /// **'Немає інших користувачів'**
  String get noOtherUsers;

  /// No description provided for @user.
  ///
  /// In uk, this message translates to:
  /// **'Користувач'**
  String get user;

  /// No description provided for @myAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Мої рахунки'**
  String get myAccounts;

  /// No description provided for @familyAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Сімейні рахунки'**
  String get familyAccounts;

  /// No description provided for @userAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Рахунки користувачів'**
  String get userAccounts;

  /// No description provided for @accounts_count.
  ///
  /// In uk, this message translates to:
  /// **'{count} рахунків'**
  String accounts_count(Object count);

  /// No description provided for @addAccountTooltip.
  ///
  /// In uk, this message translates to:
  /// **'Додати рахунок'**
  String get addAccountTooltip;

  /// No description provided for @noUserAccounts.
  ///
  /// In uk, this message translates to:
  /// **'У користувача немає рахунків'**
  String get noUserAccounts;

  /// No description provided for @noTitle.
  ///
  /// In uk, this message translates to:
  /// **'Без назви'**
  String get noTitle;

  /// No description provided for @balance.
  ///
  /// In uk, this message translates to:
  /// **'Баланс'**
  String get balance;

  /// No description provided for @editAccount.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати рахунок'**
  String get editAccount;

  /// No description provided for @deleteAccount.
  ///
  /// In uk, this message translates to:
  /// **'Видалення рахунку'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Ви впевнені, що хочете видалити рахунок \"{name}\"?'**
  String deleteAccountConfirm(Object name);

  /// No description provided for @adminOnly.
  ///
  /// In uk, this message translates to:
  /// **'Доступно тільки для адміністраторів'**
  String get adminOnly;

  /// No description provided for @noFamilyAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Немає сімейних рахунків'**
  String get noFamilyAccounts;

  /// No description provided for @noPersonalAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Немає особистих рахунків'**
  String get noPersonalAccounts;

  /// No description provided for @userNoAccounts.
  ///
  /// In uk, this message translates to:
  /// **'У користувача {name} немає рахунків'**
  String userNoAccounts(Object name);

  /// No description provided for @transferBetweenAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Переказ між рахунками'**
  String get transferBetweenAccounts;

  /// No description provided for @fromAccount.
  ///
  /// In uk, this message translates to:
  /// **'З рахунку'**
  String get fromAccount;

  /// No description provided for @toAccount.
  ///
  /// In uk, this message translates to:
  /// **'На рахунок'**
  String get toAccount;

  /// No description provided for @transfer.
  ///
  /// In uk, this message translates to:
  /// **'Переказати'**
  String get transfer;

  /// No description provided for @transferNote.
  ///
  /// In uk, this message translates to:
  /// **'Переказ на інший рахунок'**
  String get transferNote;

  /// No description provided for @transferFromNote.
  ///
  /// In uk, this message translates to:
  /// **'Переказ з іншого рахунку'**
  String get transferFromNote;

  /// No description provided for @otherUser.
  ///
  /// In uk, this message translates to:
  /// **'Інший користувач'**
  String get otherUser;

  /// No description provided for @salary.
  ///
  /// In uk, this message translates to:
  /// **'Зарплата'**
  String get salary;

  /// No description provided for @gifts.
  ///
  /// In uk, this message translates to:
  /// **'Подарунки'**
  String get gifts;

  /// No description provided for @dividends.
  ///
  /// In uk, this message translates to:
  /// **'Дивіденди'**
  String get dividends;

  /// No description provided for @partTime.
  ///
  /// In uk, this message translates to:
  /// **'Підробіток'**
  String get partTime;

  /// No description provided for @sale.
  ///
  /// In uk, this message translates to:
  /// **'Продаж'**
  String get sale;

  /// No description provided for @editIncome.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати дохід'**
  String get editIncome;

  /// No description provided for @addIncome.
  ///
  /// In uk, this message translates to:
  /// **'Додати дохід'**
  String get addIncome;

  /// No description provided for @noIncomes.
  ///
  /// In uk, this message translates to:
  /// **'Немає доходів'**
  String get noIncomes;

  /// No description provided for @statistics.
  ///
  /// In uk, this message translates to:
  /// **'Статистика'**
  String get statistics;

  /// No description provided for @noAccessToStats.
  ///
  /// In uk, this message translates to:
  /// **'У вас немає доступу до статистики'**
  String get noAccessToStats;

  /// No description provided for @expenseStats.
  ///
  /// In uk, this message translates to:
  /// **'Статистика витрат'**
  String get expenseStats;

  /// No description provided for @generalStats.
  ///
  /// In uk, this message translates to:
  /// **'Загальна статистика'**
  String get generalStats;

  /// No description provided for @incomeStats.
  ///
  /// In uk, this message translates to:
  /// **'Статистика доходів'**
  String get incomeStats;

  /// No description provided for @wholeFamily.
  ///
  /// In uk, this message translates to:
  /// **'Вся сім\'я'**
  String get wholeFamily;

  /// No description provided for @allAccounts.
  ///
  /// In uk, this message translates to:
  /// **'Всі рахунки'**
  String get allAccounts;

  /// No description provided for @totalEarned.
  ///
  /// In uk, this message translates to:
  /// **'Всього зароблено'**
  String get totalEarned;

  /// No description provided for @totalSpent.
  ///
  /// In uk, this message translates to:
  /// **'Всього витрачено'**
  String get totalSpent;

  /// No description provided for @totalBalance.
  ///
  /// In uk, this message translates to:
  /// **'Загальний баланс'**
  String get totalBalance;

  /// No description provided for @total.
  ///
  /// In uk, this message translates to:
  /// **'Всього'**
  String get total;

  /// No description provided for @spent.
  ///
  /// In uk, this message translates to:
  /// **'витрачено'**
  String get spent;

  /// No description provided for @received.
  ///
  /// In uk, this message translates to:
  /// **'отримано'**
  String get received;

  /// No description provided for @averagePerDay.
  ///
  /// In uk, this message translates to:
  /// **'В середньому за день'**
  String get averagePerDay;

  /// No description provided for @noDataToDisplay.
  ///
  /// In uk, this message translates to:
  /// **'Немає даних для відображення'**
  String get noDataToDisplay;

  /// No description provided for @transactionHistory.
  ///
  /// In uk, this message translates to:
  /// **'Історія транзакцій'**
  String get transactionHistory;

  /// No description provided for @expenseHistory.
  ///
  /// In uk, this message translates to:
  /// **'Історія витрат'**
  String get expenseHistory;

  /// No description provided for @incomeHistory.
  ///
  /// In uk, this message translates to:
  /// **'Історія доходів'**
  String get incomeHistory;

  /// No description provided for @aiAssistant.
  ///
  /// In uk, this message translates to:
  /// **'ШІ Помічник'**
  String get aiAssistant;

  /// No description provided for @insufficientData.
  ///
  /// In uk, this message translates to:
  /// **'Недостатньо даних для аналізу. Додайте більше транзакцій.'**
  String get insufficientData;

  /// No description provided for @recommendations.
  ///
  /// In uk, this message translates to:
  /// **'Рекомендації'**
  String get recommendations;

  /// No description provided for @chat.
  ///
  /// In uk, this message translates to:
  /// **'Чат'**
  String get chat;

  /// No description provided for @financialAssistant.
  ///
  /// In uk, this message translates to:
  /// **'Фінансовий помічник'**
  String get financialAssistant;

  /// No description provided for @personalizedRecommendations.
  ///
  /// In uk, this message translates to:
  /// **'Отримайте персоналізовані рекомендації щодо оптимізації вашого бюджету на основі аналізу ваших витрат.'**
  String get personalizedRecommendations;

  /// No description provided for @getRecommendations.
  ///
  /// In uk, this message translates to:
  /// **'Отримати рекомендації'**
  String get getRecommendations;

  /// No description provided for @recommendationsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Рекомендації'**
  String get recommendationsTitle;

  /// No description provided for @recentTransactions.
  ///
  /// In uk, this message translates to:
  /// **'Останні транзакції'**
  String get recentTransactions;

  /// No description provided for @askFinances.
  ///
  /// In uk, this message translates to:
  /// **'Запитайте щось про ваші фінанси...'**
  String get askFinances;

  /// No description provided for @aiThinking.
  ///
  /// In uk, this message translates to:
  /// **'ШІ думає...'**
  String get aiThinking;

  /// No description provided for @familyChat.
  ///
  /// In uk, this message translates to:
  /// **'Сімейний чат'**
  String get familyChat;

  /// No description provided for @noMessages.
  ///
  /// In uk, this message translates to:
  /// **'Немає повідомлень'**
  String get noMessages;

  /// No description provided for @message.
  ///
  /// In uk, this message translates to:
  /// **'Повідомлення'**
  String get message;

  /// No description provided for @errorMessage.
  ///
  /// In uk, this message translates to:
  /// **'Помилка: {error}'**
  String errorMessage(Object error);

  /// No description provided for @familyKeyError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження ключа сім\'ї: {error}'**
  String familyKeyError(Object error);

  /// No description provided for @messageProcessError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка при обробці повідомлень: {error}'**
  String messageProcessError(Object error);

  /// No description provided for @enterBiometrics.
  ///
  /// In uk, this message translates to:
  /// **'Увійдіть для доступу до додатку'**
  String get enterBiometrics;

  /// No description provided for @biometricAuthError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка біометричної автентифікації: {error}'**
  String biometricAuthError(Object error);

  /// No description provided for @incorrectPin.
  ///
  /// In uk, this message translates to:
  /// **'Невірний PIN-код'**
  String get incorrectPin;

  /// No description provided for @enterPin.
  ///
  /// In uk, this message translates to:
  /// **'Введіть PIN-код'**
  String get enterPin;

  /// No description provided for @enterWithBiometrics.
  ///
  /// In uk, this message translates to:
  /// **'Увійти з біометрією'**
  String get enterWithBiometrics;

  /// No description provided for @or.
  ///
  /// In uk, this message translates to:
  /// **'або'**
  String get or;

  /// No description provided for @enter.
  ///
  /// In uk, this message translates to:
  /// **'Увійти'**
  String get enter;

  /// No description provided for @loginProtectionNotSet.
  ///
  /// In uk, this message translates to:
  /// **'Захист входу не налаштовано'**
  String get loginProtectionNotSet;

  /// No description provided for @continueAction.
  ///
  /// In uk, this message translates to:
  /// **'Продовжити'**
  String get continueAction;

  /// No description provided for @name.
  ///
  /// In uk, this message translates to:
  /// **'Ім\'я'**
  String get name;

  /// No description provided for @email.
  ///
  /// In uk, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In uk, this message translates to:
  /// **'Фото профілю оновлено'**
  String get profilePhotoUpdated;

  /// No description provided for @photoUploadError.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження фото: {error}'**
  String photoUploadError(String error);

  /// No description provided for @profileUpdated.
  ///
  /// In uk, this message translates to:
  /// **'Профіль оновлено'**
  String get profileUpdated;

  /// No description provided for @saveChanges.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти зміни'**
  String get saveChanges;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
