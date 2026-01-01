import 'package:flutter/material.dart';
import '../models/pesanan_model.dart';
import '../services/pesanan_service.dart';
import '../utils/session_helper.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  final PesananService _service = PesananService();

  String? _token;
  String? _selectedStatus; // SP001, SP002, dst
  Future<List<Pesanan>>? _futurePesanan;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final token = await SessionHelper.getToken();

    if (!mounted) return;

    if (token == null) {
      setState(() {
        _token = null;
        _futurePesanan = null;
      });
      return;
    }

    setState(() {
      _token = token;
      _futurePesanan = _service.fetchPesanan(token);
    });
  }

  // ================= COUNT PER STATUS =================
  int _countByStatus(List<Pesanan> list, String statusId) {
    return list.where((p) => p.idStatusPesanan == statusId).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF385E39),
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildStatusFilter(),
          Expanded(
            child: _futurePesanan == null
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<Pesanan>>(
                    future: _futurePesanan,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final pesananList = snapshot.data ?? [];

                      // 🔥 BELUM PILIH STATUS
                      if (_selectedStatus == null) {
                        return const Center(
                          child: Text(
                            'Pilih status pesanan di atas',
                            style: TextStyle(color: Colors.black54),
                          ),
                        );
                      }

                      final filtered = pesananList
                          .where(
                              (p) => p.idStatusPesanan == _selectedStatus)
                          .toList();

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada pesanan'),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _PesananCard(
                            pesanan: filtered[index],
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ================= STATUS FILTER + BADGE =================
  Widget _buildStatusFilter() {
    final statuses = [
      ('Menunggu', 'SP001'),
      ('Diproses', 'SP002'),
      ('Dikirim', 'SP003'),
      ('Selesai', 'SP004'),
      ('Dibatalkan', 'SP005'),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: FutureBuilder<List<Pesanan>>(
        future: _futurePesanan,
        builder: (context, snapshot) {
          final list = snapshot.data ?? [];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statuses.map((status) {
                final isActive = _selectedStatus == status.$2;
                final count = _countByStatus(list, status.$2);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    selected: isActive,
                    onSelected: (_) {
                      setState(() {
                        _selectedStatus =
                            isActive ? null : status.$2;
                      });
                    },
                    selectedColor: const Color(0xFF6E9E4F),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          status.$1,
                          style: TextStyle(
                            color:
                                isActive ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (count > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

// ================= CARD PESANAN =================
class _PesananCard extends StatelessWidget {
  final Pesanan pesanan;

  const _PesananCard({required this.pesanan});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(pesanan.idStatusPesanan);
    final statusText = _statusText(pesanan.idStatusPesanan);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID Pesanan: ${pesanan.idPesanan}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text('Tanggal: ${pesanan.tanggalPesanan}'),
          Text('Metode: ${pesanan.metodePembayaran}'),

          const SizedBox(height: 6),
          Text(
            'Total: Rp ${pesanan.totalHarga.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  // ================= STATUS MAPPER =================
  static String _statusText(String id) {
    switch (id) {
      case 'SP001':
        return 'Menunggu Pembayaran';
      case 'SP002':
        return 'Diproses';
      case 'SP003':
        return 'Dikirim';
      case 'SP004':
        return 'Selesai';
      case 'SP005':
        return 'Dibatalkan';
      default:
        return '-';
    }
  }

  static Color _statusColor(String id) {
    switch (id) {
      case 'SP001':
        return Colors.orange;
      case 'SP002':
        return Colors.blue;
      case 'SP003':
        return Colors.purple;
      case 'SP004':
        return Colors.green;
      case 'SP005':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
