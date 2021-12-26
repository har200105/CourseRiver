import 'dart:convert';

Course courseFromJson(String str) => Course.fromJson(json.decode(str));

String courseToJson(Course data) => json.encode(data.toJson());

class Course {
    Course({
        this.data,
    });

    List<CourseData> data;

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        data: List<CourseData>.from(json["data"].map((x) => CourseData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CourseData {
    CourseData({
        this.isHighestRated,
        this.isRecentlyAdded,
        this.isTrendingCourse,
        this.isAccepted,
        this.ratedBy,
        this.hasBeenCommented,
        this.comments,
        this.id,
        this.courseName,
        this.courseDescription,
        this.channelName,
        this.courseUrl,
        this.coursePic,
        this.category,
        this.courseRatings,
        this.coursePublishedOn,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    bool isHighestRated;
    bool isRecentlyAdded;
    bool isTrendingCourse;
    bool isAccepted;
    List<String> ratedBy;
    bool hasBeenCommented;
    List<Comment> comments;
    String id;
    String courseName;
    String courseDescription;
    String channelName;
    String courseUrl;
    String coursePic;
    String category;
    String courseRatings;
    String coursePublishedOn;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    factory CourseData.fromJson(Map<String, dynamic> json) => CourseData(
        isHighestRated: json["isHighestRated"],
        isRecentlyAdded: json["isRecentlyAdded"],
        isTrendingCourse: json["isTrendingCourse"],
        isAccepted: json["isAccepted"],
        ratedBy: List<String>.from(json["ratedBy"].map((x) => x)),
        hasBeenCommented: json["hasBeenCommented"],
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
        id: json["_id"],
        courseName: json["courseName"],
        courseDescription: json["courseDescription"],
        channelName: json["channelName"],
        courseUrl: json["courseUrl"],
        coursePic: json["coursePic"],
        category: json["category"],
        courseRatings: json["courseRatings"],
        coursePublishedOn: json["coursePublishedOn"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "isHighestRated": isHighestRated,
        "isRecentlyAdded": isRecentlyAdded,
        "isTrendingCourse": isTrendingCourse,
        "isAccepted": isAccepted,
        "ratedBy": List<dynamic>.from(ratedBy.map((x) => x)),
        "hasBeenCommented": hasBeenCommented,
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "_id": id,
        "courseName": courseName,
        "courseDescription": courseDescription,
        "channelName": channelName,
        "courseUrl": courseUrl,
        "coursePic": coursePic,
        "category": category,
        "courseRatings": courseRatings,
        "coursePublishedOn": coursePublishedOn,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

class Comment {
  
    Comment({
        this.id,
        this.commentedText,
        this.commentedBy,
    });

    String id;
    String commentedText;
    String commentedBy;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        commentedText: json["commentedText"],
        commentedBy: json["commentedBy"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "commentedText": commentedText,
        "commentedBy": commentedBy,
    };
}
