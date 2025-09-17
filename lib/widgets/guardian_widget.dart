import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/styles.dart';

class GuardianWidget extends StatefulWidget {
  final List<Guardian> guardians;
  final String? studentId; // Tambahkan studentId untuk keperluan edit
  final void Function(List<Guardian>) onChanged;

  const GuardianWidget({
    super.key,
    required this.guardians,
    this.studentId, // Opsional, diisi saat edit
    required this.onChanged,
  });

  @override
  State<GuardianWidget> createState() => _GuardianWidgetState();
}

class _GuardianWidgetState extends State<GuardianWidget> {
  late List<Guardian> _guardians;

  @override
  void initState() {
    super.initState();
    // Inisialisasi guardians dengan studentId jika ada
    _guardians = widget.guardians.isNotEmpty
        ? widget.guardians
        : [
            Guardian(studentId: widget.studentId ?? '', name: '', relation: 'Ayah', address: ''),
            Guardian(studentId: widget.studentId ?? '', name: '', relation: 'Ibu', address: ''),
            Guardian(studentId: widget.studentId ?? '', name: '', relation: 'Wali', address: ''),
          ];
  }

  void _updateGuardian(int index, Guardian g) {
    setState(() {
      // Pastikan studentId tetap terjaga
      _guardians[index] = Guardian(
        id: g.id,
        studentId: widget.studentId ?? g.studentId,
        name: g.name,
        relation: g.relation,
        address: g.address,
      );
    });
    widget.onChanged(_guardians);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.family_restroom, color: Color(0xFF00B4DB), size: 28),
            SizedBox(width: 8),
            Text(
              "Data Orang Tua / Wali",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._guardians.asMap().entries.map((entry) {
          final index = entry.key;
          final guardian = entry.value;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE3FDFD),
                    Color(0xFFFFFFFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guardian.relation,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007EA7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GuardianForm(
                    guardian: guardian,
                    onChanged: (g) => _updateGuardian(index, g),
                    isRequired: guardian.relation != 'Wali', // Wali optional
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _GuardianForm extends StatefulWidget {
  final Guardian guardian;
  final void Function(Guardian) onChanged;
  final bool isRequired;

  const _GuardianForm({
    required this.guardian,
    required this.onChanged,
    required this.isRequired,
  });

  @override
  State<_GuardianForm> createState() => _GuardianFormState();
}

class _GuardianFormState extends State<_GuardianForm> {
  late TextEditingController _nameCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.guardian.name);
    _addressCtrl = TextEditingController(text: widget.guardian.address);
  }

  void _emit() {
    widget.onChanged(Guardian(
      id: widget.guardian.id, // Pertahankan ID jika ada
      studentId: widget.guardian.studentId, // Pertahankan studentId
      name: _nameCtrl.text,
      relation: widget.guardian.relation,
      address: _addressCtrl.text,
    ));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _nameCtrl,
          decoration: Styles.inputDecoration("Nama Lengkap").copyWith(
            prefixIcon: const Icon(Icons.person, color: Color(0xFF00B4DB)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
          ),
          validator: widget.isRequired
              ? (v) => v == null || v.isEmpty
                  ? "Nama ${widget.guardian.relation} wajib diisi"
                  : null
              : null,
          onChanged: (_) => _emit(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _addressCtrl,
          decoration: Styles.inputDecoration("Alamat").copyWith(
            prefixIcon: const Icon(Icons.location_on, color: Color(0xFF00B4DB)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
          ),
          maxLines: 1,
          onChanged: (_) => _emit(),
        ),
      ],
    );
  }
}