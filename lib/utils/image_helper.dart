import '../config/api_config.dart';

class ImageHelper {
  
  // Fungsi Sakti: Masukkan URL rusak, Keluar URL benar
  static String? fixUrl(String? rawUrl) {
    // 1. Cek kalau kosong
    if (rawUrl == null || rawUrl.isEmpty) {
      return null;
    }

    String finalUrl = rawUrl;

    
    if (finalUrl.startsWith('http')) {
      if (finalUrl.contains('/storage/')) {
        finalUrl = finalUrl.replaceAll('/storage/', '/photo/');
      }

      
      if (finalUrl.contains('localhost') || finalUrl.contains('10.121.188.89')) {
        try {
          String base = ApiConfig.baseUrl; 
          
         
          Uri uri = Uri.parse(base);
          String realIp = uri.host; 

          finalUrl = finalUrl
              .replaceAll('localhost', realIp)
              .replaceAll('10.121.188.89 ', realIp);
        } catch (e) {
          print("Error parsing IP di Helper: $e");
        }
      }
    } 
    
    else {
      
      String serverRoot = ApiConfig.baseUrl;
      if (serverRoot.endsWith('/api')) {
        serverRoot = serverRoot.substring(0, serverRoot.length - 4);
      }

      // Bersihkan slash di depan nama file
      String cleanPath = finalUrl.startsWith('/') ? finalUrl.substring(1) : finalUrl;

      // Pastikan folder photo/ ada (sesuai struktur folder public laravel kamu)
      if (!cleanPath.startsWith('photo/')) {
        cleanPath = 'photo/$cleanPath';
      }

      finalUrl = "$serverRoot/$cleanPath";
    }

    // 4. Fix Terakhir (PENTING): Ubah SPASI jadi %20 agar terbaca HP
    return Uri.encodeFull(finalUrl);
  }
}