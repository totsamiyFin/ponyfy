import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/connection_state.dart';
import '../theme/mlp_theme.dart';

class VpnPowerButton extends StatefulWidget {
  final VpnStatus status;
  final VoidCallback onTap;

  const VpnPowerButton({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  State<VpnPowerButton> createState() => _VpnPowerButtonState();
}

class _VpnPowerButtonState extends State<VpnPowerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(VpnPowerButton old) {
    super.didUpdateWidget(old);
    if (old.status != widget.status) _updateAnimation();
  }

  void _updateAnimation() {
    if (widget.status == VpnStatus.connected ||
        widget.status == VpnStatus.connecting) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color get _buttonColor {
    switch (widget.status) {
      case VpnStatus.connected:
        return MlpColors.connected;
      case VpnStatus.connecting:
        return MlpColors.connecting;
      case VpnStatus.disconnected:
        return MlpColors.pink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.status == VpnStatus.connecting ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulse = _pulseController.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow rings
              if (widget.status != VpnStatus.disconnected) ...[
                _GlowRing(
                  size: 200 + pulse * 30,
                  color: _buttonColor.withOpacity(0.08 + pulse * 0.06),
                ),
                _GlowRing(
                  size: 170 + pulse * 20,
                  color: _buttonColor.withOpacity(0.12 + pulse * 0.08),
                ),
              ],
              // Main button
              child!,
            ],
          );
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _buttonColor.withOpacity(0.9),
                _buttonColor.withOpacity(0.5),
                MlpColors.surface,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: _buttonColor.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: _buttonColor.withOpacity(0.2),
                blurRadius: 60,
                spreadRadius: 15,
              ),
            ],
            border: Border.all(
              color: _buttonColor.withOpacity(0.8),
              width: 2.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.status == VpnStatus.connected
                    ? Icons.power_settings_new_rounded
                    : Icons.power_settings_new_outlined,
                size: 52,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              Text(
                widget.status == VpnStatus.connected ? 'ВКЛ' : 'ВЫКЛ',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        )
            .animate(target: widget.status == VpnStatus.connecting ? 1 : 0)
            .shimmer(
              duration: 1200.ms,
              color: Colors.white24,
            ),
      ),
    );
  }
}

class _GlowRing extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowRing({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
    );
  }
}
