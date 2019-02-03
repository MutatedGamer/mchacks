part of './main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends  State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "Learning in the Cloud",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Image.asset(
                  'images/LearningCloud.jpg'
                )
              )
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: SignInButton(
                  Buttons.Google,
                  onPressed: () => StateWidget.of(context).signInWithGoogle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}