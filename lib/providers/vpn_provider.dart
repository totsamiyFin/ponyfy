import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import '../models/connection_state.dart';

// ── VPN Status ───────────────────────────────────────────────────────────────

class VpnStatusNotifier extends StateNotifier<VpnStatus> {
  VpnStatusNotifier() : super(VpnStatus.disconnected);

  FlutterV2ray? _v2ray;
  String? _activeConfig;

  Future<void> toggle(String? configUrl) async {
    if (state == VpnStatus.connected) {
      await _disconnect();
    } else {
      await _connect(configUrl);
    }
  }

  Future<void> _connect(String? configUrl) async {
    if (configUrl == null || configUrl.isEmpty) return;

    state = VpnStatus.connecting;
    try {
      _v2ray = FlutterV2ray(
        onStatusChanged: (status) {
          if (status.state == 'CONNECTED') {
            state = VpnStatus.connected;
          } else if (status.state == 'DISCONNECTED') {
            state = VpnStatus.disconnected;
          }
        },
      );

      await _v2ray!.initializeV2Ray();

      // Parse the subscription URL or vmess/vless link
      final parser = FlutterV2ray.parseFromURL(configUrl);
      _activeConfig = parser.getFullConfiguration();

      final permission = await _v2ray!.requestPermission();
      if (!permission) {
        state = VpnStatus.disconnected;
        return;
      }

      await _v2ray!.startV2Ray(
        remark: 'Ponyfy',
        config: _activeConfig!,
        blockedApps: null,
        bypassSubnets: null,
        proxyOnly: false,
      );
    } catch (e) {
      state = VpnStatus.disconnected;
    }
  }

  Future<void> _disconnect() async {
    await _v2ray?.stopV2Ray();
    state = VpnStatus.disconnected;
  }
}

final vpnStatusProvider =
    StateNotifierProvider<VpnStatusNotifier, VpnStatus>(
  (ref) => VpnStatusNotifier(),
);

// ── Profiles ─────────────────────────────────────────────────────────────────

class ProfilesNotifier extends StateNotifier<List<ProxyProfile>> {
  ProfilesNotifier() : super([]);

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
