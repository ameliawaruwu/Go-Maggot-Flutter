import 'package:flutter/material.dart';
import 'komponen-navbar.dart';

class ForumChatPage extends StatelessWidget {
  const ForumChatPage({super.key});

  // warna-warna utama
  static const Color topBarColor = Color(0xFF6E8761);     
  static const Color pageBgColor = Color(0xFFE5EACB);     
  static const Color bubbleBgLight = Colors.white;
  static const Color bubbleBgSelf = Color(0xFF76A36A);    
  static const Color bottomBarColor = Color(0xFF6E8761);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: _buildTopBar(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildDateChip(),
          const SizedBox(height: 8),
          const Expanded(
            child: _ChatList(),
          ),
          const _ChatInputBar(),
        ],
      ),

      // Komunitas = index 2 di CustomBottomNavBar kamu
      bottomNavigationBar: const CustomBottomNavBar(
        indexSelected: 2,
      ),
    );
  }

  // app bar custom mirip desain
  Widget _buildTopBar() {
    return Container(
      decoration: const BoxDecoration(
        color: topBarColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 28,
        left: 20,
        right: 20,
        bottom: 18,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Gomagzone',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_rounded,
                size: 22,
                color: topBarColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // chip tanggal "Jum, 23 Mei"
  Widget _buildDateChip() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Jum, 23 Mei',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList();

  @override
  Widget build(BuildContext context) {
    // daftar chat statis biar mirip desain
    final messages = <_ChatMessage>[
      _ChatMessage(
        senderName: 'Bang Jay',
        isMe: false,
        avatarColor: Colors.brown,
        text:
            'Bapak-bapak maggot saya diem aja, ini kurang pakan apa kurang perhatian ya? 🤔🤔🤔🤔',
        time: '10:02 AM',
      ),
      _ChatMessage(
        senderName: 'Mang joko',
        isMe: false,
        avatarColor: Colors.blueGrey,
        text: 'Coba dideketin lampu, Pak. Siapa tau lagi loyo. 😁🌱',
        time: '10:05 AM',
      ),
      _ChatMessage(
        senderName: 'Mamat sucipto',
        isMe: false,
        avatarColor: Colors.indigo,
        text:
            'Bisa jadi masuk angin, Pak. Udah dicek suhu wadahnya belum?😂😂😂😂',
        time: '10:09 AM',
      ),
      _ChatMessage(
        senderName: 'Pak Ekoo',
        isMe: false,
        avatarColor: Colors.black87,
        text: 'Kasih nasi anget dikit,\nbiar semangat lagi tuh maggot 😂🤣',
        time: '10:11 AM',
      ),
      _ChatMessage(
        senderName: 'Saya',
        isMe: true,
        avatarColor: ForumChatPage.bubbleBgSelf,
        text:
            'Haha infonya seru, Bapak-bapak!\nTetap semangat budidaya yaa ✨',
        time: '10:19 AM',
      ),
      _ChatMessage(
        senderName: 'Mang joko',
        isMe: false,
        avatarColor: Colors.blueGrey,
        text:
            'Siap Admin! Kalau maggot saya sukses, saya traktir teh manis seember 😂🫖',
        time: '10:23 AM',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return _ChatBubble(message: msg);
      },
    );
  }
}

class _ChatMessage {
  final String senderName;
  final bool isMe;
  final Color avatarColor;
  final String text;
  final String time;

  _ChatMessage({
    required this.senderName,
    required this.isMe,
    required this.avatarColor,
    required this.text,
    required this.time,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color:
            isMe ? ForumChatPage.bubbleBgSelf : ForumChatPage.bubbleBgLight,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMe ? 16 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 16),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: TextStyle(
              fontSize: 13,
              color: isMe ? Colors.white : Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message.time,
            style: TextStyle(
              fontSize: 10,
              color: (isMe ? Colors.white70 : Colors.grey[600]),
            ),
          ),
        ],
      ),
    );

    // baris dengan avatar + nama + bubble
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            _AvatarCircle(
              color: message.avatarColor,
              initials:
                  message.senderName.isNotEmpty ? message.senderName[0] : '?',
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(
                    message.senderName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                if (!isMe) const SizedBox(height: 4),
                bubble,
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final Color color;
  final String initials;

  const _AvatarCircle({
    required this.color,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: color,
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ForumChatPage.bottomBarColor,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ikon + dan lainnya
            Row(
              children: [
                _iconCircle(Icons.add),
                const SizedBox(width: 6),
                _iconCircle(Icons.image_outlined),
                const SizedBox(width: 6),
                _iconCircle(Icons.camera_alt_outlined),
              ],
            ),
            const SizedBox(width: 8),
            // text field bubble
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Tulis pesan...',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _iconCircle(Icons.emoji_emotions_outlined),
            const SizedBox(width: 6),
            _iconCircle(Icons.send_rounded),
          ],
        ),
      ),
    );
  }

  Widget _iconCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.grey[800],
      ),
    );
  }
}
