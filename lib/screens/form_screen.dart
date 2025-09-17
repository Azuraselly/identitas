import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../widgets/address_widget.dart';
import '../widgets/guardian_widget.dart';
import '../utils/styles.dart';

class FormScreen extends StatefulWidget {
  final Student? editing;
  const FormScreen({super.key, this.editing});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> with SingleTickerProviderStateMixin {
  final _formKeys = [
    GlobalKey<FormState>(), // Step 1
    GlobalKey<FormState>(), // Step 2
    GlobalKey<FormState>(), // Step 3
  ];

  // Controllers
  final _nisnCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  String _jenisKelamin = 'Laki-laki';
  String _agama = 'Islam';
  final _tempatCtrl = TextEditingController();
  DateTime _tanggal = DateTime(2005, 1, 1);
  final _telpCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();

  // Alamat fields
  String _jalan = '';
  String _rt = '';
  String _rw = '';
  String _dusun = '';
  String _desa = '';
  String _kecamatan = '';
  String _kabupaten = '';
  String _provinsi = '';
  String _kodePos = '';

  List<Guardian> _guardians = [
    Guardian(studentId: '', name: '', relation: 'Ayah', address: ''),
    Guardian(studentId: '', name: '', relation: 'Ibu', address: ''),
    Guardian(studentId: '', name: '', relation: 'Wali', address: ''),
  ];

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    if (widget.editing != null) {
      final e = widget.editing!;
      _nisnCtrl.text = e.nisn;
      _namaCtrl.text = e.nama;
      _jenisKelamin = e.jenisKelamin;
      _agama = e.agama;
      _tempatCtrl.text = e.tempatLahir;
      _tanggal = e.tanggalLahir;
      _telpCtrl.text = e.noTelp;
      _nikCtrl.text = e.nik;
      _jalan = e.jalan;
      _rt = e.rt;
      _rw = e.rw;
      _dusun = e.dusun;
      _desa = e.desa;
      _kecamatan = e.kecamatan;
      _kabupaten = e.kabupaten;
      _provinsi = e.provinsi;
      _kodePos = e.kodePos;
      // Ambil guardians dari provider
      _guardians = Provider.of<StudentProvider>(context, listen: false)
          .getGuardiansByStudentId(e.id);
    }
  }

  @override
  void dispose() {
    _nisnCtrl.dispose();
    _namaCtrl.dispose();
    _tempatCtrl.dispose();
    _telpCtrl.dispose();
    _nikCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _tanggal = d);
  }

  Future<bool> _showConfirmDialog(bool isEdit) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
            title: Row(
              children: [
                Icon(
                  isEdit ? Icons.edit_note : Icons.save_alt,
                  color: isEdit ? Colors.orange : Colors.blue,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  isEdit ? 'Ubah Data?' : 'Simpan Data?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Text(
              isEdit
                  ? 'Apakah Anda yakin ingin mengubah data siswa ini?'
                  : 'Apakah Anda yakin ingin menyimpan data siswa baru ini?',
              style: TextStyle(color: Colors.grey[700], fontSize: 15),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEdit ? Colors.orange : Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Ya',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _submit() async {
    if (_currentStep < 2) return;
    if (!_formKeys.every((key) => key.currentState!.validate())) return;

    final isEdit = widget.editing != null;
    final confirmed = await _showConfirmDialog(isEdit);
    if (!confirmed) return;

    final provider = Provider.of<StudentProvider>(context, listen: false);

    try {
      if (!isEdit) {
        await provider.addNewFromForm(
          nisn: _nisnCtrl.text,
          nama: _namaCtrl.text,
          jenisKelamin: _jenisKelamin,
          agama: _agama,
          tempatLahir: _tempatCtrl.text,
          tanggalLahir: _tanggal,
          noTelp: _telpCtrl.text,
          nik: _nikCtrl.text,
          jalan: _jalan,
          rt: _rt,
          rw: _rw,
          dusun: _dusun,
          desa: _desa,
          kecamatan: _kecamatan,
          kabupaten: _kabupaten,
          provinsi: _provinsi,
          kodePos: _kodePos,
          guardians: _guardians,
        );
      } else {
        final updated = Student(
          id: widget.editing!.id,
          nisn: _nisnCtrl.text,
          nama: _namaCtrl.text,
          jenisKelamin: _jenisKelamin,
          agama: _agama,
          tempatLahir: _tempatCtrl.text,
          tanggalLahir: _tanggal,
          noTelp: _telpCtrl.text,
          nik: _nikCtrl.text,
          jalan: _jalan,
          rt: _rt,
          rw: _rw,
          dusun: _dusun,
          desa: _desa,
          kecamatan: _kecamatan,
          kabupaten: _kabupaten,
          provinsi: _provinsi,
          kodePos: _kodePos,
        );
        await provider.updateStudent(widget.editing!.id, updated, _guardians);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit ? 'Data berhasil diubah' : 'Data berhasil disimpan',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 18, color: Color(0xFF00B4DB)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                "Data Pribadi",
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        content: Form(
          key: _formKeys[0],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                _nisnCtrl,
                "NISN",
                icon: Icons.badge,
                validator: (v) => v == null || v.isEmpty
                    ? "NISN wajib diisi"
                    : v.length != 10
                        ? "NISN harus 10 karakter"
                        : null,
                type: TextInputType.number,
              ),
              _buildTextField(
                _namaCtrl,
                "Nama Lengkap",
                icon: Icons.person,
                validator: (v) =>
                    v == null || v.isEmpty ? "Nama lengkap wajib diisi" : null,
              ),
              _buildDropdown(
                label: "Jenis Kelamin",
                value: _jenisKelamin,
                items: const ["Laki-laki", "Perempuan"],
                onChanged: (val) => setState(() => _jenisKelamin = val!),
                icon: Icons.wc,
                validator: (v) => v == null || v.isEmpty
                    ? "Jenis kelamin wajib dipilih"
                    : null,
              ),
              _buildDropdown(
                label: "Agama",
                value: _agama,
                items: const [
                  "Islam",
                  "Kristen",
                  "Hindu",
                  "Budha",
                  "Katolik",
                  "Konghucu",
                ],
                onChanged: (val) => setState(() => _agama = val!),
                icon: Icons.church,
                validator: (v) =>
                    v == null || v.isEmpty ? "Agama wajib dipilih" : null,
              ),
              _buildTextField(
                _tempatCtrl,
                "Tempat Lahir",
                icon: Icons.location_city,
                validator: (v) =>
                    v == null || v.isEmpty ? "Tempat lahir wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: Styles.inputDecoration("Tanggal Lahir").copyWith(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF00B4DB),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_tanggal.day}/${_tanggal.month}/${_tanggal.year}",
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const Icon(
                        Icons.edit_calendar,
                        size: 18,
                        color: Color(0xFF00B4DB),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildTextField(
                _telpCtrl,
                "No. Telepon",
                type: TextInputType.phone,
                icon: Icons.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) return "No. Telepon wajib diisi";
                  if (v.length < 12 || v.length > 15)
                    return "No. Telepon minimal 12, maksimal 15 karakter";
                  if (!RegExp(r'^[0-9]+$').hasMatch(v))
                    return "Harus menggunakan angka";
                  return null;
                },
              ),
              _buildTextField(
                _nikCtrl,
                "NIK",
                type: TextInputType.number,
                icon: Icons.credit_card,
                validator: (v) =>
                    v == null || v.isEmpty ? "NIK wajib diisi" : null,
              ),
            ],
          ),
        ),
      ),
      Step(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.home, size: 18, color: Color(0xFF00B4DB)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                "Alamat",
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
        content: Form(
          key: _formKeys[1],
          child: AddressWidget(
            initialJalan: _jalan,
            initialRt: _rt,
            initialRw: _rw,
            initialDusun: _dusun,
            initialDesa: _desa,
            initialKecamatan: _kecamatan,
            initialKabupaten: _kabupaten,
            initialProvinsi: _provinsi,
            initialKodePos: _kodePos,
            onChanged: (jalan, rt, rw, dusun, desa, kecamatan, kabupaten, provinsi, kodePos) {
              setState(() {
                _jalan = jalan;
                _rt = rt;
                _rw = rw;
                _dusun = dusun;
                _desa = desa;
                _kecamatan = kecamatan;
                _kabupaten = kabupaten;
                _provinsi = provinsi;
                _kodePos = kodePos;
              });
            },
          ),
        ),
      ),
      Step(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.family_restroom, size: 18, color: Color(0xFF00B4DB)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                "Orang Tua",
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 2,
        content: Form(
          key: _formKeys[2],
          child: GuardianWidget(
            guardians: _guardians,
            onChanged: (gs) => _guardians = gs,
          ),
        ),
      ),
    ];
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
    TextInputType type = TextInputType.text,
    IconData? icon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        decoration: Styles.inputDecoration(label).copyWith(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: const Color(0xFF00B4DB)),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    IconData? icon,
    Map<String, IconData>? itemIcons,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: Styles.inputDecoration(label).copyWith(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: const Color(0xFF00B4DB)),
        ),
        items: items.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Row(
              children: [
                if (itemIcons != null && itemIcons.containsKey(e))
                  Icon(itemIcons[e], color: const Color(0xFF00B4DB), size: 18),
                if (itemIcons != null && itemIcons.containsKey(e))
                  const SizedBox(width: 6),
                Text(e),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editing != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEditing ? "✏️ Edit Data Siswa" : "➕ Tambah Data Siswa",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00B4DB),
              secondary: Color(0xFF0083B0),
            ),
          ),
          child: Stepper(
            key: ValueKey(_currentStep),
            type: StepperType.horizontal,
            currentStep: _currentStep,
            steps: _buildSteps(),
            onStepContinue: () async {
              if (_currentStep < 2) {
                if (_formKeys[_currentStep].currentState!.validate()) {
                  setState(() => _currentStep += 1);
                }
              } else {
                await _submit();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              } else {
                Navigator.pop(context);
              }
            },
            controlsBuilder: (context, details) {
              final isLastStep = _currentStep == 2;
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: details.onStepCancel,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Color(0xFF00B4DB),
                      ),
                      label: const Text("Kembali"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00B4DB),
                        side: const BorderSide(color: Color(0xFF00B4DB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: details.onStepContinue,
                      icon: Icon(
                        isLastStep ? Icons.save : Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      label: Text(
                        isLastStep ? "Simpan" : "Lanjut",
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor: isLastStep
                            ? Colors.deepOrange
                            : const Color(0xFF00B4DB),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}