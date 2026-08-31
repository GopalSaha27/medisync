import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_medicine_screen.dart';

class MyMedicinesScreen extends StatelessWidget {
  const MyMedicinesScreen({super.key});

  Future<void> _markMedicineAsTaken(
    BuildContext context,
    String documentId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('medicines')
          .doc(documentId)
          .update({
        'isTaken': true,
        'takenAt': Timestamp.now(),
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicine marked as taken!'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update medicine: $e'),
        ),
      );
    }
  }

  Future<void> _deleteMedicine(
    BuildContext context,
    String documentId,
    String medicineName,
  ) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Medicine'),
          content: Text(
            'Are you sure you want to delete $medicineName?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
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

    if (confirmDelete != true) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('medicines')
          .doc(documentId)
          .delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicine deleted successfully!'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete medicine: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medicines'),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('medicines')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong!\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication_outlined,
                    size: 70,
                    color: Colors.teal,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No medicines added yet!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add your first medicine from the Home Screen.',
                  ),
                ],
              ),
            );
          }

          final medicines = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: medicines.length,

            itemBuilder: (context, index) {
              final medicine = medicines[index];

              final data =
                  medicine.data() as Map<String, dynamic>;

              final String name =
                  data['name'] ?? 'Unknown';

              final String dosage =
                  data['dosage'] ?? '';

              final String type =
                  data['type'] ?? '';

              final String time =
                  data['time'] ?? '';

              final bool isTaken =
                  data['isTaken'] ?? false;

              final Timestamp? startDate =
                  data['startDate'];

              String formattedDate = '';

              if (startDate != null) {
                final DateTime date =
                    startDate.toDate();

                formattedDate =
                    '${date.day}/${date.month}/${date.year}';
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 15),

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(10),

                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),

                            child: const Icon(
                              Icons.medication,
                              color: Colors.teal,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditMedicineScreen(
                                    documentId: medicine.id,
                                    medicineData: data,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                            tooltip: 'Edit Medicine',
                          ),

                          IconButton(
                            onPressed: () {
                              _deleteMedicine(
                                context,
                                medicine.id,
                                name,
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            tooltip: 'Delete Medicine',
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(
                            Icons.medical_services_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('Dosage: $dosage'),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.category_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('Type: $type'),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('Time: $time'),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Start Date: $formattedDate',
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isTaken
                              ? null
                              : () {
                                  _markMedicineAsTaken(
                                    context,
                                    medicine.id,
                                  );
                                },
                          icon: Icon(
                            isTaken
                                ? Icons.check_circle
                                : Icons.check,
                          ),
                          label: Text(
                            isTaken
                                ? 'Medicine Taken'
                                : 'Mark as Taken',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}