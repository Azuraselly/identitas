import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';
import '../utils/styles.dart';

class AddressWidget extends StatefulWidget {
  final Address initial;
  final void Function(Address) onChanged;
  const AddressWidget({super.key, required this.initial, required this.onChanged});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  late Address addr;
  final _jalan = TextEditingController();
  final _rt = TextEditingController();
  final _rw = TextEditingController();
  final _dusun = TextEditingController();
  final _desa = TextEditingController();
  final _kecamatan = TextEditingController();
  final _kabupaten = TextEditingController();
  final _provinsi = TextEditingController();
  final _kodepos = TextEditingController();

  List<String> _dusunSuggestions = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    addr = widget.initial;
    _jalan.text = addr.jalan;
    _rt.text = addr.rt;
    _rw.text = addr.rw;
    _dusun.text = addr.dusun;
    _desa.text = addr.desa;
    _kecamatan.text = addr.kecamatan;
    _kabupaten.text = addr.kabupaten;
    _provinsi.text = addr.provinsi;
    _kodepos.text = addr.kodePos;

    _fetchDusunSuggestions();
  }

  // 🔹 Fungsi untuk fetch suggestion dusun dari Supabase dengan error handling.
  Future<void> _fetchDusunSuggestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      setState(() {
        _errorMessage = 'Tidak ada koneksi internet.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('locations')
          .select('dusun')
          .order('dusun', ascending: true);

      final Set<String> uniqueDusun =
          response.map((item) => item['dusun'] as String).toSet();
      setState(() {
        _dusunSuggestions = uniqueDusun.toList();
        _isLoading = false;
      });
    } on PostgrestException catch (e) {
      setState(() {
        _errorMessage = 'Masalah koneksi database: ${e.message}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  // 🔹 Fungsi untuk auto-fill fields berdasarkan dusun terpilih.
  Future<void> _autoFillFromDusun(String selectedDusun) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      setState(() {
        _errorMessage = 'Tidak ada koneksi internet.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('locations')
          .select()
          .eq('dusun', selectedDusun)
          .limit(1);

      if (response.isNotEmpty) {
        final data = response[0];
        setState(() {
          _desa.text = data['desa'] ?? '';
          _kecamatan.text = data['kecamatan'] ?? '';
          _kabupaten.text = data['kabupaten'] ?? '';
          _kodepos.text = data['kode_pos'] ?? '';
          _provinsi.text = data['provinsi'] ?? '';
          _isLoading = false;
        });
        _emit(); // Ensure emit is called after auto-fill
      } else {
        setState(() {
          _errorMessage = 'Data tidak ditemukan untuk dusun ini.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  void _emit() {
    addr = Address(
      jalan: _jalan.text,
      rt: _rt.text,
      rw: _rw.text,
      dusun: _dusun.text,
      desa: _desa.text,
      kecamatan: _kecamatan.text,
      kabupaten: _kabupaten.text,
      provinsi: _provinsi.text,
      kodePos: _kodepos.text,
    );
    widget.onChanged(addr);
  }

  @override
  void dispose() {
    _jalan.dispose();
    _rt.dispose();
    _rw.dispose();
    _dusun.dispose();
    _desa.dispose();
    _kecamatan.dispose();
    _kabupaten.dispose();
    _provinsi.dispose();
    _kodepos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alamat', style: Styles.header),
        const SizedBox(height: 8),

        // Jalan dengan validator
        TextFormField(
          controller: _jalan,
          decoration: Styles.inputDecoration('Jalan').copyWith(
            prefixIcon: const Icon(Icons.signpost_outlined, color: Color(0xFF00B4DB)),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Jalan wajib diisi' : null,
          onChanged: (_) => _emit(),
        ),
        const SizedBox(height: 8),

        // RT / RW dengan validator angka
        Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: _rt,
                decoration: Styles.inputDecoration('RT').copyWith(
                  prefixIcon: const Icon(Icons.confirmation_num_outlined, color: Color(0xFF00B4DB)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'RT wajib diisi';
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Harus angka';
                  return null;
                },
                onChanged: (_) => _emit(),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: TextFormField(
                controller: _rw,
                decoration: Styles.inputDecoration('RW').copyWith(
                  prefixIcon: const Icon(Icons.confirmation_num_outlined, color: Color(0xFF00B4DB)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'RW wajib diisi';
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Harus angka';
                  return null;
                },
                onChanged: (_) => _emit(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Dusun (Autocomplete)
        RawAutocomplete<String>(
          textEditingController: _dusun,
          focusNode: FocusNode(),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return _dusunSuggestions.where(
              (option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()),
            );
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: Styles.inputDecoration('Dusun (pilih dari daftar)').copyWith(
                prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF00B4DB)),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Dusun wajib diisi' : null,
              onChanged: (_) => _emit(),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final opt = options.elementAt(index);
                      return ListTile(
                        leading: const Icon(Icons.home_work_outlined, color: Color(0xFF00B4DB)),
                        title: Text(opt, style: const TextStyle(fontSize: 15)),
                        onTap: () => onSelected(opt),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          onSelected: (val) {
            _dusun.text = val;
            _autoFillFromDusun(val);
            _emit();
          },
        ),
        const SizedBox(height: 8),

        // Desa dengan validator
        TextFormField(
          controller: _desa,
          decoration: Styles.inputDecoration('Desa').copyWith(
            prefixIcon: const Icon(Icons.villa_outlined, color: Color(0xFF00B4DB)),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Desa wajib diisi' : null,
          onChanged: (_) => _emit(),
        ),
        const SizedBox(height: 8),

        // Kecamatan & Kabupaten dengan validator
        Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: _kecamatan,
                decoration: Styles.inputDecoration('Kecamatan').copyWith(
                  prefixIcon: const Icon(Icons.map_outlined, color: Color(0xFF00B4DB)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Kecamatan wajib diisi' : null,
                onChanged: (_) => _emit(),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: TextFormField(
                controller: _kabupaten,
                decoration: Styles.inputDecoration('Kabupaten').copyWith(
                  prefixIcon: const Icon(Icons.apartment_outlined, color: Color(0xFF00B4DB)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Kabupaten wajib diisi' : null,
                onChanged: (_) => _emit(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Provinsi & Kode Pos dengan validator
        Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: _provinsi,
                decoration: Styles.inputDecoration('Provinsi').copyWith(
                  prefixIcon: const Icon(Icons.flag_outlined, color: Color(0xFF00B4DB)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Provinsi wajib diisi' : null,
                onChanged: (_) => _emit(),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: TextFormField(
                controller: _kodepos,
                decoration: Styles.inputDecoration('Kode Pos').copyWith(
                  prefixIcon: const Icon(Icons.markunread_mailbox_outlined, color: Color(0xFF00B4DB)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Kode Pos wajib diisi' : null,
                onChanged: (_) => _emit(),
              ),
            ),
          ],
        ),

        if (_isLoading) const Center(child: CircularProgressIndicator()),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}