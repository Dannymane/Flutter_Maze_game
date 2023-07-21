import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Maze game',
        home: HomePage(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 135, 153, 218)),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentPageIndex = 0;
  int score = 0;

  void setCurrentPageIndex(var pageIndex) {
    currentPageIndex = pageIndex;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget page;

    switch (appState.currentPageIndex) {
      case 0:
        page = MenuWidget();
        break;
      case 1:
        page = GameWidget();
        break;
      default:
        throw UnimplementedError('no widget for $appState.currentPageIndex');
    }

    return page;
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
              (appState.score == 0)
                  ? "Welcome, make your first attempt:"
                  : "Your last score: ${appState.score}",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
              textAlign: TextAlign.center),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                appState.setCurrentPageIndex(1);
              },
              child: Text("Start new game")),
        ]),
      ),
    );
  }
}

class GameWidget extends StatefulWidget {
  const GameWidget({super.key});

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  final List<int> maze = [
    2,
    9,
    0,
    11,
    9,
    10,
    15,
    3,
    13,
    12,
    12,
    4,
    2,
    7,
    5,
    14,
    3,
    11,
    3,
    9,
    4,
    2,
    7,
    3,
    5
  ];
  int currentIndex = 20;
  int performedSteps = 0;
  // String binary = currentIndex.toRadixString(2);
  // print(binary); // "101010"

  bool isOpen(int direction) {
    String binaryString = maze[currentIndex].toRadixString(2);
    if (binaryString.length >= direction) {
      if (binaryString[binaryString.length - direction] == "1") {
        return true;
      }
    }
    return false;
  }

  bool isGameFinished() {
    if (maze[currentIndex] == 0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Stack(
      children: [
        // Top
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: 100,
          child: Container(
            color: isOpen(3) ? Colors.white : Colors.brown,
            child: TextButton(
              child: SizedBox(height: 100),
              onPressed: () => {
                setState(() {
                  performedSteps += isOpen(3) ? 1 : 0;
                  currentIndex += isOpen(3) ? -5 : 0;
                  if (isGameFinished()) {
                    appState.setCurrentPageIndex(0);
                    appState.score = performedSteps;
                  }
                })
              },
            ),
          ),
        ),
        // Bottom
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          height: 100,
          child: Container(
            color: isOpen(4) ? Colors.white : Colors.brown,
            child: TextButton(
              child: SizedBox(height: 100),
              onPressed: () => {
                setState(() {
                  performedSteps += isOpen(4) ? 1 : 0;
                  currentIndex += isOpen(4) ? 5 : 0;
                  if (isGameFinished()) {
                    appState.score = performedSteps;
                    appState.setCurrentPageIndex(0);
                  }
                })
              },
            ),
          ),
        ),

        // Left
        Positioned(
          top: 100,
          bottom: 100,
          left: 0,
          width: 100,
          child: Container(
            color: isOpen(1) ? Colors.white : Colors.brown,
            child: TextButton(
              child: SizedBox(width: 100),
              onPressed: () => {
                setState(() {
                  performedSteps += isOpen(1) ? 1 : 0;
                  currentIndex += isOpen(1) ? -1 : 0;
                  if (isGameFinished()) {
                    appState.score = performedSteps;
                    appState.setCurrentPageIndex(0);
                  }
                })
              },
            ),
          ),
        ),
        // Right
        Positioned(
          top: 100,
          bottom: 100,
          right: 0,
          width: 100,
          child: Container(
            color: isOpen(2) ? Colors.white : Colors.brown,
            child: TextButton(
              child: SizedBox(width: 100),
              onPressed: () => {
                setState(() {
                  performedSteps += isOpen(2) ? 1 : 0;
                  currentIndex += isOpen(2) ? 1 : 0;
                  if (isGameFinished()) {
                    appState.score = performedSteps;
                    appState.setCurrentPageIndex(0);
                  }
                })
              },
            ),
          ),
        ),
        // Center
        Positioned(
          top: 100,
          bottom: 100,
          left: 100,
          right: 100,
          child: Container(color: Colors.white),
        ),
      ],
    );
  }
}
