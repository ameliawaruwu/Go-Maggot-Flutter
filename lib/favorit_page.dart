import 'package:flutter/material.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  String selectedKategori = 'Semua';

  final List<String> kategoriList = [
    'Semua',
    'BSF',
    'Kompos',
    'Kandang Maggot',
  ];

  // =========================
  // DUMMY DATA FAVORIT
  // =========================
  final List<Map<String, dynamic>> dummyFavorit = [
    {
      'nama': 'Bibit Maggot',
      'harga': 25000,
      'kategori': 'BSF',
    },
    {
      'nama': 'Maggot Dewasa',
      'harga': 50000,
      'kategori': 'BSF',
    },
    {
      'nama': 'Pupuk Kompos',
      'harga': 15000,
      'kategori': 'Kompos',
    },
    {
      'nama': 'Kandang Maggot',
      'harga': 150000,
      'kategori': 'Kandang Maggot',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredData = selectedKategori == 'Semua'
        ? dummyFavorit
        : dummyFavorit
            .where((item) => item['kategori'] == selectedKategori)
            .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF385E39),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Favorit Saya',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // =========================
          // HEADER KATEGORI (DROPDOWN)
          // =========================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedKategori,
                        isExpanded: true,
                        items: kategoriList.map((kategori) {
                          return DropdownMenuItem(
                            value: kategori,
                            child: Text(kategori),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedKategori = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =========================
          // GRID PRODUK FAVORIT
          // =========================
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                return _buildFavoritCard(filteredData[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // CARD PRODUK FAVORIT
  // =========================
  Widget _buildFavoritCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE + FAVORITE ICON
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 40),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nama'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Rp ${item['harga']}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.star, size: 14, color: Colors.orange),
                    SizedBox(width: 4),
                    Text('5.0', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
