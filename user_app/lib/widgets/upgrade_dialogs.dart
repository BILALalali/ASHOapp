import 'package:flutter/material.dart';

/// حوار موحد لترقية الحساب إلى بائع
/// يمكن استخدامه كتنبيه فقط أو مع اختيار خطة
class UpgradeToSellerDialog extends StatefulWidget {
  /// إذا كان showPlans = false يظهر فقط تنبيه الترقية مع زر "ترقية الحساب"
  /// إذا كان showPlans = true يظهر خيارات الخطط مباشرة
  final bool showPlans;
  final void Function(int? selectedPlan)? onPlanSelected;
  final VoidCallback? onCancel;
  final String? title;
  final String? description;
  final String? upgradeButtonText;
  final String? cancelButtonText;
  final List<Map<String, String>>? plans;

  const UpgradeToSellerDialog({
    super.key,
    this.showPlans = false,
    this.onPlanSelected,
    this.onCancel,
    this.title,
    this.description,
    this.upgradeButtonText,
    this.cancelButtonText,
    this.plans,
  });

  @override
  State<UpgradeToSellerDialog> createState() => _UpgradeToSellerDialogState();
}

class _UpgradeToSellerDialogState extends State<UpgradeToSellerDialog> {
  int? selectedPlan;

  List<Map<String, String>> get _plans =>
      widget.plans ??
      [
        {'label': 'حساب تجريبي (أسبوع مجاني)', 'price': 'مجاني'},
        {'label': 'حساب شهري', 'price': '100 رس'},
        {'label': 'حساب سنوي', 'price': '900 رس'},
        {'label': 'حساب دائم', 'price': '3500 رس'},
      ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      content: widget.showPlans
          ? _buildPlansContent(context)
          : _buildUpgradeNotice(context),
    );
  }

  Widget _buildUpgradeNotice(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.store, color: const Color(0xFFFF9800), size: 40),
        const SizedBox(height: 12),
        Text(widget.title ?? 'حساب البائع مطلوب',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF19345E))),
        const SizedBox(height: 8),
        Text(
            widget.description ??
                'هذه الميزة متاحة فقط لحسابات البائعين. يمكنك ترقية حسابك للوصول إلى هذه الميزة.',
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                  widget.onCancel?.call();
                },
                child: Text(widget.cancelButtonText ?? 'لاحقًا',
                    style: const TextStyle(color: Color(0xFF19345E))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  // افتح حوار الخطط
                  final plan = await showDialog<int>(
                    context: context,
                    builder: (ctx) => UpgradeToSellerDialog(
                      showPlans: true,
                      plans: _plans,
                    ),
                  );
                  if (plan != null) {
                    Navigator.pop(context, true);
                    widget.onPlanSelected?.call(plan);
                  }
                },
                child: Text(widget.upgradeButtonText ?? 'ترقية الحساب',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlansContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.title ?? 'اختر نوع حساب البائع',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF19345E))),
        const SizedBox(height: 8),
        ..._plans.asMap().entries.map((entry) {
          int idx = entry.key;
          var plan = entry.value;
          return RadioListTile<int>(
            value: idx,
            groupValue: selectedPlan,
            onChanged: (val) => setState(() => selectedPlan = val),
            title: Text(plan['label']!),
            subtitle: Text(plan['price']!,
                style: const TextStyle(color: Color(0xFFFF9800))),
            activeColor: const Color(0xFFFF9800),
          );
        }),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, null);
                  widget.onCancel?.call();
                },
                child: Text(widget.cancelButtonText ?? 'إلغاء',
                    style: const TextStyle(color: Color(0xFF19345E))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedPlan != null
                      ? const Color(0xFFFF9800)
                      : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: selectedPlan != null
                    ? () {
                        Navigator.pop(context, selectedPlan);
                        widget.onPlanSelected?.call(selectedPlan);
                      }
                    : null,
                child: Text(widget.upgradeButtonText ?? 'ترقية الحساب',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
