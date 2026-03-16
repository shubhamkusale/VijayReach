import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  /// Controllers
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController shopController = TextEditingController();
  final TextEditingController newAreaController = TextEditingController();

  /// Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Default areas
  final List<String> defaultAreas = [
    "Airoli",
    "Vashi",
    "Nerul",
    "Thane",
    "Belapur",
    "Kharghar",
    "Panvel",
    "Kopar Khairane",
    "Ghansoli",
    "Rabale"
  ];

  /// Combined list
  List<String> allAreas = [];

  String selectedArea = "";
  bool showCustomAreaField = false;

  /// Get phone number from Firebase user
  String phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber ?? "";

  static const Color navy = Color(0xFF042C53);

  @override
  void initState() {
    super.initState();
    loadAreas();
  }

  /// Load areas from Firestore
  Future<void> loadAreas() async {

    final snapshot = await firestore.collection("areas").get();

    final firestoreAreas =
        snapshot.docs.map((doc) => doc["name"] as String).toList();

    setState(() {
      allAreas = [...defaultAreas, ...firestoreAreas, "Other / Add New Area"];
    });
  }

  /// Save new area
  Future<void> saveNewArea(String areaName) async {

    await firestore.collection("areas").add({
      "name": areaName,
      "createdAt": FieldValue.serverTimestamp()
    });

    await loadAreas();
  }

  bool get isFormValid {

    if (showCustomAreaField) {
      return ownerController.text.isNotEmpty &&
          shopController.text.isNotEmpty &&
          newAreaController.text.isNotEmpty;
    }

    return ownerController.text.isNotEmpty &&
        shopController.text.isNotEmpty &&
        selectedArea.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F6F8),

      body: Center(
        child: SingleChildScrollView(

          padding: const EdgeInsets.all(16),

          child: Container(

            width: 380,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: const BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),

                  child: const Text(
                    "VijayReach",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// FORM
                Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Register Your Store",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// OWNER NAME
                      const Text("Owner Name"),
                      const SizedBox(height: 6),

                      TextField(
                        controller: ownerController,
                        decoration: inputDecoration("Enter your full name"),
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: 18),

                      /// SHOP NAME
                      const Text("Medical Shop Name"),
                      const SizedBox(height: 6),

                      TextField(
                        controller: shopController,
                        decoration: inputDecoration("Enter shop name"),
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: 18),

                      /// AREA
                      const Text("Area"),
                      const SizedBox(height: 6),

                      DropdownButtonFormField<String>(

                        value: selectedArea.isEmpty ? null : selectedArea,

                        items: allAreas.map((area) {

                          return DropdownMenuItem(
                            value: area,
                            child: Text(area),
                          );

                        }).toList(),

                        onChanged: (value) {

                          setState(() {

                            selectedArea = value!;

                            if (value == "Other / Add New Area") {
                              showCustomAreaField = true;
                            } else {
                              showCustomAreaField = false;
                            }

                          });
                        },

                        decoration: inputDecoration("Select your area"),
                      ),

                      const SizedBox(height: 16),

                      /// NEW AREA FIELD
                      if (showCustomAreaField)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text("Enter New Area"),

                            const SizedBox(height: 6),

                            TextField(
                              controller: newAreaController,
                              decoration:
                              inputDecoration("Type new area name"),
                              onChanged: (_) => setState(() {}),
                            ),
                          ],
                        ),

                      const SizedBox(height: 18),

                      /// PHONE
                      const Text("Phone Number"),
                      const SizedBox(height: 6),

                      TextField(
                        enabled: false,
                        controller:
                        TextEditingController(text: phoneNumber),
                        decoration: inputDecoration(""),
                      ),

                      const SizedBox(height: 28),

                      /// CONTINUE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(

                          onPressed: isFormValid
                              ? () async {

                            String finalArea = selectedArea;

                            if (showCustomAreaField) {

                              finalArea =
                                  newAreaController.text.trim();

                              await saveNewArea(finalArea);
                            }

                            String phone =
                                FirebaseAuth.instance.currentUser?.phoneNumber ?? "";

                            /// SAVE USER DATA
                            await firestore
                                .collection("users")
                                .doc(phone)
                                .update({

                              "ownerName": ownerController.text.trim(),
                              "shopName": shopController.text.trim(),
                              "area": finalArea,

                            });

                            /// GO TO CUSTOMER HOME
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(
                                  context, "/customerHome");
                            }

                          }
                              : null,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),

                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// TERMS
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "By registering, you agree to our ",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            children: const [
                              TextSpan(
                                text: "Terms of Service",
                                style: TextStyle(
                                  color: navy,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {

    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F3F5),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}