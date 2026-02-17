import 'package:startup_repo/imports.dart';

import '../../../food_home/presentation/utils/food_formatters.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppPadding.p16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary', style: context.font16.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: 12.sp),

            _SummaryRow(label: 'Subtotal', value: FoodFormatters.formatPrice(subtotal)),
            SizedBox(height: 6.sp),

            _SummaryRow(
              label: 'Delivery Fee',
              value: deliveryFee == 0 ? 'Free' : FoodFormatters.formatPrice(deliveryFee),
              valueColor: deliveryFee == 0 ? Colors.green : null,
            ),

            if (discount > 0) ...[
              SizedBox(height: 6.sp),
              _SummaryRow(
                label: 'Discount',
                value: '-${FoodFormatters.formatPrice(discount)}',
                valueColor: Colors.green,
              ),
            ],

            SizedBox(height: 8.sp),
            const Divider(),
            SizedBox(height: 8.sp),

            _SummaryRow(
              label: 'Total',
              value: FoodFormatters.formatPrice(total),
              isBold: true,
              valueColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({required this.label, required this.value, this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? context.font16.copyWith(fontWeight: FontWeight.w700)
              : context.font14.copyWith(color: Theme.of(context).hintColor),
        ),
        Text(
          value,
          style: isBold
              ? context.font16.copyWith(fontWeight: FontWeight.w700, color: valueColor)
              : context.font14.copyWith(fontWeight: FontWeight.w500, color: valueColor),
        ),
      ],
    );
  }
}
