import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';


part './auth.dart';
part './login_page.dart';
part './state_widget.dart';
//part './main_page.dart';
part './models/schema.dart';
part './firestore_api.dart';


class Constants{
  static const String Delete = 'Delete';

  static const List<String> choices = <String>[
    Delete,
  ];
}

final _biggerFont = const TextStyle(fontSize: 18.0, fontFamily: 'sans-serif');


// Creates a StateWidget (see state_widget.dart) with a child of the main app
// in order to keep the current login information
void main() => runApp(new StateWidget(
  child: new MyApp(),
));


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mcHacks Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => MyHomePage(),
        '/login': (context) => LoginScreen(),
      },
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
  StateModel appState;


  // Loading
  Widget _buildLoading(){
    return MaterialApp(
      title: 'Loading...',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: _buildLoadingIndicator(),
        ),
      );
  }


  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget _buildContent() {
    if (appState.isLoading) {
      return _buildLoading();
    } else if (!appState.isLoading && appState.user == null) {
      return new LoginScreen();
    } else {
      return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return _buildContent();
  }
}






class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
  return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
                document['name']
            ),
          ),
        ],
      )
  );
}



class _HomePageState extends State<HomePage> {

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget getRow(BuildContext context, snapshot) {
    return new ListTile(
        title: new Text(
          snapshot["name"],
          style: _biggerFont,
        ),
        trailing: new PopupMenuButton<String>(
          onSelected: choiceAction,
          itemBuilder: (BuildContext context){

            return Constants.choices.map((String choice){
              return PopupMenuItem<String>(
                value: snapshot.documentID,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      onTap: (){
        _openSubNote(snapshot);
      },
    );
  }


  void _openSubNote(String documentID){
    //TODO: route to different page
  }

  // Popup Menu Choice Handler
  void choiceAction(String documentID){
    final appState = StateWidget.of(context).state;
    deleteLesson(appState.user.uid, documentID);
  }

  _showDialog(BuildContext context) async {
    final appState = StateWidget.of(context).state;
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: textController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Notes name', hintText: 'eg. "Calculus Lecture 2"'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              }),
          new FlatButton(
              child: const Text('SAVE'),
              onPressed: () {
                Lesson lesson = new Lesson(textController.text);
                createLesson(appState.user.uid, lesson);
                Navigator.pop(context);
                textController.clear();
              })
        ],
      ),),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = StateWidget.of(context).state;
    //createBullet(appState.user.uid, lesson_id, bullet);

    //print(appState.user.uid);
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your Notes'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () { StateWidget.of(context).signOutOfGoogle(); },
            ),
          ],
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('users').document(appState.user.uid).collection('lessons').orderBy('timestamp', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: const Text('Loading...'));
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Text("Add a lesson!"),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    getRow(context, snapshot.data.documents[index]),
                    Divider(),
                  ],
                );
              }
            );
          },
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: new Color(0xFFE57373),
            onPressed: (){_showDialog(context);}
        ),
      ),
    );
  }
}


class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.padding,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}



