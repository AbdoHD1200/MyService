import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CustomerHomeScreen extends StatefulWidget {
  final String token;
  const CustomerHomeScreen({super.key, required this.token});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  bool loading = false;
  String? successMessage;

  Future<void> sendOrder() async {
    if (titleController.text.isEmpty || descController.text.isEmpty) return;
    setState(() {
      loading = true;
      successMessage = null;
    });

    final res = await ApiService.createOrder(
      widget.token,
      titleController.text.trim(),
      descController.text.trim(),
    );

    setState(() => loading = false);
    if (res['order'] != null) {
      setState(() {
        successMessage = "تم إرسال طلبك بنجاح للفنيين!";
        titleController.clear();
        descController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم الزبون')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('اطلب صيانة أو خدمة الآن', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'نوع المشكلة (مثال: تسريب مياه السباكة)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'وصف تفصيلي للمشكلة والصور المطلوبة', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            if (successMessage != null)
              Text(successMessage!, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : sendOrder,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              child: loading ? const CircularProgressIndicator() : const Text('إرسال الطلب للفنيين والمطابقة'),
            ),
          ],
        ),
      ),
    );
  }
}
