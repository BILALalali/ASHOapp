import 'package:flutter/material.dart';
import '../../core/theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;

  void _signup() {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      // TODO: ربط مع خدمة إنشاء الحساب
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء الحساب بنجاح!')),
        );
        // انتقل إلى شاشة تسجيل الدخول بعد النجاح
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person_add,
                    size: 64, color: Color(0xFF19345E)),
                const SizedBox(height: 24),
                Text('إنشاء حساب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF19345E))),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    border: OutlineInputBorder(),
                  ),
                  textDirection: TextDirection.rtl,
                  validator: (value) => value == null || value.trim().length < 3
                      ? 'الاسم قصير جداً'
                      : null,
                  onChanged: (val) => name = val,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني أو رقم الجوال',
                    border: OutlineInputBorder(),
                  ),
                  textDirection: TextDirection.rtl,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null,
                  onChanged: (val) => email = val,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  textDirection: TextDirection.rtl,
                  validator: (value) => value == null || value.length < 6
                      ? 'كلمة المرور قصيرة'
                      : null,
                  onChanged: (val) => password = val,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  textDirection: TextDirection.rtl,
                  validator: (value) =>
                      value != password ? 'كلمتا المرور غير متطابقتين' : null,
                  onChanged: (val) => confirmPassword = val,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('إنشاء حساب',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('لديك حساب؟ تسجيل الدخول',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
