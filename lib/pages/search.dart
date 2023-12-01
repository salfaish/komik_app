import 'package:flutter/material.dart';
import 'package:komik_app/models/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:komik_app/pages/detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Stream<QuerySnapshot> _komikStream;
  var keyword = "";
  List<DocumentSnapshot> allKomikData = [];
  List<DocumentSnapshot> filteredKomikData = [];

  @override
  void initState() {
    super.initState();
    _komikStream = Database.getData(); // Tampilkan semua data pada awalnya
    _initializeData();
  }

  void _initializeData() async {
    var allData = await Database.getData().first;
    setState(() {
      _komikStream = Stream
          .empty(); // Atur _komikStream ke Stream kosong saat mengambil semua data
      allKomikData = allData.docs;
      filteredKomikData = allData.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  keyword = value;
                  _updateStream(); // Perbarui stream setiap kali keyword berubah
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _komikStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredKomikData.length,
                    itemBuilder: (context, index) {
                      var komikData = filteredKomikData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailKomik(
                                title: komikData['title'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    komikData['poster'] ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  komikData['title'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStream() {
    setState(() {
      if (keyword.isEmpty) {
        filteredKomikData =
            allKomikData; // Saat keyword kosong, gunakan semua data
      } else {
        // Saat ada keyword, filter data berdasarkan kata kunci
        filteredKomikData = allKomikData.where((komikData) {
          var title = komikData['title'].toString().toLowerCase();
          return title.contains(keyword.toLowerCase());
        }).toList();
      }
    });
  }
}
