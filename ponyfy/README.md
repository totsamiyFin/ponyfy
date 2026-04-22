# 🦄 Ponyfy — MLP VPN Client

Форк Hiddify с темой My Little Pony. Тёмная тема + нежно-розовые акценты.

## Стек
- Flutter 3.16+ (Android + Windows из одного кода)
- Sing-box core (тот же что в Hiddify)
- Riverpod (state management)
- flutter_animate (анимации)

## Запуск

### Требования
- Flutter SDK 3.16+
- Android Studio / VS Code
- Для Windows: Visual Studio 2022 с C++ Desktop workload

### Установка
```bash
cd ponyfy
flutter pub get
```

### Android
```bash
flutter run -d android
# или собрать APK:
flutter build apk --release
```

### Windows
```bash
flutter run -d windows
# или собрать exe:
flutter build windows --release
```

## Структура
```
lib/
├── main.dart              # Точка входа
├── theme/mlp_theme.dart   # Цвета и тема MLP
├── models/                # Модели данных
├── providers/             # Riverpod провайдеры
├── screens/               # Экраны
│   ├── home_screen.dart   # Главный (кнопка VPN)
│   ├── profiles_screen.dart
│   └── settings_screen.dart
└── widgets/
    ├── vpn_button.dart    # Красивая кнопка с анимацией
    └── pony_decoration.dart
```

## TODO (для полной функциональности как Hiddify)
- [ ] Интеграция sing-box через platform channels
- [ ] TUN режим (требует root/VPN permission)
- [ ] Автообновление подписок
- [ ] Выбор ноды по пингу
- [ ] Уведомления о статусе
