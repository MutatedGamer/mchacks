import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part './auth.dart';
part './login_page.dart';
part './state_widget.dart';
//part './main_page.dart';
part './models/schema.dart';
part './firestore_api.dart';

final _biggerFont = const TextStyle(fontSize: 28.0, fontFamily: 'sans-serif');


final String lesson_id = "lesson_1";
final Bullet bullet = new Bullet("test bullet");


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
  int _counter = 0;
  StateModel appState;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }


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
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: buildButton("${snapshot["name"]}")
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

  void _openSubNote(String buttonTitle){
    //TODO: route to different page
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
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  getRow(context, snapshot.data.documents[index]),
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
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

