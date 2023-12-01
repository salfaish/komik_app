import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:komik_app/models/dataclass.dart';
import 'package:komik_app/pages/detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:komik_app/models/dataclass.dart';
import 'package:komik_app/models/dbservices.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String selectedButton; // Menyimpan tombol yang dipilih
  MyUser? _currentUser;
  late Stream<QuerySnapshot> komikStream;

  @override
  void initState() {
    super.initState();
    selectedButton = 'Manga'; // Set nilai default saat inisialisasi state
    komikStream = Database.getData();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final email = user.email;
      if (email != null) {
        final myUser = await Database.getUser(email: email);
        if (myUser != null) {
          setState(() {
            _currentUser = myUser;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20, // Sesuaikan dengan ukuran yang diinginkan
                      backgroundImage: NetworkImage(_currentUser?.profil ??
                          ""), // Ganti dengan URL gambar Anda
                    ),
                    const SizedBox(width: 20), // Spasi antara gambar dan teks
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Selamat Siang,",
                          style: TextStyle(
                              color: Color.fromRGBO(133, 133, 151, 1),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Poppins',
                              fontSize: 14),
                        ),
                        Text(
                          '${_currentUser?.nama ?? ""}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              fontSize: 22),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Komik Populer",
                      style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 180,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: komikStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color.fromARGB(115, 206, 43, 43),
                            ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        List<DocumentSnapshot> items = snapshot.data!.docs
                            .where((komik) => komik["keterangan"] == "populer")
                            .toList();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: items
                              .length, // Set the itemCount to the filtered items.
                          itemBuilder: (context, index) {
                            DocumentSnapshot komik = items[index];
                            String lvtitle = komik["title"];
                            String lvposter = komik["poster"];
                            String lvauthor = komik["author"];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailKomik(title: lvtitle),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Image.network(
                                          lvposter,
                                          width: 115.0,
                                          height: 130.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              10), // Spasi antara gambar dan teks
                                      Text(
                                        lvtitle.length > 14
                                            ? '${lvtitle.substring(0, 14)}...'
                                            : lvtitle,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              6), // Spasi antara gambar dan teks
                                      Text(
                                        lvauthor.length > 18
                                            ? '${lvauthor.substring(0, 18)}...'
                                            : lvauthor,
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(133, 133, 151, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                const Color.fromARGB(115, 206, 43, 43))),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 31,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     FilledButton(
                //       onPressed: () {
                //         // Logika untuk kategori Manga
                //       },
                //       style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all<Color>(
                //           Color.fromRGBO(97, 191, 173,
                //               1), // Ganti dengan warna hijau yang diinginkan
                //         ),
                //       ),
                //       child: Text('Manga'),
                //     ),
                //     SizedBox(
                //       width: 17,
                //     ),
                //     FilledButton(
                //       onPressed: () {
                //         // Logika untuk kategori Manhua
                //       },
                //       style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all<Color>(
                //           Color.fromRGBO(97, 191, 173,
                //               1), // Ganti dengan warna hijau yang diinginkan
                //         ),
                //       ),
                //       child: Text('Manhua'),
                //     ),
                //     SizedBox(
                //       width: 17,
                //     ),
                //     FilledButton(
                //       onPressed: () {
                //         // Logika untuk kategori Manhwa
                //       },
                //       style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all<Color>(
                //           Color.fromRGBO(97, 191, 173,
                //               1), // Ganti dengan warna hijau yang diinginkan
                //         ),
                //       ),
                //       child: Text('Manhwa'),
                //     ),
                //   ],
                // )

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildButton('Manga'),
                    SizedBox(width: 17), // Jarak antara Manga dan Manhua
                    buildButton('Manhua'),
                    SizedBox(width: 17), // Jarak antara Manhua dan Manhwa
                    buildButton('Manhwa'),
                  ],
                ),
                SizedBox(height: 16), // Spasi antara tombol dan ListView
              ],
            ),
          ),
          // if (selectedButton ==
          //     'Manga') // Menampilkan ListView hanya jika 'Manga' dipilih
          StreamBuilder<QuerySnapshot>(
            stream: komikStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(115, 206, 43, 43),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                List<DocumentSnapshot> items = snapshot.data!.docs
                    .where((komik) =>
                        komik["type"] ==
                        selectedButton) // Filter data berdasarkan jenis komik yang dipilih
                    .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot komik = items[index];
                    String lvtitle = komik["title"];
                    String lvposter = komik["poster"];
                    String lvauthor = komik["author"];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailKomik(title: lvtitle),
                          ),
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                lvposter,
                                width: 80,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lvtitle,
                                    // lvtitle.length > 50
                                    //     ? '${lvtitle.substring(0, 50)}...'
                                    //     : lvtitle,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    lvauthor,
                                    // lvauthor.length > 18
                                    //     ? '${lvauthor.substring(0, 18)}...'
                                    //     : lvauthor,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return SizedBox(); // Return an empty widget
            },
          ),
        ],
      ),
    );
  }

  Widget buildButton(String FilledButton) {
    bool isSelected = selectedButton == FilledButton; // Cek jika tombol dipilih

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedButton = FilledButton; // Set tombol yang dipilih
        });
        // Logika untuk tindakan saat tombol dipilih
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected
              ? Color.fromRGBO(97, 191, 173, 1)
              : Colors.white, // Ganti warna saat dipilih
        ),
      ),
      child: Text(
        FilledButton,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : Color.fromRGBO(133, 133, 151, 1), // Ubah warna teks
        ),
      ),
    );
  }
}
