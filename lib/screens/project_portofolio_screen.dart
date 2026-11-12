import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectPortofolioScreen extends StatefulWidget {
  const ProjectPortofolioScreen({super.key});

  @override
  State<ProjectPortofolioScreen> createState() =>
      _ProjectPortofolioScreenState();
}

class _ProjectPortofolioScreenState extends State<ProjectPortofolioScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _bgAnimationController;

  final _images = [
    'assets/Foto_1.jpeg',
    'assets/Foto_3.jpeg',
    'assets/Foto_4.jpeg',
  ];

  final _overlayTexts = [
    {
      'title': 'Kebersamaan Kelas IFB 5J',
      'subtitle':
          'Momen berharga bersama teman-teman mahasiswa Informatika Universitas Mulia.'
    },
    {
      'title': 'Kunjungan & Kegiatan Luar',
      'subtitle':
          'Eksplorasi dan belajar kolaboratif membangun relasi di lingkungan kampus.'
    },
    {
      'title': 'Presentasi & Diskusi Tim',
      'subtitle':
          'Mengembangkan soft skill dan kerja sama tim dalam berbagai proyek akademik.'
    },
  ];

  final _portfolioFeatures = [
    {
      'icon': Icons.lightbulb_outline,
      'color': Colors.orangeAccent,
      'number': '01',
      'title': 'Ideation',
      'desc':
          'Menggali dan merumuskan ide-ide inovatif untuk pengembangan aplikasi akademik.'
    },
    {
      'icon': Icons.search_outlined,
      'color': Colors.blueAccent,
      'number': '02',
      'title': 'Research',
      'desc':
          'Menganalisis kebutuhan mahasiswa dan tren teknologi untuk merancang solusi yang tepat.'
    },
    {
      'icon': Icons.design_services_outlined,
      'color': Colors.purpleAccent,
      'number': '03',
      'title': 'Design',
      'desc':
          'Merancang antarmuka pengguna (UI) yang intuitif dan pengalaman pengguna (UX) yang mulus.'
    },
    {
      'icon': Icons.code_outlined,
      'color': Colors.blue,
      'number': '04',
      'title': 'Development',
      'desc':
          'Mengimplementasikan desain ke dalam kode yang efisien menggunakan Flutter.'
    },
    {
      'icon': Icons.smartphone_outlined,
      'color': Colors.pinkAccent,
      'number': '05',
      'title': 'Testing',
      'desc':
          'Menguji aplikasi secara menyeluruh untuk memastikan kinerja dan fungsionalitas yang optimal.'
    },
    {
      'icon': Icons.check_circle_outline,
      'color': Colors.greenAccent,
      'number': '06',
      'title': 'Deployment',
      'desc':
          'Merilis aplikasi ke pengguna akhir dengan dukungan dan pembaruan berkelanjutan.'
    },
  ];

  List<dynamic> _recentProjects = [];

  @override
  void initState() {
    super.initState();
    _bgAnimationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _launchURL(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;
    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      urlString = 'https://$urlString';
    }
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Gagal membuka link.'), backgroundColor: Colors.red),
      );
    }
  }

  void _tampilkanDetailProyek(Map<dynamic, dynamic> project) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              width: 800,
              constraints: const BoxConstraints(maxHeight: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey.shade100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            project['imageBytes'] != null
                                ? Image.memory(
                                    project['imageBytes'] as Uint8List,
                                    fit: BoxFit.cover)
                                : const Center(
                                    child: Icon(Icons.image_outlined,
                                        size: 80, color: Colors.blueGrey)),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 24,
                              left: 24,
                              right: 24,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1976D2),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(project['category'] ?? '',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(project['title'] ?? '',
                                        style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF0D47A1),
                                            height: 1.2))),
                                IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.grey),
                                    onPressed: () => Navigator.pop(ctx))
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text('Deskripsi Proyek',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blueGrey)),
                            const SizedBox(height: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(project['desc'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF546E7A),
                                        height: 1.6)),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                if (project['linkPreview'] != null &&
                                    project['linkPreview']
                                        .toString()
                                        .isNotEmpty)
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          _launchURL(project['linkPreview']),
                                      icon: const Icon(Icons.visibility),
                                      label: const Text('Live Preview'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF1976D2),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16)),
                                    ),
                                  ),
                                if (project['linkPreview'] != null &&
                                    project['linkPreview']
                                        .toString()
                                        .isNotEmpty &&
                                    project['linkGithub'] != null &&
                                    project['linkGithub'].toString().isNotEmpty)
                                  const SizedBox(width: 12),
                                if (project['linkGithub'] != null &&
                                    project['linkGithub'].toString().isNotEmpty)
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          _launchURL(project['linkGithub']),
                                      icon: const Icon(Icons.code),
                                      label: const Text('Source Code'),
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xFF0D47A1),
                                          side: const BorderSide(
                                              color: Color(0xFF0D47A1)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16)),
                                    ),
                                  ),
                              ],
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
        });
  }

  void _tampilkanFormTambahProyek() {
    final formKey = GlobalKey<FormState>();
    final judulController = TextEditingController();
    final deskripsiController = TextEditingController();
    final linkPreviewController = TextEditingController();
    final linkGithubController = TextEditingController();

    String selectedKategori = 'WEB APP';
    Uint8List? selectedImageBytes;
    String? selectedImageName;

    final List<String> kategoriList = [
      'WEB APP',
      'MOBILE APP',
      'GAME SIMULATION',
      'SECURITY APP',
      'DATA SCIENCE',
      'UI/UX DESIGN',
      'IoT PROJECT',
      'OTHER PROJECT'
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              width: 600,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10))
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC62828),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(16)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC62828)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.rocket_launch,
                                        color: Color(0xFFC62828), size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Text(
                                      'Masukan ide projek anda',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF37352F)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Tuangkan gagasan brilianmu di sini. Proyek yang disimpan akan otomatis muncul di etalase portofolio.',
                                style: TextStyle(
                                    color: Color(0xFF757575), fontSize: 14),
                              ),
                              const SizedBox(height: 24),
                              const Text('Judul Proyek',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF505050))),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: judulController,
                                decoration: InputDecoration(
                                  hintText:
                                      'Cth: Sistem Presensi Wajah Terintegrasi',
                                  filled: true,
                                  fillColor: const Color(0xFFF9F9F8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                ),
                                validator: (value) => value!.trim().isEmpty
                                    ? 'Judul tidak boleh kosong'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              const Text('Kategori Bidang',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF505050))),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: selectedKategori,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF9F9F8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                ),
                                items: kategoriList.map((kat) {
                                  return DropdownMenuItem(
                                      value: kat,
                                      child: Text(kat,
                                          style:
                                              const TextStyle(fontSize: 14)));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setStateDialog(
                                        () => selectedKategori = val);
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text('Foto Proyek',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF505050))),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        try {
                                          final ImagePicker picker =
                                              ImagePicker();
                                          final XFile? image =
                                              await picker.pickImage(
                                                  source: ImageSource.gallery);

                                          if (image != null) {
                                            final Uint8List bytes =
                                                await image.readAsBytes();
                                            setStateDialog(() {
                                              selectedImageBytes = bytes;
                                              selectedImageName = image.name;
                                            });
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Gagal membuka galeri. Pastikan izin diberikan.')),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                          selectedImageBytes != null
                                              ? Icons.check_circle
                                              : Icons.upload_file,
                                          size: 20),
                                      label: Text(selectedImageName ??
                                          'Upload Foto Projek'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            selectedImageBytes != null
                                                ? Colors.green
                                                : Colors.blueGrey,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text('Deskripsi Singkat',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF505050))),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: deskripsiController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText:
                                      'Ceritakan sedikit tentang proyek ini, masalah apa yang diselesaikan, dan teknologi yang digunakan...',
                                  filled: true,
                                  fillColor: const Color(0xFFF9F9F8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                ),
                                validator: (value) => value!.trim().isEmpty
                                    ? 'Deskripsi tidak boleh kosong'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Link Preview (Opsional)',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Color(0xFF505050))),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: linkPreviewController,
                                          decoration: InputDecoration(
                                            hintText: 'Cth: mywebsite.com',
                                            filled: true,
                                            fillColor: const Color(0xFFF9F9F8),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Link GitHub (Opsional)',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Color(0xFF505050))),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          controller: linkGithubController,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Cth: github.com/user/repo',
                                            filled: true,
                                            fillColor: const Color(0xFFF9F9F8),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Batal',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          _recentProjects.insert(0, {
                                            'category': selectedKategori,
                                            'title': judulController.text,
                                            'desc': deskripsiController.text,
                                            'imageBytes': selectedImageBytes,
                                            'linkPreview':
                                                linkPreviewController.text,
                                            'linkGithub':
                                                linkGithubController.text,
                                          });
                                        });

                                        Navigator.pop(ctx);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Proyek baru berhasil ditambahkan!'),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1976D2),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Simpan Ide',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: LightBlueWavePainter(
                    animationValue: _bgAnimationController.value,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.5)),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Color(0xFF0D47A1), size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Universitas Mulia',
                          style: TextStyle(
                            color: Color(0xFF0D47A1),
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.white70,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isDesktop = constraints.maxWidth > 800;
                      double cardWidth =
                          isDesktop ? 900 : constraints.maxWidth * 0.92;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: SizedBox(
                            width: cardWidth,
                            child: AspectRatio(
                              aspectRatio: isDesktop ? 16 / 9 : 4 / 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0D47A1)
                                          .withOpacity(0.15),
                                      blurRadius: 35,
                                      offset: const Offset(0, 15),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: PageView.builder(
                                        controller: _pageController,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentPage = index;
                                          });
                                        },
                                        itemCount: _images.length,
                                        itemBuilder: (context, index) {
                                          return Image.asset(
                                            _images[index],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey.shade300,
                                                child: const Center(
                                                  child: Icon(
                                                      Icons.broken_image,
                                                      size: 64,
                                                      color: Colors.grey),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.0),
                                            Colors.black.withOpacity(0.85),
                                          ],
                                          stops: const [0.4, 1.0],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: isDesktop ? 40 : 24,
                                      left: isDesktop ? 60 : 20,
                                      right: isDesktop ? 60 : 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            _overlayTexts[_currentPage]
                                                ['title']!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isDesktop ? 32 : 20,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                              shadows: const [
                                                Shadow(
                                                    color: Colors.black45,
                                                    blurRadius: 4)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _overlayTexts[_currentPage]
                                                ['subtitle']!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: isDesktop ? 16 : 12,
                                              height: 1.4,
                                              shadows: const [
                                                Shadow(
                                                    color: Colors.black45,
                                                    blurRadius: 4)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 12,
                                      top: 0,
                                      bottom: 0,
                                      child: Center(
                                        child: _buildArrowButton(
                                          icon: Icons.arrow_back_ios_new,
                                          onPressed: _currentPage > 0
                                              ? _prevPage
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 12,
                                      top: 0,
                                      bottom: 0,
                                      child: Center(
                                        child: _buildArrowButton(
                                          icon: Icons.arrow_forward_ios,
                                          onPressed:
                                              _currentPage < _images.length - 1
                                                  ? _nextPage
                                                  : null,
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
                  ),
                  const SizedBox(height: 40),
                  _buildProcessSection(context),
                  const SizedBox(height: 60),
                  _buildRecentProjectsSection(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton(
      {required IconData icon, required VoidCallback? onPressed}) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: onPressed == null ? 0.0 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: Colors.white,
          iconSize: 20,
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildProcessSection(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 800;
      bool isTablet = constraints.maxWidth > 500 && !isDesktop;
      double contentWidth = isDesktop ? 900 : constraints.maxWidth * 0.92;

      return SizedBox(
        width: contentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
                children: [
                  TextSpan(text: 'Proses '),
                  TextSpan(
                    text: 'Pengembangan',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Langkah demi langkah mengubah ide menjadi aplikasi akademik fungsional.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF455A64),
              ),
            ),
            const SizedBox(height: 40),
            if (isDesktop || isTablet)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isDesktop ? 1.1 : 1.0,
                ),
                itemCount: _portfolioFeatures.length,
                itemBuilder: (context, index) {
                  return FeatureCard(feature: _portfolioFeatures[index]);
                },
              )
            else
              Column(
                children: _portfolioFeatures.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FeatureCard(feature: feature, isMobile: true),
                  );
                }).toList(),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildRecentProjectsSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;
        bool isTablet = constraints.maxWidth > 500 && !isDesktop;
        double contentWidth = isDesktop ? 900 : constraints.maxWidth * 0.92;

        double cardWidth;
        if (isDesktop) {
          cardWidth = (contentWidth - 40) / 3;
        } else if (isTablet) {
          cardWidth = (contentWidth - 20) / 2;
        } else {
          cardWidth = contentWidth;
        }

        return SizedBox(
          width: contentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Proyek Terbaru.',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0D47A1),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Eksplorasi karya inovatif mulai dari aplikasi mobile hingga platform web akademik.',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF0D47A1).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isDesktop)
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1976D2),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Lihat Semua',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    )
                ],
              ),
              const SizedBox(height: 32),
              _recentProjects.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Belum ada proyek. Silakan tambahkan proyek baru.',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: _recentProjects.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<dynamic, dynamic> project = entry.value;

                        return SizedBox(
                          width: cardWidth,
                          child: ProjectCard(
                            project: project,
                            onSend: () {
                              _tampilkanDetailProyek(project);
                            },
                            onDelete: () {
                              setState(() {
                                _recentProjects.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Proyek berhasil dihapus.'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 40),
              Center(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: _tampilkanFormTambahProyek,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF1976D2), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1976D2).withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ]),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle_outline,
                              color: Color(0xFF1976D2)),
                          SizedBox(width: 8),
                          Text(
                            'Tambahkan Proyek Baru',
                            style: TextStyle(
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FeatureCard extends StatefulWidget {
  final Map<String, dynamic> feature;
  final bool isMobile;

  const FeatureCard({super.key, required this.feature, this.isMobile = false});

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? widget.feature['color']
                : Colors.white.withOpacity(0.9),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.feature['color'].withOpacity(0.2)
                  : const Color(0xFF0D47A1).withOpacity(0.05),
              blurRadius: _isHovered ? 20 : 15,
              offset: Offset(0, _isHovered ? 8 : 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: widget.isMobile ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? widget.feature['color'].withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.feature['icon'],
                    size: 32,
                    color: widget.feature['color'],
                  ),
                ),
                Text(
                  widget.feature['number'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isHovered
                        ? const Color(0xFF0D47A1).withOpacity(0.3)
                        : const Color(0xFF0D47A1).withOpacity(0.15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.feature['title'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isHovered
                    ? widget.feature['color']
                    : const Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 8),
            if (widget.isMobile)
              Text(
                widget.feature['desc'],
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF546E7A),
                ),
              )
            else
              Expanded(
                child: Text(
                  widget.feature['desc'],
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF546E7A),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final Map<dynamic, dynamic> project;
  final VoidCallback onSend;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onSend,
    required this.onDelete,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFF0D47A1).withOpacity(_isHovered ? 0.15 : 0.05),
              blurRadius: _isHovered ? 25 : 15,
              offset: Offset(0, _isHovered ? 12 : 5),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.grey.shade200,
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: widget.project['imageBytes'] != null
                      ? Image.memory(
                          widget.project['imageBytes'] as Uint8List,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.blueGrey.shade100,
                          child: const Center(
                              child: Icon(Icons.image_outlined,
                                  size: 48, color: Colors.blueGrey)),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project['category'] ?? '',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: const Color(0xFF1976D2).withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.project['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0D47A1),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.project['desc'] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: widget.onSend,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1976D2).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility,
                                    size: 14, color: Color(0xFF1976D2)),
                                SizedBox(width: 6),
                                Text('Preview',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1976D2))),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: widget.onDelete,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete_outline,
                                    size: 14, color: Colors.red),
                                SizedBox(width: 6),
                                Text('Delete',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                              ],
                            ),
                          ),
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
    );
  }
}

class LightBlueWavePainter extends CustomPainter {
  final double animationValue;

  LightBlueWavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final bgGradient = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xFFE3F2FD),
        Color(0xFFE1F5FE),
        Color(0xFFB3E5FC),
        Color(0xFFE1F5FE),
      ],
    );
    paint.shader = bgGradient.createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    final waveShader1 = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFFBBDEFB).withOpacity(0.55),
        const Color(0xFF90CAF9).withOpacity(0.5),
        const Color(0xFF81D4FA).withOpacity(0.3),
      ],
    ).createShader(Offset.zero & size);

    paint.shader = waveShader1;
    final path1 = Path();
    path1.moveTo(0, size.height * 0.4);
    for (double i = 0; i <= size.width; i++) {
      double waveY = size.height * 0.5 +
          (math.sin((i / size.width * 2 * math.pi) +
                  (animationValue * 2 * math.pi)) *
              30) +
          (math.cos((i / size.width * 1.5 * math.pi) +
                  (animationValue * math.pi)) *
              15);
      path1.lineTo(i, waveY);
    }
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint);

    final waveShader2 = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        const Color(0xFF81D4FA).withOpacity(0.4),
        const Color(0xFFE1F5FE).withOpacity(0.4),
        const Color(0xFFB3E5FC).withOpacity(0.3),
      ],
    ).createShader(Offset.zero & size);

    paint.shader = waveShader2;
    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    for (double i = 0; i <= size.width; i++) {
      double waveY = size.height * 0.72 +
          (math.sin((i / size.width * 2.5 * math.pi) -
                  (animationValue * 2 * math.pi)) *
              35) +
          (math.sin((i / size.width * 1.0 * math.pi) +
                  (animationValue * 1.5 * math.pi)) *
              15);
      path2.lineTo(i, waveY);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint);

    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    const int dotSpacing = 16;
    final double horizontalShift = (animationValue * size.width) / 5;

    for (int x = -50; x < size.width + 50; x += dotSpacing) {
      for (int y = 0; y < size.height; y += dotSpacing) {
        double animatedX = x + (horizontalShift % dotSpacing);
        double patternY = size.height * 0.35 +
            (math.sin((animatedX / size.width * 4 * math.pi) +
                    (animationValue * 2 * math.pi)) *
                80) +
            (math.cos((animatedX / size.width * 2 * math.pi) -
                    (animationValue * math.pi)) *
                40);

        double distanceToCurve = (y - patternY).abs();
        if (distanceToCurve < 50) {
          double dotScale = (50 - distanceToCurve) / 50;
          double radius = (1.8 * dotScale) + 0.2;

          dotPaint.color = Colors.white.withOpacity(0.35 * dotScale);
          canvas.drawCircle(Offset(animatedX, y.toDouble()), radius, dotPaint);
        }
      }
    }

    final overlayPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.12),
          const Color(0xFFB3E5FC).withOpacity(0.1),
        ],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    final path3 = Path();
    path3.moveTo(0, size.height * 0.5);
    for (double i = 0; i <= size.width; i++) {
      double waveY = size.height * 0.64 +
          (math.sin((i / size.width * 3 * math.pi) +
                  (animationValue * 1.8 * math.pi)) *
              20);
      path3.lineTo(i, waveY);
    }
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    canvas.drawPath(path3, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant LightBlueWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
