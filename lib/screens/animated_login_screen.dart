import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class ModernLoginScreen extends StatefulWidget {
  const ModernLoginScreen({super.key});

  @override
  State<ModernLoginScreen> createState() => _ModernLoginScreenState();
}

class _ModernLoginScreenState extends State<ModernLoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  String? _identifierError;
  String? _passwordError;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _login() {
    setState(() {
      _identifierError = _identifierController.text.trim().isEmpty
          ? 'NIM atau Email wajib diisi'
          : null;
      _passwordError = _passwordController.text.trim().isEmpty
          ? 'Password wajib diisi'
          : null;
    });

    if (_identifierError != null || _passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silakan lengkapi form login terlebih dahulu!'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            initialIdentifier: _identifierController.text.trim(),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1C),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _DarkGradientWavePainter(
                    animationValue: _animationController.value,
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 40.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 40,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // BAGIAN LOGO UNIVERSITAS MULIA
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/logo_um.jpg',
                                  height: 85,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.school,
                                      size: 70,
                                      color: Color(0xFFE53935),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Sistem Informasi Akademik',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1E1E),
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Silakan masukkan NIM atau Email Anda\nbeserta password yang terdaftar.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF757575),
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            TextField(
                              controller: _identifierController,
                              style: const TextStyle(fontSize: 14),
                              onChanged: (value) {
                                if (_identifierError != null) {
                                  setState(() => _identifierError = null);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'NIM / Email',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                ),
                                errorText: _identifierError,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF5B05B),
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade400,
                                    width: 1.0,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade400,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(fontSize: 14),
                              onChanged: (value) {
                                if (_passwordError != null) {
                                  setState(() => _passwordError = null);
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                ),
                                errorText: _passwordError,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: _togglePasswordVisibility,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Text(
                                        _obscurePassword
                                            ? 'Tampilkan'
                                            : 'Sembunyikan',
                                        style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFF5B05B),
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade400,
                                    width: 1.0,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade400,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Lupa password?',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF6B76A),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        color: Color(0xFF1F1F1F),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Copyright @Universitas Mulia 2026 | Privacy Policy',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkGradientWavePainter extends CustomPainter {
  final double animationValue;

  _DarkGradientWavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final path1 = Path();
    path1.moveTo(0, height * 0.4);
    path1.quadraticBezierTo(
      width * 0.25,
      height * 0.3 + math.sin(animationValue * 2 * math.pi) * 80,
      width * 0.5,
      height * 0.5,
    );
    path1.quadraticBezierTo(
      width * 0.75,
      height * 0.7 + math.cos(animationValue * 2 * math.pi) * 80,
      width,
      height * 0.6,
    );
    path1.lineTo(width, height);
    path1.lineTo(0, height);
    path1.close();

    final paint1 = Paint()
      ..shader = ui.Gradient.linear(const Offset(0, 0), Offset(width, height), [
        const Color(0xFF2A0845),
        const Color(0xFF0F0C29),
      ]);
    canvas.drawPath(path1, paint1);

    final path2 = Path();
    path2.moveTo(0, height * 0.6);
    path2.quadraticBezierTo(
      width * 0.25,
      height * 0.8 - math.sin(animationValue * 2 * math.pi) * 60,
      width * 0.5,
      height * 0.6,
    );
    path2.quadraticBezierTo(
      width * 0.8,
      height * 0.4 - math.cos(animationValue * 2 * math.pi) * 60,
      width,
      height * 0.5,
    );
    path2.lineTo(width, height);
    path2.lineTo(0, height);
    path2.close();

    final paint2 = Paint()
      ..shader = ui.Gradient.linear(Offset(width, 0), Offset(0, height), [
        const Color(0xFF1E3C72).withOpacity(0.8),
        const Color(0xFF2A0845).withOpacity(0.8),
      ]);
    canvas.drawPath(path2, paint2);

    final path3 = Path();
    path3.moveTo(0, height * 0.7);
    path3.quadraticBezierTo(
      width * 0.3,
      height * 0.9 + math.cos(animationValue * 2 * math.pi) * 40,
      width * 0.6,
      height * 0.7,
    );
    path3.quadraticBezierTo(
      width * 0.85,
      height * 0.5 + math.sin(animationValue * 2 * math.pi) * 40,
      width,
      height * 0.8,
    );

    final paint3 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = ui.Gradient.linear(const Offset(0, 0), Offset(width, height), [
        const Color(0xFF4A00E0).withOpacity(0.6),
        const Color(0xFF8E2DE2).withOpacity(0.6),
      ]);
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant _DarkGradientWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
