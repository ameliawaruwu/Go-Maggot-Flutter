import '../config/api_config.dart';

class ImageHelper {
  static String? fixUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return null;

    // STEP 1: Decode dulu untuk membuang encoding lama (%20, %2520, dll)
    // Agar kita mulai dari teks murni (pakai spasi asli)
    String decodedUrl = Uri.decodeFull(rawUrl);

    // STEP 2: Ambil host aktif (misal 10.121.188.89 atau 10.0.2.2)
    String activeHost;
    try {
      activeHost = Uri.parse(ApiConfig.baseUrl).host;
    } catch (e) {
      activeHost = "10.0.2.2";
    }

    String finalUrl = decodedUrl;

    if (finalUrl.startsWith('http')) {
      // STEP 3: Pastikan folder tujuan benar
      if (finalUrl.contains('/storage/')) {
        finalUrl = finalUrl.replaceAll('/storage/', '/photo/');
      }

      // STEP 4: Ganti IP lama/localhost ke IP laptop yang aktif saat ini
      finalUrl = finalUrl
          .replaceAll('localhost', activeHost)
          .replaceAll('127.0.0.1', activeHost)
          .replaceAll('192.168.1.12', activeHost); 
    } else {
      // Jika URL relatif
      String serverRoot = ApiConfig.baseUrl;
      if (serverRoot.endsWith('/api')) {
        serverRoot = serverRoot.substring(0, serverRoot.length - 4);
      }
      String cleanPath = finalUrl.startsWith('/') ? finalUrl.substring(1) : finalUrl;
      if (!cleanPath.startsWith('photo/')) {
        cleanPath = 'photo/$cleanPath';
      }
      finalUrl = "$serverRoot/$cleanPath";
    }

    // STEP 5: Encode satu kali saja di akhir. 
    // Ini akan mengubah spasi menjadi %20 secara bersih.
    return Uri.encodeFull(finalUrl);
  }

  static String? fixUrlWithLog(String? rawUrl) {
    String? result = fixUrl(rawUrl);
    print('🖼️ [RESULT URL]: $result'); 
    return result;
  }
}