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
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00B4DB), Color(0xFF0083B0)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          student.nama,
          style: Styles.header.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context, provider),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // --- Profile Card ---
              _glassCard(
                child: Column(
                  children: [
                    Hero(
                      tag: "avatar_${student.id}",
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.person,
                            size: 70, color: Colors.blue.shade700),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      student.nama,
                      style: Styles.header.copyWith(
                        fontSize: 26,
                        color: Colors.blueGrey[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      avatar: const Icon(Icons.badge,
                          size: 18, color: Colors.white),
                      label: Text("NISN: ${student.nisn}"),
                      backgroundColor: Colors.blue.shade400,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Data Diri ---
              _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Data Diri"),
                    const SizedBox(height: 12),
                    _infoRow(Icons.wc, "Jenis Kelamin", student.jenisKelamin),
                    _infoRow(Icons.star_rounded, "Agama", student.agama),
                    _infoRow(
                        Icons.cake_rounded,
                        "TTL",
                        "${student.tempatLahir}, ${student.tanggalLahir.day}/${student.tanggalLahir.month}/${student.tanggalLahir.year}"),
                    _infoRow(Icons.phone_rounded, "No Telp", student.noTelp),
                    _infoRow(Icons.badge_rounded, "NIK", student.nik),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Alamat ---
              _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Alamat"),
                    const SizedBox(height: 12),
                    _infoRow(Icons.home_rounded, "Jalan", student.alamat.jalan),
                    _infoRow(Icons.location_on_rounded, "RT/RW",
                        "${student.alamat.rt}/${student.alamat.rw}"),
                    _infoRow(
                        Icons.apartment_rounded, "Dusun", student.alamat.dusun),
                    _infoRow(Icons.villa_rounded, "Desa", student.alamat.desa),
                    _infoRow(Icons.map_rounded, "Kecamatan",
                        student.alamat.kecamatan),
                    _infoRow(Icons.location_city_rounded, "Kabupaten",
                        student.alamat.kabupaten),
                    _infoRow(
                        Icons.public_rounded, "Provinsi", student.alamat.provinsi),
                    _infoRow(Icons.markunread_mailbox_rounded, "Kode Pos",
                        student.alamat.kodePos),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Orang Tua / Wali ---
              _sectionTitle("Orang Tua / Wali"),
              const SizedBox(height: 14),
              ...student.guardians.map(
                (g) => _glassCard(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        g.relation.toLowerCase().contains("ayah")
                            ? Icons.man_rounded
                            : g.relation.toLowerCase().contains("ibu")
                                ? Icons.woman_rounded
                                : Icons.group_rounded,
                        color: Colors.blue.shade700,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      g.name.isNotEmpty ? g.name : "Belum diisi",
                      style: Styles.sub.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          g.relation,
                          style: Styles.sub.copyWith(
                            fontSize: 14,
                            color: Colors.blueGrey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if (g.address.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  g.address,
                                  style: Styles.sub
                                      .copyWith(color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Floating Action Buttons ---
  Widget _buildFAB(BuildContext context, StudentProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: "edit",
          backgroundColor: Colors.blue.shade400,
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text("Edit"),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => FormScreen(editing: student)),
            );
            if (context.mounted) {
              await Provider.of<StudentProvider>(context, listen: false)
                  .loadData();
            }
          },
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: "delete",
          backgroundColor: Colors.redAccent,
          icon: const Icon(Icons.delete_forever, color: Colors.white),
          label: Text("Hapus",
          style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            _showDeleteDialog(context, provider);
          },
        ),
      ],
    );
  }

  // --- Glass Card ---
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Card(
          color: Colors.white.withOpacity(0.7),
          elevation: 8,
          shadowColor: Colors.blueGrey.withOpacity(0.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          child: Padding(padding: const EdgeInsets.all(20), child: child),
        ),
      ),
    );
  }

  // --- Section Title ---
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: Styles.header.copyWith(
        fontSize: 20,
        color: Colors.blueGrey[800],
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // --- Info Row ---
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.blue.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label: $value",
              style: Styles.sub.copyWith(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Dialog Konfirmasi Hapus ---
  void _showDeleteDialog(BuildContext context, StudentProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  color: Colors.redAccent,
                ),
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
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text("Batal",
                      style: TextStyle(color: Colors.black),
                      ),
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
                      onPressed: () async {
                        await provider.deleteStudent(student.id);
                        if (context.mounted) {
                          Navigator.pop(ctx, true);
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Hapus",
                      style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}