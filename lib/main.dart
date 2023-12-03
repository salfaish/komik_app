import 'package:flutter/material.dart';
import 'package:komik_app/auth/login.dart';
import 'package:komik_app/pages/favorite.dart';
import 'package:komik_app/pages/profile.dart';
import 'package:komik_app/pages/search.dart';
import 'package:komik_app/services/firebase_options.dart';
import 'package:komik_app/pages/home.dart';
import 'package:komik_app/pages/profile.dart';
import 'package:komik_app/splash.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// late final FirebaseApp app;
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => MyHomePage(),
      },
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(fontFamily: 'Inter'),
//       home: SplashScreen(), // Set the splash screen as the home
//       routes: {
//         '/login': (context) => Login(), // Login page route
//         '/home': (context) => MyHomePage(), // Home page route
//         // Add other routes as needed
//       },
//       initialRoute: '/login', // Navigate to the login screen after splash
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         // debugShowCheckedModeBanner: false,
//         theme: ThemeData(fontFamily: 'Inter'),
//         // home: MyHomePage(),
//         initialRoute: '/login', // Tentukan rute awal
//         routes: {
//           '/login': (context) => Login(), // Halaman login
//           '/splash': (context) => LandingPage(),
//           '/home': (context) => MyHomePage(),
//         } // Halaman home
//         );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0; // Menyimpan indeks halaman yang sedang aktif

  final List<Widget> pages = [
    HomePage(),
    SearchPage(),
    // FavoritePage(),
    ProfilePage(),
  ];

  final List<TitledNavigationBarItem> items = [
    TitledNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    TitledNavigationBarItem(
      icon: Icon(Icons.search),
      title: Text('Search'),
    ),
    // TitledNavigationBarItem(
    //   icon: Icon(Icons.favorite),
    //   title: Text('Favorite'),
    // ),
    TitledNavigationBarItem(
      icon: Icon(Icons.person_outline),
      title: Text('Profile'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        child: TitledBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          reverse: true,
          curve: Curves.easeInBack,
          items: items,
          activeColor: const Color.fromRGBO(84, 186, 185, 1),
          inactiveColor: Colors.blueGrey,
          indicatorColor: const Color.fromRGBO(84, 186, 185, 1),
        ),
      ),
    );
  }
}
