import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, String>> _contacts = [
    {'name': 'Rajesh Medicals', 'area': 'Airoli'},
    {'name': 'City Care Pharmacy', 'area': 'Airoli'},
    {'name': 'HealthPlus Chemists', 'area': 'Vashi'},
    {'name': 'GreenLeaf Medical', 'area': 'Vashi'},
    {'name': 'Nerul Medicals', 'area': 'Nerul'},
  ];

  final List<Map<String, dynamic>> _history = [];

  void _sendBroadcast() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _history.insert(0, {
        'text': text,
        'time': DateTime.now(),
        'count': _contacts.length,
      });
      _messageController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Broadcast sent to ${_contacts.length} contacts')),
    );
  }

  Widget _buildBroadcastTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF042C53),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Contacts',
                    style: TextStyle(color: Color(0xFF85B7EB), fontSize: 12)),
                Text('${_contacts.length}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Compose Broadcast',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Type your message in English or Marathi...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _sendBroadcast,
            icon: const Icon(Icons.send),
            label: const Text('Send to All Contacts'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF042C53),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsTab() {
    final areas = _contacts.map((c) => c['area']!).toSet().toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: areas.map((area) {
        final areaContacts =
            _contacts.where((c) => c['area'] == area).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(area,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF042C53))),
            ),
            ...areaContacts.map((contact) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF042C53),
                      child: Text(contact['name']![0],
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(contact['name']!),
                    subtitle: Text(contact['area']!),
                  ),
                )),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHistoryTab() {
    if (_history.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No broadcasts sent yet',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final msg = _history[index];
        final time = msg['time'] as DateTime;
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF042C53),
              child: Icon(Icons.campaign, color: Colors.white),
            ),
            title: Text(msg['text'],
                maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(
                'Sent to ${msg['count']} contacts · ${time.hour}:${time.minute.toString().padLeft(2, '0')}'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF042C53),
        title: const Text('VijayReach',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildBroadcastTab(),
          _buildContactsTab(),
          _buildHistoryTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE6F1FB),
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign, color: Color(0xFF042C53)),
            label: 'Broadcast',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: Color(0xFF042C53)),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history, color: Color(0xFF042C53)),
            label: 'History',
          ),
        ],
      ),
    );
  }
}