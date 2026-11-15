import 'package:flutter/material.dart';
import '../data/database_helper.dart';

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
