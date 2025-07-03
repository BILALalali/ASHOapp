import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF19345E),
        title: const Text('إضافة منتج'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: ProductForm(),
          ),
        ),
      ),
    );
  }
}

class ProductForm extends StatefulWidget {
  const ProductForm({Key? key}) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  String? _name;
  String? _description;
  String? _price;
  String? _currency;
  String? _category;

  final List<String> _currencies = [
    'الليرة السورية',
    'الليرة التركية',
    'الدولار الأمريكي'
  ];
  final List<String> _categories = [
    'الكترونيات',
    'ملابس',
    'أثاث',
    'سيارات',
    'عقارات',
    'ألعاب',
    'كتب',
    'أخرى',
  ];

  bool _submitted = false;
  bool _success = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      autovalidateMode:
          _submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImagesPicker(
            images: _images,
            onAdd: _pickImages,
            onRemove: (index) => setState(() => _images.removeAt(index)),
          ),
          const SizedBox(height: 18),
          _ProductTextField(
            label: 'اسم المنتج',
            maxLength: 50,
            minLength: 5,
            onSaved: (v) => _name = v,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'اسم المنتج مطلوب';
              if (v.trim().length < 5)
                return 'اسم المنتج يجب أن يكون 5 أحرف على الأقل';
              if (v.trim().length > 50)
                return 'اسم المنتج يجب ألا يتجاوز 50 حرفًا';
              return null;
            },
          ),
          const SizedBox(height: 12),
          _ProductTextField(
            label: 'وصف المنتج',
            maxLength: 500,
            minLength: 50,
            maxLines: 5,
            onSaved: (v) => _description = v,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'وصف المنتج مطلوب';
              if (v.trim().length < 50)
                return 'الوصف يجب أن يكون 50 حرفًا على الأقل';
              if (v.trim().length > 500) return 'الوصف يجب ألا يتجاوز 500 حرف';
              return null;
            },
          ),
          const SizedBox(height: 12),
          _ProductTextField(
            label: 'السعر',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSaved: (v) => _price = v,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'السعر مطلوب';
              final num? price = num.tryParse(v);
              if (price == null || price <= 0) return 'أدخل رقمًا موجبًا';
              return null;
            },
          ),
          const SizedBox(height: 12),
          _ProductDropdownField(
            label: 'العملة',
            value: _currency,
            items: _currencies,
            onChanged: (v) => setState(() => _currency = v),
            validator: (v) => v == null ? 'العملة مطلوبة' : null,
          ),
          const SizedBox(height: 12),
          _ProductDropdownField(
            label: 'الفئة',
            value: _category,
            items: _categories,
            onChanged: (v) => setState(() => _category = v),
            validator: (v) => v == null ? 'الفئة مطلوبة' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19345E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              onPressed: _onSubmit,
              child: const Text('إضافة المنتج',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    final List<XFile>? picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked != null && picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked);
      });
    }
  }

  void _onSubmit() {
    setState(() {
      _submitted = true;
      _success = false;
    });
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يجب اختيار صورة واحدة على الأقل')));
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // هنا يمكن إرسال البيانات للـ backend لاحقاً
      debugPrint('--- بيانات المنتج ---');
      debugPrint('الصور: ${_images.length}');
      debugPrint('اسم المنتج: $_name');
      debugPrint('الوصف: $_description');
      debugPrint('السعر: $_price');
      debugPrint('العملة: $_currency');
      debugPrint('الفئة: $_category');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('تمت إضافة المنتج بنجاح!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _success = true;
        _images.clear();
        _name = null;
        _description = null;
        _price = null;
        _currency = null;
        _category = null;
        _formKey.currentState?.reset();
      });
    }
  }
}

// Widget لاختيار صور المنتج
class _ProductImagesPicker extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  const _ProductImagesPicker(
      {required this.images, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('صور المنتج',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF19345E))),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index < images.length) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(images[index].path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () => onRemove(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.85),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: onAdd,
                  child: DottedBorder(
                    color: const Color(0xFFFFA726),
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [6, 3],
                    strokeWidth: 2,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_a_photo,
                          color: Color(0xFF19345E), size: 32),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

// Widget لحقل نصي معاد الاستخدام
class _ProductTextField extends StatelessWidget {
  final String label;
  final int? maxLength;
  final int? minLength;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  const _ProductTextField({
    required this.label,
    this.maxLength,
    this.minLength,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF19345E), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF19345E), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      maxLength: maxLength,
      minLines: maxLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onSaved: onSaved,
      validator: validator,
    );
  }
}

// Widget لقائمة منسدلة معاد الاستخدام
class _ProductDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  const _ProductDropdownField({
    required this.label,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF19345E), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF19345E), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      value: value,
      items: items
          .map((e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

// DottedBorder widget (يمكنك استخدام حزمة dotted_border أو استبداله بـ Container مع Border)
class DottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final BorderType borderType;
  final Radius radius;
  final List<double> dashPattern;
  final double strokeWidth;
  const DottedBorder({
    required this.child,
    required this.color,
    required this.borderType,
    required this.radius,
    required this.dashPattern,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    // يمكنك استبداله بحزمة dotted_border الحقيقية إذا كانت متوفرة
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: color, width: strokeWidth, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(radius),
      ),
      child: child,
    );
  }
}

enum BorderType { RRect }
