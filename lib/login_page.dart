part of './main.dart';

class LoginScreen extends StatelessWidget {

  var googleButton = SignInButton(
    Buttons.Google,
    onPressed: () => _authenticateWithGoogle(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    "Learning in the Cloud",
                    style: _biggerFont,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: googleButton,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}