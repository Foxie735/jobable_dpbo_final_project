import 'package:flutter/material.dart';
import 'package:jobable_dpbo_final_project/Components/colors.dart';
import 'package:jobable_dpbo_final_project/SQLite/database_helper.dart';

class JobDetailPage extends StatefulWidget {
  final Map<String, dynamic> job;
  final int userId;

  const JobDetailPage({super.key, required this.job, required this.userId});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final DatabaseHelper db = DatabaseHelper();
  bool _isApplied = false;

  void _checkIfApplied() async {
    final isApplied = await db.isJobApplied(widget.userId, widget.job['id']);
    setState(() {
      _isApplied = isApplied;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIfApplied();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.job['name'] ?? 'Job Detail')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Job Name: ${widget.job['name']}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 15),
              Text('Position: ${widget.job['position']}'),
              const SizedBox(height: 15),
              Text('Company: ${widget.job['company']}'),
              const SizedBox(height: 15),
              Text('Location: ${widget.job['location']}'),
              const SizedBox(height: 15),
              Text('Disability: ${widget.job['disability']}'),
              const SizedBox(height: 15),
              Text('Description: ${widget.job['description']}'),
              const SizedBox(height: 500),
              OutlinedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: _isApplied ? Colors.grey : primaryColor,
                  ),
                  backgroundColor: _isApplied ? Colors.grey[200] : Colors.white,
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                ),
                onPressed: () async {
                  if (!_isApplied) {
                    await db.applyJob(widget.userId, widget.job['id']);
                    setState(() {
                      _isApplied = true;
                    });

                    // Assuming you have a function to fetch the total jobs applied:

                    // Optionally update the homepage state or a parent widget
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  }
                },
                child: Text(
                  _isApplied ? 'Applied' : 'Apply Job',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
