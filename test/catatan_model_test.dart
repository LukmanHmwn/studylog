import 'package:flutter_test/flutter_test.dart';
import 'package:studylog/providers/catatan_store.dart';

void main() {
  group('Pengujian Model SQLite & Store Catatan StudyLog', () {
    test('CatatanModel round-trip toMap() dan fromMap() tidak mengubah data',
        () {
      final tenggat = DateTime(2026, 11, 20, 23, 59);
      final asli = CatatanModel(
        id: '101',
        mataKuliah: 'Pemrograman Aplikasi Bergerak',
        judul: 'SQLite Persistence',
        isi: 'Materi penyimpanan lokal Android',
        tanggal: 'Minggu, 15 November 2026',
        deadline: tenggat,
        isSelesai: true,
      );

      final hasil = CatatanModel.fromMap(asli.toMap());

      expect(hasil.id, '101');
      expect(hasil.mataKuliah, 'Pemrograman Aplikasi Bergerak');
      expect(hasil.judul, 'SQLite Persistence');
      expect(hasil.isi, 'Materi penyimpanan lokal Android');
      expect(hasil.tanggal, 'Minggu, 15 November 2026');
      expect(hasil.deadline, tenggat);
      expect(hasil.isSelesai, true);
    });

    test('CatatanStore dapat memperbarui data catatan dengan benar', () {
      final store = CatatanStore();
      store.tambahCatatan(
        CatatanModel(
          id: '202',
          mataKuliah: 'Kriptografi',
          judul: 'Judul Awal',
          isi: 'Isi Awal',
          tanggal: 'Minggu, 15 November 2026',
        ),
      );

      store.updateCatatan('202', 'Judul Baru', 'Isi materi diperbarui');

      final updated = store.catatanList.firstWhere((c) => c.id == '202');
      expect(updated.judul, 'Judul Baru');
      expect(updated.isi, 'Isi materi diperbarui');
    });
  });
}
