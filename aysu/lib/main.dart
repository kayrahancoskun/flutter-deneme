import 'package:aysu/Pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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
  double _counter = 0;
  String _imagePath = "images/elmali_turta4.png";
  double hedeflenen = 0.0;
  double sonuc = 0.0;
  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = _counter + 200;
      gradientHesapla();
    });
    if (_counter >= hedeflenen * 1000) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Hedefe Ulaştınız.',
          confirmBtnText: "Tamam",
          title: "Tebrikler!");
    }
    prefs.setDouble('icilen_su', _counter);
    print('içilen su kaydedildi.${_counter}');
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _setImageBasedOnVki(double vki) {
    setState(() {
      if (vki < 18.5) {
        _imagePath = "images/zayif.png";
      } else if (vki >= 18.5 && vki < 24.9) {
        _imagePath = "images/normal.png";
      } else if (vki >= 25 && vki < 29.9) {
        _imagePath = "images/kilolu.png";
      } else {
        _imagePath = "images/obez.png";
      }
    });
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? vkikayit = prefs.getDouble('vki');
    double? sukayit = prefs.getDouble('su');
    _counter = prefs.getDouble('icilen_su')!;

    print('vki gelen: $vkikayit');
    print('su gelen: $sukayit');

    setState(() {
      hedeflenen = sukayit ?? 0.0; // null check ve varsayılan değer ataması
      _counter;
    });
    prefs.setDouble('icilen_su', _counter);
    print('içilen su kaydedildi.${_counter}');
    gradientHesapla();

    print('bitti');
  }

  void gradientHesapla() async {
    double icilecekMl = hedeflenen * 1000;
    sonuc = ((_counter * 100) / icilecekMl) / 100;
    print(sonuc);
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
              Text(
                  _counter.toString() +
                      '/' +
                      (hedeflenen * 1000).toStringAsFixed(0),
                  style: TextStyle(
                    color: Color.fromARGB(255, 4, 255, 0),
                  )),
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [sonuc, sonuc],
                    colors: <Color>[
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 12, 138, 255)
                    ],
                  )),
                  width: MediaQuery.of(context).size.width * 0.100,
                  height: MediaQuery.of(context).size.height * 0.100,
                  margin: EdgeInsets.all(50),
                  // alignment: Alignment(-0.9, 0.9),
                  child: Text(
                    "flutter container",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
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
