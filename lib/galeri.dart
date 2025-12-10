import 'package:flutter/material.dart';

class GaleriPage extends StatefulWidget {
  const GaleriPage({super.key});

  @override
  State<GaleriPage> createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
  // --- PALET WARNA ---
  final Color primaryDarkGreen = const Color(0xFF385E39); // Hijau Tua (Header)
  final Color lightCardGreen = const Color(0xFFE4EDE5);   // Hijau Pucat (Body)
  final Color accentLightGreen = const Color(0xFF6E9E4F); // Hijau Aksen

  // Data Dummy Gambar (Ganti dengan path asset kamu)
  final List<String> listGambar1 = [
    'assets/Bibit-remove_bg.png',
    'assets/maggot_removebg.png',
    'assets/kompos_remove_bg.png',
  ];

  final List<String> listGambar2 = [
    'assets/images/article_sample.png', // Pastikan asset ini ada
    'assets/Kandang.png',
    'assets/Bundling_Maggot.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCardGreen, // Background Bawah Terang
      
      // --- HEADER HIJAU TUA ---
      appBar: AppBar(
        backgroundColor: primaryDarkGreen,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kembali",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Membuat lengkungan manis di bawah header
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // 1. JUDUL CHIP "Galeri Kami"
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: primaryDarkGreen.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  "Galeri Kami",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryDarkGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 2. SLIDER GALERI 1
            _buildGallerySection(
              title: "Proses Pengeringan\nBibit Maggot",
              images: listGambar1,
            ),

            const SizedBox(height: 30),

            // 3. SLIDER GALERI 2
            _buildGallerySection(
              title: "Proses Pemberian Pakan\nUntuk Ayam",
              images: listGambar2,
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // WIDGET BUILDER: Membuat Section Galeri (Judul + Slider)
  Widget _buildGallerySection({required String title, required List<String> images}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryDarkGreen,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 15),

        // Panggil Widget Carousel Buatan Sendiri
        SizedBox(
          height: 220, // Tinggi area slider
          child: _GalleryCarousel(images: images, primaryColor: primaryDarkGreen),
        ),
      ],
    );
  }
}

// --- WIDGET CAROUSEL (SLIDER) ---
class _GalleryCarousel extends StatefulWidget {
  final List<String> images;
  final Color primaryColor;

  const _GalleryCarousel({required this.images, required this.primaryColor});

  @override
  State<_GalleryCarousel> createState() => _GalleryCarouselState();
}

class _GalleryCarouselState extends State<_GalleryCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AREA GAMBAR (BISA DIGESER)
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              // Efek Scale agar gambar aktif lebih besar
              final bool isActive = index == _currentIndex;
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: isActive ? 0 : 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      // INTERAKSI KLIK GAMBAR
                      onTap: () {
                        // Tampilkan Dialog Zoom Gambar
                        showDialog(
                          context: context, 
                          builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(widget.images[index], fit: BoxFit.contain),
                            ),
                          )
                        );
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            widget.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                            ),
                          ),
                          // Overlay Gradient Halus di Bawah
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 10),

        // INDIKATOR TITIK (DOTS)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (index) {
            final bool isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 20 : 8, // Titik aktif lebih panjang
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? widget.primaryColor : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}