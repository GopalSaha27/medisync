import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMedicineScreen extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> medicineData;

  const EditMedicineScreen({
    super.key,
    required this.documentId,
    required this.medicineData,
  });

  @override
  State<EditMedicineScreen> createState() =>
      _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dosageController;

  late String _selectedType;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  final List<String> _medicineTypes = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drops',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.medicineData['name'] ?? '',
    );

    _dosageController = TextEditingController(
      text: widget.medicineData['dosage'] ?? '',
    );

    _selectedType =
        widget.medicineData['type'] ?? 'Tablet';

    final String savedTime =
        widget.medicineData['time'] ?? '';

    if (savedTime.isNotEmpty) {
      _selectedTime = _parseTime(savedTime);
    }

    final Timestamp? savedDate =
        widget.medicineData['startDate'];

    if (savedDate != null) {
      _selectedDate = savedDate.toDate();
    }
  }

  TimeOfDay? _parseTime(String time) {
    try {
      final parts = time.split(' ');
      final timePart = parts[0];
      final period = parts[1].toUpperCase();

      final numbers = timePart.split(':');

      int hour = int.parse(numbers[0]);
      final int minute = int.parse(numbers[1]);

      if (period == 'PM' && hour != 12) {
        hour += 12;
      }

      if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(
        hour: hour,
        minute: minute,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime =
        await showTimePicker(
      context: context,
      initialTime:
          _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _updateMedicine() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter medicine name.',
          ),
        ),
      );
      return;
    }

    if (_dosageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter dosage.',
          ),
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select medicine time.',
          ),
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select start date.',
          ),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('medicines')
          .doc(widget.documentId)
          .update({
        'name': _nameController.text.trim(),
        'dosage': _dosageController.text.trim(),
        'type': _selectedType,
        'time': _selectedTime!.format(context),
        'startDate':
            Timestamp.fromDate(_selectedDate!),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Medicine updated successfully!',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update medicine: $e',
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
        title: const Text('Edit Medicine'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                'Edit Medicine',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Update your medicine information.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

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

                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Medicine Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              InkWell(
                onTap: _selectTime,

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),

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

              const Text(
                'Start Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              InkWell(
                onTap: _selectDate,

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),

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

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed: _updateMedicine,

                  icon: const Icon(
                    Icons.update,
                  ),

                  label: const Text(
                    'Update Medicine',
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
      ),
    );
  }
}