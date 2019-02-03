part of './main.dart';

class LearnPage extends StatefulWidget {
  String lessonID;

  LearnPage(this.lessonID);


@override
_LearnPage createState() => _LearnPage(lessonID);
}

class _LearnPage extends  State<LearnPage> {
  String lessonID;

  _LearnPage(this.lessonID);

  final noteController = TextEditingController();

  String keyword;
  String fillIn;

  int index;
  int score;

  double opacity;

  int max_index;

  @override
  void initState() {
    super.initState();
    opacity = 1.0;
    index = 0;
    score = 0;

  }



  @override
  Widget build(BuildContext context) {
    final appState = StateWidget
        .of(context)
        .state;

    final lesson = Firestore.instance.collection('users')
        .document(appState.user.uid)
        .collection('lessons')
        .document(lessonID);

    final questions = Firestore.instance.collection('users')
        .document(appState.user.uid)
        .collection('lessons')
        .document(lessonID)
        .collection('study_questions');


    return StreamBuilder(
        stream: lesson.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading...");
          }
          var lesson = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text("Studying from lesson ${lesson['name']}"),
            ),
            body:
                  StreamBuilder(
                      stream: questions.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return new Text("Loading...");
                        }

                        if (snapshot.data.documents.length > 15) {
                          max_index = 15;
                        } else {
                          max_index = snapshot.data.documents.length - 1;
                        }

                        return new Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Opacity(
                              opacity: opacity,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  snapshot.data.documents[index]['fillInTheBlank'],
                                  style: _mediumFont,
                                ),
                              ),
                            ),

                            Expanded(
                              child:
                                getScoreboard()
                            ),

                            Opacity(
                              opacity: opacity,
                              child:
                              SingleChildScrollView(
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  controller: noteController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.teal)
                                      ),
                                      hintText: 'Fill in the blank!',
                                      filled: true,
                                      suffixIcon: IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () {
                                            submitGuess(noteController, snapshot.data.documents[index]['keyword']);
                                          })),
                                ),
                              )
                            ),

                          ],
                        );
                      }

                  ),

          );
        }
    );
  }

  Widget getScoreboard(){
    if(opacity == 1.0){
      return Container();
    }
    else{
      return Text("Your score is: \n" + score.toString() +"/" + (max_index+1).toString(),
          textAlign: TextAlign.center, style: new TextStyle(fontSize: 40.0));
    }
  }

  void submitGuess(TextEditingController noteController, String word) {
    if (noteController.text == word) {
      setState(()=> score ++);
    }
    if (index < max_index) {
      setState(() => index ++);
      print(word);
      print(noteController.text);
      noteController.clear();
    }
    else {
      noteController.clear();
      setState(() => opacity = 0.0,
      );
    }
  }

}