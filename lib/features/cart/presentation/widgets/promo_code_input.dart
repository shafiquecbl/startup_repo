import 'package:startup_repo/imports.dart';

class PromoCodeInput extends StatefulWidget {
  final String? appliedCode;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;

  const PromoCodeInput({super.key, this.appliedCode, required this.onApply, required this.onRemove});

  @override
  State<PromoCodeInput> createState() => _PromoCodeInputState();
}

class _PromoCodeInputState extends State<PromoCodeInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appliedCode != null) {
      // Applied state
      return Material(
        color: Colors.green.withAlpha(15),
        shape: RoundedSuperellipseBorder(
          borderRadius: AppRadius.r16,
          side: const BorderSide(color: Colors.green, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
          child: Row(
            children: [
              Icon(Iconsax.ticket_discount, size: 20.sp, color: Colors.green),
              SizedBox(width: 10.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.appliedCode!.toUpperCase(),
                      style: context.font14.copyWith(fontWeight: FontWeight.w600, color: Colors.green),
                    ),
                    Text('Promo applied!', style: context.font10.copyWith(color: Colors.green)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.onRemove,
                child: Icon(Iconsax.close_circle, size: 20.sp, color: Colors.green),
              ),
            ],
          ),
        ),
      );
    }

    // Input state — use Card for the outer container
    return Card(
      child: Padding(
        padding: EdgeInsets.all(6.sp),
        child: Row(
          children: [
            SizedBox(width: 10.sp),
            Icon(Iconsax.ticket_discount, size: 20.sp, color: Theme.of(context).hintColor),
            SizedBox(width: 10.sp),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter promo code',
                  hintStyle: context.font14.copyWith(color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.sp),
                ),
                style: context.font14,
                textCapitalization: TextCapitalization.characters,
              ),
            ),
            SizedBox(width: 8.sp),
            GestureDetector(
              onTap: () {
                if (_controller.text.isNotEmpty) {
                  widget.onApply(_controller.text);
                  _controller.clear();
                }
              },
              child: Material(
                color: AppColors.primary,
                shape: AppRadius.r8Shape,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                  child: Text(
                    'Apply',
                    style: context.font12.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
