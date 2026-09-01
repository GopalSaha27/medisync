import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/notification_service.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _dosageController =
      TextEditingController();

  String _selectedType = 'Tablet';

  final List<String> _medicineTypes = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drops',
    'Other',
  ];

  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  bool _isSaving = false;

  // Select medicine time.
  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  // Select medicine start date.
  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Save medicine to Firestore and schedule a reminder.
  Future<void> _saveMedicine() async {
    // Validate medicine name.
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter medicine name.'),
        ),
      );
      return;
    }

    // Validate dosage.
    if (_dosageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter dosage.'),
        ),
      );
      return;
    }

    // Validate medicine time.
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select medicine time.'),
        ),
      );
      return;
    }

    // Validate start date.
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start date.'),
        ),
      );
      return;
    }

    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final String medicineName =
          _nameController.text.trim();

      final String dosage =
          _dosageController.text.trim();

      final TimeOfDay selectedTime =
          _selectedTime!;

      final DateTime selectedDate =
          _selectedDate!;

      // Save medicine to Firestore.
      final DocumentReference medicineRef =
          await FirebaseFirestore.instance
              .collection('medicines')
              .add({
        'name': medicineName,
        'dosage': dosage,
        'type': _selectedType,
        'time': selectedTime.format(context),
        'startDate': Timestamp.fromDate(selectedDate),
        'createdAt': Timestamp.now(),
      });

      // Schedule notification.
      // The notification service automatically skips this
      // on Web because scheduled local notifications are
      // not supported on Chrome.
      try {
        await NotificationService.scheduleMedicineReminder(
          id: medicineRef.id.hashCode.abs(),
          medicineName: medicineName,
          dosage: dosage,
          hour: selectedTime.hour,
          minute: selectedTime.minute,
        );
      } catch (notificationError) {
        // Medicine is already saved in Firestore.
        // Notification failure should not delete the medicine.
        debugPrint(
          'Notification scheduling failed: $notificationError',
        );
      }

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Medicine saved successfully!',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save medicine: $e',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Medicine',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Medicine Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Enter your medicine information below.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

              // Medicine name.
              const Text(
                'Medicine Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _nameController,

                decoration: InputDecoration(
                  hintText: 'Example: Napa',

                  prefixIcon: const Icon(
                    Icons.medication_outlined,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Dosage.
              const Text(
                'Dosage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _dosageController,

                decoration: InputDecoration(
                  hintText: 'Example: 500 mg',

                  prefixIcon: const Icon(
                    Icons.medical_services_outlined,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Medicine type.
              const Text(
                'Medicine Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: _selectedType,

                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),

                items: _medicineTypes.map(
                  (String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  },
                ).toList(),

                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // Medicine time.
              const Text(
                'Medicine Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              InkWell(
                onTap: _selectTime,

                borderRadius:
                    BorderRadius.circular(14),

                child: Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),

                    borderRadius:
                        BorderRadius.circular(14),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                      ),

                      const SizedBox(width: 12),

                      Text(
                        _selectedTime == null
                            ? 'Select medicine time'
                            : _selectedTime!
                                .format(context),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Start date.
              const Text(
                'Start Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              InkWell(
                onTap: _selectDate,

                borderRadius:
                    BorderRadius.circular(14),

                child: Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),

                    borderRadius:
                        BorderRadius.circular(14),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                      ),

                      const SizedBox(width: 12),

                      Text(
                        _selectedDate == null
                            ? 'Select start date'
                            : '${_selectedDate!.day}/'
                              '${_selectedDate!.month}/'
                              '${_selectedDate!.year}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // Save button.
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed:
                      _isSaving ? null : _saveMedicine,

                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.save_outlined,
                        ),

                  label: Text(
                    _isSaving
                        ? 'Saving...'
                        : 'Save Medicine',

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}