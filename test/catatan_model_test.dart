import 'package:flutter_test/flutter_test.dart';
import 'package:studylog/providers/catatan_store.dart';

void main() {
  group('Pengujian Model & Store Catatan StudyLog', () {
    test(
        'CatatanModel menyimpan atribut mata kuliah, judul, dan isi dengan benar',
        () {
      final catatan = CatatanModel(
        id: '101',
        mataKuliah: 'Pemrograman Aplikasi Bergerak',
        judul: 'State Management & SQLite',
        isi: 'Materi praktikum Flutter StudyLog',
        tanggal: 'Minggu, 15 November 2026',
      );

      expect(catatan.id, '101');
      expect(catatan.mataKuliah, 'Pemrograman Aplikasi Bergerak');
      expect(catatan.judul, 'State Management & SQLite');
      expect(catatan.isi, 'Materi praktikum Flutter StudyLog');
    });

    test('CatatanStore dapat memperbarui data catatan dengan benar', () {
      final store = CatatanStore();
      if (store.catatanList.isNotEmpty) {
        final target = store.catatanList.first;
        store.updateCatatan(target.id, 'Judul Baru', 'Isi materi diperbarui');

        final updated = store.catatanList.firstWhere((c) => c.id == target.id);
        expect(updated.judul, 'Judul Baru');
        expect(updated.isi, 'Isi materi diperbarui');
      }
    });
  });
}
