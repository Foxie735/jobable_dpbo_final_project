import 'package:flutter/material.dart';
import 'package:jobable_dpbo_final_project/Components/colors.dart';
import 'package:jobable_dpbo_final_project/Components/textfield.dart';
import 'package:jobable_dpbo_final_project/Views/jobpage.dart';
import '../SQLite/database_helper.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final db = DatabaseHelper();

  String? _selectedDisability;
  final List<String> _disabilityOptions = [
    'Physical Disability',
    'Intellectual Disability',
    'Mental Disability',
    'Sensory Disability',
    'Autism Spectrum Disorder',
  ];

  void _addJob() async {
    if (_formKey.currentState!.validate()) {
      await db.insertJob({
        'name': _nameController.text,
        'position': _positionController.text,
        'disability': _selectedDisability,
        'company': _companyController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
      });

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Job")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                InputField(
                  hint: "Job Name",
                  icon: Icons.work,
                  controller: _nameController,
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 20),
                InputField(
                  hint: "Position",
                  icon: Icons.supervisor_account,
                  controller: _positionController,
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 20),
                InputField(
                  hint: "Company",
                  icon: Icons.corporate_fare,
                  controller: _companyController,
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 20),
                InputField(
                  hint: "Location",
                  icon: Icons.location_on,
                  controller: _locationController,
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 20),
                InputField(
                  hint: "Description",
                  icon: Icons.description,
                  controller: _descriptionController,
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 50),
                DropdownButtonFormField<String>(
                  value: _selectedDisability,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Select Disability Type",
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                  ),
                  items: _disabilityOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDisability = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a disability type'
                      : null,
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(
                      color: primaryColor,
                    ),
                    backgroundColor: Colors.white,
                    minimumSize: const Size(
                      double.infinity,
                      50,
                    ),
                  ),
                  onPressed: _addJob,
                  child: const Text(
                    'Add Job',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set this to 1 since this is the "Add Job" screen
        onTap: (index) {
          if (index == 0) {
            // Navigate to homepage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const JobApplicationApp()),
            );
          } else if (index == 1) {
            // Stay on Add Job screen
            // Alternatively, you can close the current screen if desired
          }
        },
        selectedItemColor: const Color(0xFFD68631),
        unselectedItemColor: Colors.grey[300],
        backgroundColor: const Color(0xFF10465E),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Add Job",
          ),
        ],
      ),
    );
  }
}
