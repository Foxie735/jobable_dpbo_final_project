import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../JSON/users.dart';

class DatabaseHelper {
  final databaseName = "auth.db";

  // Tables
  String user = '''
   CREATE TABLE users (
   usrId INTEGER PRIMARY KEY AUTOINCREMENT,
   fullName TEXT,
   email TEXT,
   usrName TEXT UNIQUE,
   usrPassword TEXT
   )
   ''';

  String job = '''
   CREATE TABLE jobs (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     name TEXT,
     position TEXT,
     disability TEXT,
     company TEXT,
     location TEXT,
     description TEXT
   )
   ''';

  String appliedJobs = '''
   CREATE TABLE applied_jobs (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     usrId INTEGER,
     jobId INTEGER,
     FOREIGN KEY (usrId) REFERENCES users(usrId),
     FOREIGN KEY (jobId) REFERENCES jobs(id)
   )
   ''';

  // Our connection is ready
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: 3, // Tingkatkan versi database
      onCreate: (db, version) async {
        await db.execute(user);
        await db.execute(job);
        await db.execute(appliedJobs);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute(appliedJobs); // Tambahkan tabel baru
        }
      },
    );
  }

  // Function methods for users

  // Authentication
  Future<bool> authenticate(Users usr) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from users where usrName = '${usr.usrName}' AND usrPassword = '${usr.password}' ");
    return result.isNotEmpty;
  }

  // Sign up
  Future<int> createUser(Users usr) async {
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
  }

  // Get current User details
  Future<Users?> getUser(String usrName, String password) async {
    final Database db = await initDB();
    var result = await db.query(
      "users",
      where: "usrName = ? AND usrPassword = ?",
      whereArgs: [usrName, password],
    );

    if (result.isNotEmpty) {
      return Users.fromMap(result.first); // Return the user details
    }
    return null;
  }

  // Function methods for jobs

  // Insert a job into the jobs table
  Future<void> insertJob(Map<String, dynamic> job) async {
    final Database db = await initDB();
    await db.insert('jobs', job, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all jobs from the jobs table
  Future<List<Map<String, dynamic>>> getJobs() async {
    final Database db = await initDB();
    return db.query('jobs');
  }

  Future<bool> isJobApplied(int usrId, int jobId) async {
    final Database db = await initDB();
    var result = await db.query(
      'applied_jobs',
      where: 'usrId = ? AND jobId = ?',
      whereArgs: [usrId, jobId],
    );
    return result.isNotEmpty;
  }

// Tambahkan pekerjaan yang dilamar ke tabel applied_jobs
  Future<void> applyJob(int usrId, int jobId) async {
    final Database db = await initDB();
    await db.insert(
      'applied_jobs',
      {'usrId': usrId, 'jobId': jobId},
      conflictAlgorithm: ConflictAlgorithm.ignore, // Hindari duplikasi
    );
  }

// Hitung total pekerjaan yang sudah dilamar oleh user
  Future<int> getTotalJobsApplied(int usrId) async {
    final Database db = await initDB();
    var result = await db.query(
      'applied_jobs',
      where: 'usrId = ?',
      whereArgs: [usrId],
    );
    return result
        .length; // This is the total count of applied jobs for this user
  }

  Future<void> clearAllTables() async {
    final Database db = await initDB();

    // Delete all records from the users table
    await db.delete('users');

    // Delete all records from the jobs table
    await db.delete('jobs');
  }
}
