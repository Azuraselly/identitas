import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Tambahkan dependency ini di pubspec.yaml
import '../models/student.dart';

class StudentProvider extends ChangeNotifier {
  List<Student> _students = [];
  bool _isLoading = false;
  String? _error;

  List<Student> get students => List.unmodifiable(_students);
  bool get isLoading => _isLoading;
  String? get error => _error;

  final _uuid = const Uuid();
  final supabase = Supabase.instance.client;

  // 🔹 Fungsi untuk memeriksa koneksi internet sebelum operasi Supabase.
  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }

  // 🔹 Load data dari Supabase dengan error handling untuk koneksi internet dan Supabase.
  Future<void> loadData() async {
    if (!await _checkConnectivity()) {
      _error = 'Tidak ada koneksi internet.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await supabase.from('students').select();
      _students = (response as List)
          .map((json) => Student.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      _error = 'Masalah koneksi Supabase: ${e.message}';
    } catch (e) {
      _error = 'Error loading data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Create student ke Supabase dengan connectivity check.
  Future<void> createStudent(Student s) async {
    if (!await _checkConnectivity()) {
      _error = 'Tidak ada koneksi internet.';
      notifyListeners();
      return;
    }

    try {
      final json = s.toJson();
      if (json['id'] == null || (json['id'] as String).isEmpty) {
        json['id'] = _uuid.v4(); // generate UUID kalau kosong
      }
      await supabase.from('students').insert(json);
      await loadData();
    } on PostgrestException catch (e) {
      _error = 'Masalah koneksi Supabase: ${e.message}';
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = 'Error creating student: $e';
      notifyListeners();
      rethrow;
    }
  }

  // 🔹 Tambah dari form
  Future<void> addNewFromForm({
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
  }) async {
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
    await createStudent(student);
  }

  // 🔹 Update student dengan connectivity check.
  Future<void> updateStudent(String id, Student newStudent) async {
    if (!await _checkConnectivity()) {
      _error = 'Tidak ada koneksi internet.';
      notifyListeners();
      return;
    }

    try {
      final json = newStudent.toJson();
      await supabase.from('students').update(json).eq('id', id);
      await loadData();
    } on PostgrestException catch (e) {
      _error = 'Masalah koneksi Supabase: ${e.message}';
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = 'Error updating student: $e';
      notifyListeners();
      rethrow;
    }
  }

  // 🔹 Delete student dengan connectivity check.
  Future<void> deleteStudent(String id) async {
    if (!await _checkConnectivity()) {
      _error = 'Tidak ada koneksi internet.';
      notifyListeners();
      return;
    }

    try {
      await supabase.from('students').delete().eq('id', id);
      await loadData();
    } on PostgrestException catch (e) {
      _error = 'Masalah koneksi Supabase: ${e.message}';
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = 'Error deleting student: $e';
      notifyListeners();
      rethrow;
    }
  }

  // 🔹 Get by ID
  Student? getById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}