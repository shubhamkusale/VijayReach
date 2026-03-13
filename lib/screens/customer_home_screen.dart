import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF042C53),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'VijayReach',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Messages from Vijay',
              style: TextStyle(
                color: Color(0xFF85B7EB),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          final messages = [
            {
              'title': 'Stock Alert',
              'body': 'Amoxicillin 500mg back in stock. New batch arrived. Contact for orders.',
              'time': 'Today 9:30 AM',
            },
            {
              'title': 'Payment Reminder',
              'body': 'March dues pending. Please clear by 15th to avoid disruption.',
              'time': 'Yesterday 11:00 AM',
            },
            {
              'title': 'New Product',
              'body': 'Introducing Zincovit Plus. Contact Vijay for free samples.',
              'time': 'Mon 2:15 PM',
            },
          ];
          final msg = messages[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F1FB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFB5D4F4)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF042C53),
                        child: Text('VK',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Vijay Kusale',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Color(0xFF042C53))),
                          Text(msg['time']!,
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF378ADD))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(msg['title']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF042C53))),
                  const SizedBox(height: 4),
                  Text(msg['body']!,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF185FA5))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}