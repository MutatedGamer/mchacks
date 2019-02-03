part of './main.dart';

//void main() {
//  runApp(Main());
//}

//class Main extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Creating new lesson',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: LessonPage(),
//    );
//  }
//}

class LessonPage extends StatefulWidget {

  String lessonID;

  LessonPage(this.lessonID);

  @override
  _LessonPageState createState() => _LessonPageState(lessonID);
}

class _LessonPageState extends State<LessonPage> {

  String lessonID;

  _LessonPageState(this.lessonID);

  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = StateWidget.of(context).state;
    final lesson = Firestore.instance.collection('users')
                    .document(appState.user.uid)
                    .collection('lessons')
                    .document(lessonID);
    return StreamBuilder(
      stream: lesson.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Loading...");
        }
        var lesson = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(lesson['name']),
          ),
          body:
          new Column(
            children: <Widget>[
              //the following textfields must be positioned on the right, but they are not the center
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                        new RaisedButton(
                          padding: EdgeInsets.all(10.0),
                          child: Text("LEARN",
                            style: new TextStyle(
                                fontSize: 24.0,
                                color: Colors.white
                            ),
                          ),
                          color: Colors.blue,
                          elevation: 4.0,
                          splashColor: Colors.blueGrey,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LearnPage(lessonID))
                            );
                          },
                        ),
                      ),
                    ),

                  ]
              ),
              Expanded(
                child:
                noteBullets(),
              ),
              SingleChildScrollView(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  controller: noteController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)
                      ),
                      hintText: 'Enter your notes here!',
                      filled: true,
                      suffixIcon: IconButton(
                          icon: Icon(Icons.check_circle  ),
                          onPressed: () {
                            submitNote(noteController);
                          })),
                ),
              )

            ],
          ),
        );
      }
    );
  }

//  final lessonTitle = new Container(
//    //TODO: Firebase traverse to get lesson title
//    child: new Text(
//        "Traverse database for text here",
//        textAlign: TextAlign.center,
//        style: new TextStyle(
//          fontSize: 30.0,
//          color: Colors.black
//        )
//    )
//  );

  Widget noteBullets(){
    final appState = StateWidget.of(context).state;
    final lesson = Firestore.instance.collection('users')
        .document(appState.user.uid)
        .collection('lessons')
        .document(lessonID)
        .collection('regular_input')
        .orderBy('timestamp', descending: true);
    
    return StreamBuilder(
        stream: lesson.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading...");
          }
          var lesson = snapshot.data;
          return new ListView.builder(
            itemCount: lesson.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return makeBullet(lesson.documents[index]['text']);
            },
          );
        }
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

  void submitNote(TextEditingController controller){
    if (controller.text == "") return;
    final appState = StateWidget.of(context).state;
    final Bullet bullet = new Bullet(controller.text);
    createBullet(appState.user.uid, lessonID, bullet);
    controller.clear();
  }
}