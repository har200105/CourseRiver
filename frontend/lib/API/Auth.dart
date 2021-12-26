import 'package:courseriver/Services/Api.dart';
import 'package:http/http.dart' as http;

class Authentication {
  final client = http.Client();

  Future loginUser(String email, String password) async {
    final http.Response response = await http.post(
        Uri.parse("${API().api}/login"),
        body: {'email': email, 'password': password});
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future signupUser(
      String email, String password, String name, String image) async {
    print("Signup");
    final http.Response response = await http
        .post(Uri.parse("${API().api}/signup"), body: {
      'email': email,
      'password': password,
      'name': name,
      'image': image != "" ? image : "https://image.shutterstock.com/image-vector/avatar-vector-male-profile-gray-260nw-538707355.jpg"
    }, headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });
    print("Responsing");
    if (response.statusCode == 200) {
      print("Response");
      return response.body;
    }
  }
}
