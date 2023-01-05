import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool extendButton = true;
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(1.5, 0))
            .animate(
                CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (!(notification.direction == ScrollDirection.idle)) {
            setState(() {
              extendButton = false;
            });
            _controller!.forward();
          } else {
            setState(() {
              extendButton = true;
            });
            _controller!.reverse();
          }
          return true;
        },
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return const ListTile(
              leading: Text('Hi, number'),
            );
          },
          itemCount: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        width: extendButton ? 150 : 55,
        child: FloatingActionButton.extended(
            onPressed: () {},
            isExtended: extendButton,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            label: FadeTransition(
                opacity: _fadeAnimation!,
                child: SlideTransition(
                  position: _slideAnimation!,
                  child: const Text("Scan any qr"),
                )),
            icon: const Icon(Icons.qr_code)),
      ),
    );
  }
}
