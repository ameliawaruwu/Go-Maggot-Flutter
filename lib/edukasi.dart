import 'package:flutter/material.dart';
import 'models/artikel_model.dart';
import 'services/artikel_service.dart'; // Sesuaikan path jika perlu
import 'artikel_detail.dart';

class EdukasiContent extends StatefulWidget {
  const EdukasiContent({super.key});

  @override
  State<EdukasiContent> createState() => _EdukasiContentState();
}

class _EdukasiContentState extends State<EdukasiContent> {
  late Future<List<ArtikelModel>> futureArtikels;

  @override
  void initState() {
    super.initState();
    futureArtikels = ArtikelService().fetchArtikels();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryDarkGreen = Color(0xFF385E39);
    const Color lightCardGreen = Color(0xFFE4EDE5);
    const Color limeText = Color(0xFF7BBC38);
    const Color buttonGreen = Color(0xFF6AA336);

    return Scaffold(
      backgroundColor: lightCardGreen,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hai Gomma,", style: TextStyle(fontSize: 24, color: primaryDarkGreen, fontWeight: FontWeight.bold)),
            const Text("Let’s Learn!", style: TextStyle(fontSize: 24, color: limeText, fontWeight: FontWeight.w800)),
            const SizedBox(height: 25),
            
            // ... (Bagian Video Banner Anda) ...

            const SizedBox(height: 30),
            const Row(
              children: [
                Expanded(child: Divider(color: primaryDarkGreen, thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Artikel Kami", style: TextStyle(color: primaryDarkGreen, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(child: Divider(color: primaryDarkGreen, thickness: 1)),
              ],
            ),
            const SizedBox(height: 20),

            FutureBuilder<List<ArtikelModel>>(
              future: futureArtikels,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada artikel tersedia."));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final artikel = snapshot.data![index];
                    return _buildArticleCard(context, artikel, Colors.white, buttonGreen, primaryDarkGreen);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, ArtikelModel artikel, Color cardBg, Color btnColor, Color textColor) {
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
                image: DecorationImage(
                  // Menggunakan field gambarUrl yang dikirim dari Laravel Controller
                  image: NetworkImage(artikel.gambarUrl), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 3,
            child: Text(
              artikel.judul,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 24,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtikelDetailPage(artikel: artikel),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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