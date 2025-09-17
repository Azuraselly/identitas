import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/student.dart';

class StudentProvider extends ChangeNotifier {
  List<Student> _students = [];
  Map<String, List<Guardian>> _guardians = {}; // Simpan guardians per student
  bool _isLoading = false;
  String? _error;

  List<Student> get students => List.unmodifiable(_students);
  bool get isLoading => _isLoading;
  String? get error => _error;

  final _uuid = const Uuid();
  final supabase = Supabase.instance.client;

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }

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

      // Ambil data students
      final studentResponse = await supabase.from('students').select();
      _students = (studentResponse as List)
          .map((json) => Student.fromJson(json as Map<String, dynamic>))
          .toList();

      // Ambil data guardians
      final guardianResponse = await supabase.from('guardians').select();
      _guardians = {};
      for (var g in guardianResponse) {
        final guardian = Guardian.fromJson(g as Map<String, dynamic>);
        if (!_guardians.containsKey(guardian.studentId)) {
          _guardians[guardian.studentId] = [];
        }
        _guardians[guardian.studentId]!.add(guardian);
      }
    } on PostgrestException catch (e) {
      _error = 'Masalah koneksi Supabase: ${e.message}';
    } catch (e) {
      _error = 'Error loading data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createStudent(Student s, List<Guardian> guardians) async {
    if (!await _checkConnectivity()) {
      _error = 'Tidak ada koneksi internet.';
      notifyListeners();
      return;
    }

    try {
      final json = s.toJson();
      if (json['id'] == null || (json['id'] as String).isEmpty) {
        json['id'] = _uuid.v4();
      }
      // Insert ke tabel students
      await supabase.from('students').insert(json);

      // Insert ke tabel guardians
      for (var g in guardians) {
        final guardianJson = g.toJson();
        guardianJson['id'] = _uuid.v4();
        guardianJson['student_id'] = json['id'];
        await supabase.from('guardians').insert(guardianJson);
      }

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

  Future<void> addNewFromForm({
    required String nisn,
    required String nama,
    required String jenisKelamin,
    required String agama,
    required String tempatLahir,
    required DateTime tanggalLahir,
    required String noTelp,
    required String nik,
    required String jalan,
    required String rt,
    required String rw,
    required String dusun,
    required String desa,
    required String kecamatan,
    required String kabupaten,
    required String provinsi,
    required String kodePos,
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
      jalan: jalan,
      rt: rt,
      rw: rw,
      dusun: dusun,
      desa: desa,
      kecamatan: kecamatan,
      kabupaten: kabupaten,
      provinsi: provinsi,
      kodePos: kodePos,
    );
    await createStudent(student, guardians);
  }

  Future<void> updateStudent(String id, Student newStudent, List<Guardian> guardians) async {
    if (!await _checkConnectivity()) {
      _error = 'Tidak ada koneksi internet.';
      notifyListeners();
      return;
    }

    try {
      final json = newStudent.toJson();
      // Update tabel students
      await supabase.from('students').update(json).eq('id', id);

      // Hapus guardians lama dan tambahkan yang baru
      await supabase.from('guardians').delete().eq('student_id', id);
      for (var g in guardians) {
        final guardianJson = g.toJson();
        guardianJson['id'] = _uuid.v4();
        guardianJson['student_id'] = id;
        await supabase.from('guardians').insert(guardianJson);
      }

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

  Future<void> deleteStudent(String id) async {
    if (!await _checkConnectivity()) {
      _error = 'Tidak ada koneksi internet.';
      notifyListeners();
      return;
    }

    try {
      // Hapus dari students (guardians otomatis terhapus karena ON DELETE CASCADE)
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

  Student? getById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Guardian> getGuardiansByStudentId(String studentId) {
    return _guardians[studentId] ?? [];
  }
}