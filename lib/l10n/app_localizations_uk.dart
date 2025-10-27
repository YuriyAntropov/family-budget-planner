// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Планувальник сімейного бюджету';

  @override
  String welcome(String name) {
    return 'Вітаємо, $name!';
  }

  @override
  String get settings => 'Налаштування';

  @override
  String get language => 'Мова';

  @override
  String get home => 'Головна';

  @override
  String get income => 'Доходи';

  @override
  String get accounts => 'Рахунки';

  @override
  String get expenses => 'Витрати';

  @override
  String get addAccount => 'Додати рахунок';

  @override
  String get addCategory => 'Додати категорію';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get delete => 'Видалити';

  @override
  String get amount => 'Сума';

  @override
  String get currency => 'Валюта';

  @override
  String get date => 'Дата';

  @override
  String get category => 'Категорія';

  @override
  String get account => 'Рахунок';

  @override
  String get logout => 'Вийти';

  @override
  String get familySettings => 'Налаштування сім\'ї';

  @override
  String get profileSettings => 'Налаштування профілю';

  @override
  String get securitySettings => 'Параметри входу';

  @override
  String get theme => 'Тема';

  @override
  String get sync => 'Синхронізація';

  @override
  String get help => 'Допомога';

  @override
  String get about => 'Про програму';

  @override
  String get exportData => 'Експорт даних';

  @override
  String get login => 'Вхід';

  @override
  String get password => 'Пароль';

  @override
  String get fillAllFields => 'Заповніть всі поля';

  @override
  String get loginError => 'Помилка входу. Перевірте дані.';

  @override
  String get userNotFound => 'Користувача з таким email не знайдено';

  @override
  String get wrongPassword => 'Неправильний пароль';

  @override
  String get invalidEmail => 'Некоректний email';

  @override
  String get userDisabled => 'Цей обліковий запис відключено';

  @override
  String get signIn => 'Увійти';

  @override
  String get noAccount => 'Немає облікового запису? Зареєструватися';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get enterEmailReset => 'Введіть email для скидання пароля';

  @override
  String get resetInstructions =>
      'Інструкції для скидання пароля відправлено на email';

  @override
  String get signInGoogle => 'Увійти через Google';

  @override
  String get googleLoginError => 'Помилка входу через Google';

  @override
  String get registration => 'Реєстрація';

  @override
  String get createAccount => 'Створення облікового запису';

  @override
  String get yourName => 'Ваше ім\'я';

  @override
  String get confirmPassword => 'Підтвердження пароля';

  @override
  String get passwordsDontMatch => 'Паролі не співпадають';

  @override
  String get register => 'Зареєструватися';

  @override
  String get emailInUse => 'Цей email вже використовується';

  @override
  String get weakPassword => 'Пароль занадто слабкий';

  @override
  String get registrationError => 'Помилка реєстрації';

  @override
  String get alreadyHaveAccount => 'Вже маєте обліковий запис? Увійти';

  @override
  String get familySettingsTitle => 'Налаштування сім\'ї';

  @override
  String get refreshData => 'Оновити дані';

  @override
  String get notFamilyMember => 'Ви не є членом сім\'ї';

  @override
  String get updateStatus => 'Оновити статус';

  @override
  String get restartApp => 'Перезапустити додаток для оновлення даних';

  @override
  String get returnHome => 'Повернутися на головну';

  @override
  String get createFamily => 'Створити сім\'ю';

  @override
  String get familyName => 'Назва сім\'ї';

  @override
  String get create => 'Створити';

  @override
  String get joinFamily => 'Приєднатися до сім\'ї';

  @override
  String get inviteCode => 'Код запрошення';

  @override
  String get join => 'Приєднатися';

  @override
  String get findLocalFamilies => 'Знайти сім\'ї в локальній мережі';

  @override
  String get joinNFC => 'Приєднатися через NFC';

  @override
  String get bringDeviceNFC => 'Піднесіть пристрій до іншого пристрою з NFC';

  @override
  String get familyCreated => 'Сім\'ю успішно створено';

  @override
  String get joinRequestSent =>
      'Запит на приєднання надіслано. Очікуйте підтвердження.';

  @override
  String get familyNotFound => 'Сім\'ю з таким кодом запрошення не знайдено';

  @override
  String get family => 'Сім\'я';

  @override
  String get copy => 'Копіювати';

  @override
  String get share => 'Поділитися';

  @override
  String get shareNFC => 'Поділитися через NFC';

  @override
  String get dataSentNFC => 'Дані успішно передано через NFC';

  @override
  String get familyMembers => 'Члени сім\'ї';

  @override
  String get unknownUser => 'Невідомий користувач';

  @override
  String get role => 'Роль';

  @override
  String get device => 'Пристрій';

  @override
  String get unknown => 'Невідомо';

  @override
  String get removeUser => 'Видалити користувача';

  @override
  String removeUserConfirm(Object email) {
    return 'Ви дійсно хочете видалити користувача $email з сім\'ї?';
  }

  @override
  String get userRemoved => 'Користувача видалено з сім\'ї';

  @override
  String get removeUserError => 'Помилка видалення користувача';

  @override
  String get joinRequests => 'Запити на приєднання';

  @override
  String get location => 'Локація';

  @override
  String get accept => 'Прийняти';

  @override
  String get reject => 'Відхилити';

  @override
  String get leaveFamily => 'Вийти з сім\'ї';

  @override
  String get leaveFamilyConfirm =>
      'Ви дійсно хочете вийти з сім\'ї? Всі ваші дані будуть відключені від сімейного бюджету.';

  @override
  String get leftFamily => 'Ви успішно вийшли з сім\'ї';

  @override
  String get leaveFamilyError => 'Помилка виходу з сім\'ї';

  @override
  String get restartRequired => 'Перезапустіть додаток';

  @override
  String get restartMessage =>
      'Вас було додано до сім\'ї. Для застосування змін необхідно перезапустити додаток.';

  @override
  String get restart => 'Перезапустити';

  @override
  String get userAdded =>
      'Користувача додано до сім\'ї. Попросіть його перезапустити додаток.';

  @override
  String get requestRejected => 'Запит відхилено';

  @override
  String get rejectError => 'Помилка відхилення запиту';

  @override
  String roleSelection(Object email) {
    return 'Вибір ролі для $email';
  }

  @override
  String get administrator => 'Адміністратор';

  @override
  String get fullAccess => 'Повний доступ до всіх функцій';

  @override
  String get child => 'Дитина';

  @override
  String get expensesOnly => 'Може тільки додавати витрати';

  @override
  String get customRole => 'Своя роль';

  @override
  String get configurePermissions => 'Налаштувати права доступу';

  @override
  String get permissionsConfig => 'Налаштування прав доступу';

  @override
  String get canAddExpenses => 'Може додавати витрати';

  @override
  String get canUseChat => 'Може писати в чаті';

  @override
  String get canAddIncome => 'Може додавати доходи';

  @override
  String get canViewAllAccounts => 'Може бачити всі рахунки';

  @override
  String get canEditAccounts => 'Може редагувати рахунки';

  @override
  String get canViewStatistics => 'Може бачити статистику';

  @override
  String get canInviteMembers => 'Може запрошувати учасників';

  @override
  String get canManageRoles => 'Може керувати ролями';

  @override
  String get noLocalFamilies => 'Сім\'ї в локальній мережі не знайдено';

  @override
  String get availableFamilies => 'Доступні сім\'ї';

  @override
  String get familyNoName => 'Сім\'я без назви';

  @override
  String get code => 'Код';

  @override
  String get searchError => 'Помилка пошуку сімей';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get ukrainian => 'Українська';

  @override
  String get english => 'English';

  @override
  String get familySettingsDesc =>
      'Створення, приєднання та управління сім\'єю';

  @override
  String get geoLocation => 'Геолокація транзакцій';

  @override
  String get geoLocationDesc => 'Автоматично додавати геомітки до транзакцій';

  @override
  String get profileSettingsTitle => 'Налаштування профілю';

  @override
  String get securitySettingsDesc => 'Налаштування безпеки входу в додаток';

  @override
  String get light => 'Світла';

  @override
  String get displayCurrency => 'Валюта для відображення';

  @override
  String get currencyDesc => 'Всі суми будуть конвертовані в обрану валюту';

  @override
  String get syncStatus => 'Переглянути статус';

  @override
  String get userNotInFamily => 'Помилка: користувач не в сім\'ї';

  @override
  String get syncProgress => 'Перевірка статусу синхронізації...';

  @override
  String get syncStatusTitle => 'Статус синхронізації';

  @override
  String get syncSuccess => 'Всі дані успішно синхронізовано';

  @override
  String get syncProblems => 'Виникли проблеми при синхронізації';

  @override
  String get close => 'Закрити';

  @override
  String get dataExported => 'Дані успішно експортовано';

  @override
  String get exportDesc => 'Зберегти дані в JSON файл';

  @override
  String get securityTitle => 'Параметри входу';

  @override
  String get useBiometrics => 'Використовувати біометрію';

  @override
  String get biometricsDesc => 'Face ID / Touch ID';

  @override
  String get usePinCode => 'Використовувати PIN-код';

  @override
  String get pinCodeDesc => '4-значний код для входу';

  @override
  String get biometricsNotSupported =>
      'Біометрія не підтримується на цьому пристрої';

  @override
  String get setPinCode => 'Встановіть PIN-код';

  @override
  String get enter4Digits => 'Введіть 4-значний код';

  @override
  String get pinMust4Digits => 'PIN-код повинен містити 4 цифри';

  @override
  String get helpTitle => 'Допомога';

  @override
  String get howToUse => 'Як користуватися додатком';

  @override
  String get addIncomeHelp =>
      '1. Додавання доходів: перетягніть категорію доходу на рахунок';

  @override
  String get addExpenseHelp =>
      '2. Додавання витрат: перетягніть категорію витрат на рахунок';

  @override
  String get viewStatsHelp =>
      '3. Перегляд статистики: натисніть на категорію для детального аналізу';

  @override
  String get aboutTitle => 'Про програму';

  @override
  String get familyBudget => 'Сімейний бюджет';

  @override
  String get version => 'Версія 0.0.2';

  @override
  String get copyright => '© 2025 Всі права захищені';

  @override
  String get accountName => 'Назва рахунку';

  @override
  String get initialBalance => 'Початковий баланс';

  @override
  String get accountOwner => 'Власник рахунку';

  @override
  String get personal => 'Особистий';

  @override
  String get familyAccount => 'Сімейний';

  @override
  String get add => 'Додати';

  @override
  String get invalidBalance => 'Некоректний баланс';

  @override
  String get categoryName => 'Назва категорії';

  @override
  String get now => 'Зараз';

  @override
  String get selectDate => 'Вибрати дату';

  @override
  String get addExpense => 'Додати витрату';

  @override
  String get editExpense => 'Редагувати витрату';

  @override
  String get comment => 'Коментар';

  @override
  String get currentAccount => 'Поточний рахунок';

  @override
  String get confirmation => 'Підтвердження';

  @override
  String get deleteTransactionConfirm =>
      'Ви впевнені, що хочете видалити цю транзакцію?';

  @override
  String get transactionDeleted => 'Транзакцію видалено';

  @override
  String get invalidAmount => 'Некоректна сума';

  @override
  String get noPermissionIncome => 'У вас немає прав для додавання доходів';

  @override
  String get noAccounts => 'Немає рахунків';

  @override
  String get noTransactions => 'Немає транзакцій';

  @override
  String get noExpenses => 'Немає витрат';

  @override
  String get unknownAccount => 'Невідомий рахунок';

  @override
  String get familyIdError => 'Помилка отримання ID сім\'ї';

  @override
  String get transactionLocation => 'Місце здійснення транзакції:';

  @override
  String get mapDisplayError => 'Помилка відображення карти';

  @override
  String get locationError => 'Помилка отримання геолокації';

  @override
  String get products => 'Продукти';

  @override
  String get transport => 'Транспорт';

  @override
  String get entertainment => 'Розваги';

  @override
  String get utilities => 'Комунальні';

  @override
  String get clothing => 'Одяг';

  @override
  String get other => 'Інше';

  @override
  String get selectUser => 'Вибрати користувача';

  @override
  String get noOtherUsers => 'Немає інших користувачів';

  @override
  String get user => 'Користувач';

  @override
  String get myAccounts => 'Мої рахунки';

  @override
  String get familyAccounts => 'Сімейні рахунки';

  @override
  String get userAccounts => 'Рахунки користувачів';

  @override
  String accounts_count(Object count) {
    return '$count рахунків';
  }

  @override
  String get addAccountTooltip => 'Додати рахунок';

  @override
  String get noUserAccounts => 'У користувача немає рахунків';

  @override
  String get noTitle => 'Без назви';

  @override
  String get balance => 'Баланс';

  @override
  String get editAccount => 'Редагувати рахунок';

  @override
  String get deleteAccount => 'Видалення рахунку';

  @override
  String deleteAccountConfirm(Object name) {
    return 'Ви впевнені, що хочете видалити рахунок \"$name\"?';
  }

  @override
  String get adminOnly => 'Доступно тільки для адміністраторів';

  @override
  String get noFamilyAccounts => 'Немає сімейних рахунків';

  @override
  String get noPersonalAccounts => 'Немає особистих рахунків';

  @override
  String userNoAccounts(Object name) {
    return 'У користувача $name немає рахунків';
  }

  @override
  String get transferBetweenAccounts => 'Переказ між рахунками';

  @override
  String get fromAccount => 'З рахунку';

  @override
  String get toAccount => 'На рахунок';

  @override
  String get transfer => 'Переказати';

  @override
  String get transferNote => 'Переказ на інший рахунок';

  @override
  String get transferFromNote => 'Переказ з іншого рахунку';

  @override
  String get otherUser => 'Інший користувач';

  @override
  String get salary => 'Зарплата';

  @override
  String get gifts => 'Подарунки';

  @override
  String get dividends => 'Дивіденди';

  @override
  String get partTime => 'Підробіток';

  @override
  String get sale => 'Продаж';

  @override
  String get editIncome => 'Редагувати дохід';

  @override
  String get addIncome => 'Додати дохід';

  @override
  String get noIncomes => 'Немає доходів';

  @override
  String get statistics => 'Статистика';

  @override
  String get noAccessToStats => 'У вас немає доступу до статистики';

  @override
  String get expenseStats => 'Статистика витрат';

  @override
  String get generalStats => 'Загальна статистика';

  @override
  String get incomeStats => 'Статистика доходів';

  @override
  String get wholeFamily => 'Вся сім\'я';

  @override
  String get allAccounts => 'Всі рахунки';

  @override
  String get totalEarned => 'Всього зароблено';

  @override
  String get totalSpent => 'Всього витрачено';

  @override
  String get totalBalance => 'Загальний баланс';

  @override
  String get total => 'Всього';

  @override
  String get spent => 'витрачено';

  @override
  String get received => 'отримано';

  @override
  String get averagePerDay => 'В середньому за день';

  @override
  String get noDataToDisplay => 'Немає даних для відображення';

  @override
  String get transactionHistory => 'Історія транзакцій';

  @override
  String get expenseHistory => 'Історія витрат';

  @override
  String get incomeHistory => 'Історія доходів';

  @override
  String get aiAssistant => 'ШІ Помічник';

  @override
  String get insufficientData =>
      'Недостатньо даних для аналізу. Додайте більше транзакцій.';

  @override
  String get recommendations => 'Рекомендації';

  @override
  String get chat => 'Чат';

  @override
  String get financialAssistant => 'Фінансовий помічник';

  @override
  String get personalizedRecommendations =>
      'Отримайте персоналізовані рекомендації щодо оптимізації вашого бюджету на основі аналізу ваших витрат.';

  @override
  String get getRecommendations => 'Отримати рекомендації';

  @override
  String get recommendationsTitle => 'Рекомендації';

  @override
  String get recentTransactions => 'Останні транзакції';

  @override
  String get askFinances => 'Запитайте щось про ваші фінанси...';

  @override
  String get aiThinking => 'ШІ думає...';

  @override
  String get familyChat => 'Сімейний чат';

  @override
  String get noMessages => 'Немає повідомлень';

  @override
  String get message => 'Повідомлення';

  @override
  String errorMessage(Object error) {
    return 'Помилка: $error';
  }

  @override
  String familyKeyError(Object error) {
    return 'Помилка завантаження ключа сім\'ї: $error';
  }

  @override
  String messageProcessError(Object error) {
    return 'Помилка при обробці повідомлень: $error';
  }

  @override
  String get enterBiometrics => 'Увійдіть для доступу до додатку';

  @override
  String biometricAuthError(Object error) {
    return 'Помилка біометричної автентифікації: $error';
  }

  @override
  String get incorrectPin => 'Невірний PIN-код';

  @override
  String get enterPin => 'Введіть PIN-код';

  @override
  String get enterWithBiometrics => 'Увійти з біометрією';

  @override
  String get or => 'або';

  @override
  String get enter => 'Увійти';

  @override
  String get loginProtectionNotSet => 'Захист входу не налаштовано';

  @override
  String get continueAction => 'Продовжити';

  @override
  String get name => 'Ім\'я';

  @override
  String get email => 'Email';

  @override
  String get profilePhotoUpdated => 'Фото профілю оновлено';

  @override
  String photoUploadError(String error) {
    return 'Помилка завантаження фото: $error';
  }

  @override
  String get profileUpdated => 'Профіль оновлено';

  @override
  String get saveChanges => 'Зберегти зміни';
}
