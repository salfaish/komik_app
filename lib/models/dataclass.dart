import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:komik_app/models/dbservices.dart';

CollectionReference tbKomik = FirebaseFirestore.instance.collection("komik");
CollectionReference tbUser = FirebaseFirestore.instance.collection("users");

class Database {
  //  ---------- METHOD TAMPIL SEMUA DATA ----------  //
  static Stream<QuerySnapshot> getData() {
    return tbKomik.snapshots();
  }

  //  ---------- METHOD SEARCH KOMIK ----------  //
  static Stream<QuerySnapshot> searchKomik(String keyword) {
    if (keyword.isEmpty) {
      return tbKomik.snapshots();
    } else {
      return tbKomik
          .where('title', isGreaterThanOrEqualTo: keyword)
          .where('title', isLessThanOrEqualTo: keyword + '\uf8ff')
          .snapshots();
    }
  }

  //  ---------- METHOD USER ----------  //
  static Future<MyUser> getUser({required String email}) async {
    QuerySnapshot querySnapshot =
        await tbUser.where("email", isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return MyUser.fromJson(data); // Sesuaikan dengan model data pengguna Anda
    } else {
      throw Exception("Data dengan email $email tidak ditemukan");
    }
  }

  //  ---------- METHOD TAMBAH USER ----------  //
  static Future<void> tambahUser({required MyUser user}) async {
    DocumentReference docref = tbUser.doc(user.email);
    await docref
        .set(user.toJson())
        .whenComplete(() => "Pengguna berhasil ditambahkan")
        .catchError((e) => print(e));
  }

  //  ---------- METHOD DETAIL ----------  //
  static Future<Komik> getKomik({required String title}) async {
    QuerySnapshot querySnapshot =
        await tbKomik.where("title", isEqualTo: title).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return Komik.fromJson(data);
    } else {
      throw Exception("Data dengan judul $Komik tidak ditemukan");
    }
  }

  static Future<Komik> getKomikGrid() async {
    QuerySnapshot querySnapshot = await tbKomik.get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return Komik.fromJson(data);
    } else {
      throw Exception("Data tidak ditemukan");
    }
  }
}
