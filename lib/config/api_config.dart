class ApiConfig {
  
<<<<<<< HEAD
  static const String _serverIp = "10.121.188.89"; 
  static const String _serverPort = "8000";
=======
  static const String _serverIp = "192.168.1.12"; // JANGAN pakai http://
  static const String _serverPort = "8000";

  // Base URL Utama: http://192.168.1.12:8000/api
>>>>>>> a958cfd2cc239bdca994ab247fbc9acfe161977a
  static const String baseUrl = "http://$_serverIp:$_serverPort/api";

  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/register";
  
  static const String logout = "$baseUrl/logout"; 
  static const String profile = "$baseUrl/profile"; 

  static const String products = "$baseUrl/produk";
  
 
  static String productDetail(dynamic id) => "$baseUrl/produk/$id";

  // Fitur Lain
  static const String faq = "$baseUrl/faq";
  static const String galeri = "$baseUrl/galeri";
  static const String reviews = "$baseUrl/reviews";
  
  // Artikel
  static const String articles = "$baseUrl/artikel";
  static String articleDetail(dynamic id) => "$baseUrl/artikel/$id";

 
  static const String dashboardPelanggan = "$baseUrl/dashboard/pelanggan";
  
  // Pesanan Saya
  static const String myOrders = "$baseUrl/pesanan-saya";
  static String myOrderDetail(dynamic id) => "$baseUrl/pesanan-saya/$id";
  
  // Pembayaran Saya
  static const String myPayments = "$baseUrl/pembayaran-saya";

  static String orderDetailItems(dynamic idPesanan) => "$baseUrl/pesanan/$idPesanan/detail";
}