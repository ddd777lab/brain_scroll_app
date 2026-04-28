import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 漂浮地图风格图标 — 大世界页面入口标识
///
/// 特性：
/// - 静态轻微阴影 + 漂浮感
/// - 点击放大 + 阴影更深 + 位置上移
/// - 柔和动画 200ms
/// - 图片失败时 fallback 到 Icons.public
class FloatingWorldIcon extends StatefulWidget {
  final double size;

  const FloatingWorldIcon({super.key, this.size = 48});

  @override
  State<FloatingWorldIcon> createState() => _FloatingWorldIconState();
}

class _FloatingWorldIconState extends State<FloatingWorldIcon>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // 点击状态参数
    final scale = _isPressed ? 1.12 : 1.0;
    final elevation = _isPressed ? 8.0 : 3.0;

    return Transform.scale(
      scale: scale,
      child: Transform.translate(
        offset: Offset(0, _isPressed ? -4 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.18 : 0.10),
                blurRadius: elevation * 2,
                offset: Offset(0, elevation),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: _buildIcon(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        'assets/images/world_map_icon.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.public,
                size: widget.size * 0.5,
                color: AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
