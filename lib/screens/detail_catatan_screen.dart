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

  final Map<String, Map<String, String>> _detailMataKuliah = {
    'Sistem Manajemen Basis Data': {
      'dosen': 'NASRUDDIN BIN IDRIS, S.Kom., M.Kom.',
      'jadwal': 'Senin 19:00-20:30 (LAB B (FIKOM))',
      'kelas': 'IFB 5J',
      'sks': '3 SKS',
    },
    'Teknologi Aplikasi Bergerak': {
      'dosen': 'ISTIA BUDI, S.T., M.M.',
      'jadwal': 'Senin 20:30-22:00 (LAB A (FIKOM))',
      'kelas': 'IFB 5J',
      'sks': '3 SKS',
    },
    'Penalaran Komputer': {
      'dosen': 'ISA ROSITA, S.Kom., M.Cs.',
      'jadwal': 'Selasa 19:00-20:30 (A201)',
      'kelas': 'IFB 5J',
      'sks': '3 SKS',
    },
    'Simulasi dan Game Komputer': {
      'dosen': 'HERUZULKIFLI ROWA, S.Kom, M.Kom',
      'jadwal': 'Selasa 20:30-22:00 (LAB A (FIKOM))',
      'kelas': 'IFB 5J',
      'sks': '3 SKS',
    },
    'Kriptografi': {
      'dosen': 'MUHAMMAD SAFI\'I, S.Kom., M.Kom.',
      'jadwal': 'Rabu 20:30-22:00 (A301)',
      'kelas': 'IFB 5J',
      'sks': '3 SKS',
    },
    'Penulisan dan Publikasi Ilmiah': {
      'dosen': 'YUSTIAN SERVANDA, S.Kom., M.Kom.',
      'jadwal': 'Kamis 19:00-20:30 (A203)',
      'kelas': 'IFB 5J',
      'sks': '2 SKS',
    },
    'Jaringan Nirkabel': {
      'dosen': 'MARADONA, S.Kom., M.Kom.',
      'jadwal': 'Jumat 19:00-20:30 (LAB JARINGAN (FIKOM))',
      'kelas': 'IFB 5J',
      'sks': '3 SKS',
    },
    'Pemrograman Aplikasi Bergerak': {
      'dosen': 'PRAMUDYA PRIMA INSAN, S.Kom., M.Kom.',
      'jadwal': 'Jumat 20:30-22:00 (LAB A (FIKOM))',
      'kelas': 'IFB 5J',
      'sks': '3 SKS',
    },
  };

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.catatan.judul);
    const legacyPlaceholder =
        'Ketuk untuk melengkapi ringkasan materi perkuliahan...';
    final initialIsi = widget.catatan.isi.trim() == legacyPlaceholder
        ? ''
        : widget.catatan.isi;
    _isiController = TextEditingController(text: initialIsi);
    _selectedDeadline = widget.catatan.deadline;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _pilihDeadline() async {
    final initialDate =
        _selectedDeadline ?? DateTime.now().add(const Duration(days: 1));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (pickedTime == null || !mounted) return;

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

  void _simpanPerubahan() {
    final judulBaru = _judulController.text.trim();
    final isiBaru = _isiController.text.trim();

    Provider.of<CatatanStore>(context, listen: false).updateCatatan(
      widget.catatan.id,
      judulBaru.isNotEmpty ? judulBaru : widget.catatan.judul,
      isiBaru,
      deadlineBaru: _selectedDeadline,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil disimpan!'),
        backgroundColor: Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final infoMatkul = _detailMataKuliah[widget.catatan.mataKuliah] ??
        {
          'dosen': 'Dosen Pengampu',
          'jadwal': widget.catatan.tanggal,
          'kelas': 'IFB 5J',
          'sks': '3 SKS',
        };

    String deadlineText = '+ Set Tanggal & Jam Pengumpulan Tugas';
    if (_selectedDeadline != null) {
      final d = _selectedDeadline!;
      final jam =
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
      deadlineText = 'Tenggat Tugas: ${d.day}/${d.month}/${d.year} • Jam $jam';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton.icon(
              onPressed: _simpanPerubahan,
              icon: const Icon(
                Icons.save_outlined,
                color: Color(0xFF2383E2),
                size: 19,
              ),
              label: const Text(
                'Simpan',
                style: TextStyle(
                  color: Color(0xFF2383E2),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Ikon & Nama Mata Kuliah
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.grid_view_rounded,
                        color: Color(0xFF38BDF8),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        widget.catatan.mataKuliah,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Kartu Informasi Akademik Mata Kuliah
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(Icons.person_outline_rounded,
                                size: 17, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(width: 10),
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: SizedBox(
                              width: 112,
                              child: Text(
                                'Dosen Pengampu',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                infoMatkul['dosen']!,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0369A1),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.access_time_rounded,
                        label: 'Jadwal Kuliah',
                        value: infoMatkul['jadwal']!,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.apartment_rounded,
                        label: 'Ruang / Kelas',
                        value: infoMatkul['kelas']!,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.auto_stories_outlined,
                        label: 'Bobot SKS',
                        value: infoMatkul['sks']!,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Input Judul Catatan
                const Text(
                  'Judul Catatan',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _judulController,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Tombol Set Tenggat Tugas
                InkWell(
                  onTap: _pilihDeadline,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedDeadline != null
                          ? const Color(0xFFFEF2F2)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedDeadline != null
                            ? const Color(0xFFFECACA)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.alarm_add_rounded,
                          size: 18,
                          color: _selectedDeadline != null
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            deadlineText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _selectedDeadline != null
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                        if (_selectedDeadline != null) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _selectedDeadline = null),
                            child: const Icon(Icons.close_rounded,
                                size: 16, color: Color(0xFFDC2626)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 14),

                // Area Teks Ringkasan Materi
                TextField(
                  controller: _isiController,
                  maxLines: null,
                  minLines: 8,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                    height: 1.6,
                  ),
                  decoration: const InputDecoration(
                    hintText:
                        'Ketuk untuk melengkapi ringkasan materi perkuliahan...',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 17, color: const Color(0xFF64748B)),
        const SizedBox(width: 10),
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}
