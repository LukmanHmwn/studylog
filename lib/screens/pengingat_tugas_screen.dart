import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catatan_store.dart';
import 'detail_catatan_screen.dart';

class PengingatTugasScreen extends StatelessWidget {
  const PengingatTugasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF37352F)),
        title: const Text(
          'Pengingat Tugas',
          style:
              TextStyle(color: Color(0xFF37352F), fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<CatatanStore>(
        builder: (context, store, child) {
          final listTugas =
              store.catatanList.where((c) => c.deadline != null).toList();

          listTugas.sort((a, b) => a.deadline!.compareTo(b.deadline!));

          if (listTugas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Hore! Tidak ada tugas / deadline.',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: listTugas.length,
            itemBuilder: (context, index) {
              final tugas = listTugas[index];
              return _buildTaskCard(context, tugas);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, CatatanModel tugas) {
    final now = DateTime.now();
    final deadline = tugas.deadline!;
    final difference = deadline.difference(now);

    String statusText;
    Color statusColor;

    if (difference.isNegative) {
      statusText = 'Terlewat';
      statusColor = Colors.redAccent;
    } else if (difference.inDays == 0 && deadline.day == now.day) {
      statusText = 'Hari Ini!';
      statusColor = Colors.orange;
    } else if (difference.inDays == 0 || difference.inDays == 1) {
      statusText = 'Besok (H-1)';
      statusColor = const Color(0xFF2383E2);
    } else {
      statusText = 'H-${difference.inDays}';
      statusColor = Colors.green;
    }

    String jam =
        "${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}";
    String tanggal = "${deadline.day}/${deadline.month}/${deadline.year}";

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        // Menggunakan InkWell sebagai ganti ListTile tap agar lebih fleksibel
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailCatatanScreen(catatan: tugas)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align to top
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: Icon(Icons.assignment_late_outlined, color: statusColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        tugas.judul.isEmpty ? 'Tugas Tanpa Judul' : tugas.judul,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(tugas.mataKuliah,
                        style: const TextStyle(color: Colors.blueGrey)),
                    const SizedBox(height: 8),
                    // PERBAIKAN: Menggunakan Wrap untuk elemen tanggal/jam agar tidak overflow
                    Wrap(
                      spacing: 12.0, // Jarak horizontal
                      runSpacing: 4.0, // Jarak vertikal jika elemen turun baris
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today,
                                size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(tanggal,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(jam,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Elemen Status dipisahkan agar selalu berada di kanan
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
