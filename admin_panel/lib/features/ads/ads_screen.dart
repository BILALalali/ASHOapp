// شاشة إدارة الإعلانات
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'ad_model.dart';
import 'ads_service.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  List<AdModel> _ads = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  Future<void> _loadAds() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final ads = await AdsService.getAllAds();
      setState(() {
        _ads = ads;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _addAdDialog() async {
    final result = await showDialog<AdModel>(
      context: context,
      builder: (context) => _AddAdDialog(),
    );
    if (result != null) {
      await AdsService.addAd(result);
      _loadAds();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('تمت إضافة الإعلان بنجاح'),
              backgroundColor: Colors.green),
        );
      }
    }
  }

  Future<void> _deleteAd(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الإعلان؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('حذف')),
        ],
      ),
    );
    if (confirmed == true) {
      await AdsService.deleteAd(id);
      _loadAds();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('تم حذف الإعلان'), backgroundColor: Colors.red),
        );
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('نظام الإعلانات',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF193A6B))),
              ElevatedButton.icon(
                onPressed: _addAdDialog,
                icon: const Icon(Icons.add),
                label: const Text('إضافة إعلان'),
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
                    : _ads.isEmpty
                        ? const Center(child: Text('لا توجد إعلانات حالياً'))
                        : ListView.separated(
                            itemCount: _ads.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final ad = _ads[index];
                              return Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: ad.imageUrl.startsWith('data:')
                                        ? Image.memory(
                                            base64Decode(
                                                ad.imageUrl.split(',').last),
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover)
                                        : Image.network(ad.imageUrl,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, e, s) =>
                                                Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.grey[200],
                                                    child: const Icon(
                                                        Icons.image,
                                                        color: Colors.grey))),
                                  ),
                                  title: Text('رابط: ${ad.link ?? '-'}',
                                      style: const TextStyle(fontSize: 14)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'تاريخ البداية: ${ad.startDate.day}/${ad.startDate.month}/${ad.startDate.year}',
                                          style: const TextStyle(fontSize: 12)),
                                      Text(
                                          'المدة: ${_durationText(ad.duration)}',
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    tooltip: 'حذف',
                                    onPressed: () => _deleteAd(ad.id),
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

  String _durationText(AdDuration d) {
    switch (d) {
      case AdDuration.day:
        return 'يوم واحد';
      case AdDuration.week:
        return 'أسبوع';
      case AdDuration.twoWeeks:
        return 'أسبوعين';
      case AdDuration.month:
        return 'شهر';
    }
  }
}

class _AddAdDialog extends StatefulWidget {
  @override
  State<_AddAdDialog> createState() => _AddAdDialogState();
}

class _AddAdDialogState extends State<_AddAdDialog> {
  String? _imageData;
  final _linkController = TextEditingController();
  AdDuration? _duration;
  bool _isLoading = false;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.bytes != null) {
        final ext = file.extension ?? 'jpg';
        setState(() {
          _imageData = 'data:image/$ext;base64,${base64Encode(file.bytes!)}';
        });
      }
    }
  }

  void _submit() {
    if (_imageData == null || _duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('يرجى اختيار صورة وتحديد مدة الإعلان'),
          backgroundColor: Colors.red));
      return;
    }
    final ad = AdModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrl: _imageData!,
      link: _linkController.text.isNotEmpty ? _linkController.text : null,
      startDate: DateTime.now(),
      duration: _duration!,
    );
    Navigator.of(context).pop(ad);
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
                  const Icon(Icons.campaign, color: Color(0xFF193A6B)),
                  const SizedBox(width: 8),
                  const Text('إضافة إعلان جديد',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF193A6B))),
                  const Spacer(),
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _pickImage,
                child: _imageData == null
                    ? Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.grey),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _imageData!.startsWith('data:')
                            ? Image.memory(
                                base64Decode(_imageData!.split(',').last),
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover)
                            : Image.network(_imageData!,
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover),
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                    labelText: 'رابط الإعلان (اختياري)',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AdDuration>(
                decoration: const InputDecoration(
                    labelText: 'مدة الإعلان', border: OutlineInputBorder()),
                value: _duration,
                items: const [
                  DropdownMenuItem(
                      value: AdDuration.day, child: Text('يوم واحد')),
                  DropdownMenuItem(
                      value: AdDuration.week, child: Text('أسبوع')),
                  DropdownMenuItem(
                      value: AdDuration.twoWeeks, child: Text('أسبوعين')),
                  DropdownMenuItem(value: AdDuration.month, child: Text('شهر')),
                ],
                onChanged: (v) => setState(() => _duration = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: const Icon(Icons.check),
                  label: const Text('إضافة الإعلان'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
