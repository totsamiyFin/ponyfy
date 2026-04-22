import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/connection_state.dart';
import '../providers/vpn_provider.dart';
import '../theme/mlp_theme.dart';

class ProfilesScreen extends ConsumerStatefulWidget {
  const ProfilesScreen({super.key});

  @override
  ConsumerState<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends ConsumerState<ProfilesScreen> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _addProfile() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    ref.read(profilesProvider.notifier).addProfile(
          ProxyProfile(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: 'Профиль ${DateTime.now().hour}:${DateTime.now().minute}',
            url: url,
          ),
        );
    _urlController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(profilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профили 💎'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: MlpColors.pink),
            onPressed: () => _showAddSheet(context),
          ),
        ],
      ),
      body: profiles.isEmpty
          ? _EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: profiles.length,
              itemBuilder: (ctx, i) => _ProfileTile(
                profile: profiles[i],
                onDelete: () => ref
                    .read(profilesProvider.notifier)
                    .removeProfile(profiles[i].id),
              ).animate().fadeIn(delay: (i * 80).ms).slideX(begin: 0.2),
            ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MlpColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Добавить профиль ✨',
              style: TextStyle(
                color: MlpColors.pinkLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              style: const TextStyle(color: MlpColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Вставь ссылку на подписку...',
                prefixIcon: Icon(Icons.link, color: MlpColors.pink),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _PinkButton(
                label: 'Добавить',
                onTap: _addProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final ProxyProfile profile;
  final VoidCallback onDelete;

  const _ProfileTile({required this.profile, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [MlpColors.pink, MlpColors.purple],
            ),
          ),
          child: const Center(
            child: Text('🌈', style: TextStyle(fontSize: 20)),
          ),
        ),
        title: Text(
          profile.name,
          style: const TextStyle(
            color: MlpColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          profile.url,
          style: const TextStyle(color: MlpColors.textHint, fontSize: 11),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: MlpColors.disconnected),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🦄', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'Нет профилей',
            style: TextStyle(
              color: MlpColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Добавь ссылку на подписку,\nчтобы начать магию!',
            textAlign: TextAlign.center,
            style: TextStyle(color: MlpColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _PinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PinkButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [MlpColors.pink, MlpColors.purple],
          ),
          boxShadow: [
            BoxShadow(
              color: MlpColors.pinkGlow,
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
