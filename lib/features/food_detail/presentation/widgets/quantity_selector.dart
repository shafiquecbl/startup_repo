import 'package:startup_repo/imports.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const QuantitySelector({super.key, required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.sp),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Minus button
            _ControlButton(
              icon: Icons.remove_rounded,
              onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
            ),

            // Quantity display
            SizedBox(
              width: 48.sp,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: context.font18.copyWith(fontWeight: FontWeight.w700),
              ),
            ),

            // Plus button
            _ControlButton(
              icon: Icons.add_rounded,
              onTap: quantity < 99 ? () => onChanged(quantity + 1) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ControlButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: isEnabled ? AppColors.primary : AppColors.primary.withAlpha(30),
        shape: AppRadius.r8Shape,
        child: SizedBox(
          width: 36.sp,
          height: 36.sp,
          child: Center(
            child: Icon(icon, size: 18.sp, color: isEnabled ? Colors.white : Colors.white54),
          ),
        ),
      ),
    );
  }
}
