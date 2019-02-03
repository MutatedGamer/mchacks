import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';


part './auth.dart';
part './login_page.dart';
part './state_widget.dart';
//part './main_page.dart';
part './models/schema.dart';
part './firestore_api.dart';
part './lesson_page.dart';
part './watson_processing.dart';


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
        primarySwatch: Colors.green,
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

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  String textValue = 'Hello World !';

  @override
  void initState() {
    super.initState();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        showNotification(msg);
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
  }

  update(String token) {
    final appState = StateWidget.of(context).state;
    print(token);
    final user = Firestore.instance.collection('users').document(appState.user.uid);
    user.updateData({"token":"$token"});
    textValue = token;
    setState(() {});
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
        _openSubNote(snapshot.documentID);
      },
    );
  }


  void _openSubNote(String documentID){
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => LessonPage(documentID))
    );
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



