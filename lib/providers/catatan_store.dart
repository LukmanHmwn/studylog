import 'package:flutter/material.dart';

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
}

class CatatanStore extends ChangeNotifier {
  final List<CatatanModel> _catatanList = [];

  List<CatatanModel> get catatanList => _catatanList;

  void tambahCatatan(CatatanModel catatan) {
    _catatanList.add(catatan);
    notifyListeners();
  }

  void updateCatatan(
    String id,
    String judulBaru,
    String isiBaru, {
    DateTime? deadlineBaru,
  }) {
    final index = _catatanList.indexWhere((c) => c.id == id);
    if (index != -1) {
      _catatanList[index].judul = judulBaru;
      _catatanList[index].isi = isiBaru;
      _catatanList[index].deadline = deadlineBaru;
      notifyListeners();
    }
  }

  void toggleSelesai(String id) {
    final index = _catatanList.indexWhere((c) => c.id == id);
    if (index != -1) {
      _catatanList[index].isSelesai = !_catatanList[index].isSelesai;
      notifyListeners();
    }
  }

  void hapusCatatan(String id) {
    _catatanList.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
