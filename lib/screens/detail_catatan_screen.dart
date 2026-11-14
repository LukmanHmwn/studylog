import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_store.dart';

class DetailCatatanScreen extends StatefulWidget {
  final CatatanModel catatan;

  const DetailCatatanScreen({super.key, required this.catatan});

  @override
  State<DetailCatatanScreen> createState() => _DetailCatatanScreenState();
}

class _DetailCatatanScreenState extends State<DetailCatatanScreen> {
  late TextEditingController _judulController;
  late TextEditingController _isiController;
  DateTime? _selectedDeadline;

  final Map<String, Map<String, String>> mataKuliahInfo = {
    'Sistem Manajemen Basis Data': {
      'dosen': 'FAHRUL HIDAYAT S.Kom., M.Kom',
      'jadwal': 'Senin 19.00-20.30 (LAB A)',
      'ruang': 'IFB 5J',
      'sks': '3 SKS'
    },
    'Teknologi Aplikasi Bergerak': {
      'dosen': 'ISTIA BUDI S.Kom M.Kom',
      'jadwal': 'Senin 20.30-22.00 (LAB A)',
      'ruang': 'IFB 5J',
      'sks': '3 SKS'
    },
    'Penalaran Komputer': {
      'dosen': 'SLAMET HARTONO S.Kom., M.Kom',
      'jadwal': 'Selasa 19.00-20.30 (A201)',
      'ruang': 'IFB 5J',
      'sks': '3 SKS'
    },
    'Simulasi dan Game Komputer': {
      'dosen': 'ISTIA BUDI S.Kom M.Kom',
      'jadwal': 'Rabu 20.30-22.00 (LAB A)',
      'ruang': 'IFB 5J',
      'sks': '3 SKS'
    },
    'Kriptografi': {
      'dosen': 'WISNU HERA P S.TP., M.Eng',
      'jadwal': 'Kamis 20.30-22.00 (LAB ROBOTIK)',
      'ruang': 'IFB 5J',
      'sks': '3 SKS'
    },
    'Penulisan dan Publikasi Ilmiah': {
      'dosen': 'Prof. Dr. Ir. SULARDIONO, M.S.',
      'jadwal': 'Jumat 20.30-22.00 (A203)',
      'ruang': 'IFB 5J',
      'sks': '3 SKS'
    },
    'Jaringan Nirkabel': {
      'dosen': 'FANNY RAMADHANI S.Kom., M.Kom',
      'jadwal': 'Sabtu 19.00-20.30 (LAB JARINGAN)',
      'ruang': 'IFB 5J',
      'sks': '3 SKS'
    },
    'Pemrograman Aplikasi Bergerak': {
      'dosen': 'GUNAWAN S.ST., M.T',
      'jadwal': 'Sabtu 20.30-22.00 (LAB A)',
      'ruang': 'IFB 5J',
      'sks': '3 SKS'
    },
  };

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.catatan.judul);
    _isiController = TextEditingController(text: widget.catatan.isi);
    _selectedDeadline = widget.catatan.deadline;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  void _simpanPerubahan() {
    Provider.of<CatatanStore>(context, listen: false).updateCatatan(
      widget.catatan.id,
      _judulController.text,
      _isiController.text,
      deadlineBaru: _selectedDeadline,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan & Deadline berhasil disimpan!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _aturDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDeadline != null
            ? TimeOfDay.fromDateTime(_selectedDeadline!)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = mataKuliahInfo[widget.catatan.mataKuliah];
    String deadlineText = "+ Set Tanggal & Jam Pengumpulan Tugas";
    if (_selectedDeadline != null) {
      final d = _selectedDeadline!;
      String jam =
          "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
      deadlineText = "Tenggat: ${d.day}/${d.month}/${d.year} • Jam $jam";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF37352F)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: _simpanPerubahan,
              icon: const Icon(Icons.save, color: Color(0xFF2383E2), size: 18),
              label: const Text('Simpan',
                  style: TextStyle(
                      color: Color(0xFF2383E2), fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.apps, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.catatan.mataKuliah,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF37352F)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (info != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEAEAEA)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.person_outline, 'Dosen Pengampu',
                        info['dosen'] ?? '-',
                        isHighlight: true),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.access_time, 'Jadwal Kuliah',
                        info['jadwal'] ?? '-'),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.meeting_room_outlined, 'Ruang / Kelas',
                        info['ruang'] ?? '-'),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.menu_book_outlined, 'Bobot SKS',
                        info['sks'] ?? '-'),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            const Text(
              'Judul Catatan',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _judulController,
                style: const TextStyle(fontSize: 15, color: Color(0xFF37352F)),
                decoration: const InputDecoration(
                  hintText: 'Masukkan judul untuk membedakan catatan ini...',
                  hintStyle: TextStyle(color: Color(0xFFD4D4D4), fontSize: 15),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _aturDeadline,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedDeadline == null
                      ? const Color(0xFFF9F9F8)
                      : const Color(0xFF2383E2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: _selectedDeadline == null
                          ? const Color(0xFFEAEAEA)
                          : const Color(0xFF2383E2).withOpacity(0.5)),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8.0,
                  children: [
                    Icon(Icons.alarm,
                        size: 18,
                        color: _selectedDeadline == null
                            ? const Color(0xFF91918E)
                            : const Color(0xFF2383E2)),
                    Text(
                      deadlineText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _selectedDeadline == null
                            ? const Color(0xFF91918E)
                            : const Color(0xFF2383E2),
                      ),
                    ),
                    if (_selectedDeadline != null)
                      GestureDetector(
                        onTap: () => setState(() => _selectedDeadline = null),
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.redAccent),
                      )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFEAEAEA), thickness: 1),
            const SizedBox(height: 16),
            TextField(
              controller: _isiController,
              maxLines: null,
              style: const TextStyle(
                  fontSize: 15, color: Color(0xFF37352F), height: 1.6),
              decoration: const InputDecoration(
                hintText:
                    'Tuangkan ringkasan materi, ide tugas, atau coretan brilianmu di sini...\nKetik apapun yang ingin kamu ingat hari ini!',
                hintStyle: TextStyle(
                    color: Color(0xFFD4D4D4),
                    fontStyle: FontStyle.italic,
                    height: 1.6),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isHighlight = false}) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 300;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          SizedBox(
            width: isMobile ? 90 : 120,
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          Expanded(
            child: isHighlight
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        value,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0)),
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF37352F)),
                  ),
          ),
        ],
      );
    });
  }
}
