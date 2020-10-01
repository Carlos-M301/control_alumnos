import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

Future<Matriculas> fetchMatriculas() async {
  //http://www.7timer.info/bin/api.pl?lon=-97.872&lat=22.282&product=civillight&output=json
  final response = await http.get('http://60c00e500322.ngrok.io/api/alumnos');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Matriculas.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('No se encontrarón las matriculas');
  }
}

class Matriculas {
  final List<dynamic> alumnos;

  Matriculas({this.alumnos});

  factory Matriculas.fromJson(Map<String, dynamic> json) {
    return Matriculas(alumnos: json['alumnos']);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Matriculas> futureMatriculas;
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    futureMatriculas = fetchMatriculas();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  List<Widget> display_matriculas(Matriculas matriculas) {
    List<Widget> list = [];
    for (var alumnos in matriculas.alumnos) {
      list.add(Card(
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Text(alumnos['matricula']),
                  width: 200,
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  child: Text(alumnos['nombre']),
                  width: 200,
                ),
                flex: 3,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          padding: EdgeInsets.all(16),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Matriculas>(
            future: futureMatriculas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var alumnos = display_matriculas(snapshot.data);
                return ListView(
                  children: alumnos,
                );
              } else if (snapshot.hasError) {
                return Text('Error');
              }
              return CircularProgressIndicator();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
