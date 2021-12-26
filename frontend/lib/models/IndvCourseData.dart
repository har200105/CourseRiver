class IndvCourseData {
  bool isHighestRated;
  bool isRecentlyAdded;
  bool isTrendingCourse;
  bool isAccepted;
  List<String> ratedBy;
  bool hasBeenCommented;
  List<Comments> comments;
  String sId;
  String courseName;
  String courseDescription;
  String channelName;
  String courseUrl;
  String coursePic;
  String category;
  String courseRatings;
  String coursePublishedOn;
  String createdAt;
  String updatedAt;
  int iV;

  IndvCourseData(
      {this.isHighestRated,
      this.isRecentlyAdded,
      this.isTrendingCourse,
      this.isAccepted,
      this.ratedBy,
      this.hasBeenCommented,
      this.comments,
      this.sId,
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
      this.iV});

  IndvCourseData.fromJson(Map<String, dynamic> json) {
    isHighestRated = json['isHighestRated'];
    isRecentlyAdded = json['isRecentlyAdded'];
    isTrendingCourse = json['isTrendingCourse'];
    isAccepted = json['isAccepted'];
    ratedBy = json['ratedBy'].cast<String>();
    hasBeenCommented = json['hasBeenCommented'];
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    sId = json['_id'];
    courseName = json['courseName'];
    courseDescription = json['courseDescription'];
    channelName = json['channelName'];
    courseUrl = json['courseUrl'];
    coursePic = json['coursePic'];
    category = json['category'];
    courseRatings = json['courseRatings'];
    coursePublishedOn = json['coursePublishedOn'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isHighestRated'] = this.isHighestRated;
    data['isRecentlyAdded'] = this.isRecentlyAdded;
    data['isTrendingCourse'] = this.isTrendingCourse;
    data['isAccepted'] = this.isAccepted;
    data['ratedBy'] = this.ratedBy;
    data['hasBeenCommented'] = this.hasBeenCommented;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['courseName'] = this.courseName;
    data['courseDescription'] = this.courseDescription;
    data['channelName'] = this.channelName;
    data['courseUrl'] = this.courseUrl;
    data['coursePic'] = this.coursePic;
    data['category'] = this.category;
    data['courseRatings'] = this.courseRatings;
    data['coursePublishedOn'] = this.coursePublishedOn;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Comments {
  String sId;
  String commentedText;
  String commentedBy;

  Comments({this.sId, this.commentedText, this.commentedBy});

  Comments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    commentedText = json['commentedText'];
    commentedBy = json['commentedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['commentedText'] = this.commentedText;
    data['commentedBy'] = this.commentedBy;
    return data;
  }
}