import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:provider/provider.dart';

import '../providers/catatan_store.dart';
import 'profile_detail_screen.dart';
import 'schedule_screen.dart';
import 'daftar_catatan_screen.dart';
import 'animated_login_screen.dart';
import 'project_portofolio_screen.dart';
import 'pengingat_tugas_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String _currentName = '';
  String _currentNim = '';
  String _currentDate = '';
  String? _profileImagePath;

  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _tasks = [
    {
      'matkul': 'Sistem Manajemen Basis Data',
      'jadwal': 'LAB A (FIKOM) • 19:00-20:30'
    },
    {
      'matkul': 'Teknologi Aplikasi Bergerak',
      'jadwal': 'LAB A (FIKOM) • 20:30-22:00'
    },
    {'matkul': 'Penalaran Komputer', 'jadwal': 'A201 • 19:00-20:30'},
    {
      'matkul': 'Simulasi dan Game Komputer',
      'jadwal': 'LAB A (FIKOM) • 20:30-22:00'
    },
    {'matkul': 'Kriptografi', 'jadwal': 'LAB ROBOTIK • 20:30-22:00'},
    {
      'matkul': 'Penulisan dan Publikasi Ilmiah',
      'jadwal': 'A203 • 20:30-22:00'
    },
    {
      'matkul': 'Jaringan Nirkabel',
      'jadwal': 'LAB JARINGAN (FIKOM) • 19:00-20:30'
    },
    {
      'matkul': 'Pemrograman Aplikasi Bergerak',
      'jadwal': 'LAB A (FIKOM) • 20:30-22:00'
    },
  ];

  String? _selectedMataKuliah;
  final TextEditingController _tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setTanggal(DateTime.now());
  }

  void _setTanggal(DateTime date) {
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

    final namaHari = hariList[date.weekday - 1];
    final namaBulan = bulanList[date.month - 1];

    setState(() {
      _currentDate = '$namaHari, ${date.day} $namaBulan ${date.year}';
      _tanggalController.text = _currentDate;
    });
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2383E2),
              onPrimary: Colors.white,
              onSurface: Color(0xFF37352F),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) _setTanggal(picked);
  }

  void _simpanCatatan() {
    if (_formKey.currentState!.validate()) {
      final judul = 'Sesi Kelas: ${_selectedMataKuliah ?? "Umum"}';
      const isi = 'Ketuk untuk melengkapi ringkasan materi perkuliahan...';
      final mataKuliah = _selectedMataKuliah ?? 'Mata Kuliah Umum';

      Provider.of<CatatanStore>(context, listen: false).tambahCatatan(
        CatatanModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          judul: judul,
          isi: isi,
          mataKuliah: mataKuliah,
          tanggal: _currentDate,
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi kelas berhasil dibuat!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() {
        _selectedMataKuliah = null;
      });
      _setTanggal(DateTime.now());
    }
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: isDesktop ? null : _buildSidebar(context),
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF37352F)),
              title: const AnimatedHeaderTitle(),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) _buildSidebar(context),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/gedungmulia.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 48.0 : 20.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('👋', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    const Text('Welcome to StudyLog',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF37352F),
                            letterSpacing: -1)),
                    const SizedBox(height: 16),
                    const Text(
                        'Ruang kerja akademik StudyLog khusus mahasiswa Universitas Mulia. Silakan buat sesi kelas di bawah ini.',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF505050),
                            height: 1.5)),
                    const SizedBox(height: 32),
                    const Divider(color: Color(0xFFEDEDED), thickness: 2),
                    const SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 32 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 20,
                              offset: const Offset(0, 4))
                        ],
                        border: Border.all(color: const Color(0xFFEAEAEA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF2383E2)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.add_task,
                                    color: Color(0xFF2383E2)),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                  child: Text('Buat Sesi Kelas',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF37352F)))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                              'Pilih tanggal dan mata kuliah untuk membuat draf catatan baru.',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF757575))),
                          const SizedBox(height: 32),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildModernTextField(
                                    controller: _tanggalController,
                                    label: 'Hari & Tanggal',
                                    icon: Icons.calendar_today_outlined,
                                    readOnly: true,
                                    onTap: () => _pilihTanggal(context)),
                                const SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  value: _selectedMataKuliah,
                                  isExpanded: true,
                                  hint: const Text('Pilih Mata Kuliah',
                                      style: TextStyle(
                                          color: Color(0xFF91918E),
                                          fontSize: 15)),
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF91918E)),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.class_outlined,
                                        color: Color(0xFF91918E), size: 20),
                                    filled: true,
                                    fillColor: const Color(0xFFF9F9F8),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEAEAEA))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEAEAEA))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF2383E2),
                                            width: 1.5)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.redAccent, width: 1)),
                                  ),
                                  selectedItemBuilder: (BuildContext context) {
                                    return _tasks
                                        .map<Widget>((item) => Text(
                                            item['matkul']!,
                                            style: const TextStyle(
                                                color: Color(0xFF37352F),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis))
                                        .toList();
                                  },
                                  items: _tasks.map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item['matkul'],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(item['matkul']!,
                                                style: const TextStyle(
                                                    color: Color(0xFF37352F),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            const SizedBox(height: 2),
                                            Text(item['jadwal']!,
                                                style: const TextStyle(
                                                    color: Color(0xFF757575),
                                                    fontSize: 12),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) => setState(
                                      () => _selectedMataKuliah = newValue),
                                  validator: (value) => value == null
                                      ? 'Silakan pilih mata kuliah terlebih dahulu'
                                      : null,
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _simpanCatatan,
                                    icon: const Icon(Icons.check_circle_outline,
                                        size: 20),
                                    label: const Text('Buat Sesi Kelas',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2383E2),
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shadowColor: const Color(0xFF2383E2)
                                          .withOpacity(0.5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      bool readOnly = false,
      VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(
          color: const Color(0xFF37352F),
          fontSize: 15,
          fontWeight: readOnly ? FontWeight.w500 : FontWeight.normal),
      validator: (value) => (value == null || value.trim().isEmpty)
          ? 'Bagian ini wajib diisi'
          : null,
      decoration: InputDecoration(
        labelText: readOnly ? null : label,
        hintText: readOnly ? null : label,
        labelStyle: const TextStyle(color: Color(0xFF91918E)),
        hintStyle: const TextStyle(color: Color(0xFF91918E)),
        prefixIcon: Icon(icon, color: const Color(0xFF91918E), size: 20),
        filled: true,
        fillColor: const Color(0xFFF9F9F8),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEAEAEA))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEAEAEA))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2383E2), width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(8),
        image: _profileImagePath != null
            ? DecorationImage(
                image: kIsWeb
                    ? NetworkImage(_profileImagePath!)
                    : FileImage(File(_profileImagePath!)) as ImageProvider,
                fit: BoxFit.cover)
            : null,
      ),
      child: _profileImagePath == null
          ? const Center(
              child: Icon(Icons.person, color: Colors.white, size: 20))
          : null,
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 260,
      height: double.infinity,
      color: const Color(0xFFF7F7F5),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: AnimatedHeaderTitle()),
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, a, b) => ProfileDetailScreen(
                            initialName: _currentName,
                            initialNim: _currentNim,
                            initialImagePath: _profileImagePath)));
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _currentName = result['name'] ?? '';
                    _currentNim = result['nim'] ?? '';
                    if (result['imagePath'] != null) {
                      _profileImagePath = result['imagePath'];
                    }
                  });
                }
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
                                  ? "Belum ada nama"
                                  : _currentName,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _currentName.isEmpty
                                      ? Colors.grey
                                      : const Color(0xFF37352F)),
                              overflow: TextOverflow.ellipsis),
                          Text(
                              _currentNim.isEmpty
                                  ? "NIM: -"
                                  : "NIM: $_currentNim",
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF757575))),
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
              icon: Icons.task_alt,
              title: 'Pengingat Tugas',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PengingatTugasScreen())),
            ),
            const SizedBox(height: 16),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text('AKADEMIK & MENU',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey))),
            HoverableSidebarItem(
                icon: Icons.list_alt,
                title: 'StudyLog',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DaftarCatatanScreen()))),
            HoverableSidebarItem(
                icon: Icons.school_outlined,
                title: 'Jadwal Kuliah',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScheduleScreen()))),
            HoverableSidebarItem(
                icon: Icons.code,
                title: 'Project Portofolio',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ProjectPortofolioScreen()))),
            const Spacer(),
            const Divider(height: 1, color: Color(0xFFE0E0DE)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: HoverableSidebarItem(
                  icon: Icons.logout,
                  title: 'Kembali ke Login',
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ModernLoginScreen()))),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedHeaderTitle extends StatefulWidget {
  const AnimatedHeaderTitle({super.key});
  @override
  State<AnimatedHeaderTitle> createState() => _AnimatedHeaderTitleState();
}

class _AnimatedHeaderTitleState extends State<AnimatedHeaderTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.95, end: 1.05)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
            scale: _animation,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset('assets/logo_um.jpg',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.school,
                        color: Color(0xFF2383E2),
                        size: 22)))),
        const SizedBox(width: 8),
        const Text('Universitas Mulia',
            style: TextStyle(
                color: Color(0xFF37352F),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5)),
      ],
    );
  }
}

class HoverableSidebarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final bool isSelected;
  final VoidCallback? onTap;
  const HoverableSidebarItem(
      {super.key,
      required this.icon,
      required this.title,
      this.trailing,
      this.isSelected = false,
      this.onTap});
  @override
  State<HoverableSidebarItem> createState() => _HoverableSidebarItemState();
}

class _HoverableSidebarItemState extends State<HoverableSidebarItem> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ?? () {},
      onHover: (hovering) => setState(() => _isHovering = hovering),
      child: Container(
        color: widget.isSelected
            ? Colors.black.withOpacity(0.06)
            : _isHovering
                ? Colors.black.withOpacity(0.04)
                : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(widget.icon, size: 18, color: const Color(0xFF91918E)),
            const SizedBox(width: 12),
            Expanded(
                child: Text(widget.title,
                    style: TextStyle(
                        fontSize: 14,
                        color: widget.isSelected
                            ? const Color(0xFF37352F)
                            : const Color(0xFF505050),
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.normal))),
            if (widget.trailing != null)
              Text(widget.trailing!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
