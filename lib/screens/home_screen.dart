import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/connection_state.dart';
import '../providers/vpn_provider.dart';
import '../theme/mlp_theme.dart';
import '../widgets/vpn_button.dart';
import '../widgets/pony_decoration.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(vpnStatusProvider);
    final profile = ref.watch(activeProfileProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Starfield background
          const StarfieldBackground(),

          // Gradient overlay top
          Positioned(
            top: 0, left: 0, right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    MlpColors.pinkGlow,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _AppBar(),
                const SizedBox(height: 24),

                // Status badge
                _StatusBadge(status: status)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.3),

                const SizedBox(height: 8),

                // Pony message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    status.ponyMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: MlpColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 40),

                // VPN Power Button
                VpnPowerButton(
                  status: status,
                  onTap: () {
                    if (profile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Сначала добавь профиль во вкладке Профили'),
                          backgroundColor: MlpColors.disconnected,
                        ),
                      );
                      return;
                    }
                    ref.read(vpnStatusProvider.notifier).toggle(profile.url);
                  },
                )
                    .animate()
                    .scale(begin: const Offset(0.8, 0.8), duration: 500.ms,
                        curve: Curves.elasticOut),

                const SizedBox(height: 40),

                // Active profile card
                if (profile != null)
                  _ProfileCard(profile: profile)
                      .animate()
                      .fadeIn(delay: 300.ms)
                      .slideY(begin: 0.3),

                const Spacer(),

                // Pony decoration
                const PonyDecoration()
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .slideY(begin: 0.5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [MlpColors.pink, MlpColors.purple],
              ),
            ),
            child: const Center(
              child: Text('🦄', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Ponyfy',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: MlpColors.pinkLight,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: MlpColors.textSecondary),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final VpnStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: status.color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status.color,
              boxShadow: [
                BoxShadow(color: status.color, blurRadius: 6, spreadRadius: 1),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status.label,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final ProxyProfile profile;
  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.dns_outlined, color: MlpColors.pink, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      profile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MlpColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: MlpColors.pinkGlow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Активный',
                      style: TextStyle(color: MlpColors.pink, fontSize: 11),
                    ),
                  ),
                ],
              ),
              if (profile.remainingDays != null) ...[
                const SizedBox(height: 12),
                _TrafficRow(
                  used: profile.usedTrafficGb ?? 0,
                  total: profile.totalTrafficGb ?? 0,
                  days: profile.remainingDays!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrafficRow extends StatelessWidget {
  final double used;
  final double total;
  final int days;

  const _TrafficRow({
    required this.used,
    required this.total,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? (used / total).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${used.toStringAsFixed(1)} / ${total.toStringAsFixed(1)} GB',
              style: const TextStyle(color: MlpColors.textSecondary, fontSize: 12),
            ),
            Text(
              '$days дн.',
              style: const TextStyle(color: MlpColors.purple, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: MlpColors.surfaceAlt,
            valueColor: const AlwaysStoppedAnimation(MlpColors.pink),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
