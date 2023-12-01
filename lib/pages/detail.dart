import 'package:flutter/material.dart';
import 'package:komik_app/models/dataclass.dart';
import 'package:komik_app/models/dbservices.dart';

class DetailKomik extends StatefulWidget {
  final String title;

  const DetailKomik({Key? key, required this.title}) : super(key: key);

  @override
  State<DetailKomik> createState() => _DetailKomikState();
}

class _DetailKomikState extends State<DetailKomik> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Komik>(
      future: Database.getKomik(title: widget.title),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: Text('No data available'),
            ),
          );
        }

        final dataKomik = snapshot.data!;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(dataKomik.title),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 235,
                  child: Image.network(
                    dataKomik.poster,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Judul komik
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataKomik.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                dataKomik.author,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(133, 133, 151, 1),
                                ),
                              ),
                            ],
                          ),
                          // Tombol favorit
                          // IconButton(
                          //   icon: Icon(
                          //     isFavorite
                          //         ? Icons.favorite
                          //         : Icons.favorite_border,
                          //     color: isFavorite ? Colors.red : null,
                          //   ),
                          //   onPressed: () {
                          //     setState(() {
                          //       isFavorite = !isFavorite;
                          //       // Lakukan operasi lain saat tombol favorit diklik
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Text(
                        "Sinopsis",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        dataKomik.desc,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(133, 133, 151, 1),
                        ),
                      ),
                      // Tambahkan widget-widget lainnya sesuai kebutuhan
                      SizedBox(height: 100),
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
}
