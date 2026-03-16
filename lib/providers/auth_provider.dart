import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/otp_screen.dart';

class AuthProvider extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String verificationId = "";
  bool isLoading = false;

  /// SEND OTP
  Future<void> sendOTP(BuildContext context, String phoneNumber) async {

    // Sign out existing user
    await _auth.signOut();

    isLoading = true;
    notifyListeners();

    print("Sending OTP to: $phoneNumber");

    await _auth.verifyPhoneNumber(

      phoneNumber: phoneNumber,

      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {

        isLoading = false;
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Verification failed")),
        );
      },

      codeSent: (String verId, int? resendToken) {

        verificationId = verId;

        isLoading = false;
        notifyListeners();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(phoneNumber: phoneNumber),
          ),
        );
      },

      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }



  /// VERIFY OTP
  Future<void> verifyOTP(
      BuildContext context,
      String otp,
      String phoneNumber,
      ) async {

    try {

      isLoading = true;
      notifyListeners();

      print("Verifying OTP: $otp with verificationId: $verificationId");

      PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Sign in user
      await _auth.signInWithCredential(credential);

      // After login check role
      await _checkUserRole(context, phoneNumber);

    } catch (e) {

      isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }



  /// CHECK USER ROLE + REGISTRATION
  Future<void> _checkUserRole(
      BuildContext context,
      String phoneNumber,
      ) async {

    final userDoc =
    await _firestore.collection("users").doc(phoneNumber).get();

    if (userDoc.exists) {

      String role = userDoc["role"] ?? "customer";

      // Check if registration completed
      bool isRegistered =
      userDoc.data()!.containsKey("shopName");

      if (role == "admin") {

        Navigator.pushReplacementNamed(context, "/adminHome");

      } else if (!isRegistered) {

        // New customer -> go to registration
        Navigator.pushReplacementNamed(context, "/register");

      } else {

        // Existing customer
        Navigator.pushReplacementNamed(context, "/customerHome");

      }

    } else {

      // Completely new user
      await _firestore.collection("users").doc(phoneNumber).set({

        "phone": phoneNumber,
        "role": "customer",
        "createdAt": FieldValue.serverTimestamp()

      });

      Navigator.pushReplacementNamed(context, "/register");
    }

    isLoading = false;
    notifyListeners();
  }
}