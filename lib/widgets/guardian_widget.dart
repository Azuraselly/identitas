import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/styles.dart';

class GuardianWidget extends StatefulWidget {
  final List<Guardian> guardians;
  final void Function(List<Guardian>) onChanged;

  const GuardianWidget({
    super.key,
    required this.guardians,
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
    _guardians = widget.guardians.isNotEmpty
        ? widget.guardians
        : [
            Guardian(name: '', relation: 'Ayah', address: ''),
            Guardian(name: '', relation: 'Ibu', address: ''),
            Guardian(name: '', relation: 'Wali', address: ''),
          ];
  }

  void _updateGuardian(int index, Guardian g) {
    setState(() {
      _guardians[index] = g;
    });
    widget.onChanged(_guardians);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _guardians.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Data Orang Tua / Wali",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: const TabBar(
              indicatorColor: Color(0xFF14B8A6),
              labelColor: Color(0xFF14B8A6),
              unselectedLabelColor: Color(0xFF6B7280),
              tabs: [
                Tab(icon: Icon(Icons.male), text: "Ayah"),
                Tab(icon: Icon(Icons.female), text: "Ibu"),
                Tab(icon: Icon(Icons.people), text: "Wali"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: TabBarView(
              children: List.generate(_guardians.length, (index) {
                return _GuardianForm(
                  title: _guardians[index].relation,
                  guardian: _guardians[index],
                  onChanged: (g) => _updateGuardian(index, g),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardianForm extends StatefulWidget {
  final String title;
  final Guardian guardian;
  final void Function(Guardian) onChanged;

  const _GuardianForm({
    required this.title,
    required this.guardian,
    required this.onChanged,
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
      name: _nameCtrl.text,
      relation: widget.title,
      address: _addressCtrl.text,
    ));
  }

  Icon _getRelationIcon() {
    switch (widget.title.toLowerCase()) {
      case "ayah":
        return const Icon(Icons.man, color: Color(0xFF14B8A6));
      case "ibu":
        return const Icon(Icons.woman, color: Color(0xFF14B8A6));
      default:
        return const Icon(Icons.group, color: Color(0xFF14B8A6));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              children: [
                _getRelationIcon(),
                const SizedBox(width: 8),
                Text(
                  widget.title.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: Styles.inputDecoration("Nama ${widget.title}")
                  .copyWith(
                prefixIcon:
                    const Icon(Icons.person, color: Color(0xFF14B8A6)),
              ),
              onChanged: (_) => _emit(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressCtrl,
              decoration: Styles.inputDecoration("Alamat ${widget.title}")
                  .copyWith(
                prefixIcon:
                    const Icon(Icons.location_on, color: Color(0xFF14B8A6)),
              ),
              onChanged: (_) => _emit(),
            ),
          ],
        ),
      ),
    );
  }
}
