import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'rating_star.dart'; // <-- Baris ini dihapus agar tidak konflik
import '../models/review_model.dart';
import '../services/feedback_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _productQualityRating = 0;
  int _sellerServiceRating = 0;
  String _description = '';
  bool _showName = true;
  bool _isLoading = false;

  File? _imageFile;
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();

  // --- PALETTE WARNA ---
  final Color appBarGreen = const Color(0xFF385E39);     // Hijau Tua
  final Color bgGreenMatte = const Color(0xFFD4E2D4);    // Hijau Sage Matang
  final Color buttonGreen = const Color(0xFF6E9E4F);     // Hijau Tombol
  final Color starYellow = const Color(0xFFFFD700);      // Kuning Bintang
  final Color cardWhite = Colors.white;                  

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _videoFile = File(pickedFile.path));
  }

  void _submitFeedback() async {
    if (_description.trim().isEmpty || _productQualityRating == 0) {
      _showSnackBar('Mohon lengkapi ulasan Anda.');
      return;
    }
    setState(() => _isLoading = true);
    
    ReviewModel reviewBaru = ReviewModel(
      idProduk: "PR01",
      ratingSeller: _sellerServiceRating,
      komentar: _description,
      kualitas: "Bintang $_productQualityRating",
      tampilkanUsername: _showName ? 1 : 0,
    );

    bool sukses = await FeedbackService.kirimReview(reviewBaru, foto: _imageFile, video: _videoFile);
    setState(() => _isLoading = false);

    if (sukses) {
      _showSnackBar('Ulasan berhasil dikirim!');
      if (mounted) Navigator.pop(context); // Tambahkan check mounted
    } else {
      _showSnackBar('Gagal mengirim ulasan.');
    }
  }

  void _showSnackBar(String pesan) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  Widget _buildInputCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreenMatte,
      appBar: AppBar(
        backgroundColor: appBarGreen,
        elevation: 0,
        centerTitle: false, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Nilai Produk', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              children: [
                _buildInputCard(
                  title: "Bagaimana kualitas produk ini?",
                  child: InteractiveRatingStars(
                    color: starYellow, // Sekarang parameter ini valid
                    onRatingChanged: (r) => setState(() => _productQualityRating = r)
                  ),
                ),

                _buildInputCard(
                  title: "Tuliskan ulasan Anda",
                  child: TextField(
                    maxLines: 4,
                    onChanged: (v) => _description = v,
                    decoration: const InputDecoration.collapsed(hintText: 'Ulasan jujur Anda sangat membantu kami...'),
                  ),
                ),

                _buildInputCard(
                  title: "Tambahkan Foto atau Video",
                  child: Row(
                    children: [
                      _buildMediaBtn("Foto", _imageFile, Icons.camera_alt, _pickImage),
                      const SizedBox(width: 15),
                      _buildMediaBtn("Video", _videoFile, Icons.videocam, _pickVideo),
                    ],
                  ),
                ),

                _buildInputCard(
                  title: "Pelayanan & Privasi",
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tampilkan Nama", style: TextStyle(fontSize: 14)),
                          Switch(
                            value: _showName,
                            onChanged: (v) => setState(() => _showName = v),
                            activeColor: appBarGreen,
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Rating Pelayanan Penjual", style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ),
                      const SizedBox(height: 10),
                      InteractiveRatingStars(
                        color: starYellow, // Parameter ini valid
                        onRatingChanged: (r) => setState(() => _sellerServiceRating = r)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("KIRIM Ulasan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaBtn(String label, File? file, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: bgGreenMatte.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            image: file != null ? DecorationImage(image: FileImage(file), fit: BoxFit.cover) : null,
          ),
          child: file == null 
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: appBarGreen), Text(label, style: const TextStyle(fontSize: 11))])
            : const Align(alignment: Alignment.topRight, child: Icon(Icons.check_circle, color: Colors.green, size: 20)),
        ),
      ),
    );
  }
}

// --- DEFINISI WIDGET BINTANG DI SINI ---
// Ini akan menggantikan file rating_star.dart yang error
class InteractiveRatingStars extends StatefulWidget {
  final Color color;
  final Function(int) onRatingChanged;

  const InteractiveRatingStars({
    Key? key,
    required this.color, // Kita definisikan color di sini
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _InteractiveRatingStarsState createState() => _InteractiveRatingStarsState();
}

class _InteractiveRatingStarsState extends State<InteractiveRatingStars> {
  int _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingChanged(_currentRating);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              index < _currentRating ? Icons.star : Icons.star_border,
              color: widget.color, // Menggunakan warna dari parameter
              size: 36,
            ),
          ),
        );
      }),
    );
  }
}