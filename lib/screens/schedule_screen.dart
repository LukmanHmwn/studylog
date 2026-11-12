import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _fadeController;

  String _currentTime = '';
  String _currentDate = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Inisialisasi waktu real-time
    _updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateTime(),
    );

    // Animasi background gradasi bergerak (10 detik per siklus)
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    // Animasi fade in saat halaman dibuka
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bgController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];

    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    if (mounted) {
      setState(() {
        _currentDate = '$dayName, ${now.day} $monthName ${now.year}';
        _currentTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF37352F),
        ), // Ikon gelap untuk light mode
        title: const Text(
          'Dashboard Akademik',
          style: TextStyle(
            color: Color(0xFF37352F),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND GRADASI ANIMASI CERAH (Gradient Abstract Design)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        // Gradasi warna bergerak (Cyan pastel, Peach, Pink muda)
                        Color.lerp(
                          const Color(0xFFE0F7FA),
                          const Color(0xFFFFE0B2),
                          _bgController.value,
                        )!,
                        Color.lerp(
                          const Color(0xFFFFCCBC),
                          const Color(0xFFFCE4EC),
                          _bgController.value,
                        )!,
                        const Color(0xFFF1F8E9),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Ornamen grafis lengkungan abstrak bergerak
          Positioned(
            top: -150,
            left: -100,
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _bgController.value * 2 * math.pi,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. KONTEN UTAMA JADWAL
          SafeArea(
            child: FadeTransition(
              opacity: _fadeController,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, // Diubah menjadi 20 agar pas di HP
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Status SKS dan Waktu (Desain Light, Responsif)
                    _buildHeaderCard(),
                    const SizedBox(height: 32),

                    // Grid Kartu Jadwal Kuliah
                    Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: [
                        AnimatedScheduleCard(
                          day: 'Senin',
                          courses: [
                            _CourseData(
                              'SISTEM MANAJEMEN BASIS DATA',
                              '19:00 - 20:30',
                              'LAB B (FIKOM)',
                              '3 SKS - IFB5J',
                            ),
                            _CourseData(
                              'TEKNOLOGI APLIKASI BERGERAK',
                              '20:30 - 22:00',
                              'LAB A (FIKOM)',
                              '3 SKS - IFB5J',
                            ),
                          ],
                        ),
                        AnimatedScheduleCard(
                          day: 'Selasa',
                          courses: [
                            _CourseData(
                              'PENALARAN KOMPUTER',
                              '19:00 - 20:30',
                              'A201',
                              '3 SKS - IFB5J',
                            ),
                            _CourseData(
                              'SIMULASI DAN GAME KOMPUTER',
                              '20:30 - 22:00',
                              'LAB A (FIKOM)',
                              '3 SKS - IFB5J',
                            ),
                          ],
                        ),
                        AnimatedScheduleCard(
                          day: 'Rabu',
                          courses: [
                            _CourseData(
                              'KRIPTOGRAFI',
                              '20:30 - 22:00',
                              'A301',
                              '3 SKS - IFB5J',
                            ),
                          ],
                        ),
                        AnimatedScheduleCard(
                          day: 'Kamis',
                          courses: [
                            _CourseData(
                              'PENULISAN DAN PUBLIKASI ILMIAH',
                              '19:00 - 20:30',
                              'A203',
                              '2 SKS - IFB5J',
                            ),
                          ],
                        ),
                        AnimatedScheduleCard(
                          day: 'Jumat',
                          courses: [
                            _CourseData(
                              'JARINGAN NIRKABEL',
                              '19:00 - 20:30',
                              'LAB JARINGAN (FIKOM)',
                              '3 SKS - IFB5J',
                            ),
                            _CourseData(
                              'PEMROGRAMAN APLIKASI BERGERAK',
                              '20:30 - 22:00',
                              'LAB A (FIKOM)',
                              '3 SKS - IFB5J',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Komponen Header Dashboard (Telah Diperbaiki Menjadi Wrap)
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Putih transparan
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 20, // Memberi jarak jika teks turun ke baris baru
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'SEMESTER GANJIL 2026/2027',
                  style: TextStyle(
                    color: Color(0xFFFF7A00),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Total 23 SKS',
                style: TextStyle(
                  color: Color(0xFF37352F),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Informatika (S1) - Universitas Mulia',
                style: TextStyle(color: Color(0xFF757575), fontSize: 13),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentDate,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xFF37352F),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _currentTime,
                    style: const TextStyle(
                      color: Color(0xFF37352F),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Model Data Sementara untuk Mata Kuliah
class _CourseData {
  final String name;
  final String time;
  final String room;
  final String sks;
  _CourseData(this.name, this.time, this.room, this.sks);
}

// Komponen Kartu Jadwal dengan Animasi Interaktif (Bisa diklik/ditekan)
class AnimatedScheduleCard extends StatefulWidget {
  final String day;
  final List<_CourseData> courses;

  const AnimatedScheduleCard({
    super.key,
    required this.day,
    required this.courses,
  });

  @override
  State<AnimatedScheduleCard> createState() => _AnimatedScheduleCardState();
}

class _AnimatedScheduleCardState extends State<AnimatedScheduleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ), // Kecepatan animasi saat diklik
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    // Aksi saat kartu diklik bisa ditambahkan di sini
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Anda memilih jadwal hari ${widget.day}')),
    );
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 380, // Membatasi lebar kartu
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              0.8,
            ), // Latar belakang putih transparan
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Hari
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2383E2).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF2383E2),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.day,
                    style: const TextStyle(
                      color: Color(0xFF37352F),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Daftar Mata Kuliah
              ...widget.courses.map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Icon(
                          Icons.circle,
                          color: Color(0xFF2383E2),
                          size: 10,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.name,
                              style: const TextStyle(
                                color: Color(0xFF37352F),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildBadge(
                                  Icons.access_time,
                                  course.time,
                                  const Color(0xFFFF9100),
                                ), // Oranye
                                _buildBadge(
                                  Icons.location_on_outlined,
                                  course.room,
                                  const Color(0xFF00C853),
                                ), // Hijau
                                _buildBadge(
                                  Icons.book_outlined,
                                  course.sks,
                                  const Color(0xFFAA00FF),
                                ), // Ungu
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Komponen Badge (Pill) untuk Waktu, Ruangan, dan SKS (Versi Light Mode)
  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
