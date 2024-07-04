import 'package:aysu/Pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'AYSU💧'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _imagePath = "images/calinti_insan.png";
  double hedeflenen = 0.0;
  void _incrementCounter() {
    setState(() {
      _counter = _counter + 200;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _setImageBasedOnVki(double vki) {
    setState(() {
      if (vki < 18.5) {
        _imagePath = "images/insan_vucudu.png";
      } else if (vki >= 18.5 && vki < 24.9) {
        _imagePath = "images/normal_vucut.png";
      } else if (vki >= 25 && vki < 29.9) {
        _imagePath = "images/hafif_obez.png";
      } else {
        _imagePath = "images/obez.png";
      }
    });
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double? vkikayit = prefs.getDouble('vki');
    double? sukayit = prefs.getDouble('su');

    print('vki gelen: $vkikayit');
    print('su gelen: $sukayit');

    setState(() {
      hedeflenen = sukayit ?? 0.0; // null check ve varsayılan değer ataması
    });

    print('bitti');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              }),
        ],
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$_counter/$hedeflenen',
                  style: TextStyle(
                    color: Color.fromARGB(255, 4, 255, 0),
                  )),
              Container(
                width: 200,
                height: 250,
                  color: Colors.black,
                  margin: EdgeInsets.all(50),
                  alignment: Alignment(-0.9, 0.9),
                  child: Text(
                    "flutter container",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  )),

              // Container
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'SU İÇ SU',
        child: const Text('SU İÇ'),
      ),
    );
  }
}
