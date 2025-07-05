import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'product_model.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;
  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _currencyController;
  late TextEditingController _categoryController;
  late TextEditingController _sellerNameController;
  late TextEditingController _statusController;
  late DateTime _createdAt;
  late List<String> _imageUrls;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descController = TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _currencyController = TextEditingController(text: widget.product.currency);
    _categoryController = TextEditingController(text: widget.product.category);
    _sellerNameController =
        TextEditingController(text: widget.product.sellerName);
    _statusController = TextEditingController(text: widget.product.status);
    _createdAt = widget.product.createdAt;
    _imageUrls = List<String>.from(widget.product.imageUrls);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _currencyController.dispose();
    _categoryController.dispose();
    _sellerNameController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null && result.files.isNotEmpty) {
      // في التطبيق الحقيقي يجب رفع الصورة للسيرفر والحصول على رابطها
      // هنا سنحاكي ذلك بإضافة صورة base64 مؤقتة
      final file = result.files.first;
      if (file.bytes != null) {
        final ext = file.extension ?? 'jpg';
        final base64 = 'data:image/$ext;base64,${base64Encode(file.bytes!)}';
        setState(() {
          _imageUrls.add(base64);
        });
      } else if (file.path != null) {
        setState(() {
          _imageUrls.add(file.path!);
        });
      }
    }
  }

  void _setMainImage(int index) {
    setState(() {
      final img = _imageUrls.removeAt(index);
      _imageUrls.insert(0, img);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit, color: Color(0xFF193A6B)),
                  const SizedBox(width: 8),
                  const Text('تعديل المنتج',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF193A6B))),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // إدارة الصور
              Text('صور المنتج:',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageUrls.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    if (i == _imageUrls.length) {
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Icon(Icons.add_a_photo,
                              size: 32, color: Colors.grey),
                        ),
                      );
                    }
                    final url = _imageUrls[i];
                    final isMain = i == 0;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: url.startsWith('data:')
                              ? Image.memory(
                                  base64Decode(url.split(',').last),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(url,
                                  width: 80, height: 80, fit: BoxFit.cover),
                        ),
                        if (isMain)
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('رئيسية',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ),
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Row(
                            children: [
                              if (!isMain)
                                IconButton(
                                  icon: const Icon(Icons.star,
                                      color: Colors.amber, size: 20),
                                  tooltip: 'تعيين كصورة رئيسية',
                                  onPressed: () => _setMainImage(i),
                                ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red, size: 20),
                                tooltip: 'حذف الصورة',
                                onPressed: () => _removeImage(i),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'اسم المنتج', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                    labelText: 'الوصف', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                          labelText: 'السعر', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _currencyController,
                      decoration: const InputDecoration(
                          labelText: 'العملة', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                    labelText: 'الفئة', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sellerNameController,
                decoration: const InputDecoration(
                    labelText: 'اسم البائع', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _statusController.text,
                decoration: const InputDecoration(
                    labelText: 'الحالة', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'available', child: Text('متاح')),
                  DropdownMenuItem(value: 'sold', child: Text('مباع')),
                ],
                onChanged: (value) {
                  setState(() {
                    _statusController.text = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('تاريخ الإضافة: '),
                  Text(
                      '${_createdAt.day}/${_createdAt.month}/${_createdAt.year}'),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _createdAt,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _createdAt = picked;
                        });
                      }
                    },
                    child: const Text('تغيير'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
                      child: const Text('حفظ التعديلات'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    if (_nameController.text.isEmpty ||
        _descController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى ملء جميع الحقول المطلوبة'),
            backgroundColor: Colors.red),
      );
      return;
    }
    final updatedProduct = widget.product.copyWith(
      name: _nameController.text,
      description: _descController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      currency: _currencyController.text,
      category: _categoryController.text,
      imageUrls: _imageUrls,
      sellerName: _sellerNameController.text,
      status: _statusController.text,
      createdAt: _createdAt,
    );
    Navigator.of(context).pop(updatedProduct);
  }
}
