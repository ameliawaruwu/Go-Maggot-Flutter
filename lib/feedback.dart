import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; //
import 'rating_star.dart';
import '../models/review_model.dart';
import '../services/feedback_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // State untuk input user
  int _productQualityRating = 0;
  int _sellerServiceRating = 0;
  int _deliverySpeedRating = 0;
  String _description = '';
  bool _showName = true;
  bool _isLoading = false;

  // State untuk file media
  File? _imageFile;
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();

  final Color primaryColor = const Color.fromARGB(255, 55, 89, 53);
  final Color cardColor = const Color(0xFFE4EDE1);
  final Color textColor = Colors.white;

  // Fungsi memilih Gambar
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  // Fungsi memilih Video
  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _videoFile = File(pickedFile.path));
    }
  }

  void _submitFeedback() async {
    if (_description.trim().isEmpty) {
      _showSnackBar('Tuliskan ulasan produk Anda terlebih dahulu!');
      return;
    }

    if (_productQualityRating == 0 || _sellerServiceRating == 0) {
      _showSnackBar('Mohon berikan rating bintang.');
      return;
    }

    setState(() => _isLoading = true);

    // Bungkus data teks ke model
    ReviewModel reviewBaru = ReviewModel(
      idProduk: "PR01", // Sesuaikan dengan ID produk Anda
      ratingSeller: _sellerServiceRating,
      komentar: _description,
      kualitas: "Bintang $_productQualityRating",
      tampilkanUsername: _showName ? 1 : 0,
    );

    // Kirim data dan file ke Service (Gunakan fungsi Multipart)
    bool sukses = await FeedbackService.kirimReview(
      reviewBaru, 
      foto: _imageFile, 
      video: _videoFile
    );

    setState(() => _isLoading = false);

    if (sukses) {
      _showSnackBar('Ulasan produk berhasil dikirim! ❤️');
      if (mounted) Navigator.pop(context);
    } else {
      _showSnackBar('Gagal mengirim ulasan. Cek Login atau Koneksi Anda.');
    }
  }

  void _showSnackBar(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  Widget _buildMediaButton(IconData icon, String label, File? file, VoidCallback onTap) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: file != null ? Colors.lightGreen : cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Icon(
                file != null ? Icons.check_circle : icon, 
                size: 40, 
                color: primaryColor
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            file != null ? "Berhasil dipilih" : label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
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
        title: Text('Nilai Produk', style: TextStyle(color: textColor)),
        actions: [
          _isLoading 
          ? const Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: CircularProgressIndicator(color: Colors.white)))
          : TextButton(onPressed: _submitFeedback, child: Text('Submit', style: TextStyle(color: textColor, fontSize: 16))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kualitas Produk', style: TextStyle(color: textColor, fontSize: 18)),
            const SizedBox(height: 10),
            InteractiveRatingStars(onRatingChanged: (rating) => setState(() => _productQualityRating = rating)),
            
            const SizedBox(height: 20),
            Text('Deskripsi:', style: TextStyle(color: textColor, fontSize: 18)),
            const SizedBox(height: 10),
            Container(
              height: 150,
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(12),
              child: TextField(
                maxLines: null,
                decoration: const InputDecoration.collapsed(hintText: 'Tuliskan ulasan Anda...'),
                onChanged: (value) => _description = value,
              ),
            ),
            
            const SizedBox(height: 20),
            Text('Tambahkan gambar atau video:', style: TextStyle(color: textColor, fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildMediaButton(Icons.image_outlined, 'Foto', _imageFile, _pickImage),
                _buildMediaButton(Icons.video_library_outlined, 'Video', _videoFile, _pickVideo),
              ],
            ),
            
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tampilkan Nama', style: TextStyle(color: textColor, fontSize: 18)),
                Switch(
                  value: _showName,
                  onChanged: (val) => setState(() => _showName = val),
                  activeColor: cardColor,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            Text('Pelayanan Penjual', style: TextStyle(color: textColor, fontSize: 18)),
            const SizedBox(height: 10),
            InteractiveRatingStars(onRatingChanged: (rating) => setState(() => _sellerServiceRating = rating)),
          ],
        ),
      ),
    );
  }
}