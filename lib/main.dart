import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';  // Import Supabase
import 'providers/student_provider.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Pastikan binding Flutter siap
  
  // Inisialisasi Supabase dengan URL dan API Key dari dashboard Supabase
  await Supabase.initialize(
    url: 'https://cjlmnepmffqthqxemmre.supabase.co',  // Ganti dengan URL project Supabase Anda
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNqbG1uZXBtZmZxdGhxeGVtbXJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5ODI3OTgsImV4cCI6MjA3MzU1ODc5OH0.SElqI02X2nDdLlfSF1wF4z4iSPXk0tbaAYRmqJafiZs',  // Ganti dengan anon key dari Supabase
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Form CRUD',
        theme: ThemeData(
          primaryColor: const Color(0xFF1B5E20),
          scaffoldBackgroundColor: const Color(0xFFF6F7FB),
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1B5E20),
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}