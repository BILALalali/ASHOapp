import 'package:flutter/material.dart';
import '../user_model.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة مع الصورة والاسم
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: user.accountTypeColor.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: user.accountTypeColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF193A6B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: user.accountTypeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: user.accountTypeColor),
                        ),
                        child: Text(
                          user.accountTypeDisplay,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: user.accountTypeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // مؤشر الحالة
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: user.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // معلومات الاتصال
            _buildInfoRow(Icons.email, user.email),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, user.phone),
            const SizedBox(height: 8),
            if (user.address != null) ...[
              _buildInfoRow(Icons.location_on, user.address!),
              const SizedBox(height: 8),
            ],

            // الإحصائيات
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'المنتجات',
                    user.productsCount.toString(),
                    Icons.store,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'الطلبات',
                    user.ordersCount.toString(),
                    Icons.shopping_cart,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'التقييم',
                    user.rating.toStringAsFixed(1),
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // تاريخ الانضمام
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'انضم في: ${_formatDate(user.joinDate)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // أزرار التحكم
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('تعديل'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onToggleStatus,
                    icon: Icon(
                      user.isActive ? Icons.block : Icons.check_circle,
                      size: 16,
                    ),
                    label: Text(user.isActive ? 'إلغاء التفعيل' : 'تفعيل'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      foregroundColor:
                          user.isActive ? Colors.red : Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('حذف'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF193A6B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon,
      {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color ?? Colors.grey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF193A6B),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
