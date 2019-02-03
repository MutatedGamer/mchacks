import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Notes"),
        ),
        body: ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            }),
        floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
          backgroundColor: new Color(0xFFE57373),
          onPressed: (){}
        )
    );
  }

  Widget buildButton(String buttonTitle){
    final Color tintColor = Colors.blue;
    return new Column(
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(top: 5.0),
          child:
              ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 50.0,
                child:
                  new RaisedButton(
                    padding: EdgeInsets.all(10.0),
                    child: Text(buttonTitle,
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                      ),
                    ),
                    color: Colors.blue,
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    onPressed: (){
                      _openSubNote(buttonTitle);
                    },
                  )
              )
          //  child: new Text(buttonTitle, style: new TextStyle(fontSize: 16.0,
          // fontWeight: FontWeight.w600, color: tintColor),),
        )
      ],
    );
  }

  Widget getRow(int i) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: buildButton("Row ${widgets[i]["title"]}")
    );
  }

  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }

  void _openSubNote(String buttonTitle){
    //TODO: route to different page
  }
}