import 'package:flutter/material.dart';
import 'colors.dart'; 
import 'komponen-navbar.dart'; 
import 'product.dart'; 

class PlaceholderCommunity extends StatelessWidget {
  const PlaceholderCommunity({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Halaman Komunitas'));
}

class PlaceholderProfile extends StatelessWidget {
  const PlaceholderProfile({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Halaman Profile'));
}

class PlaceholderEducation extends StatelessWidget {
  const PlaceholderEducation({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Halaman Edukasi'));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int _selectedIndex = 0; 

  late final List<Widget> _widgetOptions; 
  
  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomeContent(), // Index 0: Konten Beranda lama (dibuat di bawah)
      const ProductPage(), // Index 1: Halaman Produk
      const PlaceholderCommunity(), // Index 2: Komunitas
      const PlaceholderProfile(), // Index 3: Profile
      const PlaceholderEducation(), // Index 4: Edukasi
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
    debugPrint('Navigasi ke Indeks: $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0 ? _buildCustomAppBar(context) : null,
      
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      
      bottomNavigationBar: CustomBottomNavBar(
        indexSelected: _selectedIndex, 
        onItemSelected: _onItemTapped, 
      ),
    );
  }

  AppBar _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: primaryDarkGreen,
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 90, 
      flexibleSpace: Container(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
        decoration: const BoxDecoration(
          color: primaryDarkGreen,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kaushan Script', 
                  color: accentLightGreen, 
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'Go'),
                  TextSpan(
                    text: 'Maggot',
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Kaushan Script', 
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, color: secondaryTextColor, size: 30),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: secondaryTextColor, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAboutMaggotSection(context),
            const SizedBox(height: 20),
            _buildTopProductsSection(context),
            const SizedBox(height: 20),
            _buildCultivationPromotion(context),
            const SizedBox(height: 20),
          ],
        ),
      );
  }

  Widget _buildAboutMaggotSection(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundLightGreen,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3)),],
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Gambar Maggot
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/maggot_removebg.png', width: 100, height: 100, fit: BoxFit.cover,),
              ),
              const SizedBox(width: 15),
              // Deskripsi
              const Expanded(
                child: Text('Apa itu maggot?\nMaggot atau lebih sering disebut sebagai belatung, merupakan larva dari jenis lalat Black Soldier Fly (BSF) atau dalam bahasa latin disebut dengan Hermetia Illucens. Bisa dibilang, maggot adalah larva dari jenis lalat yang semula berasal dari telur, kemudian bermetamorfosis menjadi lalat dewasa.', style: TextStyle(fontSize: 14, color: primaryTextColor, height: 1.4,), textAlign: TextAlign.justify,),
              ),
            ],
          ),
      );
  }

  Widget _buildTopProductsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Produk Terlaris Bulan Ini!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryDarkGreen,),),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0, 
            children: [
              _buildProductItem('assets/Bibit-remove_bg.png'), 
              _buildProductItem('assets/Bundling_Maggot.png'),
              _buildProductItem('assets/maggot_removebg.png'), 
              _buildProductItem('assets/kompos_remove_bg.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCultivationPromotion(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: primaryDarkGreen,
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          opacity: 0.5,
        ),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Yuk budidaya maggot!', style: TextStyle(color: secondaryTextColor, fontSize: 22, fontWeight: FontWeight.bold,),),
                const SizedBox(height: 5),
                const Text('Mengenal lebih dalam seputar budidaya maggot yang mudah dan efisien untuk pemula', style: TextStyle(color: secondaryTextColor, fontSize: 14,), maxLines: 2, overflow: TextOverflow.ellipsis,),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            right: 15,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentLightGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
              ),
              child: const Text('selengkapnya', style: TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }

  
  static const Color primaryDarkGreen = Color(0xFF385E39);
  static const Color accentLightGreen = Color(0xFF6E9E4F);
  static const Color secondaryTextColor = Colors.white; 
  static const Color primaryTextColor = Colors.black; 
  static const Color backgroundLightGreen = Color(0xFFE8F5E9); 
  static const Color cardColor = Colors.white; 
}

