import 'package:flutter/material.dart';

void main() {
  runApp(const MediSyncApp());
}

class MediSyncApp extends StatelessWidget {
  const MediSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediSync',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MediSync',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Greeting
            const Text(
              'Good Morning 👋',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Stay on track with your medication.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            // Progress Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.teal.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Today's Progress",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      SizedBox(
                        height: 75,
                        width: 75,
                        child: CircularProgressIndicator(
                          value: 0.8,
                          strokeWidth: 8,
                          backgroundColor: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 20),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '80%',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '4 of 5 doses completed',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Section title
            const Text(
              "Today's Medication",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // Medicine Card 1
            _MedicineCard(
              medicineName: 'Paracetamol',
              dosage: '1 Tablet',
              time: '08:00 AM',
              status: 'Taken',
              icon: Icons.medication,
            ),

            const SizedBox(height: 12),

            // Medicine Card 2
            _MedicineCard(
              medicineName: 'Vitamin D',
              dosage: '1 Capsule',
              time: '02:00 PM',
              status: 'Upcoming',
              icon: Icons.medication_outlined,
            ),

            const SizedBox(height: 12),

            // Medicine Card 3
            _MedicineCard(
              medicineName: 'Medicine C',
              dosage: '1 Tablet',
              time: '10:00 PM',
              status: 'Upcoming',
              icon: Icons.medication_outlined,
            ),

            const SizedBox(height: 25),

            // Add Medicine Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add Medicine',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication),
            label: 'Medicines',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final String medicineName;
  final String dosage;
  final String time;
  final String status;
  final IconData icon;

  const _MedicineCard({
    required this.medicineName,
    required this.dosage,
    required this.time,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool taken = status == 'Taken';

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [

            CircleAvatar(
              radius: 25,
              child: Icon(icon),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    medicineName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text('$dosage • $time'),
                ],
              ),
            ),

            Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: taken ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}