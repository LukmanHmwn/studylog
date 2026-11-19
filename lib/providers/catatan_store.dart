import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/database_helper.dart';

class KolaboratorShare {
  String nama;
  String role;

  KolaboratorShare({
    required this.nama,
    required this.role,
  });
}

class SharePayloadResult {
  final CatatanModel catatan;
  final String pengirim;
  final String akses;

  SharePayloadResult({
    required this.catatan,
    required this.pengirim,
    required this.akses,
  });
}

class CatatanModel {
  String id;
  String judul;
  String isi;
  String mataKuliah;
  String tanggal;
  DateTime? deadline;
  bool isSelesai;

  CatatanModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.mataKuliah,
    required this.tanggal,
    this.deadline,
    this.isSelesai = false,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'mata_kuliah': mataKuliah,
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
      'deadline': deadline?.toIso8601String(),
      'is_selesai': isSelesai ? 1 : 0,
    };
  }

  factory CatatanModel.fromMap(Map<String, Object?> map) {
    final deadlineStr = map['deadline'] as String?;
    return CatatanModel(
      id: map['id'].toString(),
      mataKuliah: map['mata_kuliah'] as String,
      judul: map['judul'] as String,
      isi: map['isi'] as String,
      tanggal: map['tanggal'] as String,
      deadline: (deadlineStr != null && deadlineStr.isNotEmpty)
          ? DateTime.tryParse(deadlineStr)
          : null,
      isSelesai: (map['is_selesai'] as int? ?? 0) == 1,
    );
  }

  String toShareCode({
    String? pengirim,
    String akses = 'Can duplicate',
  }) {
    final payload = {
      'v': 1,
      'mk': mataKuliah,
      'j': judul,
      'i': isi,
      't': tanggal,
      'dl': deadline?.toIso8601String(),
      'by': (pengirim != null && pengirim.trim().isNotEmpty)
          ? pengirim.trim()
          : 'Mahasiswa Universitas Mulia',
      'acc': akses,
    };
    final encoded = base64Url.encode(utf8.encode(jsonEncode(payload)));
    return 'STUDYLOG://$encoded';
  }

  String toFormattedShareMessage({
    String? pengirim,
    String akses = 'Can duplicate',
  }) {
    final jenis = deadline != null ? 'TUGAS KULIAH' : 'CATATAN KULIAH';
    final buffer = StringBuffer()
      ..writeln('📘 *STUDYLOG • $jenis*')
      ..writeln('• *Mata Kuliah:* $mataKuliah')
      ..writeln('• *Judul:* $judul');

    if (deadline != null) {
      final d = deadline!;
      final jam =
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
      buffer.writeln(
          '• *Tenggat:* ${d.day}/${d.month}/${d.year} • Jam $jam WITA');
    }

    if (isi.trim().isNotEmpty) {
      buffer
        ..writeln('')
        ..writeln('*Ringkasan Materi / Detail:*')
        ..writeln(isi.trim());
    }

    buffer
      ..writeln('')
      ..writeln('---')
      ..writeln(
          'Salin pesan ini lalu buka menu *Impor* di aplikasi StudyLog untuk menyimpannya:')
      ..write(toShareCode(pengirim: pengirim, akses: akses));

    return buffer.toString();
  }

  static SharePayloadResult? parseSharePayload(String rawInput) {
    try {
      final match =
          RegExp(r'STUDYLOG://([A-Za-z0-9\-_=]+)').firstMatch(rawInput.trim());
      if (match == null) return null;

      final token = match.group(1)!;
      final normalized = base64Url.normalize(token);
      final decodedJson = utf8.decode(base64Url.decode(normalized));
      final decoded = jsonDecode(decodedJson);
      if (decoded is! Map) return null;

      final deadlineStr = decoded['dl']?.toString();
      final mkRaw = decoded['mk']?.toString().trim() ?? '';
      final judulRaw = decoded['j']?.toString().trim() ?? '';
      final isiRaw = decoded['i']?.toString() ?? '';
      final tglRaw = decoded['t']?.toString().trim() ?? '';
      final pengirimRaw = decoded['by']?.toString().trim() ?? '';
      final aksesRaw = decoded['acc']?.toString().trim() ?? '';

      final catatan = CatatanModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mataKuliah: mkRaw.isNotEmpty ? mkRaw : 'Umum',
        judul: judulRaw.isNotEmpty ? judulRaw : 'Catatan Bersama',
        isi: isiRaw,
        tanggal: tglRaw.isNotEmpty
            ? tglRaw
            : '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        deadline: (deadlineStr != null && deadlineStr.isNotEmpty)
            ? DateTime.tryParse(deadlineStr)
            : null,
        isSelesai: false,
      );

      return SharePayloadResult(
        catatan: catatan,
        pengirim: pengirimRaw.isNotEmpty ? pengirimRaw : 'Teman Kuliah',
        akses: aksesRaw.isNotEmpty ? aksesRaw : 'Can duplicate',
      );
    } catch (_) {
      return null;
    }
  }
}

class CatatanStore extends ChangeNotifier {
  final List<CatatanModel> _catatanList = [];

  List<CatatanModel> get catatanList => _catatanList;

  Future<void> muatCatatan() async {
    try {
      final dataDariDb = await DatabaseHelper.instance.getAllCatatan();
      _catatanList
        ..clear()
        ..addAll(dataDariDb);
      notifyListeners();
    } catch (e) {
      debugPrint('Gagal memuat data SQLite: $e');
    }
  }

  Future<void> tambahCatatan(CatatanModel catatan) async {
    _catatanList.add(catatan);
    notifyListeners();
    try {
      await DatabaseHelper.instance.insertCatatan(catatan);
    } catch (e) {
      debugPrint('Gagal menyimpan catatan ke SQLite: $e');
    }
  }

  Future<void> updateCatatan(
    String id,
    String judulBaru,
    String isiBaru, {
    DateTime? deadlineBaru,
  }) async {
    final index = _catatanList.indexWhere((c) => c.id == id);
    if (index != -1) {
      _catatanList[index].judul = judulBaru;
      _catatanList[index].isi = isiBaru;
      _catatanList[index].deadline = deadlineBaru;
      notifyListeners();
      try {
        await DatabaseHelper.instance.updateCatatan(_catatanList[index]);
      } catch (e) {
        debugPrint('Gagal memperbarui catatan di SQLite: $e');
      }
    }
  }

  Future<void> toggleSelesai(String id) async {
    final index = _catatanList.indexWhere((c) => c.id == id);
    if (index != -1) {
      _catatanList[index].isSelesai = !_catatanList[index].isSelesai;
      notifyListeners();
      try {
        await DatabaseHelper.instance.updateCatatan(_catatanList[index]);
      } catch (e) {
        debugPrint('Gagal memperbarui status tugas di SQLite: $e');
      }
    }
  }

  Future<void> hapusCatatan(String id) async {
    _catatanList.removeWhere((c) => c.id == id);
    notifyListeners();
    try {
      await DatabaseHelper.instance.deleteCatatan(id);
    } catch (e) {
      debugPrint('Gagal menghapus catatan dari SQLite: $e');
    }
  }
}

/// Modal Berbagi Catatan & Tugas ala Notion
Future<void> showNotionShareDialog(
  BuildContext context,
  CatatanModel catatan,
) async {
  final inviteController = TextEditingController();
  String inviteRole = 'Can duplicate';
  String generalAccess = 'Anyone with StudyLog code';
  String generalRole = 'Can duplicate';
  final kolaborator = [
    KolaboratorShare(nama: 'Anda (Pemilik Ruang)', role: 'Full access'),
  ];

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final shareCode = catatan.toShareCode(akses: generalRole);
          final isTugas = catatan.deadline != null;

          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 490),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Modal ala Notion
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF2383E2).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isTugas
                                ? Icons.task_alt_rounded
                                : Icons.ios_share_rounded,
                            color: const Color(0xFF2383E2),
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isTugas ? 'Bagikan Tugas' : 'Bagikan Catatan',
                                style: const TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                catatan.judul,
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
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(Icons.close_rounded,
                              size: 20, color: Color(0xFF64748B)),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Baris Undang Teman (ala Notion Invite)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: inviteController,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Tambah nama atau NIM teman...',
                              hintStyle: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF94A3B8),
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 11),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final nama = inviteController.text.trim();
                            if (nama.isEmpty) return;
                            setModalState(() {
                              kolaborator.add(
                                KolaboratorShare(nama: nama, role: inviteRole),
                              );
                              inviteController.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2383E2),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Undang',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Daftar Kolaborator
                    ...kolaborator.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      final isOwner = idx == 0;
                      final initial = item.nama.isNotEmpty
                          ? item.nama[0].toUpperCase()
                          : 'M';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: isOwner
                                  ? const Color(0xFF2383E2)
                                  : const Color(0xFF0D9488),
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.nama,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            if (isOwner)
                              Text(
                                item.role,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            else
                              DropdownButton<String>(
                                value: item.role,
                                underline: const SizedBox.shrink(),
                                isDense: true,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w600,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Can duplicate',
                                    child: Text('Can duplicate'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Can view',
                                    child: Text('Can view'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Can edit',
                                    child: Text('Can edit'),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setModalState(() {
                                      kolaborator[idx].role = val;
                                    });
                                  }
                                },
                              ),
                          ],
                        ),
                      );
                    }),

                    const Divider(height: 22, color: Color(0xFFE2E8F0)),

                    // General Access (Akses Umum ala Notion)
                    const Text(
                      'Akses Umum',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            generalAccess == 'Anyone with StudyLog code'
                                ? Icons.public_rounded
                                : Icons.lock_outline_rounded,
                            size: 18,
                            color: const Color(0xFF2383E2),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButton<String>(
                              value: generalAccess,
                              isExpanded: true,
                              underline: const SizedBox.shrink(),
                              isDense: true,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Anyone with StudyLog code',
                                  child:
                                      Text('Siapa saja dengan kode StudyLog'),
                                ),
                                DropdownMenuItem(
                                  value: 'Invited classmates only',
                                  child: Text('Hanya teman yang diundang'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => generalAccess = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: generalRole,
                            underline: const SizedBox.shrink(),
                            isDense: true,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Can duplicate',
                                child: Text('Can duplicate'),
                              ),
                              DropdownMenuItem(
                                value: 'Can view',
                                child: Text('Can view'),
                              ),
                              DropdownMenuItem(
                                value: 'Can edit',
                                child: Text('Can edit'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() {
                                  generalRole = val;
                                  inviteRole = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Kotak Kode Berbagi StudyLog
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link_rounded,
                              size: 18, color: Color(0xFF2383E2)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              shareCode,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: shareCode));
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Kode StudyLog berhasil disalin! Tempel di menu Impor teman.'),
                                  backgroundColor: Color(0xFF16A34A),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: const Color(0xFF93C5FD)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.copy_rounded,
                                      size: 14, color: Color(0xFF2383E2)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Salin Kode',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2383E2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Tombol Aksi Bawah (Salin Pesan & Kirim WhatsApp)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final pesan = catatan.toFormattedShareMessage(
                                akses: generalRole,
                              );
                              await Clipboard.setData(
                                  ClipboardData(text: pesan));
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Format catatan & kode berhasil disalin!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.content_copy_rounded,
                                size: 16),
                            label: const Text(
                              'Salin Teks',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1E293B),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final pesan = catatan.toFormattedShareMessage(
                                akses: generalRole,
                              );
                              final waUri = Uri.parse(
                                  'https://wa.me/?text=${Uri.encodeComponent(pesan)}');
                              try {
                                await launchUrl(waUri,
                                    mode: LaunchMode.externalApplication);
                              } catch (_) {
                                await Clipboard.setData(
                                    ClipboardData(text: pesan));
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Teks berbagi disalin ke clipboard.'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.send_rounded, size: 16),
                            label: const Text(
                              'Kirim WhatsApp',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF16A34A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  inviteController.dispose();
}

/// Modal Impor Catatan / Tugas dari Teman
Future<void> showNotionImportDialog(
  BuildContext context, {
  bool khususTugas = false,
}) async {
  final pasteController = TextEditingController();
  SharePayloadResult? parsedResult;

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final previewCatatan = parsedResult?.catatan;
          final pengirim = parsedResult?.pengirim ?? 'Teman Kuliah';
          final akses = parsedResult?.akses ?? 'Can duplicate';

          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF2383E2).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.download_for_offline_rounded,
                            color: Color(0xFF2383E2),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                khususTugas
                                    ? 'Impor Tugas Teman'
                                    : 'Impor Catatan / Tugas Teman',
                                style: const TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const Text(
                                'Tempel kode STUDYLOG:// atau pesan dari teman',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(Icons.close_rounded,
                              size: 20, color: Color(0xFF64748B)),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: pasteController,
                      maxLines: 3,
                      onChanged: (val) {
                        setModalState(() {
                          parsedResult = CatatanModel.parseSharePayload(val);
                        });
                      },
                      style: const TextStyle(fontSize: 12.5),
                      decoration: InputDecoration(
                        hintText:
                            'Tempel kode STUDYLOG://... atau pesan WhatsApp dari teman di sini...',
                        hintStyle: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF94A3B8),
                        ),
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
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () async {
                          final clip =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          final text = clip?.text ?? '';
                          if (text.isEmpty) return;
                          setModalState(() {
                            pasteController.text = text;
                            parsedResult = CatatanModel.parseSharePayload(text);
                          });
                        },
                        icon: const Icon(Icons.content_paste_go_rounded,
                            size: 16),
                        label: const Text(
                          'Tempel dari Clipboard',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (previewCatatan != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified_rounded,
                                    size: 16, color: Color(0xFF16A34A)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Siap Diduplikasi • ${previewCatatan.mataKuliah}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    akses,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              previewCatatan.judul,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            if (previewCatatan.isi.trim().isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                previewCatatan.isi,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                            const SizedBox(height: 6),
                            Text(
                              'Dibagikan oleh: $pengirim',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (pasteController.text.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      const Text(
                        'Kode STUDYLOG:// belum terdeteksi. Pastikan seluruh teks pesan dari teman ikut tersalin.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: previewCatatan == null
                            ? null
                            : () async {
                                if (khususTugas &&
                                    previewCatatan.deadline == null) {
                                  previewCatatan.deadline = DateTime.now()
                                      .add(const Duration(days: 1));
                                }
                                await Provider.of<CatatanStore>(context,
                                        listen: false)
                                    .tambahCatatan(previewCatatan);
                                if (!dialogContext.mounted) return;
                                Navigator.pop(dialogContext);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '"${previewCatatan.judul}" berhasil ditambahkan ke StudyLog!'),
                                    backgroundColor: const Color(0xFF16A34A),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                        icon: const Icon(Icons.library_add_check_rounded,
                            size: 18),
                        label: const Text(
                          'Simpan ke StudyLog',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2383E2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
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
          );
        },
      );
    },
  );
  pasteController.dispose();
}
