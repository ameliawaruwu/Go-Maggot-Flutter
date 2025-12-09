// lib/feedback_page.dart
import 'package:flutter/material.dart';
import 'rating_star.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // State untuk menyimpan nilai-nilai feedback
  int _productQualityRating = 0;
  int _sellerServiceRating = 0;
  int _deliverySpeedRating = 0;
  String _description = '';
  bool _showName = true;
  bool _mediaAttached = false; // Simulasi untuk menandakan media telah dipilih

  // Warna-warna yang diestimasi dari desain gambar
  final Color primaryColor = const Color.fromARGB(255, 55, 89, 53); // Latar Belakang Utama
  final Color cardColor = const Color(0xFFE4EDE1); // Warna Card/Background Deskripsi
  final Color textColor = Colors.white;

  void _submitFeedback() {
    // Logika untuk mengirim data ke server
    debugPrint('Feedback Dikirim:');
    debugPrint('Kualitas Produk: $_productQualityRating');
    debugPrint('Pelayanan Penjual: $_sellerServiceRating');
    debugPrint('Kecepatan Pengiriman: $_deliverySpeedRating');
    debugPrint('Deskripsi: $_description');
    debugPrint('Tampilkan Nama: $_showName');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ulasan produk berhasil dikirim!')),
    );
  }

  // Widget untuk tombol unggah media
  Widget _buildMediaUploadButton(IconData icon, String label) {
    return Expanded(
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
          onPressed: () {
            // Logika memilih file gambar/video
            setState(() {
              _mediaAttached = true; // Set state untuk simulasi
            });
            debugPrint('Memilih $label');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: cardColor, // Warna latar belakang tombol
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
          TextButton(
            onPressed: _submitFeedback,
            child: Text(
              'Submit',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Kualitas Produk Rating ---
            Text(
              'Kualitas Produk',
              style: TextStyle(
                  color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            // Widget Rating Bintang untuk Kualitas Produk
            InteractiveRatingStars(
              onRatingChanged: (rating) {
                setState(() {
                  _productQualityRating = rating;
                });
              },
            ),
            const SizedBox(height: 20),

            // --- Deskripsi Text Area ---
            Text(
              'Deskripsi:',
              style: TextStyle(
                  color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  maxLines: null, // Memungkinkan banyak baris
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Tuliskan ulasan produk Anda di sini...',
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                  onChanged: (value) {
                    _description = value;
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Tambahkan Gambar atau Video ---
            Text(
              'Tambahkan gambar atau video:',
              style: TextStyle(
                  color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                _buildMediaUploadButton(Icons.image_outlined, 'gambar'),
                _buildMediaUploadButton(Icons.video_library_outlined, 'video'),
              ],
            ),
            const SizedBox(height: 30),

            // --- Opsi Tampilkan Nama (Toggle) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Tampilkan Nama',
                  style: TextStyle(color: textColor, fontSize: 18),
                ),
                Switch(
                  value: _showName,
                  onChanged: (value) {
                    setState(() {
                      _showName = value;
                    });
                  },
                  activeColor: cardColor, 
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade400,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Pelayanan Penjual Rating ---
            Text(
              'Pelayanan Penjual',
              style: TextStyle(color: textColor, fontSize: 18),
            ),
            const SizedBox(height: 10),
            InteractiveRatingStars(
              onRatingChanged: (rating) {
                setState(() {
                  _sellerServiceRating = rating;
                });
              },
            ),
            const SizedBox(height: 20),

            // --- Kecepatan Pengiriman Rating ---
            Text(
              'Kecepatan Pengiriman',
              style: TextStyle(color: textColor, fontSize: 18),
            ),
            const SizedBox(height: 10),
            InteractiveRatingStars(
              onRatingChanged: (rating) {
                setState(() {
                  _deliverySpeedRating = rating;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}