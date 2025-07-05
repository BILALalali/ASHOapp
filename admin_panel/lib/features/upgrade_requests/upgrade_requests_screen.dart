// شاشة مراجعة طلبات الترقية
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../users/user_model.dart';
import '../users/users_service.dart';

class UpgradeRequestsScreen extends StatefulWidget {
  const UpgradeRequestsScreen({super.key});

  @override
  State<UpgradeRequestsScreen> createState() => _UpgradeRequestsScreenState();
}

class _UpgradeRequestsScreenState extends State<UpgradeRequestsScreen> {
  List<User> _requests = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final users = await UsersService.getAllUsers();
      final requests =
          users.where((u) => !u.isSeller && u.hasUpgradeRequest).toList();
      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptRequest(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الترقية'),
        content: Text('هل تريد ترقية المستخدم "${user.name}" إلى بائع؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('تأكيد الترقية'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      // محاكاة قبول الترقية
      setState(() {
        _requests = _requests
            .map((u) => u.id == user.id
                ? u.copyWith(isSeller: true, hasUpgradeRequest: false)
                : u)
            .toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تمت ترقية المستخدم إلى بائع'),
            backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _rejectRequest(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد رفض الطلب'),
        content: Text('هل تريد رفض طلب الترقية للمستخدم "${user.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('رفض الطلب'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        _requests = _requests.where((u) => u.id != user.id).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تم رفض طلب الترقية'), backgroundColor: Colors.red),
      );
    }
  }

  void _contactUser(User user) {
    // يمكنك هنا فتح واتساب أو نسخ رقم الهاتف أو أي وسيلة تواصل
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('تواصل مع ${user.name}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.blue),
                const SizedBox(width: 8),
                SelectableText(user.phone,
                    style: const TextStyle(fontSize: 16)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Navigator.pop(context);
                    Clipboard.setData(ClipboardData(text: user.phone));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم نسخ رقم الهاتف')));
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.green),
                const SizedBox(width: 8),
                SelectableText(user.email,
                    style: const TextStyle(fontSize: 16)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Navigator.pop(context);
                    Clipboard.setData(ClipboardData(text: user.email));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('تم نسخ البريد الإلكتروني')));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('طلبات الترقية',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF193A6B))),
              IconButton(
                onPressed: _loadRequests,
                icon: const Icon(Icons.refresh),
                tooltip: 'تحديث',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Text(_error!,
                            style: const TextStyle(color: Colors.red)))
                    : _requests.isEmpty
                        ? const Center(
                            child: Text('لا توجد طلبات ترقية حالياً'))
                        : ListView.separated(
                            itemCount: _requests.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final user = _requests[index];
                              return Card(
                                elevation: 4,
                                color: Colors.blue[50],
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.blue[100],
                                            child: Icon(Icons.person,
                                                size: 30,
                                                color: Colors.blue[700]),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(user.name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                Text(user.email,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                              user.isVerified
                                                  ? Icons.verified
                                                  : Icons.verified_outlined,
                                              color: user.isVerified
                                                  ? Colors.green
                                                  : Colors.grey,
                                              size: 22),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(Icons.phone,
                                              size: 16,
                                              color: Colors.grey[700]),
                                          const SizedBox(width: 4),
                                          Text(user.phone,
                                              style: const TextStyle(
                                                  fontSize: 13)),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.phone_forwarded,
                                                color: Colors.blue),
                                            tooltip: 'تواصل',
                                            onPressed: () => _contactUser(user),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text('طلب ترقية',
                                                style: TextStyle(
                                                    color: Colors.blue[700],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.calendar_today,
                                              size: 15,
                                              color: Colors.grey[600]),
                                          const SizedBox(width: 3),
                                          Text(
                                              '${user.joinDate.day}/${user.joinDate.month}/${user.joinDate.year}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () =>
                                                  _acceptRequest(user),
                                              icon: const Icon(
                                                  Icons.check_circle),
                                              label: const Text('قبول الترقية'),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () =>
                                                  _rejectRequest(user),
                                              icon: const Icon(Icons.cancel),
                                              label: const Text('رفض الطلب'),
                                              style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
