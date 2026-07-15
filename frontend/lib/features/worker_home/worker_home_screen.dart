import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class WorkerHomeScreen extends StatefulWidget {
  final String token;
  const WorkerHomeScreen({super.key, required this.token});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  List<dynamic> orders = [];
  bool loading = true;

  Future<void> fetchOrders() async {
    final res = await ApiService.getOrders(widget.token);
    setState(() {
      orders = res['orders'] ?? [];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الفني/العامل'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchOrders),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text('لا توجد طلبات متاحة حالياً في منطقتك.'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.build)),
                        title: Text(order['title'] ?? 'بدون عنوان'),
                        subtitle: Text(order['description'] ?? 'لا يوجد وصف'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم قبول الطلب، والاتصال بالزبون جاري!')),
                            );
                          },
                          child: const Text('قبول'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
