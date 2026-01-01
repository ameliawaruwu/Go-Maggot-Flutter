import 'package:flutter/material.dart';
import '../models/galeri_model.dart';
import '../services/galeri_service.dart';

class GaleriPage extends StatefulWidget {
  const GaleriPage({super.key});

  @override
  State<GaleriPage> createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
  final Color primaryDarkGreen = const Color(0xFF385E39);
  final Color lightCardGreen = const Color(0xFFE4EDE5);
  
  late Future<List<GaleriModel>> futureGaleri;

  @override
  void initState() {
    super.initState();
    // Inisialisasi pengambilan data saat widget pertama kali dimuat
    futureGaleri = GaleriService().fetchGaleri();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCardGreen,
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureGaleri = GaleriService().fetchGaleri();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              // JUDUL CHIP
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDarkGreen),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // FUTURE BUILDER UNTUK DATA DINAMIS
              FutureBuilder<List<GaleriModel>>(
                future: futureGaleri,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada foto di galeri."));
                  }

                  final dataGaleri = snapshot.data!;

                  return _buildGallerySection(
                    title: "Koleksi Kegiatan Kami",
                    items: dataGaleri,
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGallerySection({required String title, required List<GaleriModel> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDarkGreen),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 250, // Ditinggikan sedikit untuk menampung teks keterangan
          child: _GalleryCarousel(items: items, primaryColor: primaryDarkGreen),
        ),
      ],
    );
  }
}

class _GalleryCarousel extends StatefulWidget {
  final List<GaleriModel> items;
  final Color primaryColor;

  const _GalleryCarousel({required this.items, required this.primaryColor});

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
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final item = widget.items[index];
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
                      onTap: () => _showLargeImage(context, item.gambarUrl),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // IMAGE NETWORK (Dari Laravel)
                         Image.network(
                            // Menangani spasi agar menjadi %20 secara otomatis
                            Uri.encodeFull(item.gambarUrl ?? ''), 
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, size: 50),
                              );
                            },
                          ),
                          // Keterangan Overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                ),
                              ),
                              child: Text(
                                item.keterangan ?? '',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: index == _currentIndex ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == _currentIndex ? widget.primaryColor : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showLargeImage(BuildContext context, String? url) {
    if (url == null) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(url, fit: BoxFit.contain),
        ),
      ),
    );
  }
}