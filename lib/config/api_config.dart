class ApiConfig {
  static const String _serverIp = "10.0.2.2";
  static const String _serverPort = "8000";

  // Base URL Utama: http://10.0.2.2:8000/api
  static const String baseUrl = "http://$_serverIp:$_serverPort/api";

  // Auth
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  static const String logout = "$baseUrl/logout"; 
  static const String profile = "$baseUrl/profile"; 

  // Products
  static const String products = "$baseUrl/produk";
  static String productDetail(dynamic id) => "$baseUrl/produk/$id";

  // Fitur Lain
  static const String faq = "$baseUrl/faq";
  static const String galeri = "$baseUrl/galeri";
  static const String reviews = "$baseUrl/reviews";
  
  // Artikel
  static const String articles = "$baseUrl/artikel";
  static String articleDetail(dynamic id) => "$baseUrl/artikel/$id";

  // Dashboard
  static const String dashboardPelanggan = "$baseUrl/dashboard/pelanggan";
  
  // Pesanan Saya
  static const String myOrders = "$baseUrl/pesanan-saya";
  static String myOrderDetail(dynamic id) => "$baseUrl/pesanan-saya/$id";
  
  // Pembayaran Saya
  static const String myPayments = "$baseUrl/pembayaran-saya";
  static String orderDetailItems(dynamic idPesanan) => "$baseUrl/pesanan/$idPesanan/detail";

  // ✅ TAMBAHKAN INI - Endpoint Checkout
  static const String checkoutProcess = "$baseUrl/checkout/process";
  static const String uploadPaymentProof = "$baseUrl/pembayaran/upload";

  // Status Pesanan
   static const String orderStatus = "$baseUrl/pesanan-saya";
  
  // Helper untuk ganti IP (jika pakai device fisik)
  static String getBaseUrlWithCustomIP(String ip) {
    return "http://$ip:$_serverPort/api";
  }
}