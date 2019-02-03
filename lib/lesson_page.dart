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
      title: 'Creating new lesson',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LessonPage(),
    );
  }
}

class LessonPage extends StatefulWidget {
  LessonPage({Key key}) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  List bulletNotes = ["Sample sample sample sample sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      "Sample sample sample sample sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      "Sample sample sample sample sample",
                      ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Creating a New Lesson"),
        ),
        body:
          new Column(
            children: <Widget>[
              //the following textfields must be positioned on the right, but they are not the center
              lessonTitle,
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                      new RaisedButton(
                        padding: EdgeInsets.all(10.0),
                        child: Text("LEARN",
                          style: new TextStyle(
                              fontSize: 20.0,
                              color: Colors.white
                          ),
                        ),
                        color: Colors.blue,
                        elevation: 4.0,
                        splashColor: Colors.blueGrey,
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: (){
                          _openSubNote();
                        },
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      child: Text("EDIT",
                        style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.white
                        ),
                      ),
                      color: Colors.blue,
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: (){
                        _openSubNote();
                      },
                    ),
                  ),

                ]
              ),
              Expanded(
                child:
                  noteBullets(),
              ),
            ],
          ),
    );
  }

  final lessonTitle = new Container(
    //TODO: Firebase traverse to get lesson title
    child: new Text(
        "Traverse database for text here",
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontSize: 30.0,
          color: Colors.black
        )
    )
  );

  Widget noteBullets(){

    return new ListView.builder(
      itemCount: bulletNotes.length,
      itemBuilder: (BuildContext context, int index) {
        return makeBullet(bulletNotes[index]);
      },
    );
  }

  Widget makeBullet(String text){
    return new GestureDetector(
      onTap: (){
        //in case we need to tap on the cards to do something
        //maybe delete functionality added here?
      },
      child:
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 2.0, 12.0, 2.0),
          child: new Card(
            child:
                Padding(
                  padding:EdgeInsetsDirectional.fromSTEB(4.0, 10.0, 4.0, 10.0),
                  child: new Text(text, style:TextStyle(fontSize: 16.0)),
                ),
          ),
        ),
    );

  }

  void _openSubNote(){
    //TODO: route to different page
  }
}