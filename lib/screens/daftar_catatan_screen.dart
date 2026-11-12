import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_store.dart';
import 'detail_catatan_screen.dart';
// Import FormScreen untuk tombol back
import 'form_screen.dart';

class DaftarCatatanScreen extends StatefulWidget {
  const DaftarCatatanScreen({super.key});

  @override
  State<DaftarCatatanScreen> createState() => _DaftarCatatanScreenState();
}

class _DaftarCatatanScreenState extends State<DaftarCatatanScreen> {
  String _searchQuery = '';

  // Data Info Mata Kuliah (Dikembalikan seperti aslimu)
  final Map<String, Map<String, String>> mataKuliahInfo = {
    'Sistem Manajemen Basis Data': {
      'dosen': 'FAHRUL HIDAYAT S.Kom., M.Kom',
    },
    'Teknologi Aplikasi Bergerak': {
      'dosen': 'ISTIA BUDI S.Kom M.Kom',
    },
    'Penalaran Komputer': {
      'dosen': 'SLAMET HARTONO S.Kom., M.Kom',
    },
    'Simulasi dan Game Komputer': {
      'dosen': 'ISTIA BUDI S.Kom M.Kom',
    },
    'Kriptografi': {
      'dosen': 'WISNU HERA P S.TP., M.Eng',
    },
    'Penulisan dan Publikasi Ilmiah': {
      'dosen': 'Prof. Dr. Ir. SULARDIONO, M.S.',
    },
    'Jaringan Nirkabel': {
      'dosen': 'FANNY RAMADHANI S.Kom., M.Kom',
    },
    'Pemrograman Aplikasi Bergerak': {
      'dosen': 'GUNAWAN S.ST., M.T',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        iconTheme: const IconThemeData(color: Color(0xFF37352F)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FormScreen()),
            );
          },
        ),
        title: const Text('Daftar Catatan',
            style: TextStyle(
                color: Color(0xFF37352F), fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari catatan...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF1F1F0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<CatatanStore>(
        builder: (context, store, child) {
          final catatanList = store.catatanList.reversed.toList();
          final filteredList = catatanList.where((catatan) {
            return catatan.judul
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                catatan.mataKuliah
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
          }).toList();

          if (filteredList.isEmpty) {
            return const Center(
                child: Text('Belum ada catatan.',
                    style: TextStyle(color: Colors.grey, fontSize: 16)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final catatan = filteredList[index];
              final info = mataKuliahInfo[catatan.mataKuliah];
              return _buildCatatanCard(context, store, catatan, info);
            },
          );
        },
      ),
    );
  }

  Widget _buildCatatanCard(BuildContext context, CatatanStore store,
      CatatanModel catatan, Map<String, String>? info) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9F9F8),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.class_, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(catatan.mataKuliah,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF37352F))),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEAEAEA)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catatan.judul.isNotEmpty
                      ? catatan.judul
                      : 'Catatan Tanpa Judul',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF37352F)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      info?['dosen'] ?? 'Dosen Belum Diatur',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(catatan.tanggal,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEAEAEA)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailCatatanScreen(catatan: catatan)));
                  },
                  child: const Text('BUKA CATATAN',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2383E2))),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.redAccent, size: 20),
                  onPressed: () => _konfirmasiHapus(context, store, catatan.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _konfirmasiHapus(BuildContext context, CatatanStore store, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Hapus Catatan?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Catatan ini akan dihapus secara permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              store.hapusCatatan(id);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
