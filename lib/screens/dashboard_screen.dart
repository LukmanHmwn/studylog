import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/catatan_store.dart';
import 'animated_login_screen.dart';
import 'daftar_catatan_screen.dart';
import 'detail_catatan_screen.dart';
import 'form_screen.dart';
import 'pengingat_tugas_screen.dart';
import 'profile_detail_screen.dart';
import 'project_portofolio_screen.dart';
import 'schedule_screen.dart';

class _MatkulItem {
  final String kode;
  final String nama;
  final String dosen;
  final int hari;
  final String jam;
  final String ruang;
  final Color warna;

  const _MatkulItem({
    required this.kode,
    required this.nama,
    required this.dosen,
    required this.hari,
    required this.jam,
    required this.ruang,
    required this.warna,
  });
}

class DashboardScreen extends StatefulWidget {
  final String? initialIdentifier;

  const DashboardScreen({super.key, this.initialIdentifier});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _currentName = '';
  String _currentNim = '';
  String? _profileImagePath;

  static const List<_MatkulItem> _daftarMatkul = [
    _MatkulItem(
      kode: 'SMBD',
      nama: 'Sistem Manajemen Basis Data',
      dosen: 'NASRUDDIN BIN IDRIS, S.Kom., M.Kom.',
      hari: 1,
      jam: '19:00 - 20:30',
      ruang: 'LAB B (FIKOM)',
      warna: Color(0xFF0D9488),
    ),
    _MatkulItem(
      kode: 'TAB',
      nama: 'Teknologi Aplikasi Bergerak',
      dosen: 'ISTIA BUDI, S.T., M.M.',
      hari: 1,
      jam: '20:30 - 22:00',
      ruang: 'LAB A (FIKOM)',
      warna: Color(0xFF2563EB),
    ),
    _MatkulItem(
      kode: 'PK',
      nama: 'Penalaran Komputer',
      dosen: 'ISA ROSITA, S.Kom., M.Cs.',
      hari: 2,
      jam: '19:00 - 20:30',
      ruang: 'A201',
      warna: Color(0xFFE11D48),
    ),
    _MatkulItem(
      kode: 'SGK',
      nama: 'Simulasi dan Game Komputer',
      dosen: 'HERUZULKIFLI ROWA, S.Kom, M.Kom',
      hari: 2,
      jam: '20:30 - 22:00',
      ruang: 'LAB A (FIKOM)',
      warna: Color(0xFFD97706),
    ),
    _MatkulItem(
      kode: 'KRIP',
      nama: 'Kriptografi',
      dosen: 'MUHAMMAD SAFI\'I, S.Kom., M.Kom.',
      hari: 3,
      jam: '20:30 - 22:00',
      ruang: 'A301',
      warna: Color(0xFF7C3AED),
    ),
    _MatkulItem(
      kode: 'PPI',
      nama: 'Penulisan dan Publikasi Ilmiah',
      dosen: 'YUSTIAN SERVANDA, S.Kom., M.Kom.',
      hari: 4,
      jam: '19:00 - 20:30',
      ruang: 'A203',
      warna: Color(0xFF475569),
    ),
    _MatkulItem(
      kode: 'JN',
      nama: 'Jaringan Nirkabel',
      dosen: 'MARADONA, S.Kom., M.Kom.',
      hari: 5,
      jam: '19:00 - 20:30',
      ruang: 'LAB JARINGAN (FIKOM)',
      warna: Color(0xFF0284C7),
    ),
    _MatkulItem(
      kode: 'PAB',
      nama: 'Pemrograman Aplikasi Bergerak',
      dosen: 'PRAMUDYA PRIMA INSAN, S.Kom., M.Kom.',
      hari: 5,
      jam: '20:30 - 22:00',
      ruang: 'LAB A (FIKOM)',
      warna: Color(0xFF4F46E5),
    ),
  ];

  @override
  void initState() {
    super.initState();
    final id = widget.initialIdentifier?.trim() ?? '';
    if (id.isNotEmpty) {
      if (id.contains('@')) {
        _currentName = id.split('@').first;
      } else {
        _currentNim = id;
      }
    }
  }

  String _formatTanggalHariIni() {
    final now = DateTime.now();
    const hariList = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const bulanList = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${hariList[now.weekday - 1]}, ${now.day} ${bulanList[now.month - 1]} ${now.year}';
  }

  ImageProvider? _resolveProfileImage() {
    if (_profileImagePath == null || _profileImagePath!.isEmpty) return null;
    if (kIsWeb) {
      return NetworkImage(_profileImagePath!);
    }
    final file = File(_profileImagePath!);
    if (!file.existsSync()) return null;
    return FileImage(file);
  }

  Future<void> _bukaProfil() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(
          initialName: _currentName,
          initialNim: _currentNim,
          initialImagePath: _profileImagePath,
        ),
      ),
    );
    if (!mounted || result is! Map) return;
    setState(() {
      _currentName = (result['name'] ?? '').toString();
      _currentNim = (result['nim'] ?? '').toString();
      if (result['imagePath'] != null) {
        _profileImagePath = result['imagePath'].toString();
      }
    });
  }

  void _bukaHalaman(Widget halaman,
      {bool tutupDrawer = false, bool gantiHalaman = false}) {
    if (tutupDrawer) Navigator.pop(context);
    if (gantiHalaman) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => halaman),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => halaman),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 960;
    final isWideDesktop = width >= 1220;
    final isCompact = width < 640;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      drawer: isDesktop ? null : _buildSidebar(isDrawer: true),
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
              title: const AnimatedHeaderTitle(),
              actions: [
                IconButton(
                  tooltip: 'Buat Sesi Kelas',
                  icon: const Icon(Icons.add_circle_outline_rounded,
                      color: Color(0xFF2383E2)),
                  onPressed: () => _bukaHalaman(const FormScreen()),
                ),
              ],
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) _buildSidebar(isDrawer: false),
          Expanded(
            child: Consumer<CatatanStore>(
              builder: (context, store, _) {
                final catatanList = store.catatanList;
                final totalCatatan = catatanList.length;
                final materiTerisi =
                    catatanList.where((c) => c.isi.trim().isNotEmpty).length;
                final semuaTugas =
                    catatanList.where((c) => c.deadline != null).toList();
                final tugasAktifList = semuaTugas
                    .where((c) => !c.isSelesai)
                    .toList()
                  ..sort((a, b) => a.deadline!.compareTo(b.deadline!));
                final tugasSelesai =
                    semuaTugas.where((c) => c.isSelesai).length;
                final matkulTercatat =
                    catatanList.map((c) => c.mataKuliah).toSet().length;

                final persenMateri = totalCatatan == 0
                    ? 0
                    : ((materiTerisi / totalCatatan) * 100).round();
                final persenTugas = semuaTugas.isEmpty
                    ? 0
                    : ((tugasSelesai / semuaTugas.length) * 100).round();
                final persenMatkul =
                    ((matkulTercatat / _daftarMatkul.length) * 100)
                        .clamp(0, 100)
                        .round();

                return SingleChildScrollView(
                  padding: EdgeInsets.all(isCompact ? 16.0 : 28.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1360),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopBar(isCompact, tugasAktifList.length),
                          const SizedBox(height: 24),
                          if (isWideDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: _buildKolomTengah(
                                    isCompact: isCompact,
                                    catatanList: catatanList,
                                    totalCatatan: totalCatatan,
                                    matkulTercatat: matkulTercatat,
                                    tugasAktif: tugasAktifList.length,
                                    persenMateri: persenMateri,
                                    persenTugas: persenTugas,
                                    persenMatkul: persenMatkul,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 4,
                                  child: _buildKolomKanan(tugasAktifList),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildKolomTengah(
                                  isCompact: isCompact,
                                  catatanList: catatanList,
                                  totalCatatan: totalCatatan,
                                  matkulTercatat: matkulTercatat,
                                  tugasAktif: tugasAktifList.length,
                                  persenMateri: persenMateri,
                                  persenTugas: persenTugas,
                                  persenMatkul: persenMatkul,
                                ),
                                const SizedBox(height: 24),
                                _buildKolomKanan(tugasAktifList),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isCompact, int jumlahTugasAktif) {
    final namaTampil = _currentName.isEmpty
        ? (_currentNim.isEmpty ? 'Mahasiswa UM' : _currentNim)
        : _currentName;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _bukaHalaman(const DaftarCatatanScreen()),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded,
                      color: Color(0xFF64748B), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Cari catatan perkuliahan atau mata kuliah...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isCompact) ...[
          const SizedBox(width: 10),
          InkWell(
            onTap: _bukaProfil,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: _buildProfileAvatar(size: 34),
            ),
          ),
        ] else ...[
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_outlined,
                    size: 16, color: Color(0xFF2383E2)),
                SizedBox(width: 6),
                Text(
                  'IFB 5J • Sem 5',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => _bukaHalaman(const PengingatTugasScreen()),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_rounded,
                      size: 21, color: Color(0xFF334155)),
                  if (jumlahTugasAktif > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: _bukaProfil,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  _buildProfileAvatar(size: 32),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 140),
                    child: Text(
                      namaTampil,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18, color: Color(0xFF64748B)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeroProfileBox({required double size, required bool isCompact}) {
    final imageProvider = _resolveProfileImage();

    return InkWell(
      onTap: _bukaProfil,
      borderRadius: BorderRadius.circular(isCompact ? 18 : 20),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: imageProvider == null
              ? const LinearGradient(
                  colors: [Color(0xFF2383E2), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: imageProvider != null ? const Color(0xFFEFF6FF) : null,
          borderRadius: BorderRadius.circular(isCompact ? 18 : 20),
          border: imageProvider != null
              ? Border.all(color: const Color(0xFFCBD5E1), width: 2)
              : null,
          image: imageProvider != null
              ? DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: imageProvider != null
            ? Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(isCompact ? 8.0 : 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: isCompact ? 28 : 42,
                    ),
                    SizedBox(height: isCompact ? 4 : 8),
                    Text(
                      isCompact ? 'StudyLog' : 'StudyLog SQLite',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: isCompact ? 10.5 : 12.5,
                      ),
                    ),
                    if (!isCompact) ...[
                      const SizedBox(height: 2),
                      const Text(
                        'Offline Ready',
                        style: TextStyle(
                          color: Color(0xFFDBEAFE),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildKolomTengah({
    required bool isCompact,
    required List<CatatanModel> catatanList,
    required int totalCatatan,
    required int matkulTercatat,
    required int tugasAktif,
    required int persenMateri,
    required int persenTugas,
    required int persenMatkul,
  }) {
    final sapaanNama =
        _currentName.isNotEmpty ? _currentName : 'Mahasiswa Informatika';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. BANNER SAPAAN (RESPONSIF HP & LAPTOP)
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isCompact ? 20 : 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildHeroProfileBox(size: 74, isCompact: true),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _formatTanggalHariIni(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2383E2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Halo, $sapaanNama!',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Kamu memiliki $totalCatatan catatan kuliah tersimpan dan $tugasAktif pengingat tugas aktif. Yuk kelola sesi kuliahmu hari ini!',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _bukaHalaman(const FormScreen()),
                          icon: const Icon(Icons.add_task_rounded, size: 18),
                          label: const Text(
                            'Buat Sesi Kelas',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2383E2),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () =>
                              _bukaHalaman(const DaftarCatatanScreen()),
                          icon:
                              const Icon(Icons.auto_stories_outlined, size: 17),
                          label: const Text(
                            'Buka StudyLog',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1E293B),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _formatTanggalHariIni(),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2383E2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Halo, $sapaanNama!',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kamu memiliki $totalCatatan catatan kuliah tersimpan dan $tugasAktif pengingat tugas aktif. Yuk kelola sesi kuliahmu hari ini!',
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF64748B),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _bukaHalaman(const FormScreen()),
                                icon: const Icon(Icons.add_task_rounded,
                                    size: 18),
                                label: const Text(
                                  'Buat Sesi Kelas',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2383E2),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _bukaHalaman(const DaftarCatatanScreen()),
                                icon: const Icon(Icons.auto_stories_outlined,
                                    size: 17),
                                label: const Text(
                                  'Buka StudyLog',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF1E293B),
                                  side: const BorderSide(
                                      color: Color(0xFFCBD5E1)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildHeroProfileBox(size: 145, isCompact: false),
                  ],
                ),
        ),
        const SizedBox(height: 22),

        // 2. GRAFIK STATISTIK & RINGKASAN PROGRES
        if (isCompact) ...[
          _buildBarChartCard(catatanList, totalCatatan, matkulTercatat),
          const SizedBox(height: 18),
          _buildProgressRingsCard(persenMateri, persenTugas, persenMatkul),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: _buildBarChartCard(
                    catatanList, totalCatatan, matkulTercatat),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 5,
                child: _buildProgressRingsCard(
                    persenMateri, persenTugas, persenMatkul),
              ),
            ],
          ),
        const SizedBox(height: 22),

        // 3. KARTU DOSEN PENGAMPU
        _buildDosenPengampuCard(),
      ],
    );
  }

  Widget _buildBarChartCard(
    List<CatatanModel> catatanList,
    int totalCatatan,
    int matkulTercatat,
  ) {
    final counts = <int>[];
    int maxCount = 1;

    for (final m in _daftarMatkul) {
      final jumlah = catatanList.where((c) => c.mataKuliah == m.nama).length;
      counts.add(jumlah);
      if (jumlah > maxCount) maxCount = jumlah;
    }

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Statistik Catatan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Semester 5',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalCatatan',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  'Sesi di $matkulTercatat Mata Kuliah',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _bukaHalaman(const DaftarCatatanScreen()),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Semua',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2383E2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_daftarMatkul.length, (index) {
                final item = _daftarMatkul[index];
                final count = counts[index];
                final ratio =
                    count == 0 ? 0.14 : (0.25 + (count / maxCount) * 0.75);
                final barHeight = 84.0 * ratio;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: count > 0
                                ? const Color(0xFF2383E2)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          height: barHeight,
                          width: 18,
                          decoration: BoxDecoration(
                            color: count > 0
                                ? const Color(0xFF2383E2)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.kode,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRingsCard(
    int persenMateri,
    int persenTugas,
    int persenMatkul,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan Progres',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              Icon(Icons.pie_chart_outline_rounded,
                  size: 18, color: Color(0xFF2383E2)),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildSingleRing(
                  label: 'Materi Terisi',
                  percent: persenMateri,
                  color: const Color(0xFF2383E2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSingleRing(
                  label: 'Tugas Selesai',
                  percent: persenTugas,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildSingleRing(
                  label: 'Cakupan Matkul',
                  percent: persenMatkul,
                  color: const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSingleRing(
                  label: '23 SKS Aktif',
                  percent: 100,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleRing({
    required String label,
    required int percent,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: (percent / 100).clamp(0.0, 1.0),
                  strokeWidth: 5.5,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosenPengampuCard() {
    final dosenList = [
      _daftarMatkul[7],
      _daftarMatkul[4],
      _daftarMatkul[0],
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dosen Pengampu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextButton(
                onPressed: () => _bukaHalaman(const ScheduleScreen()),
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2383E2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...dosenList.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: item.warna.withValues(alpha: 0.14),
                    child:
                        Icon(Icons.person_rounded, color: item.warna, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.dosen,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Lihat Jadwal Kelas',
                    onPressed: () => _bukaHalaman(const ScheduleScreen()),
                    icon: const Icon(Icons.calendar_month_outlined,
                        size: 19, color: Color(0xFF2383E2)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKolomKanan(List<CatatanModel> tugasAktifList) {
    final todayWeekday = DateTime.now().weekday;
    final targetHari =
        (todayWeekday >= 1 && todayWeekday <= 5) ? todayWeekday : 1;
    const namaHariMap = {
      1: 'Senin',
      2: 'Selasa',
      3: 'Rabu',
      4: 'Kamis',
      5: 'Jumat',
    };

    final jadwalHariIni =
        _daftarMatkul.where((m) => m.hari == targetHari).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. JADWAL KULIAH HARI INI
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jadwal Kuliah',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Hari ${namaHariMap[targetHari]}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2383E2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(jadwalHariIni.length, (index) {
                final item = jadwalHariIni[index];
                final isHighlighted = index == 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () => _bukaHalaman(const ScheduleScreen()),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? const Color(0xFF2383E2)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: isHighlighted
                            ? null
                            : Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.access_time_filled_rounded,
                              size: 18,
                              color: isHighlighted
                                  ? Colors.white
                                  : const Color(0xFF2383E2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nama,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: isHighlighted
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.jam} • ${item.ruang}',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isHighlighted
                                        ? Colors.white.withValues(alpha: 0.88)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // 2. TENGGAT TUGAS TERDEKAT
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tenggat Tugas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _bukaHalaman(const PengingatTugasScreen()),
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2383E2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (tugasAktifList.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.task_alt_rounded,
                          size: 32, color: Color(0xFF10B981)),
                      SizedBox(height: 8),
                      Text(
                        'Belum ada tenggat tugas mendesak',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Atur jadwal pengumpulan tugas di dalam detail catatan StudyLog.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...tugasAktifList.take(3).map((tugas) {
                  final d = tugas.deadline!;
                  final jam = d.hour.toString().padLeft(2, '0');
                  final menit = d.minute.toString().padLeft(2, '0');
                  final waktuStr =
                      '${d.day}/${d.month}/${d.year} • $jam:$menit';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: InkWell(
                      onTap: () =>
                          _bukaHalaman(DetailCatatanScreen(catatan: tugas)),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.alarm_rounded,
                                  size: 18, color: Color(0xFFDC2626)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tugas.judul,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${tugas.mataKuliah} • $waktuStr',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFFB91C1C),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar({double size = 36}) {
    final imageProvider = _resolveProfileImage();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF2383E2),
        borderRadius: BorderRadius.circular(10),
        image: imageProvider != null
            ? DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageProvider == null
          ? Center(
              child: Icon(Icons.person, color: Colors.white, size: size * 0.55),
            )
          : null,
    );
  }

  Widget _buildSidebar({required bool isDrawer}) {
    return Container(
      width: 260,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F5),
        border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: AnimatedHeaderTitle(),
            ),
            InkWell(
              onTap: () {
                if (isDrawer) Navigator.pop(context);
                _bukaProfil();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    _buildProfileAvatar(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentName.isEmpty
                                ? 'Belum ada nama'
                                : _currentName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _currentName.isEmpty
                                  ? Colors.grey
                                  : const Color(0xFF37352F),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _currentNim.isEmpty
                                ? 'NIM: -'
                                : 'NIM: $_currentNim',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        size: 18, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE0E0DE)),
            const SizedBox(height: 16),
            HoverableSidebarItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              isSelected: true,
              onTap: () {
                if (isDrawer) Navigator.pop(context);
              },
            ),
            HoverableSidebarItem(
              icon: Icons.add_task_rounded,
              title: 'Buat Sesi Kelas',
              onTap: () => _bukaHalaman(
                const FormScreen(),
                tutupDrawer: isDrawer,
                gantiHalaman: true,
              ),
            ),
            HoverableSidebarItem(
              icon: Icons.task_alt,
              title: 'Pengingat Tugas',
              onTap: () => _bukaHalaman(
                const PengingatTugasScreen(),
                tutupDrawer: isDrawer,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                'AKADEMIK & MENU',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            HoverableSidebarItem(
              icon: Icons.list_alt,
              title: 'StudyLog',
              onTap: () => _bukaHalaman(
                const DaftarCatatanScreen(),
                tutupDrawer: isDrawer,
              ),
            ),
            HoverableSidebarItem(
              icon: Icons.school_outlined,
              title: 'Jadwal Kuliah',
              onTap: () => _bukaHalaman(
                const ScheduleScreen(),
                tutupDrawer: isDrawer,
              ),
            ),
            HoverableSidebarItem(
              icon: Icons.code,
              title: 'Project Portofolio',
              onTap: () => _bukaHalaman(
                const ProjectPortofolioScreen(),
                tutupDrawer: isDrawer,
              ),
            ),
            const Spacer(),
            const Divider(height: 1, color: Color(0xFFE0E0DE)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: HoverableSidebarItem(
                icon: Icons.logout,
                title: 'Kembali ke Login',
                onTap: () => _bukaHalaman(
                  const ModernLoginScreen(),
                  tutupDrawer: isDrawer,
                  gantiHalaman: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
