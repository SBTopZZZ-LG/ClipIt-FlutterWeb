class Session {
  final String name;
  String content;
  final String lastModified;

  Session(this.name, this.content, this.lastModified);

  Map<String, dynamic> toJson() => <String, Object>{
        "name": name,
        "content": content,
        "lastModified": lastModified
      };

  static Session fromJson(Map<String, dynamic> json) => Session(
      json["name"].toString(),
      json["content"].toString(),
      json["lastModified"].toString());
}
