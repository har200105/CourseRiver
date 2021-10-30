import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
    Category({
        this.data,
    });

    List<CategoryData> data;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        data: List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CategoryData {
    CategoryData({
        this.id,
        this.categoryName,
        this.categoryPic,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    String id;
    String categoryName;
    String categoryPic;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["_id"],
        categoryName: json["categoryName"],
        categoryPic: json["categoryPic"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "categoryName": categoryName,
        "categoryPic": categoryPic,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
