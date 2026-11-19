import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_store.dart';
import 'detail_catatan_screen.dart';
import 'form_screen.dart';

class DaftarCatatanScreen extends StatefulWidget {
  const DaftarCatatanScreen({super.key});

  @override
  State<DaftarCatatanScreen> createState() => _DaftarCatatanScreenState();
}

class _DaftarCatatanScreenState extends State<DaftarCatatanScreen> {
  String _searchQuery = '';
  String _selectedFilterMatkul = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  final Map<String, Map<String, dynamic>> mataKuliahStyle = {
    'Sistem Manajemen Basis Data': {
      'dosen': 'NASRUDDIN BIN IDRIS, S.Kom., M.Kom.',
      'color': const Color(0xFF0D9488), // Teal
      'icon': Icons.storage_rounded,
    },
    'Teknologi Aplikasi Bergerak': {
      'dosen': 'ISTIA BUDI, S.T., M.M.',
      'color': const Color(0xFF2563EB), // Royal Blue
      'icon': Icons.phone_android_rounded,
    },
    'Penalaran Komputer': {
      'dosen': 'ISA ROSITA, S.Kom., M.Cs.',
      'color': const Color(0xFFE11D48), // Rose
      'icon': Icons.psychology_rounded,
    },
    'Simulasi dan Game Komputer': {
      'dosen': 'HERUZULKIFLI ROWA, S.Kom, M.Kom',
      'color': const Color(0xFFD97706), // Amber
      'icon': Icons.sports_esports_rounded,
    },
    'Kriptografi': {
      'dosen': 'MUHAMMAD SAFI\'I, S.Kom., M.Kom.',
      'color': const Color(0xFF7C3AED), // Violet
      'icon': Icons.enhanced_encryption_rounded,
    },
    'Penulisan dan Publikasi Ilmiah': {
      'dosen': 'YUSTIAN SERVANDA, S.Kom., M.Kom.',
      'color': const Color(0xFF475569), // Slate
      'icon': Icons.article_rounded,
    },
    'Jaringan Nirkabel': {
      'dosen': 'MARADONA, S.Kom., M.Kom.',
      'color': const Color(0xFF0284C7), // Sky Blue
      'icon': Icons.wifi_tethering_rounded,
    },
    'Pemrograman Aplikasi Bergerak': {
      'dosen': 'PRAMUDYA PRIMA INSAN, S.Kom., M.Kom.',
      'color': const Color(0xFF4F46E5), // Indigo
      'icon': Icons.developer_mode_rounded,
    },
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getCourseStyle(String mataKuliah) {
    return mataKuliahStyle[mataKuliah] ??
        {
          'dosen': 'Dosen Pengampu',
          'color': const Color(0xFF2383E2),
          'icon': Icons.menu_book_rounded,
        };
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1050;
    final isMobile = screenWidth < 680;

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
            tooltip: 'Kembali ke Beranda',
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FormScreen()),
                );
              }
            },
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
                Icons.auto_stories_rounded,
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
                    'Daftar Catatan',
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
                    'StudyLog • Universitas Mulia',
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
          OutlinedButton.icon(
            onPressed: () => showNotionImportDialog(context),
            icon: const Icon(Icons.download_rounded,
                size: 16, color: Color(0xFF2383E2)),
            label: Text(
              isMobile ? 'Impor' : 'Impor Teman',
              style: const TextStyle(
                color: Color(0xFF2383E2),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFBFDBFE)),
              backgroundColor: const Color(0xFFEFF6FF),
              padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 10 : 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Consumer<CatatanStore>(
            builder: (context, store, _) {
              return Container(
                margin: EdgeInsets.only(right: isMobile ? 12 : 16, left: 8),
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.folder_copy_outlined,
                        size: 14, color: Color(0xFF475569)),
                    const SizedBox(width: 6),
                    Text(
                      '${store.catatanList.length} Sesi',
                      style: const TextStyle(
                        color: Color(0xFF334155),
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
          final allCatatan = store.catatanList.reversed.toList();

          final filteredList = allCatatan.where((catatan) {
            final matchesSearch = catatan.judul
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                catatan.mataKuliah
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                catatan.isi.toLowerCase().contains(_searchQuery.toLowerCase());

            final matchesFilter = _selectedFilterMatkul == 'Semua' ||
                catatan.mataKuliah == _selectedFilterMatkul;

            return matchesSearch && matchesFilter;
          }).toList();

          final filterOptions = [
            'Semua',
            ...allCatatan.map((e) => e.mataKuliah).toSet(),
          ];

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Pencarian & Filter Responsif
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isMobile ? 16 : 28,
                      20,
                      isMobile ? 16 : 28,
                      12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A)
                                    .withValues(alpha: 0.03),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Cari judul sesi, mata kuliah, atau ringkasan materi...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: Color(0xFF64748B),
                                size: 20,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded,
                                          size: 18, color: Color(0xFF94A3B8)),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                        if (allCatatan.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: filterOptions.map((matkul) {
                                final isSelected =
                                    _selectedFilterMatkul == matkul;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChoiceChip(
                                    label: Text(matkul),
                                    selected: isSelected,
                                    onSelected: (_) {
                                      setState(() {
                                        _selectedFilterMatkul = matkul;
                                      });
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
                                    selectedColor: const Color(0xFF2383E2),
                                    side: BorderSide(
                                      color: isSelected
                                          ? const Color(0xFF2383E2)
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
                      ],
                    ),
                  ),

                  // Konten Daftar Catatan (Grid di Web/Tablet, List di HP)
                  Expanded(
                    child: filteredList.isEmpty
                        ? _buildEmptyState(context, allCatatan.isEmpty)
                        : isMobile
                            ? ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 28),
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final catatan = filteredList[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 14.0),
                                    child: _ModernCatatanCard(
                                      catatan: catatan,
                                      styleInfo:
                                          _getCourseStyle(catatan.mataKuliah),
                                      isGridCard: false,
                                      onOpen: () =>
                                          _bukaCatatan(context, catatan),
                                      onShare: () => showNotionShareDialog(
                                          context, catatan),
                                      onDelete: () =>
                                          _konfirmasiHapus(context, catatan.id),
                                    ),
                                  );
                                },
                              )
                            : GridView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(28, 8, 28, 32),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isDesktop ? 3 : 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  mainAxisExtent: 280,
                                ),
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final catatan = filteredList[index];
                                  return _ModernCatatanCard(
                                    catatan: catatan,
                                    styleInfo:
                                        _getCourseStyle(catatan.mataKuliah),
                                    isGridCard: true,
                                    onOpen: () =>
                                        _bukaCatatan(context, catatan),
                                    onShare: () =>
                                        showNotionShareDialog(context, catatan),
                                    onDelete: () =>
                                        _konfirmasiHapus(context, catatan.id),
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
    );
  }

  void _bukaCatatan(BuildContext context, CatatanModel catatan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailCatatanScreen(catatan: catatan),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isCompletelyEmpty) {
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
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
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
                      ? Icons.note_add_outlined
                      : Icons.search_off_rounded,
                  size: 40,
                  color: const Color(0xFF2383E2),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isCompletelyEmpty
                    ? 'Belum Ada Sesi Kelas'
                    : 'Catatan Tidak Ditemukan',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isCompletelyEmpty
                    ? 'Buat sesi kelas baru atau impor catatan yang dibagikan temanmu.'
                    : 'Coba gunakan kata kunci pencarian lain atau ubah filter mata kuliah.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              if (isCompletelyEmpty) ...[
                const SizedBox(height: 22),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FormScreen()),
                          );
                        }
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text(
                        'Buat Sesi Kelas',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2383E2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => showNotionImportDialog(context),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text(
                        'Impor Teman',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2383E2),
                        side: const BorderSide(color: Color(0xFFBFDBFE)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
              'Hapus Catatan?',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Sesi catatan beserta ringkasan materi di dalamnya akan dihapus permanen.',
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

class _ModernCatatanCard extends StatefulWidget {
  final CatatanModel catatan;
  final Map<String, dynamic> styleInfo;
  final bool isGridCard;
  final VoidCallback onOpen;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const _ModernCatatanCard({
    required this.catatan,
    required this.styleInfo,
    required this.isGridCard,
    required this.onOpen,
    required this.onShare,
    required this.onDelete,
  });

  @override
  State<_ModernCatatanCard> createState() => _ModernCatatanCardState();
}

class _ModernCatatanCardState extends State<_ModernCatatanCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color accentColor = widget.styleInfo['color'] as Color;
    final IconData courseIcon = widget.styleInfo['icon'] as IconData;
    final String dosenName = widget.styleInfo['dosen'] as String;

    final hasDeadline = widget.catatan.deadline != null;
    String deadlineLabel = '';
    if (hasDeadline) {
      final d = widget.catatan.deadline!;
      deadlineLabel =
          '${d.day}/${d.month} • ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? accentColor.withValues(alpha: 0.5)
                : const Color(0xFFE2E8F0),
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? accentColor.withValues(alpha: 0.12)
                  : const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: _isHovered ? 20 : 12,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: widget.onOpen,
            borderRadius: BorderRadius.circular(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    widget.isGridCard ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  // Garis Aksen Warna di Atas Kartu
                  Container(
                    height: 4,
                    width: double.infinity,
                    color: accentColor,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge Mata Kuliah & Deadline
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(courseIcon,
                                        size: 14, color: accentColor),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        widget.catatan.mataKuliah,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11.5,
                                          color: accentColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (hasDeadline) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xFFFECACA)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.alarm_rounded,
                                        size: 12, color: Color(0xFFDC2626)),
                                    const SizedBox(width: 4),
                                    Text(
                                      deadlineLabel,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFDC2626),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Judul Catatan
                        Text(
                          widget.catatan.judul.isNotEmpty
                              ? widget.catatan.judul
                              : 'Catatan Tanpa Judul',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Pratinjau Isi Catatan
                        Text(
                          widget.catatan.isi.isNotEmpty
                              ? widget.catatan.isi
                              : 'Belum ada ringkasan materi...',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.isGridCard) const Spacer(),

                  // Info Dosen & Tanggal
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded,
                                size: 14, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                dosenName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 13, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 6),
                            Text(
                              widget.catatan.tanggal,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),

                  // Footer Tombol Aksi
                  Container(
                    color: const Color(0xFFFAFAFC),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: widget.onOpen,
                          style: TextButton.styleFrom(
                            foregroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.open_in_new_rounded, size: 15),
                          label: const Text(
                            'Buka Catatan',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: widget.onShare,
                              tooltip: 'Bagikan Catatan',
                              icon: const Icon(
                                Icons.ios_share_rounded,
                                color: Color(0xFF2383E2),
                                size: 18,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                            IconButton(
                              onPressed: widget.onDelete,
                              tooltip: 'Hapus Catatan',
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                                size: 19,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
