import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MyJellyButton());
}

class MyJellyButton extends StatelessWidget {
  const MyJellyButton({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App!!',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Flutter Example App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _widthAnimation;
  late Animation<double> _translateYAnimation;
  bool pressed = false;

  SpringDescription spring = const SpringDescription(
    mass: 0.7,
    stiffness: 700,
    damping: 14,
  );

  late SpringSimulation simulation;
  String name = "Tap Me";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );

    _widthAnimation = Tween<double>(
      begin: 150.0,
      end: 170.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _heightAnimation = Tween<double>(
      begin: 70.0,
      end: 60.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _translateYAnimation = Tween<double>(
      begin: 0.0,
      end: 9.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    simulation = SpringSimulation(spring, 0, 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          onTapDown: (_) {
            _controller.animateWith(simulation);
            setState(() {
              List<String> labels = ["Ahhh!", "Ouchh", "Slow Down"];
              // Create an instance of the Random class
              Random random = Random();

              // Get a random index from the list
              int randomIndex = random.nextInt(labels.length);

              // Access the element at the random index
              String randomValue = labels[randomIndex];

              name = randomValue;
            });
            //_controller.forward();
          },
          onTapCancel: () {
            final simulation = SpringSimulation(spring, 1, 0, 0);
            setState(() {
              name = "Tap Me !";
            });
            _controller.animateWith(simulation);
          },
          onTapUp: (_) {
            final simulation = SpringSimulation(spring, 1, 0, 0);
            setState(() {
              name = "Tap Me !";
            });
            _controller.animateWith(simulation);
          },
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0, _translateYAnimation.value),
                  child: Container(
                    height: _heightAnimation.value,
                    width: _widthAnimation.value,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 178, 128, 248),
                          Color.fromARGB(255, 108, 7, 232)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
