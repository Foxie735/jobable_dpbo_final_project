import 'package:flutter/material.dart';
import 'package:jobable_dpbo_final_project/SQLite/database_helper.dart';
import 'package:jobable_dpbo_final_project/Views/add_job.dart';
import 'package:jobable_dpbo_final_project/Views/job_detail.dart';
import 'package:jobable_dpbo_final_project/JSON/users.dart';

class JobApplicationApp extends StatefulWidget {
  final Users? profile;
  const JobApplicationApp({super.key, this.profile});

  @override
  State<JobApplicationApp> createState() => _JobApplicationAppState();
}

class _JobApplicationAppState extends State<JobApplicationApp> {
  final db = DatabaseHelper();
  List<Map<String, dynamic>> _jobs = [];
  int _totalJobsApplied = 0;

  void _fetchJobs() async {
    final jobs = await db.getJobs();
    final totalApplied =
        await db.getTotalJobsApplied(widget.profile?.usrId ?? 0);
    setState(() {
      _jobs = jobs;
      _totalJobsApplied = totalApplied;
    });
  }

  void _fetchTotalJobsApplied() async {
    final totalApplied =
        await db.getTotalJobsApplied(widget.profile?.usrId ?? 0);
    setState(() {
      _totalJobsApplied = totalApplied;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchJobs();
    _fetchTotalJobsApplied();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFAFBFC2),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Cari Pekerjaan",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF10465E),
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, ${widget.profile?.fullName ?? 'User'}!",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: const TextSpan(
                              text: "Ada yang bisa dibantu? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: "Hubungi Customer Service",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Total Job Applied: $_totalJobsApplied",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Yuk cari kerja!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Rekomendasi Pekerjaan",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // List of jobs
                ListView.builder(
                  itemCount: _jobs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final job = _jobs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for the box
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // Shadow direction
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(
                              16.0), // Padding inside the box
                          title: Text(
                            job['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                              "Position: ${job['position']}\nLocation: ${job['location']}"),
                          trailing: Text(
                            job['company'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetailPage(
                                  job: job,
                                  userId: widget.profile?.usrId ??
                                      0, // Tambahkan argumen userId
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) {
              // Navigate to homepage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      JobApplicationApp(profile: widget.profile),
                ),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddJobScreen()),
              ).then((result) {
                if (result == true) {
                  _fetchJobs();
                }
              });
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
      ),
    );
  }
}
