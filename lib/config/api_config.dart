class ApiConfig {
  
   static const String _serverIp = "192.168.1.27"; // JANGAN pakai http://
  static const String _serverPort = "8000";

  // Base URL Utama: http://10.121.188.89:8000/api
  static const String baseUrl = "http://$_serverIp:$_serverPort/api";

  // =======================================================================
  // 2. AUTHENTICATION ROUTES (Login & Register)
  // =======================================================================
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  
  // Perlu Token (Header Authorization)
  static const String logout = "$baseUrl/logout"; 
  static const String profile = "$baseUrl/profile"; 

  // =======================================================================
  // 3. PUBLIC ROUTES (Bisa diakses tanpa Login)
  // =======================================================================
  // Produk
  static const String products = "$baseUrl/produk"; // Untuk List Produk
  
  // Detail Produk (Menerima ID, bisa String atau Int tergantung database)
  static String productDetail(dynamic id) => "$baseUrl/produk/$id";

  // Fitur Lain
  static const String faq = "$baseUrl/faq";
  static const String galeri = "$baseUrl/galeri";
  static const String reviews = "$baseUrl/reviews";
  
  // Artikel
  static const String articles = "$baseUrl/artikel";
  static String articleDetail(dynamic id) => "$baseUrl/artikel/$id";

  // =======================================================================
  // 4. PELANGGAN ROUTES (Wajib Login / Pakai Token)
  // =======================================================================
  static const String dashboardPelanggan = "$baseUrl/dashboard/pelanggan";
  
  // Pesanan Saya
  static const String myOrders = "$baseUrl/pesanan-saya";
  static String myOrderDetail(dynamic id) => "$baseUrl/pesanan-saya/$id";
  
  // Pembayaran Saya
  static const String myPayments = "$baseUrl/pembayaran-saya";

  // Detail Pesanan Spesifik (berdasarkan ID Pesanan)
  // Route: /pesanan/{id_pesanan}/detail
  static String orderDetailItems(dynamic idPesanan) => "$baseUrl/pesanan/$idPesanan/detail";
}