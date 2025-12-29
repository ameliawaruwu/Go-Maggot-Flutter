import 'package:flutter/material.dart';
import 'rating_star.dart';
// Import file-file pendukung yang sudah kita buat tadi
import '../models/review_model.dart';
import '../services/feedback_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // State untuk menampung input user
  int _productQualityRating = 0;
  int _sellerServiceRating = 0;
  int _deliverySpeedRating = 0;
  String _description = '';
  bool _showName = true;
  bool _isLoading = false; // Untuk indikator loading

  final Color primaryColor = const Color.fromARGB(255, 55, 89, 53);
  final Color cardColor = const Color(0xFFE4EDE1);
  final Color textColor = Colors.white;

  // ==========================================================
  // FUNGSI SUBMIT (SUDAH TERHUBUNG KE DATABASE)
  // ==========================================================
  void _submitFeedback() async {
    // 1. Validasi: Jangan biarkan komentar kosong
    if (_description.trim().isEmpty) {
      _showSnackBar('Tuliskan ulasan produk Anda terlebih dahulu!');
      return;
    }

    // 2. Validasi: Pastikan bintang sudah diisi
    if (_productQualityRating == 0 || _sellerServiceRating == 0) {
      _showSnackBar('Mohon berikan rating bintang.');
      return;
    }

    setState(() => _isLoading = true);

    // 3. Bungkus data ke dalam Model
    // idProduk sementara kita hardcode "PR01" (sesuaikan dengan id di database kamu)
    ReviewModel reviewBaru = ReviewModel(
      idProduk: "PR01", 
      ratingSeller: _sellerServiceRating,
      komentar: _description,
      kualitas: "Bintang $_productQualityRating",
      tampilkanUsername: _showName ? 1 : 0,
    );

    // 4. Kirim melalui Service
    bool sukses = await FeedbackService.kirimReview(reviewBaru);

    setState(() => _isLoading = false);

    if (sukses) {
      _showSnackBar('Ulasan produk berhasil dikirim! ❤️');
      if (mounted) Navigator.pop(context); // Balik ke halaman sebelumnya
    } else {
      _showSnackBar('Gagal mengirim ulasan. Cek Login atau Koneksi Anda.');
    }
  }

  void _showSnackBar(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  // Widget untuk tombol unggah media (Visual saja untuk sekarang)
  Widget _buildMediaUploadButton(IconData icon, String label) {
    return Expanded(
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
          onPressed: () => debugPrint('Memilih $label'),
          style: ElevatedButton.styleFrom(
            backgroundColor: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
          child: Icon(icon, size: 40, color: primaryColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nilai Produk',
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        actions: [
          // Jika sedang loading, tampilkan spinner kecil
          _isLoading 
          ? const Padding(
              padding: EdgeInsets.all(15.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            )
          : TextButton(
              onPressed: _submitFeedback,
              child: Text('Submit', style: TextStyle(color: textColor, fontSize: 16)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Kualitas Produk', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            InteractiveRatingStars(onRatingChanged: (rating) => setState(() => _productQualityRating = rating)),
            
            const SizedBox(height: 20),
            Text('Deskripsi:', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  maxLines: null,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Tuliskan ulasan produk Anda di sini...',
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                  onChanged: (value) => _description = value,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Text('Tambahkan gambar atau video:', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(children: [_buildMediaUploadButton(Icons.image_outlined, 'gambar'), _buildMediaUploadButton(Icons.video_library_outlined, 'video')]),
            
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tampilkan Nama', style: TextStyle(color: textColor, fontSize: 18)),
                Switch(
                  value: _showName,
                  onChanged: (value) => setState(() => _showName = value),
                  activeColor: cardColor,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            Text('Pelayanan Penjual', style: TextStyle(color: textColor, fontSize: 18)),
            const SizedBox(height: 10),
            InteractiveRatingStars(onRatingChanged: (rating) => setState(() => _sellerServiceRating = rating)),
            
            const SizedBox(height: 20),
            Text('Kecepatan Pengiriman', style: TextStyle(color: textColor, fontSize: 18)),
            const SizedBox(height: 10),
            InteractiveRatingStars(onRatingChanged: (rating) => setState(() => _deliverySpeedRating = rating)),
          ],
        ),
      ),
    );
  }
}