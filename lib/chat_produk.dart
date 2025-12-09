import 'package:flutter/material.dart';

class ChatProdukPage extends StatefulWidget {
  const ChatProdukPage({super.key});

  @override
  State<ChatProdukPage> createState() => _ChatProdukPageState();
}

class _ChatProdukPageState extends State<ChatProdukPage> {
  final TextEditingController _controller = TextEditingController();

  // --- RUMUS WARNA (Sesuai Permintaan) ---
  final Color primaryDarkGreen = const Color(0xFF385E39); // Hijau Tua (Header & Bubble Saya)
  final Color accentLightGreen = const Color(0xFF6E9E4F); // Hijau Aksen (Opsional)
  final Color lightCardGreen = const Color(0xFFE4EDE5);   // Hijau Pucat (Background)
  
  // Data Dummy Chat
  final List<Map<String, dynamic>> messages = [
    {"text": "Halo kak, selamat datang di GoMaggot! 👋", "isMe": false, "time": "08:00"},
    {"text": "Ada yang bisa kami bantu terkait produk maggotnya?", "isMe": false, "time": "08:01"},
    {"text": "Halo min, mau tanya stok Maggot Kering 3kg ready ga ya?", "isMe": true, "time": "08:05"},
    {"text": "Ready kak! Silahkan langsung di checkout ya sebelum kehabisan 😄", "isMe": false, "time": "08:06"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCardGreen, // Background Hijau Pucat

      // --- HEADER (AppBar) ---
      appBar: AppBar(
        backgroundColor: primaryDarkGreen, // Header Hijau Tua
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // Avatar Admin
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.grey), 
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Admin GoMaggot",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    const Text("Online", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),

      // --- BODY (List Chat) ---
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildChatBubble(msg['text'], msg['time'], msg['isMe']);
              },
            ),
          ),

          // --- INPUT FIELD (Bagian Bawah) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Tombol Attachment (+)
                Icon(Icons.add_circle_outline, color: primaryDarkGreen, size: 28),
                const SizedBox(width: 10),

                // Kolom Ketik
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: lightCardGreen, // Background kolom ketik senada background
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Tulis pesan...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Tombol Kirim
                GestureDetector(
                  onTap: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        messages.add({
                          "text": _controller.text,
                          "isMe": true,
                          "time": "${DateTime.now().hour}:${DateTime.now().minute}"
                        });
                        _controller.clear();
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: primaryDarkGreen, // Tombol Kirim Hijau Tua
                    radius: 22,
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Bubble Chat
  Widget _buildChatBubble(String message, String time, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          // Logic Warna: 
          // Chat Saya = Hijau Tua (primaryDarkGreen)
          // Chat Admin = Putih (Colors.white)
          color: isMe ? primaryDarkGreen : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMe ? const Radius.circular(15) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.black45,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}