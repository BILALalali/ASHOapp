// شاشة لوحة المعلومات الرئيسية
import 'package:flutter/material.dart';
import 'stats_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? usersStats;
  Map<String, dynamic>? upgradeStats;
  Map<String, dynamic>? productsStats;
  Map<String, dynamic>? chatsStats;
  Map<String, dynamic>? adsStats;
  bool loading = true;

  // ألوان العناوين حسب القسم
  final Color mainBlue = const Color(0xFF193A6B);
  final Color olive = const Color(0xFF7A8B6F);
  final Color sand = const Color(0xFFD2B48C);
  final Color purple = const Color(0xFF7B519D);
  final Color teal = const Color(0xFF008080);
  final Color bg = const Color(0xFFF7F7F9); // خلفية الشاشة
  final Color cardBg = const Color(0xFFECECEC); // خلفية البطاقات

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => loading = true);
    usersStats = await StatsService.getUsersStats();
    upgradeStats = await StatsService.getUpgradeStats();
    productsStats = await StatsService.getProductsStats();
    chatsStats = await StatsService.getChatsStats();
    adsStats = await StatsService.getAdsStats();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 900 ? 3 : 1;
                  double maxCardWidth = 400;
                  return Center(
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: [
                        _InfoCard(
                          maxWidth: maxCardWidth,
                          cardBg: cardBg,
                          icon: Icons.people_alt_rounded,
                          iconColor: mainBlue,
                          title: 'المستخدمون',
                          titleColor: mainBlue,
                          mainValue: usersStats?['count'].toString() ?? '-',
                          mainValueLabel: 'مستخدم',
                          details: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                (usersStats?['pendingRequests'] ?? 0) > 0
                                    ? 'طلبات جديدة: ${usersStats?['pendingRequests']}'
                                    : 'لا يوجد طلبات جديدة',
                                style: TextStyle(
                                    color:
                                        (usersStats?['pendingRequests'] ?? 0) >
                                                0
                                            ? olive
                                            : Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              if (usersStats?['lastUpdates'] != null) ...[
                                const Text('آخر التحديثات:',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                ...List.generate(
                                    (usersStats!['lastUpdates'] as List).length,
                                    (i) {
                                  final u = usersStats!['lastUpdates'][i];
                                  return Text('- ${u['name']} (${u['action']})',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black87));
                                }),
                              ],
                            ],
                          ),
                        ),
                        _InfoCard(
                          maxWidth: maxCardWidth,
                          cardBg: cardBg,
                          icon: Icons.upgrade_rounded,
                          iconColor: olive,
                          title: 'طلبات الترقية',
                          titleColor: olive,
                          mainValue: upgradeStats?['pending'].toString() ?? '-',
                          mainValueLabel: 'طلب جديد',
                          details: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                (upgradeStats?['pending'] ?? 0) > 0
                                    ? 'طلبات جديدة: ${upgradeStats?['pending']}'
                                    : 'لا يوجد طلبات جديدة',
                                style: TextStyle(
                                    color: (upgradeStats?['pending'] ?? 0) > 0
                                        ? olive
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                  'الحسابات المرقّاة: ${upgradeStats?['upgraded'] ?? '-'}',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black87)),
                            ],
                          ),
                        ),
                        _InfoCard(
                          maxWidth: maxCardWidth,
                          cardBg: cardBg,
                          icon: Icons.store_rounded,
                          iconColor: olive,
                          title: 'المنتجات',
                          titleColor: olive,
                          mainValue: productsStats?['count'].toString() ?? '-',
                          mainValueLabel: 'منتج',
                          details: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  'مضاف اليوم: ${productsStats?['today'] ?? '-'}',
                                  style: TextStyle(color: olive, fontSize: 14)),
                              Text(
                                  'هذا الأسبوع: ${productsStats?['week'] ?? '-'}',
                                  style: TextStyle(color: olive, fontSize: 14)),
                              const SizedBox(height: 6),
                              if (productsStats?['lastProducts'] != null) ...[
                                const Text('آخر المنتجات:',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                ...List.generate(
                                    (productsStats!['lastProducts'] as List)
                                        .length, (i) {
                                  final p = productsStats!['lastProducts'][i];
                                  return Text('- ${p['name']}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black87));
                                }),
                              ],
                            ],
                          ),
                        ),
                        _InfoCard(
                          maxWidth: maxCardWidth,
                          cardBg: cardBg,
                          icon: Icons.chat_rounded,
                          iconColor: purple,
                          title: 'المحادثات والطلبات',
                          titleColor: purple,
                          mainValue:
                              chatsStats?['negotiation'].toString() ?? '-',
                          mainValueLabel: 'تفاوض',
                          details: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _StatusLabel(
                                      label: 'تم البيع',
                                      value: chatsStats?['sold'] ?? '-',
                                      color: olive),
                                  const SizedBox(width: 8),
                                  _StatusLabel(
                                      label: 'ملغاة',
                                      value: chatsStats?['cancelled'] ?? '-',
                                      color: Colors.red),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.report,
                                      size: 16, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Text(
                                      'عدد التبليغات: ${chatsStats?['reports'] ?? 0}',
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.red)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _InfoCard(
                          maxWidth: maxCardWidth,
                          cardBg: cardBg,
                          icon: Icons.campaign_rounded,
                          iconColor: teal,
                          title: 'الإعلانات',
                          titleColor: teal,
                          mainValue: adsStats?['count'].toString() ?? '-',
                          mainValueLabel: 'إعلان',
                          details: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('آخر إعلان: ${adsStats?['lastAd'] ?? '-'}',
                                  style: TextStyle(color: teal, fontSize: 14)),
                              Text(
                                  'ستنتهي غدًا: ${adsStats?['expiringTomorrow'] ?? 0}',
                                  style: TextStyle(color: olive, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final double maxWidth;
  final Color cardBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String mainValue;
  final String mainValueLabel;
  final Widget details;

  const _InfoCard({
    required this.maxWidth,
    required this.cardBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.mainValue,
    required this.mainValueLabel,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: 260,
        minHeight: 150,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(icon, size: 28, color: iconColor),
                const SizedBox(width: 8),
                Text(title,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: titleColor)),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              height: 2,
              width: 28,
              decoration: BoxDecoration(
                color: titleColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(mainValue,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(width: 5),
                Text(mainValueLabel,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
            const SizedBox(height: 6),
            Flexible(child: details),
          ],
        ),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final String label;
  final dynamic value;
  final Color color;
  const _StatusLabel(
      {required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 15)),
        const SizedBox(width: 2),
        Text(label, style: TextStyle(color: color, fontSize: 13)),
      ],
    );
  }
}
