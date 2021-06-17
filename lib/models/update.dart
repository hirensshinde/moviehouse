class AppVersion {
  final String link;
  final String version;
  final String about;

  AppVersion({this.link, this.version, this.about});

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      link: json['link'],
      version: json['version'],
      about: json['about'],
    );
  }
}
