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

  List<Guardian> _guardians = [
    Guardian(name: '', relation: 'Ayah', address: ''),
    Guardian(name: '', relation: 'Ibu', address: ''),
    Guardian(name: '', relation: 'Wali', address: ''),
  ];

  double _formProgress = 0.7;
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
      _guardians = e.guardians;
    }

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _animCtrl.forward();

    _updateFormProgress();
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

  void _updateFormProgress() {
    int filledFields = 0;
    if (_nisnCtrl.text.isNotEmpty) filledFields++;
    if (_namaCtrl.text.isNotEmpty) filledFields++;
    if (_tempatCtrl.text.isNotEmpty) filledFields++;
    if (_telpCtrl.text.isNotEmpty) filledFields++;
    if (_nikCtrl.text.isNotEmpty) filledFields++;
    if (_alamat.jalan.isNotEmpty) filledFields++;
    if (_guardians.any((g) => g.name.isNotEmpty)) filledFields++;
    setState(() {
      _formProgress = filledFields / 7;
    });
  }

  void _updateGuardians(List<Guardian> gs) {
    setState(() {
      _guardians = gs;
      _updateFormProgress();
    });
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() => _tanggal = d);
      _updateFormProgress();
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

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
        alamat: _alamat,
        guardians: _guardians,
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
          Icon(icon, color: const Color(0xFF6B7280), size: 28),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputWrapper({required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }

  // 🔹 Helper dropdown item dengan icon
  DropdownMenuItem<String> _buildDropdownItem(IconData icon, String text) {
    return DropdownMenuItem(
      value: text,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editing != null;

    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(isEditing ? '✏️ Edit Data Siswa' : '➕ Tambah Data Siswa'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF00B4DB)
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              _inputWrapper(
                child: LinearProgressIndicator(
                  value: _formProgress,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF3B82F6)),
                  minHeight: 8,
                ),
              ),

              const SizedBox(height: 16),
              _sectionTitle("Data Pribadi", Icons.person),
              _inputWrapper(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nisnCtrl,
                      decoration: Styles.inputDecoration("NISN").copyWith(
                        prefixIcon: const Icon(Icons.badge_outlined, color: Colors.teal),
                      ),
                      onChanged: (_) => _updateFormProgress(),
                      validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _namaCtrl,
                      decoration: Styles.inputDecoration("Nama Lengkap").copyWith(
                        prefixIcon: const Icon(Icons.person_outline, color: Colors.teal),
                      ),
                      onChanged: (_) => _updateFormProgress(),
                      validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Jenis Kelamin
                    DropdownButtonFormField<String>(
                      value: _jenisKelamin,
                      decoration: Styles.inputDecoration("Jenis Kelamin").copyWith(
                        
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                      items: [
                        DropdownMenuItem(
                          value: "Laki-laki",
                          child: Row(
                            children: const [
                              Icon(Icons.male, size: 20, color: Colors.blue),
                              SizedBox(width: 8),
                              Text("Laki-laki"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Perempuan",
                          child: Row(
                            children: const [
                              Icon(Icons.female, size: 20, color: Colors.pink),
                              SizedBox(width: 8),
                              Text("Perempuan"),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => _jenisKelamin = val!);
                        _updateFormProgress();
                      },
                    ),
                    const SizedBox(height: 12),

                    // 🔹 Agama
                    DropdownButtonFormField<String>(
                      value: _agama,
                      decoration: Styles.inputDecoration("Agama").copyWith(
                        
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                      items: [
                        _buildDropdownItem(Icons.mosque, "Islam"),
                        _buildDropdownItem(Icons.church, "Kristen"),
                        _buildDropdownItem(Icons.temple_hindu, "Hindu"),
                        _buildDropdownItem(Icons.self_improvement, "Budha"),
                        _buildDropdownItem(Icons.church_outlined, "Katolik"),
                        _buildDropdownItem(Icons.forest, "Konghucu"),
                      ],
                      onChanged: (val) {
                        setState(() => _agama = val!);
                        _updateFormProgress();
                      },
                    ),

                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tempatCtrl,
                      decoration: Styles.inputDecoration("Tempat Lahir").copyWith(
                        prefixIcon: const Icon(Icons.location_city, color: Colors.teal),
                      ),
                      onChanged: (_) => _updateFormProgress(),
                    ),
                    const SizedBox(height: 12),

                    InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: Styles.inputDecoration("Tanggal Lahir").copyWith(
                          prefixIcon: const Icon(Icons.cake_outlined, color: Colors.teal),
                        ),
                        child: Text("${_tanggal.day}/${_tanggal.month}/${_tanggal.year}", style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _telpCtrl,
                      decoration: Styles.inputDecoration("No. Telepon").copyWith(
                        prefixIcon: const Icon(Icons.phone_android, color: Colors.teal),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (_) => _updateFormProgress(),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _nikCtrl,
                      decoration: Styles.inputDecoration("NIK").copyWith(
                        prefixIcon: const Icon(Icons.credit_card, color: Colors.teal),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _updateFormProgress(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _sectionTitle("Alamat", Icons.home),
              _inputWrapper(
                child: AddressWidget(
                  initial: _alamat,
                  onChanged: (addr) {
                    _alamat = addr;
                    _updateFormProgress();
                  },
                ),
              ),

              const SizedBox(height: 16),
              _sectionTitle("Orang Tua / Wali", Icons.family_restroom),
              _inputWrapper(
                child: GuardianWidget(
                  guardians: _guardians,
                  onChanged: _updateGuardians,
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submit,
        icon: const Icon(Icons.save_alt),
        label: Text(isEditing ? "Simpan Perubahan" : "Simpan Data"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
