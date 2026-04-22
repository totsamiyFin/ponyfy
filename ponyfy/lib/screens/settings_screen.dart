import 'package:flutter/material.dart';
import '../theme/mlp_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки ⚙️')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader('Подключение'),
          _SettingsTile(
            icon: Icons.tune,
            title: 'Режим прокси',
            subtitle: 'Системный прокси',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.route_outlined,
            title: 'Правила маршрутизации',
            subtitle: 'Авто',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.dns_outlined,
            title: 'DNS',
            subtitle: '8.8.8.8',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _SectionHeader('Внешний вид'),
          _SettingsTile(
            icon: Icons.palette_outlined,
            title: 'Тема',
            subtitle: 'MLP Тёмная 🌙',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Язык',
            subtitle: 'Русский',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _SectionHeader('О приложении'),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Версия',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.code,
            title: 'Исходный код',
            subtitle: 'GitHub',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: MlpColors.pink,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: MlpColors.pink),
        title: Text(title,
            style: const TextStyle(color: MlpColors.textPrimary)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: MlpColors.textSecondary, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: MlpColors.textHint),
        onTap: onTap,
      ),
    );
  }
}
