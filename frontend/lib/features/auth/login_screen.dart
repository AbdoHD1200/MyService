import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../customer_home/customer_home_screen.dart';
import '../worker_home/worker_home_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  
  bool isRegisterMode = false;
  bool loading = false;
  String? error;

  Future<void> submit() async {
    setState(() {
      loading = true;
      error = null;
    });

    if (isRegisterMode) {
      final res = await ApiService.register(
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        role: widget.role,
      );
      if (res['user'] != null) {
        setState(() {
          isRegisterMode = false;
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم التسجيل بنجاح! يمكنك الآن تسجيل الدخول')),
        );
      } else {
        setState(() {
          error = res['message'] ?? 'فشل في عملية التسجيل';
          loading = false;
        });
      }
    } else {
      final res = await ApiService.login(
        phoneController.text.trim(),
        passwordController.text.trim(),
      );
      setState(() => loading = false);
      if (res['token'] != null) {
        final token = res['token'];
        if (widget.role == 'CUSTOMER') {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => CustomerHomeScreen(token: token),
          ));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => WorkerHomeScreen(token: token),
          ));
        }
      } else {
        setState(() => error = res['message'] ?? 'فشل في تسجيل الدخول');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isRegisterMode ? 'إنشاء حساب جديد' : 'تسجيل الدخول')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                widget.role == 'CUSTOMER' ? Icons.person : Icons.construction,
                size: 80,
                color: widget.role == 'CUSTOMER' ? Colors.blue : Colors.amber,
              ),
              const SizedBox(height: 16),
              Text(
                'الوضع الحالي: ${widget.role == 'CUSTOMER' ? 'زبون' : 'فني/عامل'}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 24),
              if (isRegisterMode)
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل', border: OutlineInputBorder()),
                ),
              if (isRegisterMode) const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'رقم الهاتف', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة المرور', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : submit,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: loading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Text(isRegisterMode ? 'تسجيل حساب جديد' : 'دخول'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isRegisterMode = !isRegisterMode;
                    error = null;
                  });
                },
                child: Text(isRegisterMode ? 'لديك حساب بالفعل؟ سجل دخولك' : 'ليس لديك حساب؟ أنشئ حساباً جديداً'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
