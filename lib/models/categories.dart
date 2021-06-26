class Category {
  int id;
  String category;

  Category({this.id, this.category});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      category: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": category,
      };
}
