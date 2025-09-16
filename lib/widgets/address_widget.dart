import 'package:connectivity_plus/connectivity_plus.dart';  // Import untuk cek internet
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';  // Import Supabase
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
  final _dusun = TextEditingController();  // Controller untuk dusun (sekarang autocomplete)
  final _desa = TextEditingController();
  final _kecamatan = TextEditingController();
  final _kabupaten = TextEditingController();
  final _provinsi = TextEditingController();
  final _kodepos = TextEditingController();

  List<String> _dusunSuggestions = [];  // List suggestion dusun dari Supabase
  bool _isLoading = false;  // Flag untuk loading data
  String? _errorMessage;  // Pesan error untuk ditampilkan

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

    _fetchDusunSuggestions();  // Fetch suggestion dusun saat init
  }

  // Fungsi untuk fetch list dusun unik dari Supabase
  Future<void> _fetchDusunSuggestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Error handling 1: Cek koneksi internet menggunakan connectivity_plus
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        _errorMessage = 'Tidak ada koneksi internet. Silakan cek jaringan Anda.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Query Supabase untuk ambil semua data locations
      final response = await Supabase.instance.client
          .from('locations')
          .select('dusun')
          .order('dusun', ascending: true);

      // Extract dusun unik
      final Set<String> uniqueDusun = response.map((item) => item['dusun'] as String).toSet();
      setState(() {
        _dusunSuggestions = uniqueDusun.toList();
        _isLoading = false;
      });
    } on PostgrestException catch (e) {
      // Error handling 2: Masalah koneksi dengan Supabase (misalnya auth, server down)
      setState(() {
        _errorMessage = 'Masalah koneksi dengan database: ${e.message}. Silakan coba lagi nanti.';
        _isLoading = false;
      });
    } catch (e) {
      // Error umum lainnya
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk auto-fill field berdasarkan dusun yang dipilih
  Future<void> _autoFillFromDusun(String selectedDusun) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Cek internet lagi
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        _errorMessage = 'Tidak ada koneksi internet.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Query Supabase untuk data berdasarkan dusun (ambil row pertama jika multiple)
      final response = await Supabase.instance.client
          .from('locations')
          .select()
          .eq('dusun', selectedDusun)
          .limit(1);

      if (response.isNotEmpty) {
        final data = response[0];
        setState(() {
          _desa.text = data['desa'];
          _kecamatan.text = data['kecamatan'];
          _kabupaten.text = data['kabupaten'];
          _kodepos.text = data['kode_pos'];
          // Provinsi default ke Jawa Timur (bisa tambah kolom jika perlu)
          _provinsi.text = 'Jawa Timur';  // Asumsi, karena data di Malang
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Data tidak ditemukan untuk dusun ini.';
          _isLoading = false;
        });
      }
    } on PostgrestException catch (e) {
      setState(() {
        _errorMessage = 'Masalah koneksi Supabase: ${e.message}';
        _isLoading = false;
      });
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alamat', style: Styles.header),
        const SizedBox(height: 8),
        TextFormField(controller: _jalan, decoration: Styles.inputDecoration('Jalan'), onChanged: (_) => _emit()),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: TextFormField(controller: _rt, decoration: Styles.inputDecoration('RT'), onChanged: (_) => _emit())),
            const SizedBox(width: 8),
            Expanded(child: TextFormField(controller: _rw, decoration: Styles.inputDecoration('RW'), onChanged: (_) => _emit())),
          ],
        ),
        const SizedBox(height: 8),

        // Modifikasi: Input dusun jadi Autocomplete dengan suggestion dari Supabase
        Autocomplete<String>(
          optionsMaxHeight: 200,
          optionsViewBuilder: (context, onSelected, options) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return ListTile(title: Text(option), onTap: () => onSelected(option));
              },
            );
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            controller.text = _dusun.text;  // Sync dengan controller
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: Styles.inputDecoration('Dusun (autocomplete)'),
              onChanged: (value) {
                _dusun.text = value;
                _emit();
              },
            );
          },
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return _dusunSuggestions.where((option) {
              return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            _dusun.text = selection;
            _autoFillFromDusun(selection);  // Trigger auto-fill saat dusun dipilih
            _emit();
          },
        ),

        const SizedBox(height: 8),
        // Field desa, kecamatan, dll. sekarang auto-filled (read-only atau editable manual jika perlu)
        TextFormField(controller: _desa, decoration: Styles.inputDecoration('Desa (auto-filled)'), onChanged: (_) => _emit()),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: TextFormField(controller: _kecamatan, decoration: Styles.inputDecoration('Kecamatan (auto-filled)'), onChanged: (_) => _emit())),
            const SizedBox(width: 8),
            Expanded(child: TextFormField(controller: _kabupaten, decoration: Styles.inputDecoration('Kabupaten (auto-filled)'), onChanged: (_) => _emit())),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: TextFormField(controller: _provinsi, decoration: Styles.inputDecoration('Provinsi (auto-filled)'), onChanged: (_) => _emit())),
            const SizedBox(width: 8),
            Expanded(child: TextFormField(controller: _kodepos, decoration: Styles.inputDecoration('Kode Pos (auto-filled)'), keyboardType: TextInputType.number, onChanged: (_) => _emit())),
          ],
        ),

        // Tampilkan loading atau error
        if (_isLoading) const Center(child: CircularProgressIndicator()),
        if (_errorMessage != null) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}