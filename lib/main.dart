import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'cgpa.dart';
import 'sgpa.dart';
import 'bmi.dart';
import 'age.dart';
import 'gpa.dart';
import 'converter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calcify',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const Home(),
    const About(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.12), blurRadius: 10)
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomNavigationBar(
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> buttons = [
      {'label': 'GPA', 'icon': Icons.school, 'page': const GPACalculatorApp()},
      {
        'label': 'CGPA',
        'icon': Icons.auto_graph,
        'page': const CGPACalculatorHomePage()
      },
      {
        'label': 'SGPA',
        'icon': Icons.assessment,
        'page': const SGPACalculatorPage()
      },
      {
        'label': 'BMI',
        'icon': Icons.monitor_weight,
        'page': const BMICalculatorPage()
      },
      {'label': 'Age', 'icon': Icons.cake, 'page': const AgeCalculatorPage()},
      {
        'label': 'Converters',
        'icon': Icons.swap_horiz,
        'page': const ConverterPage()
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Calcify',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Icon(Icons.calculate, size: 60, color: Colors.blue),
                SizedBox(height: 25),
                Text(
                  'Easily compute your GPA, CGPA, SGPA, BMI, Age and more!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  return _buildStyledButton(
                    context,
                    label: buttons[index]['label'],
                    icon: buttons[index]['icon'],
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => buttons[index]['page']));
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

  Widget _buildStyledButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onPressed}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 60),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: GoogleFonts.comfortaa(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ABOUT US',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome to Calcify!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16),
            Text(
              '📱 Your smart companion for quick and precise academic & personal calculations. Whether you’re a student tracking grades or someone checking BMI and age, Calcify is for you.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text(
              '✨ Features at a Glance:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            Text(
              '• GPA, SGPA, and CGPA calculators for students\n'
              '• BMI and Age calculators for health tracking\n'
              '• A wide range of unit converters\n'
              '• Elegant design, smooth animations, and instant results',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for choosing Calcify!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Text(
              '\nDeveloped by: Md. Rizauanul Haque Rakib\n'
              'Email: rizauanul@gmail.com\n',
              style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}