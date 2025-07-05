import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/theme.dart';
import '../../widgets/upgrade_dialogs.dart';

class AccountScreen extends StatefulWidget {
  final bool isSeller;
  const AccountScreen({Key? key, this.isSeller = false}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // بيانات المستخدم التجريبية
  late User user;
  String accountType = '';
  DateTime registrationDate = DateTime(2024, 1, 15);
  int ordersCount = 5;

  // صورة مؤقتة
  ImageProvider? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    user = User(
      id: '1',
      name: 'أحمد محمد',
      avatarUrl: '',
      email: 'ahmed@example.com',
      phone: '+966 50 123 4567',
      isSeller: widget.isSeller,
    );
    accountType = widget.isSeller ? 'بائع' : 'مشتري';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Stack(
        children: [
          // خلفية علوية منحنية
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              height: size.height * 0.32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF19345E), Color(0xFF30507D)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // صورة المستخدم مع ظل وإطار متدرج
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.13),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [Color(0xFF30507D), Color(0xFF19345E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.blue[50],
                              backgroundImage: _avatarImage ??
                                  (user.avatarUrl.isNotEmpty
                                      ? NetworkImage(user.avatarUrl)
                                      : null),
                              child:
                                  _avatarImage == null && user.avatarUrl.isEmpty
                                      ? const Icon(Icons.person,
                                          size: 60, color: Colors.grey)
                                      : null,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: _showImagePicker,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(7),
                              child: const Icon(Icons.camera_alt,
                                  color: Color(0xFF19345E), size: 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // معلومات المستخدم في Card شفاف
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Card(
                      color: Colors.white.withOpacity(0.92),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 16),
                        child: Column(
                          children: [
                            Text(user.name,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF19345E))),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone,
                                    color: Colors.blueGrey, size: 18),
                                const SizedBox(width: 6),
                                Text(user.phone,
                                    style: const TextStyle(
                                        color: Colors.blueGrey, fontSize: 15)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.email,
                                    color: Colors.blueGrey, size: 18),
                                const SizedBox(width: 6),
                                Text(user.email,
                                    style: const TextStyle(
                                        color: Colors.blueGrey, fontSize: 15)),
                              ],
                            ),
                            if (user.isSeller) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.green.shade300),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified,
                                        color: Colors.green, size: 20),
                                    const SizedBox(width: 8),
                                    Text('حساب بائع مفعل',
                                        style: TextStyle(
                                            color: Colors.green.shade800,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // أزرار عصرية
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF19345E),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 3,
                            ),
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: const Text('تعديل الملف الشخصي',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            onPressed: _showEditProfileDialog,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (!user.isSeller)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA726),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 3,
                              ),
                              icon:
                                  const Icon(Icons.store, color: Colors.white),
                              label: const Text('طلب الترقية لحساب بائع',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              onPressed: _showUpgradeDialog,
                            ),
                          ),
                        const SizedBox(height: 12),
                        // زر تسجيل الخروج
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                            ),
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text('تسجيل الخروج',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login',
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Card معلومات إضافية
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Card(
                      color: const Color(0xFFF9FAFB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow(
                              icon: Icons.person,
                              label: 'نوع الحساب',
                              value: accountType,
                            ),
                            const SizedBox(height: 16),
                            _infoRow(
                              icon: Icons.calendar_today,
                              label: 'تاريخ التسجيل',
                              value:
                                  '${registrationDate.year} يناير ${registrationDate.day}',
                            ),
                            const SizedBox(height: 16),
                            _infoRow(
                              icon: Icons.lock,
                              label: 'عدد الطلبات',
                              value: '$ordersCount طلبات',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePicker() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('اختيار صورة من المعرض'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 80);
                if (image != null && mounted) {
                  setState(() {
                    _avatarImage = FileImage(File(image.path));
                  });
                  Future.delayed(Duration.zero, () {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('تم اختيار صورة بنجاح')));
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('التقاط صورة جديدة'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera, imageQuality: 80);
                if (image != null && mounted) {
                  setState(() {
                    _avatarImage = FileImage(File(image.path));
                  });
                  Future.delayed(Duration.zero, () {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('تم التقاط صورة بنجاح')));
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final emailController = TextEditingController(text: user.email);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('تعديل الملف الشخصي', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'الاسم'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(
                    color: Color(0xFF19345E), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF19345E),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              elevation: 0,
            ),
            onPressed: () {
              setState(() {
                user = User(
                  id: user.id,
                  name: nameController.text,
                  avatarUrl: user.avatarUrl,
                  email: emailController.text,
                  phone: phoneController.text,
                  isSeller: user.isSeller,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث البيانات بنجاح')));
            },
            child: const Text('حفظ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => UpgradeToSellerDialog(
        showPlans: true,
        onPlanSelected: (plan) {
          // يمكنك هنا تنفيذ منطق إضافي عند اختيار الخطة
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إرسال طلب الترقية بنجاح')),
          );
        },
      ),
    );
  }

  Widget _infoRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blueGrey, size: 22),
        const SizedBox(width: 10),
        Text('$label:',
            style: const TextStyle(color: Colors.blueGrey, fontSize: 15)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF19345E)),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

// كليبر لمنحنى الخلفية العلوية
class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height + 40, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
