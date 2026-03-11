import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class OTPScreen extends StatefulWidget {

  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  final TextEditingController otpController = TextEditingController();

  int secondsRemaining = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {

    secondsRemaining = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      if (secondsRemaining == 0) {

        timer.cancel();

      } else {

        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {

    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "OTP sent to ${widget.phoneNumber}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,

              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  authProvider.verifyOTP(
                      context,
                      otpController.text.trim(),
                      widget.phoneNumber
                  );

                },

                child: authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Verify"),
              ),
            ),

            const SizedBox(height: 20),

            secondsRemaining == 0
                ? TextButton(
              onPressed: () {

                authProvider.sendOTP(
                    context,
                    widget.phoneNumber
                );

                startTimer();

              },
              child: const Text("Resend OTP"),
            )
                : Text(
              "Resend OTP in $secondsRemaining sec",
            )
          ],
        ),
      ),
    );
  }
}