import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CatatanModel {
  final String id;
  String mataKuliah;
  String tanggal;
  String judul;
  String isi;
  String dosen; // Menambahkan kembali properti dosen
  DateTime? deadline;

  CatatanModel({
    String? id,
    required this.mataKuliah,
    required this.tanggal,
    this.judul = '',
    this.isi = '',
    this.dosen = '', // Default kosong
    this.deadline,
  }) : id = id ?? const Uuid().v4();
}

class CatatanStore extends ChangeNotifier {
  final List<CatatanModel> _catatanList = [];

  List<CatatanModel> get catatanList => _catatanList;

  void tambahCatatan(CatatanModel catatan) {
    _catatanList.add(catatan);
    notifyListeners();
  }

  void updateCatatan(String id, String judulBaru, String isiBaru,
      {DateTime? deadlineBaru}) {
    final index = _catatanList.indexWhere((c) => c.id == id);
    if (index != -1) {
      _catatanList[index].judul = judulBaru;
      _catatanList[index].isi = isiBaru;
      _catatanList[index].deadline = deadlineBaru;
      notifyListeners();
    }
  }

  void hapusCatatan(String id) {
    _catatanList.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
