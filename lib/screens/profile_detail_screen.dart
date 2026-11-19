import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String initialName;
  final String initialNim;
  final String? initialImagePath;

  const ProfileDetailScreen({
    super.key,
    this.initialName = '',
    this.initialNim = '',
    this.initialImagePath,
  });

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  late TextEditingController _namaController;
  late TextEditingController _nimController;
  late TextEditingController _emailController;
  late TextEditingController _prodiController;
  late TextEditingController _semesterController;
  late TextEditingController _dosbimController;
  late TextEditingController _kelasController;
  late TextEditingController _fakultasController;
  late TextEditingController _alamatController;

  String? _imagePath;
  bool _smsAlertsActive = true;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.initialName);
    _nimController = TextEditingController(text: widget.initialNim);
    _emailController = TextEditingController(text: '');
    _prodiController = TextEditingController(text: '');
    _semesterController = TextEditingController(text: '');
    _dosbimController = TextEditingController(text: '');
    _kelasController = TextEditingController(text: '');
    _fakultasController = TextEditingController(text: '');
    _alamatController = TextEditingController(text: '');
    _imagePath = widget.initialImagePath;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _prodiController.dispose();
    _semesterController.dispose();
    _dosbimController.dispose();
    _kelasController.dispose();
    _fakultasController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _kembaliKeDashboard() {
    Navigator.pop(context, {
      'name': _namaController.text.trim(),
      'nim': _nimController.text.trim(),
      'imagePath': _imagePath,
    });
  }

  Future<void> _pilihBerkasFoto(BuildContext dialogContext) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
      );

      if (result.isEmpty) return;
      final selectedPath = result.first.path;

      if (selectedPath == null || selectedPath.isEmpty) return;

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }

      if (!mounted) return;
      setState(() {
        _imagePath = selectedPath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profil berhasil dipilih.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih foto: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _tampilkanDialogUnggahFoto() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Unggah Berkas Foto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 52,
                    color: Color(0xFFF97316),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Pilih berkas foto dari perangkat Anda untuk diunggah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _pilihBerkasFoto(dialogContext),
                      icon: const Icon(Icons.folder_outlined, size: 18),
                      label: const Text(
                        'Pilih Berkas dari Perangkat',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2383E2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _tampilkanDialogEditProfil() {
    final tempNama = TextEditingController(text: _namaController.text);
    final tempNim = TextEditingController(text: _nimController.text);
    final tempEmail = TextEditingController(text: _emailController.text);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Edit Profil',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tempNama,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tempNim,
                  decoration: const InputDecoration(
                    labelText: 'NIM / Telepon',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tempEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email Kampus',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _namaController.text = tempNama.text.trim();
                  _nimController.text = tempNim.text.trim();
                  _emailController.text = tempEmail.text.trim();
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _tampilkanDialogEditAkademik() {
    final tempProdi = TextEditingController(text: _prodiController.text);
    final tempSem = TextEditingController(text: _semesterController.text);
    final tempDosbim = TextEditingController(text: _dosbimController.text);
    final tempKelas = TextEditingController(text: _kelasController.text);
    final tempFakultas = TextEditingController(text: _fakultasController.text);
    final tempAlamat = TextEditingController(text: _alamatController.text);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Edit Data Akademik & Pribadi',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tempProdi,
                  decoration: const InputDecoration(
                    labelText: 'Jenjang / Program Studi',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tempSem,
                  decoration: const InputDecoration(
                    labelText: 'Semester / SKS',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tempDosbim,
                  decoration: const InputDecoration(
                    labelText: 'Dosen Pembimbing',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tempKelas,
                  decoration: const InputDecoration(
                    labelText: 'Kelas / Angkatan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tempFakultas,
                  decoration: const InputDecoration(
                    labelText: 'Fakultas / Institusi',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tempAlamat,
                  decoration: const InputDecoration(
                    labelText: 'Domisili / Kota',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _prodiController.text = tempProdi.text.trim();
                  _semesterController.text = tempSem.text.trim();
                  _dosbimController.text = tempDosbim.text.trim();
                  _kelasController.text = tempKelas.text.trim();
                  _fakultasController.text = tempFakultas.text.trim();
                  _alamatController.text = tempAlamat.text.trim();
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  ImageProvider? _getProfileImageProvider() {
    if (_imagePath == null || _imagePath!.isEmpty) return null;
    if (kIsWeb) {
      return NetworkImage(_imagePath!);
    }
    final file = File(_imagePath!);
    if (!file.existsSync()) return null;
    return FileImage(file);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _kembaliKeDashboard();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F5F3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
            onPressed: _kembaliKeDashboard,
          ),
          title: const Text(
            'Profil Mahasiswa',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              right: -70,
              bottom: -70,
              child: Container(
                width: 230,
                height: 230,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFF97316), Color(0xFFDB2777)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 4, child: _buildLeftProfileCard()),
                            const SizedBox(width: 24),
                            Expanded(flex: 6, child: _buildRightInfoCards()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildLeftProfileCard(),
                            const SizedBox(height: 20),
                            _buildRightInfoCards(),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftProfileCard() {
    final imageProvider = _getProfileImageProvider();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: _tampilkanDialogUnggahFoto,
                borderRadius: BorderRadius.circular(70),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFF97316), Color(0xFFDB2777)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 58,
                    backgroundColor: const Color(0xFFF1F5F9),
                    backgroundImage: imageProvider,
                    child: imageProvider == null
                        ? const Icon(
                            Icons.person_rounded,
                            size: 56,
                            color: Color(0xFF94A3B8),
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: InkWell(
                  onTap: _tampilkanDialogUnggahFoto,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                _namaController.text.isEmpty ? 'Silakan lengkapi' : 'Aktif',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileFieldTile(
            icon: Icons.person_outline_rounded,
            label: 'Nama Lengkap',
            value: _namaController.text,
          ),
          const SizedBox(height: 10),
          _buildProfileFieldTile(
            icon: Icons.phone_outlined,
            label: 'NIM / Telepon',
            value: _nimController.text,
          ),
          const SizedBox(height: 10),
          _buildProfileFieldTile(
            icon: Icons.mail_outline_rounded,
            label: 'Email Kampus',
            value: _emailController.text,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SMS alerts activation',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              Switch(
                value: _smsAlertsActive,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF22C55E),
                onChanged: (val) => setState(() => _smsAlertsActive = val),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _tampilkanDialogEditProfil,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Edit Profil',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileFieldTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightInfoCards() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Informasi Akademik',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Registrasi Aktif',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildInfoRow('Jenjang / Program Studi', _prodiController.text),
              const SizedBox(height: 12),
              _buildInfoRow('Semester / SKS', _semesterController.text),
              const SizedBox(height: 12),
              _buildInfoRow('Dosen Pembimbing', _dosbimController.text),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Pribadi & Kontak',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 18),
              _buildInfoRow('Kelas / Angkatan', _kelasController.text),
              const SizedBox(height: 12),
              _buildInfoRow('Fakultas / Institusi', _fakultasController.text),
              const SizedBox(height: 12),
              _buildInfoRow('Domisili / Kota', _alamatController.text),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _tampilkanDialogEditAkademik,
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text(
                    'Edit Data Akademik & Pribadi',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value.isEmpty ? '-' : value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}
