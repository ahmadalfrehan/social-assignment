import 'package:dio/dio.dart';

class Connectivity {
  final Dio _dio = Dio();

  Future<bool> checkConnectivity() async {
    try {
      // Make a simple GET request to a reliable server
      final response = await _dio.get('https://www.google.com');

      // Check if the response is successful (status code 200-299)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        print('You have internet connection');
        return true;
      } else {
        print('No internet connection');
        return false;
      }
    } catch (e) {
      print('No internet connection');
      return false;
    }
  }
}
