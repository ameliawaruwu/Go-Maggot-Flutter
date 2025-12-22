import 'package:flutter/material.dart';
import 'komponen-navbar.dart';
import 'home_page.dart';
import 'product.dart';
import 'forum_chat.dart';
import 'edukasi.dart';
import 'profil.dart';
import 'notifikasi.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages => <Widget>[
    HomeContent(),
    ProductContent(),
    ForumChatPage(onBackPressed: () => setState(() => _selectedIndex = 0)),
    EdukasiContent(),
    ProfileContent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PreferredSizeWidget? _getAppBar() {
    switch (_selectedIndex) {
      case 0:
        return AppBar(
          backgroundColor: const Color(0xFF385E39),
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 90,
          flexibleSpace: Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF385E39),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kaushan Script',
                      color: Color(0xFF6E9E4F),
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Go'),
                      TextSpan(
                        text: 'Maggot',
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Kaushan Script',
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotifikasiPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      case 1:
        return null; // ProductContent sudah memiliki Scaffold
      case 2:
        return null; // ForumChatPage sudah memiliki Scaffold
      case 3:
        return null; // EdukasiContent sudah memiliki Scaffold
      case 4:
        return null; // ProfileContent sudah memiliki Scaffold
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _selectedIndex != 2 ? CustomBottomNavBar(
        indexSelected: _selectedIndex,
        onTap: _onItemTapped,
      ) : null,
    );
  }
}