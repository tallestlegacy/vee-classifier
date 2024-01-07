import 'package:classifier/routes/test_screen.dart';
import 'package:flutter/material.dart';

import 'routes/home_screen.dart';
import 'utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const Placeholder(),
    const TestScreen(),
  ];

  List<NavigationDestination> destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    const NavigationDestination(
      icon: Icon(Icons.history),
      label: "History",
    ),

    // show test screen on debug
    const NavigationDestination(
      icon: Icon(Icons.bug_report_rounded),
      label: "Test",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: NavigationBar(
          destinations: destinations,
          selectedIndex: currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
