import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio _dio = Dio();
  final _baseUrl = dotenv.env["API_URL"] ?? "http://192.168.1.100:8086";

  Future<bool> checkPassword(username, password) async {
    // Perform GET request to the endpoint "/users/<id>"
    Response data = await _dio.post('$_baseUrl/api/users/login',
        data: {"username": username, "password": password});

    bool isCorrect = data.data["data"]["login"];

    return isCorrect;
  }

  Future<int> createUser(username, name, password) async {
    try {
      Response response = await _dio.post('$_baseUrl/api/users/create',
          data: {"username": username, "name": name, "password": password});
      print(response);
      bool error = response.data["error"];
      if (error) {
        return -1;
      }
      return response.data["data"];
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future getPredictions(String imagePath) async {
    MultipartFile file = await MultipartFile.fromFile(imagePath);
    var formData = FormData.fromMap({'image': file});
    var response = await _dio.post('$_baseUrl/api/ai/predict', data: formData);
    print(response.data);
    return response.data["data"];
  }
}
