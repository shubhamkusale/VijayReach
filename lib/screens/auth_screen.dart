import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("MediBroadcast Login"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.local_hospital,
              size: 80,
              color: Colors.green,
            ),

            const SizedBox(height: 30),

            const Text(
              "Enter your phone number",
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,

              decoration: const InputDecoration(
                labelText: "+91 Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: authProvider.isLoading
                    ? null
                    : () {

                  String phone =
                      "+91${phoneController.text.trim()}";

                  authProvider.sendOTP(context, phone);

                },

                child: authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Send OTP"),
              ),
            )
          ],
        ),
      ),
    );
  }
}