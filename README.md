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
  <h3>Прокрути вправо ←→</h3>
</div>

<div align="center">
  <div style="overflow-x: auto; white-space: nowrap; display: flex; gap: 10px; padding: 10px; max-width: 100%; scrollbar-width: thin;">
    <img src="screenshots/home.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/accounts.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/stats.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/19Snipaste_2025-05-23_18-01-37.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/201Snipaste_2025-05-23_18-10-45.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/20Snipaste_2025-05-23_18-10-45.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/22Snipaste_2025-05-23_21-44-27.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/25Snipaste_2025-05-23_21-59-41.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/23Snipaste_2025-05-23_21-48-56.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/16Snipaste_2025-05-23_01-21-54.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/27Snipaste_2025-05-23_22-09-02.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/studio64_a7LDXfFRSq_3.gif" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/home.gif" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/studio64_a7LDXfFRSq_2.gif" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/studio64_a7LDXfFRSq_1.gif" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/studio64_a7LDXfFRSq_4.gif" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/20250604_140912.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/182Snipaste_2025-05-23_01-21-54.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/181Snipaste_2025-05-23_01-21-54.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
    <img src="screenshots/32Snipaste_2025-05-27_21-54-48.png" width="250" style="border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);"/>
  </div>
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
