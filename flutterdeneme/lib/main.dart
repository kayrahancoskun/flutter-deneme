import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const WidgetDetail());
}

class WidgetDetail extends StatefulWidget {
  const WidgetDetail({super.key});

  @override
  State<WidgetDetail> createState() => _WidgetDetailState();
}

class _WidgetDetailState extends State<WidgetDetail> {
  int value = 0;

  get mainAxisAlignment => null;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("👑İMPARATOR SEMİH BABA👑"),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
        leading: const Text("menu"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value.toString()),
            const Text(
              "KAYRAHAN REİS📿",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                letterSpacing: 10,
                color: Colors.pink,
                
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            value = value + 1;
          });
        },
        child: const Text("🔥"),
      ),
    ));
  }
}
