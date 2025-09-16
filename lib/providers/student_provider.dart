import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';

class StudentProvider extends ChangeNotifier {
  final List<Student> _students = [];

  List<Student> get students => List.unmodifiable(_students);

  final _uuid = const Uuid();

  void createStudent(Student s) {
    _students.insert(0, s);
    notifyListeners();
  }

  void addNewFromForm({
    required String nisn,
    required String nama,
    required String jenisKelamin,
    required String agama,
    required String tempatLahir,
    required DateTime tanggalLahir,
    required String noTelp,
    required String nik,
    required Address alamat,
    required List<Guardian> guardians,
  }) {
    final student = Student(
      id: _uuid.v4(),
      nisn: nisn,
      nama: nama,
      jenisKelamin: jenisKelamin,
      agama: agama,
      tempatLahir: tempatLahir,
      tanggalLahir: tanggalLahir,
      noTelp: noTelp,
      nik: nik,
      alamat: alamat,
      guardians: guardians,
    );
    createStudent(student);
  }

  void updateStudent(String id, Student newStudent) {
    final idx = _students.indexWhere((s) => s.id == id);
    if (idx != -1) {
      _students[idx] = newStudent;
      notifyListeners();
    }
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  Student? getById(String id) => _students.firstWhere((s) => s.id == id, orElse: () => null as Student);
}
