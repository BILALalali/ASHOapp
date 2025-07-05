import 'package:flutter/material.dart';
import '../user_model.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onUpgrade;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    this.onUpgrade,
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
                // حالة التحقق
                Icon(user.isVerified ? Icons.verified : Icons.verified_outlined,
                    color: user.isVerified ? Colors.green : Colors.grey,
                    size: 22),
              ],
            ),
            const SizedBox(height: 16),

            // معلومات الاتصال
            _buildInfoRow(Icons.email, user.email),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, user.phone),
            const SizedBox(height: 8),

            // نوع الحساب وتاريخ الانضمام
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: user.isSeller ? Colors.blue[50] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(user.accountTypeDisplay,
                      style: TextStyle(
                          color: user.accountTypeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Icon(Icons.calendar_today, size: 15, color: Colors.grey[600]),
                const SizedBox(width: 3),
                Text(
                    '${user.joinDate.day}/${user.joinDate.month}/${user.joinDate.year}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('تعديل'),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('حذف'),
                    style:
                        OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
              ],
            ),
            if (onUpgrade != null) ...[
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onUpgrade,
                  icon: const Icon(Icons.upgrade, size: 16),
                  label: const Text('ترقية إلى بائع'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
            ],
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
}
