import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() =>
      _AddMedicineScreenState();
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

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveMedicine() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter medicine name.'),
        ),
      );
      return;
    }

    if (_dosageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter dosage.'),
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select medicine time.'),
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start date.'),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('medicines')
          .add({
        'name': _nameController.text.trim(),
        'dosage': _dosageController.text.trim(),
        'type': _selectedType,
        'time': _selectedTime!.format(context),
        'startDate': Timestamp.fromDate(_selectedDate!),
        'createdAt': Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicine saved successfully!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
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
        title: const Text('Add Medicine'),
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
                    borderRadius: BorderRadius.circular(14),
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
                    borderRadius: BorderRadius.circular(14),
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                items: _medicineTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),

                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedType = newValue;
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

                borderRadius: BorderRadius.circular(14),

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),

                    borderRadius: BorderRadius.circular(14),
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
                            : _selectedTime!.format(context),
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

                borderRadius: BorderRadius.circular(14),

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),

                    borderRadius: BorderRadius.circular(14),
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
                  onPressed: _saveMedicine,

                  icon: const Icon(
                    Icons.save_outlined,
                  ),

                  label: const Text(
                    'Save Medicine',
                    style: TextStyle(
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