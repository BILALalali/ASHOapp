import 'package:flutter/material.dart';
import '../user_model.dart';

class EditUserDialog extends StatefulWidget {
  final User user;

  const EditUserDialog({
    super.key,
    required this.user,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late String _selectedAccountType;
  late bool _isActive;
  late bool _isVerified;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _selectedAccountType = widget.user.accountType;
    _isActive = widget.user.isActive;
    _isVerified = widget.user.isVerified;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              children: [
                const Icon(Icons.edit, color: Color(0xFF193A6B)),
                const SizedBox(width: 8),
                const Text(
                  'تعديل المستخدم',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF193A6B),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // نموذج التعديل
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // الاسم
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكامل',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // البريد الإلكتروني
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!value.contains('@')) {
                          return 'الرجاء إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // رقم الهاتف
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // العنوان
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'العنوان',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // نوع الحساب
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'نوع الحساب',
                        prefixIcon: Icon(Icons.account_circle),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedAccountType,
                      items: const [
                        DropdownMenuItem(
                          value: 'regular',
                          child: Text('عادي'),
                        ),
                        DropdownMenuItem(
                          value: 'premium',
                          child: Text('مميز'),
                        ),
                        DropdownMenuItem(
                          value: 'business',
                          child: Text('تجاري'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAccountType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // خيارات إضافية
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('حساب نشط'),
                            value: _isActive,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('حساب متحقق'),
                            value: _isVerified,
                            onChanged: (value) {
                              setState(() {
                                _isVerified = value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // أزرار التحكم
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('إلغاء'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            child: const Text('حفظ التغييرات'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    // التحقق من صحة البيانات
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء جميع الحقول المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // إنشاء كائن المستخدم المحدث
    final updatedUser = widget.user.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      accountType: _selectedAccountType,
      isActive: _isActive,
      address: _addressController.text.isEmpty ? null : _addressController.text,
      isVerified: _isVerified,
    );

    Navigator.of(context).pop(updatedUser);
  }
}
