import 'package:aysu/Pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 55, 131, 222)),
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
  String isim = '';
  String soyisim = '';
  int yas = 0;
  int boy = 0;
  int kilo = 0;

  double _counter = 0;
  String _imagePath = "images/elmali_turta4.png";
  double hedeflenen = 0.0;
  double sonuc = 0.0;
  double vki = 0.0;
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

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isim = prefs.getString('isim') ?? '';
    soyisim = prefs.getString('soyisim') ?? '';
    yas = prefs.getInt('yas') ?? 0;
    boy = prefs.getInt('boy') ?? 0;
    kilo = prefs.getInt('kilo') ?? 0;

    double? vkikayit = prefs.getDouble('vki');
    double? sukayit = prefs.getDouble('su');
    _counter = prefs.getDouble('icilen_su')!;
    vki = prefs.getDouble('vki')!;

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
                      fontSize: 20,
                      color: Color.fromARGB(138, 25, 0, 255),
                      fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 50),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 118, 69, 183),
                              offset: Offset(0, 4),
                              blurRadius: 5,
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [sonuc, sonuc],
                            colors: <Color>[
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 12, 138, 255)
                            ],
                          )),
                      height: MediaQuery.of(context).size.height * 0.5,
                      margin: EdgeInsets.all(50),
                      // alignment: Alignment(-0.9, 0.9),
                      child: Image.asset(
                        "images/e.png",
                      )),
                  SizedBox(width: 50),
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 237, 236, 239),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(229, 2, 153, 167),
                          offset: Offset(0, 4),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "İsim:" + isim,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Soyisim:" + soyisim,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Yaş:" + yas.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Boy:" + boy.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Kilo:" + kilo.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "vki:" + vki.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

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
