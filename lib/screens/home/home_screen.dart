import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../medicine/add_medicine_screen.dart';
import '../medicine/my_medicines_screen.dart';
import '../reminder/reminders_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // AppBar
      appBar: AppBar(
        title: const Text(
          'MediSync',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        // Keep the title on the left side
        centerTitle: false,

        // AppBar action buttons
        actions: [
          IconButton(
            onPressed: () {
              // Notification feature will be added later
            },
            icon: const Icon(
              Icons.notifications_none,
            ),
          ),
        ],
      ),

      // Main screen body
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),

              // Greeting text
              const Text(
                'Hello 👋',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 5),

              // Welcome text
              const Text(
                'Welcome to MediSync',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Short description
              Text(
                'Stay on track with your medications.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

              // Today's Schedule section
              _buildTodaySchedule(context),

              const SizedBox(height: 30),

              // Quick Actions title
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // First row of action cards
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.medication_outlined,
                      title: 'My Medicines',

                      // Open My Medicines screen
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MyMedicinesScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.history,
                      title: 'History',

                      // History screen will be added later
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Second row of action cards
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.notifications_active_outlined,
                      title: 'Reminders',

                      // Open Reminders screen
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const RemindersScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.person_outline,
                      title: 'Profile',

                      // Profile screen will be added later
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the Today's Schedule section
  Widget _buildTodaySchedule(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Section title
          const Text(
            'Today\'s Schedule',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // Load medicines from Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('medicines')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),

            builder: (context, snapshot) {
              // Show loading indicator while data is loading
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              }

              // Show error message if Firestore returns an error
              if (snapshot.hasError) {
                return const Text(
                  'Unable to load medicines.',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                );
              }

              // Show message when there are no medicines
              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const Text(
                  'No medicines scheduled yet',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                );
              }

              // Get all medicine documents
              final medicines = snapshot.data!.docs;

              // Get today's date
              final today = DateTime.now();

              // Filter medicines scheduled for today
              final todayMedicines =
                  medicines.where((medicine) {
                final data =
                    medicine.data()
                        as Map<String, dynamic>;

                // Get medicine start date
                final Timestamp? startDate =
                    data['startDate'];

                // Ignore medicines without a start date
                if (startDate == null) {
                  return false;
                }

                // Convert Firestore Timestamp to DateTime
                final date = startDate.toDate();

                // Check whether the date is today
                return date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
              }).toList();

              // Show message when no medicine is scheduled today
              if (todayMedicines.isEmpty) {
                return const Text(
                  'No medicines scheduled for today.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                );
              }

              // Display today's medicines
              return Column(
                children: [
                  ...todayMedicines.map((medicine) {
                    // Get medicine data
                    final data =
                        medicine.data()
                            as Map<String, dynamic>;

                    // Get medicine name
                    final String name =
                        data['name'] ?? 'Unknown';

                    // Get medicine dosage
                    final String dosage =
                        data['dosage'] ?? '';

                    // Get medicine time
                    final String time =
                        data['time'] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),

                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: Row(
                        children: [
                          // Medicine icon container
                          Container(
                            padding:
                                const EdgeInsets.all(8),

                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),

                            child: const Icon(
                              Icons.medication,
                              color: Colors.teal,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Medicine name and dosage
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [
                                Text(
                                  name,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  dosage,
                                  style: TextStyle(
                                    color:
                                        Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Medicine time
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,

                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.teal,
                              ),

                              const SizedBox(height: 3),

                              Text(
                                time,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),

          const SizedBox(height: 10),

          // Add Medicine button
          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: () {
                // Open Add Medicine screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddMedicineScreen(),
                  ),
                );
              },

              icon: const Icon(
                Icons.add,
              ),

              label: const Text(
                'Add Medicine',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build reusable Quick Action Card
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      // Handle card tap
      onTap: onTap,

      // Make the tap effect rounded
      borderRadius: BorderRadius.circular(18),

      child: Container(
        height: 130,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          // Add a soft shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          // Center the icon and title vertically
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            // Action card icon
            Icon(
              icon,
              size: 35,
              color: Colors.teal,
            ),

            const SizedBox(height: 12),

            // Action card title
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}