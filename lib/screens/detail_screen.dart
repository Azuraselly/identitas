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
        title: Text(student.nama,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: "Edit Data",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => FormScreen(editing: student)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            tooltip: "Hapus Data",
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
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
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF009688), Color(0xFF00796B)], // Teal gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // --- Profile Info ---
              Card(
                elevation: 6,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.teal[100],
                        child: Icon(Icons.person,
                            size: 55, color: Colors.teal[700]),
                      ),
                      const SizedBox(height: 14),
                      Text(student.nama,
                          style: Styles.header.copyWith(
                              fontSize: 22, color: Colors.teal[900])),
                      const SizedBox(height: 6),
                      Text("NISN: ${student.nisn}",
                          style: Styles.sub.copyWith(color: Colors.grey[700])),
                      const Divider(height: 28, thickness: 1),
                      _infoRow(Icons.wc, "Jenis Kelamin", student.jenisKelamin),
                      _infoRow(Icons.star, "Agama", student.agama),
                      _infoRow(Icons.cake, "TTL",
                          "${student.tempatLahir}, ${student.tanggalLahir.day}/${student.tanggalLahir.month}/${student.tanggalLahir.year}"),
                      _infoRow(Icons.phone, "No Telp", student.noTelp),
                      _infoRow(Icons.badge, "NIK", student.nik),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // --- Alamat ---
              Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Alamat",
                            style: Styles.header.copyWith(
                                fontSize: 18, color: Colors.teal[800])),
                        const SizedBox(height: 10),
                        _infoRow(Icons.home, "Jalan", student.alamat.jalan),
                        _infoRow(Icons.location_on, "RT/RW",
                            "${student.alamat.rt}/${student.alamat.rw}"),
                        _infoRow(Icons.apartment, "Dusun",
                            student.alamat.dusun),
                        _infoRow(Icons.villa, "Desa", student.alamat.desa),
                        _infoRow(Icons.map, "Kecamatan",
                            student.alamat.kecamatan),
                        _infoRow(Icons.location_city, "Kabupaten",
                            student.alamat.kabupaten),
                        _infoRow(Icons.public, "Provinsi",
                            student.alamat.provinsi),
                        _infoRow(Icons.markunread_mailbox, "Kode Pos",
                            student.alamat.kodePos),
                      ]),
                ),
              ),
              const SizedBox(height: 18),

              // --- Ortu/Wali ---
              Text("Orang Tua / Wali",
                  style: Styles.header.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...student.guardians.map((g) => Card(
                    elevation: 3,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal[50],
                        child: Icon(
                          g.relation.toLowerCase().contains("ayah")
                              ? Icons.man
                              : g.relation.toLowerCase().contains("ibu")
                                  ? Icons.woman
                                  : Icons.group,
                          color: Colors.teal[700],
                        ),
                      ),
                      title: Text(g.name,
                          style: Styles.sub.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.teal[900])),
                      subtitle: Text("${g.relation}\n${g.address}"),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.teal[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Text("$label: $value",
                style: Styles.sub.copyWith(
                    fontSize: 15,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
