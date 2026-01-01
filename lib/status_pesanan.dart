import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../utils/session_helper.dart';
import '../models/pesanan_model.dart'; 
import '../services/pesanan_service.dart';
import 'feedback.dart';

class StatusPesananPage extends StatefulWidget {
  const StatusPesananPage({super.key});

  @override
  State<StatusPesananPage> createState() => _StatusPesananPageState();
}

class _StatusPesananPageState extends State<StatusPesananPage> {
  static const Color primaryDarkGreen = Color(0xFF385E39);
  static const Color lightCardGreen = Color(0xFFE4EDE5);
  static const Color greyColor = Color(0xFF888888);

  late Future<List<Pesanan>> _futurePesanan;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final token = await SessionHelper.getToken(); 
    if (token != null) {
      setState(() {
        _futurePesanan = PesananService().fetchPesanan(token); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCardGreen,
      appBar: AppBar(
        backgroundColor: primaryDarkGreen,
        elevation: 0,
        title: const Text("Status Pesanan", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Tambahkan RefreshIndicator agar status bisa diupdate dengan tarik layar
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: FutureBuilder<List<Pesanan>>(
          future: _futurePesanan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: primaryDarkGreen));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Belum ada pesanan."));
            }

            final pesanan = snapshot.data!.first;
            final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // Wajib ada untuk RefreshIndicator
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildStatusHeader(),
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        _buildDetailRow("ID Pesanan", pesanan.idPesanan),
                        _buildDetailRow("Penerima", pesanan.namaPenerima),
                        _buildDetailRow("Alamat", pesanan.alamatPengiriman),
                        _buildDetailRow("Metode", pesanan.metodePembayaran),
                        _buildDetailRow("Total Harga", currencyFormat.format(pesanan.totalHarga)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Tracker Status diperbarui sesuai ID Database
                  _buildTracker(pesanan.idStatusPesanan),
                  
                  const SizedBox(height: 40),
                  
                  // Tombol feedback muncul jika status Selesai (SP004)
                  if (pesanan.idStatusPesanan == "SP004") 
                    _buildFeedbackButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // LOGIKA TRACKER DISESUAIKAN DENGAN DATABASE (SP001 - SP004)
  bool _isStepActive(String currentStatusId, int stepLevel) {
    if (stepLevel == 1) {
       // Step 1: Menunggu Pembayaran / Diproses (SP001 & SP002)
       return true; 
    } 
    if (stepLevel == 2) {
       // Step 2: Dikirim (Aktif jika status SP003 atau SP004)
       return currentStatusId == "SP003" || currentStatusId == "SP004"; 
    } 
    if (stepLevel == 3) {
       // Step 3: Selesai (Hanya aktif jika status SP004)
       return currentStatusId == "SP004"; 
    } 
    return false;
  }

  Widget _buildTracker(String statusId) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          _buildStepIcon(Icons.inventory_2, "Diproses", _isStepActive(statusId, 1)),
          _buildConnector(_isStepActive(statusId, 2)),
          _buildStepIcon(Icons.local_shipping, "Dikirim", _isStepActive(statusId, 2)),
          _buildConnector(_isStepActive(statusId, 3)),
          _buildStepIcon(Icons.check_circle, "Selesai", _isStepActive(statusId, 3)),
        ],
      ),
    );
  }

  // Widget helper lainnya tetap sama...
  Widget _buildStepIcon(IconData icon, String label, bool active) {
    return Column(
      children: [
        Icon(icon, color: active ? primaryDarkGreen : greyColor, size: 30),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: active ? primaryDarkGreen : greyColor, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildConnector(bool active) => Expanded(child: Container(height: 2, color: active ? primaryDarkGreen : greyColor));

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryDarkGreen))),
          const Text(": "),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: primaryDarkGreen, borderRadius: BorderRadius.circular(15)),
      child: const Text("Status Pengiriman", textAlign: TextAlign.center, 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFeedbackButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: primaryDarkGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackPage())),
        child: const Text("BERI ULASAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}