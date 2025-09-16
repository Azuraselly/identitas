import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/styles.dart';

class GuardianWidget extends StatefulWidget {
  final Guardian guardian;
  final VoidCallback onRemove;
  final void Function(Guardian) onChanged;

  const GuardianWidget({super.key, required this.guardian, required this.onRemove, required this.onChanged});

  @override
  State<GuardianWidget> createState() => _GuardianWidgetState();
}

class _GuardianWidgetState extends State<GuardianWidget> {
  late Guardian g;
  final _name = TextEditingController();
  final _relation = TextEditingController();
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    g = widget.guardian;
    _name.text = g.name;
    _relation.text = g.relation;
    _address.text = g.address;
  }

  void _emit() {
    g = Guardian(name: _name.text, relation: _relation.text, address: _address.text);
    widget.onChanged(g);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(controller: _name, decoration: Styles.inputDecoration('Nama'), onChanged: (_) => _emit()),
              ),
              IconButton(onPressed: widget.onRemove, icon: const Icon(Icons.delete, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: TextFormField(controller: _relation, decoration: Styles.inputDecoration('Hubungan (Ayah/Ibu/Wali)'), onChanged: (_) => _emit())),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(controller: _address, decoration: Styles.inputDecoration('Alamat Orang Tua/Wali'), onChanged: (_) => _emit()),
        ]),
      ),
    );
  }
}
