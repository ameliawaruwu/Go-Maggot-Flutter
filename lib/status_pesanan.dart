import 'package:flutter/material.dart';
import 'feedback.dart';
import 'models/pesanan_model.dart';
import '../services/pesanan_service.dart';

class StatusPesananPage extends StatefulWidget {
  const StatusPesananPage({super.key});

  @override
  State<StatusPesananPage> createState() => _StatusPesananPageState();
}

class _StatusPesananPageState extends State<StatusPesananPage> {
  // --- PALET WARNA ---
  static const Color primaryDarkGreen = Color(0xFF385E39);
  static const Color lightCardGreen = Color(0xFFE4EDE5);
  static const Color greyColor = Color(0xFF888888);

  late Future<List<PesananModel>> _futurePesanan;

  @override
  void initState() {
    super.initState();
    // Ganti "1" dengan ID Pengguna yang login (dari Session/SharedPrefs)
    _futurePesanan = PesananService().getPesananUser("1");
  }

  void _refreshStatus() {
    setState(() {
      _futurePesanan = PesananService().getPesananUser("1");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCardGreen,
      appBar: AppBar(
        backgroundColor: primaryDarkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Status Pesanan",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<PesananModel>>(
        future: _futurePesanan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryDarkGreen));
          } else if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Kamu belum memiliki pesanan."));
          }

          // Kita ambil pesanan terbaru (indeks 0) sebagai tampilan utama
          final pesanan = snapshot.data!.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // 1. Kotak Judul Status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: primaryDarkGreen.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Ini Status Pesanan Kamu!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),

                // 2. Detail Pesanan (DINAMIS DARI DB)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow("ID Pesanan", pesanan.idPesanan, primaryDarkGreen),
                      _buildDetailRow("Nama Penerima", pesanan.namaPenerima, primaryDarkGreen),
                      _buildDetailRow("Alamat Pengiriman", pesanan.alamatPengiriman, primaryDarkGreen),
                      _buildDetailRow("Tanggal Pesanan", pesanan.tanggalPesanan, primaryDarkGreen),
                      _buildDetailRow("Total Harga", "Rp ${pesanan.totalHarga}", primaryDarkGreen),
                      _buildDetailRow("Metode Pembayaran", pesanan.metodePembayaran, primaryDarkGreen),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 3. Status Tracker (DINAMIS BERDASARKAN STATUS DARI DB)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStepItem(Icons.inventory_2, "Di Kemas", 
                          _checkActive(pesanan.statusNama, 1), primaryDarkGreen, greyColor),
                      Expanded(child: Container(height: 2, color: _checkActive(pesanan.statusNama, 2) ? primaryDarkGreen : greyColor)),
                      _buildStepItem(Icons.local_shipping, "Di Kirim", 
                          _checkActive(pesanan.statusNama, 2), primaryDarkGreen, greyColor),
                      Expanded(child: Container(height: 2, color: _checkActive(pesanan.statusNama, 3) ? primaryDarkGreen : greyColor)),
                      _buildStepItem(Icons.home, "Selesai", 
                          _checkActive(pesanan.statusNama, 3), primaryDarkGreen, greyColor),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 4. Tombol Aksi
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDarkGreen,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("KEMBALI KE\nBERANDA", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _refreshStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greyColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("REFRESH\nSTATUS", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8FA88F),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("BERI FEEDBACK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // LOGIKA TRACKING: Menentukan apakah tahapan status aktif atau tidak
  bool _checkActive(String currentStatus, int stepLevel) {
    String status = currentStatus.toLowerCase();
    if (stepLevel == 1) return true; // Minimal selalu "Di Kemas" jika ada di DB
    if (stepLevel == 2 && (status == 'dikirim' || status == 'selesai')) return true;
    if (stepLevel == 3 && status == 'selesai') return true;
    return false;
  }

  Widget _buildDetailRow(String label, String value, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: labelColor, fontSize: 14))),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildStepItem(IconData icon, String label, bool isActive, Color activeColor, Color inactiveColor) {
    return Column(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: isActive ? activeColor : inactiveColor, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? activeColor : inactiveColor)),
      ],
    );
  }
}