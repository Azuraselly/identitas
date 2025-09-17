import 'package:flutter/material.dart';
import '../models/student.dart';
import '../screens/detail_screen.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({super.key, required this.student});

  String _getInitials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "student_${student.id}",
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => DetailScreen(student: student)),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.06),
                Colors.teal.withOpacity(0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1.2,
              color: Colors.blue.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar bulat
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.teal.withOpacity(0.15),
                    child: Text(
                      _getInitials(student.nama),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Info murid
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama
                        Row(
                          children: [
                            const Icon(Icons.school,
                                size: 18, color: Colors.teal),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                student.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // NISN
                        Row(
                          children: [
                            const Icon(Icons.badge_outlined,
                                size: 16, color: Colors.blueGrey),
                            const SizedBox(width: 6),
                            Text(
                              "NISN: ${student.nisn}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Jenis kelamin + agama
                        Row(
                          children: [
                            Icon(
                              student.jenisKelamin.toLowerCase() == "laki-laki"
                                  ? Icons.male
                                  : Icons.female,
                              size: 16,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${student.jenisKelamin} • ${student.agama}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Ikon navigasi
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 26,
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}