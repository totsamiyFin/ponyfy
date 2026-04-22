import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/connection_state.dart';

// ── VPN Status ───────────────────────────────────────────────────────────────

class VpnStatusNotifier extends StateNotifier<VpnStatus> {
  VpnStatusNotifier() : super(VpnStatus.disconnected);

  Future<void> toggle() async {
    if (state == VpnStatus.connected) {
      await _disconnect();
    } else {
      await _connect();
    }
  }

  Future<void> _connect() async {
    state = VpnStatus.connecting;
    // TODO: call sing-box / xray platform channel here
    await Future.delayed(const Duration(seconds: 2));
    state = VpnStatus.connected;
  }

  Future<void> _disconnect() async {
    // TODO: stop sing-box / xray
    state = VpnStatus.disconnected;
  }
}

final vpnStatusProvider =
    StateNotifierProvider<VpnStatusNotifier, VpnStatus>(
  (ref) => VpnStatusNotifier(),
);

// ── Profiles ─────────────────────────────────────────────────────────────────

class ProfilesNotifier extends StateNotifier<List<ProxyProfile>> {
  ProfilesNotifier()
      : super([
          ProxyProfile(
            id: '1',
            name: 'Pony Server 🌈',
            url: 'https://example.com/sub',
            remainingDays: 28,
            usedTrafficGb: 12.4,
            totalTrafficGb: 50.0,
            updatedAt: DateTime.now(),
          ),
        ]);

  void addProfile(ProxyProfile p) => state = [...state, p];
  void removeProfile(String id) =>
      state = state.where((p) => p.id != id).toList();
}

final profilesProvider =
    StateNotifierProvider<ProfilesNotifier, List<ProxyProfile>>(
  (ref) => ProfilesNotifier(),
);

final activeProfileProvider = Provider<ProxyProfile?>((ref) {
  final profiles = ref.watch(profilesProvider);
  return profiles.isEmpty ? null : profiles.first;
});
