// شاشة إدارة المستخدمين
import 'package:flutter/material.dart';
import 'user_model.dart';
import 'users_service.dart';
import 'widgets/user_card.dart';
import 'widgets/edit_user_dialog.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedType = 'all';
  String _selectedVerify = 'all';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final users = await UsersService.getAllUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterUsers() {
    List<User> filtered = _users;

    // تطبيق البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((user) =>
              user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.phone.contains(_searchQuery))
          .toList();
    }

    // تطبيق الفلتر
    if (_selectedType != 'all') {
      filtered = filtered
          .where((user) =>
              _selectedType == 'buyer' ? !user.isSeller : user.isSeller)
          .toList();
    }
    if (_selectedVerify != 'all') {
      filtered = filtered
          .where((user) => _selectedVerify == 'verified'
              ? user.isVerified
              : !user.isVerified)
          .toList();
    }

    setState(() {
      _filteredUsers = filtered;
    });
  }

  Future<void> _editUser(User user) async {
    final result = await showDialog<User>(
      context: context,
      builder: (context) => EditUserDialog(user: user),
    );

    if (result != null) {
      try {
        await UsersService.updateUser(user.id, {
          'name': result.name,
          'email': result.email,
          'phone': result.phone,
          'isVerified': result.isVerified,
        });

        // تحديث القائمة
        await _loadUsers();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث المستخدم بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل في تحديث المستخدم: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المستخدم "${user.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await UsersService.deleteUser(user.id);

        // تحديث القائمة
        await _loadUsers();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف المستخدم بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل في حذف المستخدم: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إدارة المستخدمين',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF193A6B),
                ),
              ),
              IconButton(
                onPressed: _loadUsers,
                icon: const Icon(Icons.refresh),
                tooltip: 'تحديث',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الإحصائيات
          Row(
            children: [
              _buildStatCard(
                  'إجمالي المستخدمين', _users.length.toString(), Icons.people),
              const SizedBox(width: 16),
              _buildStatCard(
                  'البائعين',
                  _users.where((u) => u.isSeller).length.toString(),
                  Icons.store,
                  color: Colors.blue),
              const SizedBox(width: 16),
              _buildStatCard(
                  'المشترين',
                  _users.where((u) => !u.isSeller).length.toString(),
                  Icons.shopping_cart,
                  color: Colors.grey),
              const SizedBox(width: 16),
              _buildStatCard(
                  'المتحققين',
                  _users.where((u) => u.isVerified).length.toString(),
                  Icons.verified,
                  color: Colors.green),
            ],
          ),
          const SizedBox(height: 24),

          // البحث والفلترة
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'البحث في المستخدمين...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _filterUsers();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _selectedType,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('جميع الأنواع')),
                    DropdownMenuItem(value: 'buyer', child: Text('المشترين')),
                    DropdownMenuItem(value: 'seller', child: Text('البائعين')),
                  ],
                  onChanged: (value) {
                    _selectedType = value!;
                    _filterUsers();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _selectedVerify,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('كل الحالات')),
                    DropdownMenuItem(value: 'verified', child: Text('متحقق')),
                    DropdownMenuItem(
                        value: 'not_verified', child: Text('غير متحقق')),
                  ],
                  onChanged: (value) {
                    _selectedVerify = value!;
                    _filterUsers();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // قائمة المستخدمين
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadUsers,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : _filteredUsers.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد مستخدمين',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return UserCard(
                                user: user,
                                onEdit: () => _editUser(user),
                                onDelete: () => _deleteUser(user),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      {Color? color}) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color ?? const Color(0xFF193A6B)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF193A6B),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
