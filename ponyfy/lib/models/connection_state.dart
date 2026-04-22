import 'package:flutter/material.dart';
import '../theme/mlp_theme.dart';

enum VpnStatus { disconnected, connecting, connected }

extension VpnStatusX on VpnStatus {
  String get label {
    switch (this) {
      case VpnStatus.disconnected:
        return 'Отключено';
      case VpnStatus.connecting:
        return 'Подключение...';
      case VpnStatus.connected:
        return 'Подключено';
    }
  }

  Color get color {
    switch (this) {
      case VpnStatus.disconnected:
        return MlpColors.disconnected;
      case VpnStatus.connecting:
        return MlpColors.connecting;
      case VpnStatus.connected:
        return MlpColors.connected;
    }
  }

  String get ponyMessage {
    switch (this) {
      case VpnStatus.disconnected:
        return 'Нажми кнопку, чтобы начать магию! ✨';
      case VpnStatus.connecting:
        return 'Рарити готовит соединение... 💎';
      case VpnStatus.connected:
        return 'Дружба — это магия и свободный интернет! 🌈';
    }
  }
}

class ProxyProfile {
  final String id;
  final String name;
  final String url;
  final DateTime? updatedAt;
  final int? remainingDays;
  final double? usedTrafficGb;
  final double? totalTrafficGb;

  const ProxyProfile({
    required this.id,
    required this.name,
    required this.url,
    this.updatedAt,
    this.remainingDays,
    this.usedTrafficGb,
    this.totalTrafficGb,
  });
}
