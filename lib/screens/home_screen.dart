import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../widgets/student_card.dart';
import 'form_screen.dart';
import '../utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Load data dari Supabase setelah widget siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      provider.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final filtered = provider.students
        .where(
          (s) =>
              s.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.nisn.contains(_searchQuery),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Soft white-gray background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "Data Siswa",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                hintText: "Cari siswa berdasarkan nama atau NISN...",
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Color(0xFF00B4DB).withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFF0083B0),
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          // Loading or Error State
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text('Error: ${provider.error}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => provider.loadData(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00B4DB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    : filtered.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            physics: const BouncingScrollPhysics(),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final s = filtered[index];
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                                child: StudentCard(student: s),
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00B4DB),
        icon: const Icon(Icons.add, color: Colors.white, size: 26),
        label: const Text(
          "Tambah",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const FormScreen()),
          ).then((_) {
            // Reload data setelah kembali dari FormScreen
            Provider.of<StudentProvider>(context, listen: false).loadData();
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.people_alt_rounded,
              size: 90,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Belum ada data',
            style: Styles.header.copyWith(
              fontSize: 22,
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap tombol di kanan bawah untuk menambahkan siswa baru',
            style: Styles.sub.copyWith(
              color: Colors.grey[600],
              fontSize: 15,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}