import 'package:flutter/material.dart';
import 'package:jobable_dpbo_final_project/Components/colors.dart';

class JobDetailPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job['name'] ?? 'Job Detail')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Job Name: ${job['name']}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 15),
              Text('Position: ${job['position']}'),
              const SizedBox(height: 15),
              Text('Company: ${job['company']}'),
              const SizedBox(height: 15),
              Text('Location: ${job['location']}'),
              const SizedBox(height: 15),
              Text('Disability: ${job['disability']}'),
              const SizedBox(height: 15),
              Text('Description: ${job['description']}'),
              const SizedBox(height: 500),
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
                onPressed: () {},
                child: const Text(
                  'Apply Job',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
