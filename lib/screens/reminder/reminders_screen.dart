import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  // Delete a reminder from Firestore
  Future<void> _deleteReminder(
    BuildContext context,
    String documentId,
    String medicineName,
  ) async {
    // Show confirmation dialog before deleting
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Reminder'),

          content: Text(
            'Are you sure you want to delete the reminder for $medicineName?',
          ),

          actions: [
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),

            // Delete button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    // Stop if user cancelled the delete operation
    if (confirmDelete != true) {
      return;
    }

    try {
      // Delete the medicine document from Firestore
      await FirebaseFirestore.instance
          .collection('medicines')
          .doc(documentId)
          .delete();

      // Make sure the screen is still mounted
      if (!context.mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Reminder deleted successfully!',
          ),
        ),
      );
    } catch (e) {
      // Make sure the screen is still mounted
      if (!context.mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete reminder: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Screen AppBar
      appBar: AppBar(
        title: const Text(
          'Reminders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Load medicine data from Firestore
      body: StreamBuilder<QuerySnapshot>(
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
              child: CircularProgressIndicator(),
            );
          }

          // Show error if Firestore returns an error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Something went wrong!\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Show empty state when there are no medicines
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          // Get all medicine documents
          final medicines = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            // Number of reminder cards
            itemCount: medicines.length,

            itemBuilder: (context, index) {
              // Get current medicine document
              final medicine = medicines[index];

              // Convert Firestore data to Map
              final data =
                  medicine.data()
                      as Map<String, dynamic>;

              // Get medicine name
              final String name =
                  data['name'] ?? 'Unknown Medicine';

              // Get dosage
              final String dosage =
                  data['dosage'] ?? '';

              // Get medicine type
              final String type =
                  data['type'] ?? '';

              // Get medicine time
              final String time =
                  data['time'] ?? '';

              // Build reminder card
              return _buildReminderCard(
                context: context,
                documentId: medicine.id,
                medicineName: name,
                dosage: dosage,
                type: type,
                time: time,
              );
            },
          );
        },
      ),
    );
  }

  // Build the empty state UI
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(25),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            // Reminder icon
            Icon(
              Icons.notifications_none,
              size: 80,
              color: Colors.teal,
            ),

            SizedBox(height: 20),

            // Empty state title
            Text(
              'No Reminders Yet',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            // Empty state description
            Text(
              'Add a medicine to create a reminder.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a single reminder card
  Widget _buildReminderCard({
    required BuildContext context,
    required String documentId,
    required String medicineName,
    required String dosage,
    required String type,
    required String time,
  }) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 15,
      ),

      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // Medicine header
            Row(
              children: [
                // Medicine icon
                Container(
                  padding:
                      const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.teal,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 12),

                // Medicine name
                Expanded(
                  child: Text(
                    medicineName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Delete reminder button
                IconButton(
                  onPressed: () {
                    _deleteReminder(
                      context,
                      documentId,
                      medicineName,
                    );
                  },

                  icon: const Icon(
                    Icons.delete_outline,
                  ),

                  tooltip: 'Delete Reminder',
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Reminder time
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: Row(
                children: [
                  // Clock icon
                  const Icon(
                    Icons.access_time,
                    color: Colors.teal,
                    size: 28,
                  ),

                  const SizedBox(width: 12),

                  // Time text
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'Reminder Time',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        time.isEmpty
                            ? 'Time not set'
                            : time,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Dosage information
            Row(
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Text(
                  'Dosage: $dosage',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Medicine type information
            Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Text(
                  'Type: $type',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}