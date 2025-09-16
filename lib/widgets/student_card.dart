import 'package:flutter/material.dart';
import '../models/student.dart';
import '../screens/detail_screen.dart';
import '../utils/styles.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // buka halaman detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => DetailScreen(student: student),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.teal[100],
                child: const Icon(Icons.person, size: 32, color: Colors.teal),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.nama,
                      style: Styles.header.copyWith(
                        fontSize: 18,
                        color: Colors.teal[900],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "NISN: ${student.nisn}",
                      style: Styles.sub.copyWith(color: Colors.grey[700]),
                    ),
                    Text(
                      "JK: ${student.jenisKelamin} | ${student.agama}",
                      style: Styles.sub.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
