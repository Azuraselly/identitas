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

class _FormScreenState extends State<FormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nisnCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  String _jenisKelamin = 'Laki-laki';
  String _agama = 'Islam';
  final _tempatCtrl = TextEditingController();
  DateTime _tanggal = DateTime(2005, 1, 1);
  final _telpCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();

  Address _alamat = Address(
    jalan: '',
    rt: '',
    rw: '',
    dusun: '',
    desa: '',
    kecamatan: '',
    kabupaten: '',
    provinsi: '',
    kodePos: '',
  );

  final List<Guardian> _guardians = [];

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

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
      _alamat = e.alamat;
      _guardians.addAll(e.guardians);
    }

    _animCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _nisnCtrl.dispose();
    _namaCtrl.dispose();
    _tempatCtrl.dispose();
    _telpCtrl.dispose();
    _nikCtrl.dispose();
    _animCtrl.dispose();
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

  void _addGuardian() {
    setState(() {
      _guardians.add(Guardian(name: '', relation: '', address: ''));
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final provider = Provider.of<StudentProvider>(context, listen: false);

    if (widget.editing == null) {
      provider.addNewFromForm(
        nisn: _nisnCtrl.text,
        nama: _namaCtrl.text,
        jenisKelamin: _jenisKelamin,
        agama: _agama,
        tempatLahir: _tempatCtrl.text,
        tanggalLahir: _tanggal,
        noTelp: _telpCtrl.text,
        nik: _nikCtrl.text,
        alamat: _alamat,
        guardians: List.from(_guardians),
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
        alamat: _alamat,
        guardians: List.from(_guardians),
      );
      provider.updateStudent(widget.editing!.id, updated);
    }

    Navigator.pop(context);
  }

  Widget _sectionTitle(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal[700]),
          const SizedBox(width: 10),
          Text(
            text,
            style: Styles.header.copyWith(
              fontSize: 18,
              color: Colors.teal[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputWrapper({required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 3,
        shadowColor: Colors.teal.withOpacity(0.2),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editing != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(isEditing ? '✏️ Edit Data Siswa' : '➕ Tambah Data Siswa'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[300]!, Colors.teal[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.teal.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation(Colors.teal[700]),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("70%", style: Styles.sub.copyWith(color: Colors.teal[700])),
                ],
              ),
              const SizedBox(height: 25),

              // Section: Data Pribadi
              _sectionTitle("Data Pribadi", Icons.person),
              _inputWrapper(
                child: TextFormField(
                  controller: _nisnCtrl,
                  decoration: Styles.inputDecoration('NISN'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'NISN harus diisi' : null,
                ),
              ),
              _inputWrapper(
                child: TextFormField(
                  controller: _namaCtrl,
                  decoration: Styles.inputDecoration('Nama Lengkap'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Nama harus diisi' : null,
                ),
              ),
              _inputWrapper(
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _jenisKelamin,
                        items: ['Laki-laki', 'Perempuan']
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _jenisKelamin = v ?? 'Laki-laki'),
                        decoration: Styles.inputDecoration('Jenis Kelamin'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _agama,
                        items: [
                          'Islam',
                          'Kristen',
                          'Katolik',
                          'Hindu',
                          'Budha',
                          'Konghucu',
                          'Lainnya'
                        ]
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _agama = v ?? 'Islam'),
                        decoration: Styles.inputDecoration('Agama'),
                      ),
                    ),
                  ],
                ),
              ),
              _inputWrapper(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tempatCtrl,
                        decoration: Styles.inputDecoration('Tempat Lahir'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: Styles.inputDecoration('Tanggal Lahir'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${_tanggal.day}/${_tanggal.month}/${_tanggal.year}'),
                              const Icon(Icons.calendar_today,
                                  size: 18, color: Colors.teal),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _inputWrapper(
                child: TextFormField(
                  controller: _telpCtrl,
                  decoration: Styles.inputDecoration('No. Telepon'),
                  keyboardType: TextInputType.phone,
                ),
              ),
              _inputWrapper(
                child: TextFormField(
                  controller: _nikCtrl,
                  decoration: Styles.inputDecoration('NIK'),
                  keyboardType: TextInputType.number,
                ),
              ),

              const SizedBox(height: 25),
              _sectionTitle("Alamat", Icons.home),
              _inputWrapper(
                child: AddressWidget(
                  initial: _alamat,
                  onChanged: (addr) => _alamat = addr,
                ),
              ),

              const SizedBox(height: 25),
              _sectionTitle("Ortu / Wali", Icons.family_restroom),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tambah data ortu/wali",
                      style: Styles.sub.copyWith(color: Colors.teal[900])),
                  ElevatedButton.icon(
                    onPressed: _addGuardian,
                    icon: const Icon(Icons.add_circle_outline),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    label: const Text("Tambah"),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_guardians.isEmpty)
                Text("Belum ada data orang tua/wali", style: Styles.sub),
              ..._guardians.asMap().entries.map((e) {
                final idx = e.key;
                return GuardianWidget(
                  guardian: _guardians[idx],
                  onRemove: () => setState(() => _guardians.removeAt(idx)),
                  onChanged: (g) => setState(() => _guardians[idx] = g),
                );
              }),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // Floating Save Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submit,
        icon: const Icon(Icons.save_alt, color: Colors.white),
        label: Text(
          isEditing ? "Simpan Perubahan" : "Simpan Data",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.teal[700],
      ),
    );
  }
}
