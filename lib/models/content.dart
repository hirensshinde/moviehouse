class Content {
  int id;
  String title;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}
