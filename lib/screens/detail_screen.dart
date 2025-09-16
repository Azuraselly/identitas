import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../utils/styles.dart';
import 'form_screen.dart';

class DetailScreen extends StatelessWidget {
  final Student student;
  const DetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.teal.withOpacity(0.2)),
          ),
        ),
        title: Text(
          student.nama,
          style: Styles.header.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            tooltip: "Edit Data",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => FormScreen(editing: student)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever_rounded, color: Colors.white),
            tooltip: "Hapus Data",
            onPressed: () {
              _showDeleteDialog(context, provider);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)], // soft elegan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // --- Profile Card ---
              Card(
                elevation: 8,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Hero(
                        tag: "avatar_${student.id}",
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.teal[50],
                          child: Icon(Icons.person, size: 60, color: Colors.teal[700]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(student.nama,
                          style: Styles.header.copyWith(
                              fontSize: 24,
                              color: Colors.teal[900],
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text("NISN: ${student.nisn}",
                          style: Styles.sub.copyWith(color: Colors.grey[700])),
                      const Divider(height: 30, thickness: 1),
                      _infoRow(Icons.wc, "Jenis Kelamin", student.jenisKelamin),
                      _infoRow(Icons.star_rounded, "Agama", student.agama),
                      _infoRow(Icons.cake_rounded, "TTL",
                          "${student.tempatLahir}, ${student.tanggalLahir.day}/${student.tanggalLahir.month}/${student.tanggalLahir.year}"),
                      _infoRow(Icons.phone_rounded, "No Telp", student.noTelp),
                      _infoRow(Icons.badge_rounded, "NIK", student.nik),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Alamat Card ---
              Card(
                elevation: 6,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Alamat",
                          style: Styles.header.copyWith(
                              fontSize: 20,
                              color: Colors.teal[800],
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      _infoRow(Icons.home_rounded, "Jalan", student.alamat.jalan),
                      _infoRow(Icons.location_on_rounded, "RT/RW",
                          "${student.alamat.rt}/${student.alamat.rw}"),
                      _infoRow(Icons.apartment_rounded, "Dusun", student.alamat.dusun),
                      _infoRow(Icons.villa_rounded, "Desa", student.alamat.desa),
                      _infoRow(Icons.map_rounded, "Kecamatan", student.alamat.kecamatan),
                      _infoRow(Icons.location_city_rounded, "Kabupaten", student.alamat.kabupaten),
                      _infoRow(Icons.public_rounded, "Provinsi", student.alamat.provinsi),
                      _infoRow(Icons.markunread_mailbox_rounded, "Kode Pos", student.alamat.kodePos),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Orang Tua / Wali ---
              Text("Orang Tua / Wali",
                  style: Styles.header.copyWith(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              ...student.guardians.map((g) => Card(
                    elevation: 5,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal[50],
                        child: Icon(
                          g.relation.toLowerCase().contains("ayah")
                              ? Icons.man_rounded
                              : g.relation.toLowerCase().contains("ibu")
                                  ? Icons.woman_rounded
                                  : Icons.group_rounded,
                          color: Colors.teal[700],
                        ),
                      ),
                      title: Text(g.name,
                          style: Styles.sub.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.teal[900])),
                      subtitle: Text("${g.relation}\n${g.address}",
                          style: Styles.sub.copyWith(color: Colors.grey[700])),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.teal[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Text("$label: $value",
                style: Styles.sub.copyWith(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, StudentProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 80, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text(
                'Hapus Data?',
                style: Styles.header.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
              const SizedBox(height: 8),
              const Text(
                'Data siswa ini akan dihapus permanen.\nApakah Anda yakin?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Batal"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        provider.deleteStudent(student.id);
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: const Text("Hapus"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
