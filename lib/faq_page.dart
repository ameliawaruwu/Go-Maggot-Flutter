import 'package:flutter/material.dart';
import 'main.dart'; // supaya bisa pakai Navigator.pop dan theme yg sama (opsional)

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgDarkGreen = Color(0xFF163822);
    const Color headerGreen = Color(0xFF4F6F3E);
    const Color cardBg = Colors.white;
    const Color bubbleGreen = Color(0xFF6E9E4F);

    return Scaffold(
      backgroundColor: bgDarkGreen,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF4F6F3E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'FAQ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ===== LIST FAQ =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  FAQCard(
                    question: 'Apakah maggot aman digunakan?',
                    answer:
                        'Maggot dapat digunakan sebagai alternatif pengurai sampah, '
                        'dan aman untuk pakan ternak karena bukan termasuk lalat penyebar penyakit.',
                  ),
                  FAQCard(
                    question: 'Apakah pembayaran dapat COD?',
                    answer:
                        'Pembayaran tidak dapat dilakukan dengan COD. '
                        'Pembayaran dilakukan secara non-tunai.',
                  ),
                  FAQCard(
                    question: 'Bagaimana cara membayarnya?',
                    answer:
                        'Anda dapat melakukan pembayaran lewat transfer bank, '
                        'm-banking, atau dompet digital seperti gopay, shopeepay, dan ovo.',
                  ),
                  FAQCard(
                    question: 'Bagaimana cara melakukan pembelian di toko ini?',
                    answer:
                        'Pilih navigasi produk, pilih produk yang ingin dibeli, '
                        'kemudian lanjutkan proses checkout hingga pembayaran selesai.',
                  ),
                  SizedBox(height: 12),
                  _AskSection(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  const FAQCard({
    super.key,
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    const Color bubbleGreen = Color(0xFF6E9E4F);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5EA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // bubble hijau di kiri
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: bubbleGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.question_answer_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
          // teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  answer,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AskSection extends StatelessWidget {
  const _AskSection();

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mau bertanya? Tulis pertanyaanmu di bawah kolom ini yaa!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: 3,
                  minLines: 2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tulis pertanyaanmu di sini...',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                // TODO: kirim pertanyaan ke backend / simpan
                FocusScope.of(context).unfocus();
                final text = controller.text.trim();
                if (text.isEmpty) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pertanyaan kamu sudah terkirim.'),
                  ),
                );
                controller.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF497537),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Send',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
