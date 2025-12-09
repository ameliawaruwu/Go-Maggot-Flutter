import 'package:flutter/material.dart';
import 'komponen-navbar.dart'; 

class EdukasiPage extends StatelessWidget {
  const EdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA ---
    const Color primaryDarkGreen = Color(0xFF385E39); // Hijau Tua (Header)
    const Color lightCardGreen = Color(0xFFE4EDE5);   // Hijau Pucat (Body)
    const Color limeText = Color(0xFF7BBC38);         // Teks Aksen
    const Color buttonGreen = Color(0xFF6AA336);      // Tombol
    
    return Scaffold(
      backgroundColor: lightCardGreen, // Background Body Hijau Pucat
      
      // --- HEADER (APPBAR) HIJAU TUA ---
      appBar: AppBar(
        backgroundColor: primaryDarkGreen, // <--- INI JADI HIJAU TUA
        elevation: 0,
        toolbarHeight: 80, // Tinggi header disesuaikan
        automaticallyImplyLeading: false, // Hilangkan tombol back default
        
        // Isi Header (Search Bar + Notif)
        title: Row(
          children: [
            // Search Bar
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white, // Putih agar kontras dengan hijau tua
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Cari artikel...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: Icon(Icons.search, size: 24, color: primaryDarkGreen),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            
            // Icon Notifikasi
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5), // Border Putih
              ),
              child: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 26),
            ),
          ],
        ),
        
        // Membuat lengkungan di bawah AppBar (Opsional, biar manis)
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),

      // --- BODY ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. TEKS SAMBUTAN
            const Text(
              "Hai Gomma,",
              style: TextStyle(fontSize: 24, color: primaryDarkGreen, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Let’s Learn!",
              style: TextStyle(fontSize: 24, color: limeText, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 25),

            // 3. VIDEO THUMBNAIL
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.black26, 
                // image: const DecorationImage(image: AssetImage('assets/images/video_thumbnail.png'), fit: BoxFit.cover,),
              ),
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white, 
                    shape: BoxShape.circle, 
                  ),
                  padding: const EdgeInsets.all(2), 
                  child: const Icon(Icons.play_circle_fill, color: Colors.red, size: 70),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 4. DIVIDER "Artikel Kami"
            const Row(
              children: [
                Expanded(child: Divider(color: primaryDarkGreen, thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Artikel Kami",
                    style: TextStyle(color: primaryDarkGreen, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(child: Divider(color: primaryDarkGreen, thickness: 1)),
              ],
            ),
            const SizedBox(height: 20),

            // 5. GRID ARTIKEL
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildArticleCard(Colors.white, buttonGreen, primaryDarkGreen);
              },
            ),
          ],
        ),
      ),
      
      // --- BOTTOM NAVIGATION BAR (PUTIH DEFAULT) ---
      bottomNavigationBar: const CustomBottomNavBar(
        indexSelected: 3, 
        // Kita tidak mengirim parameter warna, jadi dia akan pakai default (Putih)
      ),
    );
  }

  // WIDGET KARTU ARTIKEL
  Widget _buildArticleCard(Color cardBg, Color btnColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade200,
              ),
              child: const Center(child: Icon(Icons.image, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 8),
          
          Expanded(
            flex: 3,
            child: Text(
              "Maggot ini dapat dipakai untuk pakan hewan ternak loh!",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          SizedBox(
            height: 24,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "selengkapnya",
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}