import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_store.dart';
import 'detail_catatan_screen.dart';

class PengingatTugasScreen extends StatefulWidget {
  const PengingatTugasScreen({super.key});

  @override
  State<PengingatTugasScreen> createState() => _PengingatTugasScreenState();
}

class _PengingatTugasScreenState extends State<PengingatTugasScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _tambahTugas(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final catatanBaru = CatatanModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        judul: _judulController.text,
        mataKuliah: 'Umum',
        isi: _deskripsiController.text,
        tanggal: DateTime.now().toString(),
        deadline: DateTime.now().add(const Duration(days: 1)),
      );

      Provider.of<CatatanStore>(context, listen: false)
          .tambahCatatan(catatanBaru);

      _judulController.clear();
      _deskripsiController.clear();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengingat tugas berhasil ditambahkan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _tampilkanFormTambah(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tambah Pengingat Tugas',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF37352F))),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul Tugas',
                    filled: true,
                    fillColor: const Color(0xFFF9F9F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAEAEA)),
                    ),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Judul wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _deskripsiController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi / Detail Tugas',
                    filled: true,
                    fillColor: const Color(0xFFF9F9F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEAEAEA)),
                    ),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Deskripsi wajib diisi'
                      : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _tambahTugas(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2383E2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Simpan Tugas',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF37352F)),
        title: const Text('Pengingat Tugas',
            style: TextStyle(
                color: Color(0xFF37352F), fontWeight: FontWeight.bold)),
      ),
      body: Consumer<CatatanStore>(
        builder: (context, store, child) {
          final listTugas =
              store.catatanList.where((c) => c.deadline != null).toList();

          if (listTugas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Hore! Tidak ada tugas / deadline.',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: listTugas.length,
            itemBuilder: (context, index) {
              final tugas = listTugas[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailCatatanScreen(catatan: tugas)),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        tugas.judul.isEmpty ? 'Tugas Tanpa Judul' : tugas.judul,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(tugas.mataKuliah,
                            style: const TextStyle(color: Colors.blueGrey)),
                      ),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => store.hapusCatatan(tugas.id),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilkanFormTambah(context),
        backgroundColor: const Color(0xFF2383E2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
