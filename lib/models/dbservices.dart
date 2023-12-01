class Komik {
  final String author;
  final String chapter;
  final String desc;
  final String keterangan;
  final String poster;
  final String title;
  final String type;

  Komik({
    required this.author,
    required this.chapter,
    required this.desc,
    required this.keterangan,
    required this.poster,
    required this.title,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "author": author,
      "chapter": chapter,
      "desc": desc,
      "keterangan": keterangan,
      "poster": poster,
      "title": title,
      "type": type,
    };
  }

  factory Komik.fromJson(Map<String, dynamic> json) {
    return Komik(
      author: json["author"],
      chapter: json["chapter"],
      desc: json["desc"],
      keterangan: json["keterangan"],
      poster: json["poster"],
      title: json["title"],
      type: json["type"],
    );
  }
}

class MyUser {
  final String email;
  final String nama;
  final String profil;

  MyUser({
    required this.email,
    required this.nama,
    required this.profil,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "nama": nama,
      "profil": profil,
    };
  }

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      email: json["email"],
      nama: json["nama"],
      profil: json["profil"],
    );
  }
}
