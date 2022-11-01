import 'package:courseriver/Services/Api.dart';
import 'package:courseriver/Services/Cache.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CourseAPI {
  final client = http.Client();
  final Cache cache = Cache();

  Future fetchAllCourse() async {
    final String url = "${API().api}/allCourses";
    final Uri uri = Uri.parse(url);
    try {
      final http.Response response = await client.get(uri, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 201) {
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchTrending() async {
    final String url = "${API().api}/getTrending";
    final Uri uri = Uri.parse(url);
    try {
      final http.Response response = await client.get(uri, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 201) {
        print(response.statusCode);
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchRecent() async {
    final String url = "${API().api}/getRecent";
    final Uri uri = Uri.parse(url);
    try {
      final http.Response response = await client.get(uri, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 201) {
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchHighest() async {
    final String url = "${API().api}/getHighest";
    final Uri uri = Uri.parse(url);
    try {
      final http.Response response = await client.get(uri, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 201) {
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchCourseByCategory(String category) async {
    try {
      var response = await http.get(
          Uri.parse(
              "https://courseriver.herokuapp.com/getCourseByCat/${category}"),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*"
          });
      if (response.statusCode == 201) {
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchReqCourses() async {
    try {
      final String url = "${API().api}/reqCourses";
      final Uri uri = Uri.parse(url);
      final http.Response response = await client.get(uri, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 201) {
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future acceptCourse(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String url = "${API().api}/acceptCourse/${id}";
    final Uri uri = Uri.parse(url);
    final http.Response response = await client.put(uri, headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Authorization": preferences.getString("jwt")
    });
    if (response.statusCode == 201) {
      return response.body;
    }
  }

  Future rejectCourse(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String url = "${API().api}/rejectCourse/${id}";
    final Uri uri = Uri.parse(url);
    final http.Response response = await client
        .put(uri, headers: {"Authorization": preferences.getString("jwt")});
    if (response.statusCode == 201) {
      return response.body;
    }
  }

  Future deleteCourse(String id) async {
    final String url = "${API().api}/deleteCourse/${id}";
    final Uri uri = Uri.parse(url);
    final http.Response response = await client.delete(uri, headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });

    if (response.statusCode == 201) {
      return response.body;
    }
  }

  Future fetchCategories() async {
    try {
      final String url = "${API().api}/getCategory";
      final Uri uri = Uri.parse(url);
      final http.Response response = await client.get(uri, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });
      if (response.statusCode == 201) {
        print(response.body);
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future rateCourse(String id, String newRatings) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var jwt = preferences.getString("jwt");
      print(jwt);
      final String url = "${API().api}/ratecourse";
      final Uri uri = Uri.parse(url);
      final http.Response response = await client.put(uri,
          body: {'courseId': id, 'newRatings': newRatings},
          headers: {"Authorization": jwt});
      print(response.body);
      if (response.statusCode == 201) {
        print(response.body);
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future rateAgain(String id) async {
    try {
      print("cwef");
      final String url = "${API().api}/removeRating/${id}";
      final Uri uri = Uri.parse(url);
      final http.Response response = await client
          .put(uri, headers: {"Authorization": cache.readCache("jwt")});
      print(response.body);
      if (response.statusCode == 201) {
        print(response.body);
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getCourseData(String id) async {
    try {
      final String url = "${API().api}/getCourse/${id}";
      final Uri uri = Uri.parse(url);
      final http.Response response = await client.get(uri, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      });
      if (response.statusCode == 201) {
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future addCourse(
      String courseName,
      String courseDescription,
      String coursePic,
      String channelName,
      String courseUrl,
      String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String url = "${API().api}/addCourse";
      String courseRatings = "4";
      final Uri uri = Uri.parse(url);
      print(url);
      print(courseName);
      final http.Response response = await http.post(uri, body: {
        'courseName': courseName,
        'courseDescription': courseDescription,
        'coursePic': coursePic,
        'channelName': channelName,
        'courseUrl': courseUrl,
        'category': category,
        'courseRatings': courseRatings
      }, headers: {
        "Authorization": prefs.getString("jwt")
      });
      if (response.statusCode == 201) {
        print(response.body);
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future addCourseReq(
      String courseName,
      String courseDescription,
      String coursePic,
      String channelName,
      String courseUrl,
      String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String url = "${API().api}/addReqCourse";
      String courseRatings = "4";
      final Uri uri = Uri.parse(url);
      print(url);
      print(courseName);
      final http.Response response = await http.post(uri, body: {
        'courseName': courseName,
        'courseDescription': courseDescription,
        'coursePic': coursePic,
        'channelName': channelName,
        'courseUrl': courseUrl,
        'category': category,
        'courseRatings': courseRatings
      }, headers: {
        "Authorization": prefs.getString("jwt")
      });
      print(response.body);
      if (response.statusCode == 201) {
        print(response.body);
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getSearchedCourses(String text) async {
    try {
      var response = await http.post(
          Uri.parse("https://courseriver.herokuapp.com/searchcourse"),
          body: {'query': text});

      if (response.statusCode == 201) {
        print(response.body);
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentCourse(String commentText, String courseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comment = await http.post(
        Uri.parse("https://courseriver.herokuapp.com/addComment/${courseId}"),
        body: {
          'commentedText': commentText,
        },
        headers: {
          'Authorization': prefs.getString("jwt")
        });

    if (comment.statusCode == 201) {
      return comment.body;
    }
  }

  Future getUserCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = "${API().api}/getUserCourse";
    var response = await http.get(Uri.parse(url),
        headers: {"Authorization": prefs.getString("jwt")});

    if (response.statusCode == 201) {
      return response.body;
    }
  }
}
