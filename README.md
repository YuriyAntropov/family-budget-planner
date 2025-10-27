# Family Budget Planner

**Семейный финансовый менеджер** — мобильное приложение для учёта расходов и доходов семьи.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)

---

## Особенности
- Синхронизация данных в реальном времени (Firebase)
- Роли: взрослый / ребёнок
- Общие и личные счета
- Категории с перетаскиванием
- Статистика и графики
- Геотеги транзакций (Google Maps)
- Режим редактирования
- AI-помощник (в разработке)

---

## Скриншоты

<div align="center">
  <img src="screenshots/home.gif" width="30%"/>
  <img src="screenshots/accounts.png" width="30%"/>
  <img src="screenshots/stats.png" width="30%"/>
</div>

---

## Как запустить

```bash
git clone https://github.com/YuriyAntropov/family-budget-planner.git
cd family-budget-planner
flutter pub get

Добавь google-services.json в android/app/ (из Firebase Console)
Включи Authentication и Firestore
Запусти: flutter run


API-ключи удалены из репозитория для безопасности


Технологии

Flutter — UI
Firebase — Auth + Firestore
Provider — состояние
Google Maps — геолокация
ReorderableGridView — перетаскивание


Безопасность

API-ключи удалены из истории Git
Используется .gitignore
Проект безопасен для портфолио


Автор
Yuriy Antropov
GitHub
Дипломная работа, 2025
