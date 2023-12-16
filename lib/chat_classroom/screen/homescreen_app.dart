import 'package:chat_app_new_version/chat_classroom/screen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../chatgpt/screens/chat_screen.dart';
import '../helper/heper_function.dart';
import '../service/auth.dart';
import '../service/database_service.dart';
import '../widget/widget.dart';
import 'homescreen_chat.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, String>> imageList = [
    {"id": "1", "image_path": 'assets/icons/student1.webp'},
    {"id": "2", "image_path": 'assets/icons/student2.jpg'},
    {"id": "3", "image_path": 'assets/icons/student3.webp'},
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  List<choices> ch = const <choices>[
    choices(name: 'Bank', image: AssetImage('assets/icons/bank.png')),
    choices(name: 'Classroom', image: AssetImage('assets/icons/classroom.png')),
    choices(name: 'Forum', image: AssetImage('assets/icons/library.png')),
    choices(name: 'Service', image: AssetImage('assets/icons/chatgpt.png')),
  ];

  List<choices> extendedChoices = const <choices>[
    choices(name: 'Library', image: AssetImage('assets/icons/library.png')),
    choices(name: 'Chat', image: AssetImage('assets/icons/chatgpt.png')),
    choices(name: 'Chat', image: AssetImage('assets/icons/chatgpt.png')),
    choices(name: 'Chat', image: AssetImage('assets/icons/chatgpt.png')),
  ];

  bool showExtendedGrid = false;

  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  Stream? group;

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   gettingUserData();
  // }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        group = snapshot;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    gettingUserData();
    _widgetOptions = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                CarouselSlider(
                  items: imageList.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item['image_path']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                    );
                  }).toList(),
                  carouselController: carouselController,
                  options: CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlay: true,
                    aspectRatio: 2,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => carouselController.animateToPage(entry.key),
                        child: Container(
                          width: currentIndex == entry.key ? 10 : 7,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentIndex == entry.key
                                ? const Color.fromARGB(255, 35, 31, 32)
                                : Colors.grey.shade500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text(
              'Essential',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 105, 114, 106),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      showExtendedGrid = !showExtendedGrid;
                    });
                  },
                  child: Text(
                    showExtendedGrid ? 'Hide <<' : 'View >>',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 105, 114, 106),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 4),
              child: GridView.count(
                childAspectRatio: 12 / 8,
                crossAxisSpacing: 2,
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                children: List.generate(ch.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        changeScreen(context, (){});
                      } else if (index == 1) {
                        changeScreen(context, const HomeScreenChat());
                      } else if (index == 2) {
                       
                      } else if (index == 3) {
                       changeScreen(context, const ChatScreen());
                      }
                    },
                    child: SelectCard(
                      key: ValueKey(index),
                      ch: ch[index],
                    ),
                  );
                }),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Profit Promotion & Gift',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 105, 114, 106),
                ),
              ),
              Image.asset('assets/icons/promotion.png'),
            ],
          ),
        ],
      ),
      const Column(
        children: [
          Text("Bonjour"),
          Text("Bonjour"),
        ],
      ),
      const Column(
        children: [
          Text("Bonjour"),
          Text("Bonjour"),
        ],
      ),
      const Column(
        children: [
          Text("Bonjour"),
          Text("Bonjour"),
        ],
      ),
      const Column(
        children: [
          Text("Bonjour"),
          Text("Bonjour"),
        ],
      ),
    ];
  }

  void _onTabItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/logo.png',
                width: 50,
              ),
              const SizedBox(width: 8),
              const Text(
                'ITC Students',
                style: TextStyle(
                  color: Color.fromARGB(255, 105, 114, 106),
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 163, 255, 161),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selectedColor: const Color.fromARGB(255, 163, 255, 161),
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.home_filled),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                changeScreenReplacement(context,const HomeScreenChat());
              },
              selectedColor: const Color.fromARGB(255, 163, 255, 161),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                changeScreenReplacement(
                    context, ProfileScreen(email: email, userName: userName));
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Log Out",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 163, 255, 161),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 36,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartBar, size: 36),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add_outlined, size: 36),
            label: "News",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership_outlined, size: 36),
            label: "Services",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 36),
            label: "Profile",
          ),
        ],
        onTap: _onTabItem,
      ),
    );
  }
}

class choices {
  const choices({required this.name, required this.image});
  final String name;
  final ImageProvider image;
}

class SelectCard extends StatelessWidget {
  const SelectCard({required Key? key, required this.ch}) : super(key: key);
  final choices ch;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: ch.image, width: 80),
            Text(
              ch.name,
              style: const TextStyle(
                color: Color.fromARGB(255, 105, 114, 106),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
