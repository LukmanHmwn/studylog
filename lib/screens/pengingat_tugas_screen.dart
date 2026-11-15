import 'dart:async';
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

  String _selectedFilter = 'Semua';
  Timer? _clockTimer;

  final List<String> _daftarMataKuliah = [
    'Umum',
    'Sistem Manajemen Basis Data',
    'Teknologi Aplikasi Bergerak',
    'Penalaran Komputer',
    'Simulasi dan Game Komputer',
    'Kriptografi',
    'Penulisan dan Publikasi Ilmiah',
    'Jaringan Nirkabel',
    'Pemrograman Aplikasi Bergerak',
  ];

  final Map<String, Map<String, dynamic>> _mataKuliahStyle = {
    'Sistem Manajemen Basis Data': {
      'color': const Color(0xFF0D9488),
      'icon': Icons.storage_rounded,
    },
    'Teknologi Aplikasi Bergerak': {
      'color': const Color(0xFF2563EB),
      'icon': Icons.phone_android_rounded,
    },
    'Penalaran Komputer': {
      'color': const Color(0xFFE11D48),
      'icon': Icons.psychology_rounded,
    },
    'Simulasi dan Game Komputer': {
      'color': const Color(0xFFD97706),
      'icon': Icons.sports_esports_rounded,
    },
    'Kriptografi': {
      'color': const Color(0xFF7C3AED),
      'icon': Icons.enhanced_encryption_rounded,
    },
    'Penulisan dan Publikasi Ilmiah': {
      'color': const Color(0xFF475569),
      'icon': Icons.article_rounded,
    },
    'Jaringan Nirkabel': {
      'color': const Color(0xFF0284C7),
      'icon': Icons.wifi_tethering_rounded,
    },
    'Pemrograman Aplikasi Bergerak': {
      'color': const Color(0xFF4F46E5),
      'icon': Icons.developer_mode_rounded,
    },
  };

  @override
  void initState() {
    super.initState();
    // Pembaruan otomatis setiap 30 detik agar status melewati batas waktu selalu akurat
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });

    // Tampilkan notifikasi pengingat otomatis saat layar dibuka jika ada tugas belum selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final store = Provider.of<CatatanStore>(context, listen: false);
      final sekarang = DateTime.now();
      final tugasAktif = store.catatanList
          .where((c) => c.deadline != null && !c.isSelesai)
          .toList();

      if (tugasAktif.isNotEmpty) {
        final lewatBatas =
            tugasAktif.where((c) => c.deadline!.isBefore(sekarang)).length;

        final pesanNotif = lewatBatas > 0
            ? 'Pengingat: Ada ${tugasAktif.length} tugas belum selesai ($lewatBatas melewati batas waktu)!'
            : 'Pengingat: Kamu memiliki ${tugasAktif.length} tugas yang belum diselesaikan.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
            backgroundColor: lewatBatas > 0
                ? const Color(0xFFB91C1C)
                : const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                Icon(
                  lewatBatas > 0
                      ? Icons.notification_important_rounded
                      : Icons.notifications_active_rounded,
                  color: Colors.amberAccent,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    pesanNotif,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getCourseStyle(String mataKuliah) {
    return _mataKuliahStyle[mataKuliah] ??
        {
          'color': const Color(0xFF2383E2),
          'icon': Icons.assignment_rounded,
        };
  }

  String _formatTanggalIndo(DateTime date) {
    const hariList = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
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
      'Desember'
    ];
    return '${hariList[date.weekday - 1]}, ${date.day} ${bulanList[date.month - 1]} ${date.year}';
  }

  void _tampilkanFormTambah(BuildContext context) {
    String selectedMatkul = 'Umum';
    DateTime selectedDeadline = DateTime.now().add(const Duration(hours: 3));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final jamStr =
                '${selectedDeadline.hour.toString().padLeft(2, '0')}:${selectedDeadline.minute.toString().padLeft(2, '0')}';
            final tglStr =
                '${selectedDeadline.day}/${selectedDeadline.month}/${selectedDeadline.year} • Jam $jamStr';

            return Center(
              widthFactor: 1,
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                    left: 24,
                    right: 24,
                    top: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFCBD5E1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2383E2)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.add_alarm_rounded,
                                    color: Color(0xFF2383E2)),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Tambah Pengingat Tugas',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: selectedMatkul,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Mata Kuliah',
                              prefixIcon:
                                  const Icon(Icons.class_outlined, size: 20),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            items: _daftarMataKuliah
                                .map((mk) => DropdownMenuItem(
                                      value: mk,
                                      child: Text(
                                        mk,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => selectedMatkul = val);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _judulController,
                            decoration: InputDecoration(
                              labelText: 'Judul Tugas',
                              hintText: 'Contoh: Laporan Praktikum Modul 4',
                              prefixIcon:
                                  const Icon(Icons.title_rounded, size: 20),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Judul tugas wajib diisi'
                                    : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _deskripsiController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Deskripsi / Detail Tugas',
                              hintText:
                                  'Tuliskan rincian tugas atau ketentuan pengumpulan...',
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Deskripsi wajib diisi'
                                    : null,
                          ),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDeadline,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (pickedDate == null || !context.mounted)
                                return;

                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime:
                                    TimeOfDay.fromDateTime(selectedDeadline),
                              );
                              if (pickedTime == null) return;

                              setModalState(() {
                                selectedDeadline = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFBFDBFE)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.event_available_rounded,
                                      color: Color(0xFF2563EB), size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Batas Waktu Penyelesaian (Deadline)',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF3B82F6),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          tglStr,
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1E3A8A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Ubah',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final catatanBaru = CatatanModel(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    judul: _judulController.text.trim(),
                                    mataKuliah: selectedMatkul,
                                    isi: _deskripsiController.text.trim(),
                                    tanggal: _formatTanggalIndo(DateTime.now()),
                                    deadline: selectedDeadline,
                                    isSelesai: false,
                                  );

                                  Provider.of<CatatanStore>(this.context,
                                          listen: false)
                                      .tambahCatatan(catatanBaru);

                                  _judulController.clear();
                                  _deskripsiController.clear();
                                  Navigator.pop(modalContext);

                                  ScaffoldMessenger.of(this.context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Pengingat tugas berhasil ditambahkan!'),
                                      backgroundColor: Color(0xFF16A34A),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.check_circle_rounded,
                                  size: 19),
                              label: const Text(
                                'Simpan Tugas',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2383E2),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1050;
    final isMobile = screenWidth < 680;
    final sekarang = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        toolbarHeight: 68,
        titleSpacing: isMobile ? 4 : 16,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon:
                const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
            tooltip: 'Kembali',
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2383E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                color: Color(0xFF2383E2),
                size: 20,
              ),
            ),
            SizedBox(width: isMobile ? 10 : 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pengingat Tugas',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Pantau Tenggat & Status Tugas',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Consumer<CatatanStore>(
            builder: (context, store, _) {
              final belumSelesai = store.catatanList
                  .where((c) => c.deadline != null && !c.isSelesai)
                  .length;
              return Container(
                margin: EdgeInsets.only(right: isMobile ? 12 : 16, left: 6),
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 12, vertical: 6),
                decoration: BoxDecoration(
                  color: belumSelesai > 0
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: belumSelesai > 0
                        ? const Color(0xFFFDE68A)
                        : const Color(0xFFBBF7D0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      belumSelesai > 0
                          ? Icons.pending_actions_rounded
                          : Icons.verified_rounded,
                      size: 14,
                      color: belumSelesai > 0
                          ? const Color(0xFFB45309)
                          : const Color(0xFF15803D),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$belumSelesai Aktif',
                      style: TextStyle(
                        color: belumSelesai > 0
                            ? const Color(0xFFB45309)
                            : const Color(0xFF15803D),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: Consumer<CatatanStore>(
        builder: (context, store, child) {
          final semuaTugas = store.catatanList
              .where((c) => c.deadline != null)
              .toList()
              .reversed
              .toList();

          final belumSelesaiList =
              semuaTugas.where((t) => !t.isSelesai).toList();
          final lewatBatasList = belumSelesaiList
              .where((t) => t.deadline!.isBefore(sekarang))
              .toList();
          final selesaiList = semuaTugas.where((t) => t.isSelesai).toList();

          final filteredTugas = semuaTugas.where((tugas) {
            if (_selectedFilter == 'Belum Selesai') {
              return !tugas.isSelesai;
            } else if (_selectedFilter == 'Melewati Batas') {
              return !tugas.isSelesai && tugas.deadline!.isBefore(sekarang);
            } else if (_selectedFilter == 'Selesai') {
              return tugas.isSelesai;
            }
            return true;
          }).toList();

          final filterTabs = [
            'Semua',
            'Belum Selesai',
            'Melewati Batas',
            'Selesai',
          ];

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Notifikasi Pengingat Tugas yang Belum Selesai / Melewati Batas
                  if (belumSelesaiList.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        isMobile ? 16 : 28,
                        18,
                        isMobile ? 16 : 28,
                        0,
                      ),
                      child: _buildReminderBanner(
                        belumSelesaiCount: belumSelesaiList.length,
                        lewatBatasCount: lewatBatasList.length,
                        isMobile: isMobile,
                        onFilterTap: () {
                          setState(() {
                            _selectedFilter = lewatBatasList.isNotEmpty
                                ? 'Melewati Batas'
                                : 'Belum Selesai';
                          });
                        },
                      ),
                    ),

                  // Ringkasan Statistik & Filter Chip
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isMobile ? 16 : 28,
                      16,
                      isMobile ? 16 : 28,
                      12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                label: 'Belum Selesai',
                                count: belumSelesaiList.length,
                                color: const Color(0xFF2563EB),
                                icon: Icons.hourglass_top_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildStatCard(
                                label: 'Lewat Waktu',
                                count: lewatBatasList.length,
                                color: const Color(0xFFDC2626),
                                icon: Icons.warning_amber_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildStatCard(
                                label: 'Selesai',
                                count: selesaiList.length,
                                color: const Color(0xFF16A34A),
                                icon: Icons.check_circle_outline_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: filterTabs.map((tab) {
                              final isSelected = _selectedFilter == tab;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(tab),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setState(() => _selectedFilter = tab);
                                  },
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF475569),
                                  ),
                                  backgroundColor: Colors.white,
                                  selectedColor: tab == 'Melewati Batas'
                                      ? const Color(0xFFDC2626)
                                      : tab == 'Selesai'
                                          ? const Color(0xFF16A34A)
                                          : const Color(0xFF2383E2),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : const Color(0xFFE2E8F0),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  showCheckmark: false,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Daftar Kartu Tugas (Grid di Web/Tablet, List di HP)
                  Expanded(
                    child: filteredTugas.isEmpty
                        ? _buildEmptyState(semuaTugas.isEmpty)
                        : isMobile
                            ? ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 88),
                                itemCount: filteredTugas.length,
                                itemBuilder: (context, index) {
                                  final tugas = filteredTugas[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 14.0),
                                    child: _ModernTugasCard(
                                      tugas: tugas,
                                      styleInfo:
                                          _getCourseStyle(tugas.mataKuliah),
                                      isGridCard: false,
                                      onToggleSelesai: () =>
                                          _handleToggleSelesai(store, tugas),
                                      onOpenDetail: () =>
                                          _bukaDetail(context, tugas),
                                      onDelete: () =>
                                          _konfirmasiHapus(context, tugas.id),
                                    ),
                                  );
                                },
                              )
                            : GridView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(28, 8, 28, 88),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isDesktop ? 3 : 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  mainAxisExtent: 315,
                                ),
                                itemCount: filteredTugas.length,
                                itemBuilder: (context, index) {
                                  final tugas = filteredTugas[index];
                                  return _ModernTugasCard(
                                    tugas: tugas,
                                    styleInfo:
                                        _getCourseStyle(tugas.mataKuliah),
                                    isGridCard: true,
                                    onToggleSelesai: () =>
                                        _handleToggleSelesai(store, tugas),
                                    onOpenDetail: () =>
                                        _bukaDetail(context, tugas),
                                    onDelete: () =>
                                        _konfirmasiHapus(context, tugas.id),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _tampilkanFormTambah(context),
        backgroundColor: const Color(0xFF2383E2),
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Tugas',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _handleToggleSelesai(CatatanStore store, CatatanModel tugas) {
    final akanSelesai = !tugas.isSelesai;
    store.toggleSelesai(tugas.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor:
            akanSelesai ? const Color(0xFF16A34A) : const Color(0xFF475569),
        content: Text(
          akanSelesai
              ? 'Mantap! Tugas "${tugas.judul}" ditandai selesai.'
              : 'Status tugas "${tugas.judul}" dikembalikan ke belum selesai.',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _bukaDetail(BuildContext context, CatatanModel tugas) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailCatatanScreen(catatan: tugas),
      ),
    );
  }

  Widget _buildReminderBanner({
    required int belumSelesaiCount,
    required int lewatBatasCount,
    required bool isMobile,
    required VoidCallback onFilterTap,
  }) {
    final isOverdueAlert = lewatBatasCount > 0;
    final bgColor =
        isOverdueAlert ? const Color(0xFFFEF2F2) : const Color(0xFFFFFBEB);
    final borderColor =
        isOverdueAlert ? const Color(0xFFFECACA) : const Color(0xFFFDE68A);
    final iconBgColor =
        isOverdueAlert ? const Color(0xFFDC2626) : const Color(0xFFD97706);
    final titleColor =
        isOverdueAlert ? const Color(0xFF991B1B) : const Color(0xFF92400E);

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isOverdueAlert
                  ? Icons.notification_important_rounded
                  : Icons.notifications_active_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOverdueAlert
                      ? 'Perhatian! Ada $lewatBatasCount Tugas Melewati Batas Waktu'
                      : 'Pengingat: $belumSelesaiCount Tugas Belum Selesai',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isOverdueAlert
                      ? 'Total $belumSelesaiCount tugas masih aktif. Segera selesaikan dan tekan tombol Selesai.'
                      : 'Jangan lupa selesaikan tugas sebelum melewati batas waktu pengumpulan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: titleColor.withValues(alpha: 0.85),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 12),
            TextButton(
              onPressed: onFilterTap,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: iconBgColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: borderColor),
                ),
              ),
              child: const Text(
                'Tampilkan',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isCompletelyEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2383E2).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompletelyEmpty
                      ? Icons.task_alt_rounded
                      : Icons.filter_list_off_rounded,
                  size: 40,
                  color: const Color(0xFF2383E2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isCompletelyEmpty
                    ? 'Hore! Tidak Ada Tugas Saat Ini'
                    : 'Tidak Ada Tugas di Kategori Ini',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isCompletelyEmpty
                    ? 'Tekan tombol "+ Tambah Tugas" di kanan bawah untuk membuat pengingat deadline baru.'
                    : 'Pilih tab filter "Semua" untuk melihat seluruh daftar pengingat tugasmu.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _konfirmasiHapus(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              'Hapus Tugas?',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Pengingat tugas ini akan dihapus permanen dari daftar.',
          style: TextStyle(color: Color(0xFF475569), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(
                  color: Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Provider.of<CatatanStore>(context, listen: false)
                  .hapusCatatan(id);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _ModernTugasCard extends StatefulWidget {
  final CatatanModel tugas;
  final Map<String, dynamic> styleInfo;
  final bool isGridCard;
  final VoidCallback onToggleSelesai;
  final VoidCallback onOpenDetail;
  final VoidCallback onDelete;

  const _ModernTugasCard({
    required this.tugas,
    required this.styleInfo,
    required this.isGridCard,
    required this.onToggleSelesai,
    required this.onOpenDetail,
    required this.onDelete,
  });

  @override
  State<_ModernTugasCard> createState() => _ModernTugasCardState();
}

class _ModernTugasCardState extends State<_ModernTugasCard> {
  bool _isHovered = false;

  String _formatDurasiRelatif(Duration diff, {required bool isOverdue}) {
    final absDiff = diff.abs();
    final prefix = isOverdue ? 'Terlambat' : 'Sisa waktu';
    if (absDiff.inDays >= 1) {
      final jamSisa = absDiff.inHours % 24;
      return jamSisa > 0
          ? '$prefix ${absDiff.inDays} hari $jamSisa jam'
          : '$prefix ${absDiff.inDays} hari';
    } else if (absDiff.inHours >= 1) {
      final menitSisa = absDiff.inMinutes % 60;
      return menitSisa > 0
          ? '$prefix ${absDiff.inHours} jam $menitSisa mnt'
          : '$prefix ${absDiff.inHours} jam';
    } else {
      final menit = absDiff.inMinutes < 1 ? 1 : absDiff.inMinutes;
      return '$prefix $menit menit';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color courseColor = widget.styleInfo['color'] as Color;
    final IconData courseIcon = widget.styleInfo['icon'] as IconData;

    final sekarang = DateTime.now();
    final deadline = widget.tugas.deadline!;
    final isSelesai = widget.tugas.isSelesai;
    final isOverdue = !isSelesai && deadline.isBefore(sekarang);
    final selisih = deadline.difference(sekarang);

    final Color topBarColor = isSelesai
        ? const Color(0xFF16A34A)
        : isOverdue
            ? const Color(0xFFDC2626)
            : courseColor;

    final String jamStr =
        '${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}';
    final String deadlineFormatted =
        '${deadline.day}/${deadline.month}/${deadline.year} • Jam $jamStr';

    final String statusRelatif = isSelesai
        ? 'Tugas telah diselesaikan'
        : _formatDurasiRelatif(selisih, isOverdue: isOverdue);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: isSelesai ? const Color(0xFFFAFFFC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOverdue
                ? const Color(0xFFFCA5A5)
                : isSelesai
                    ? const Color(0xFFBBF7D0)
                    : _isHovered
                        ? courseColor.withValues(alpha: 0.5)
                        : const Color(0xFFE2E8F0),
            width: isOverdue || _isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isOverdue
                  ? const Color(0xFFDC2626).withValues(alpha: 0.08)
                  : const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: _isHovered ? 20 : 12,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                widget.isGridCard ? MainAxisSize.max : MainAxisSize.min,
            children: [
              // Garis Aksen Status di Bagian Atas Kartu
              Container(
                height: 4,
                width: double.infinity,
                color: topBarColor,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris Badge Mata Kuliah & Status Batas Waktu
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 5),
                            decoration: BoxDecoration(
                              color: courseColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(courseIcon, size: 13, color: courseColor),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    widget.tugas.mataKuliah,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                      color: courseColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (isSelesai)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    size: 12, color: Color(0xFF15803D)),
                                SizedBox(width: 4),
                                Text(
                                  'Selesai',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF15803D),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (isOverdue)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xFFFECACA)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline_rounded,
                                    size: 12, color: Color(0xFFDC2626)),
                                SizedBox(width: 4),
                                Text(
                                  'Melewati Batas',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.schedule_rounded,
                                    size: 12, color: Color(0xFF2563EB)),
                                SizedBox(width: 4),
                                Text(
                                  'Aktif',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Judul Tugas
                    Text(
                      widget.tugas.judul.isNotEmpty
                          ? widget.tugas.judul
                          : 'Tugas Tanpa Judul',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        decoration: isSelesai
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: isSelesai
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF0F172A),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Deskripsi Tugas
                    Text(
                      widget.tugas.isi.isNotEmpty
                          ? widget.tugas.isi
                          : 'Tidak ada deskripsi tambahan.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.isGridCard) const Spacer(),

              // Kotak Informasi Tenggat & Status Waktu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: isSelesai
                        ? const Color(0xFFF0FDF4)
                        : isOverdue
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelesai
                          ? const Color(0xFFBBF7D0)
                          : isOverdue
                              ? const Color(0xFFFECACA)
                              : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelesai
                            ? Icons.task_alt_rounded
                            : isOverdue
                                ? Icons.alarm_off_rounded
                                : Icons.alarm_rounded,
                        size: 16,
                        color: isSelesai
                            ? const Color(0xFF16A34A)
                            : isOverdue
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF475569),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deadlineFormatted,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: isOverdue
                                    ? const Color(0xFF991B1B)
                                    : const Color(0xFF334155),
                              ),
                            ),
                            Text(
                              statusRelatif,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelesai
                                    ? const Color(0xFF15803D)
                                    : isOverdue
                                        ? const Color(0xFFDC2626)
                                        : const Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // Kolom Tombol Selesai & Aksi Kartu
              Container(
                color: const Color(0xFFFAFAFC),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: isSelesai
                          ? OutlinedButton.icon(
                              onPressed: widget.onToggleSelesai,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF16A34A),
                                side:
                                    const BorderSide(color: Color(0xFF86EFAC)),
                                backgroundColor: const Color(0xFFF0FDF4),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.check_circle_rounded,
                                  size: 16),
                              label: const Text(
                                'Selesai ✓',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: widget.onToggleSelesai,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF16A34A),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text(
                                'Selesai',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: widget.onOpenDetail,
                      tooltip: 'Buka Detail Catatan',
                      icon: const Icon(
                        Icons.open_in_new_rounded,
                        color: Color(0xFF475569),
                        size: 18,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      onPressed: widget.onDelete,
                      tooltip: 'Hapus Tugas',
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                        size: 19,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
