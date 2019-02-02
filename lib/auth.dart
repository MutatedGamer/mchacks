part of './main.dart';



final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;

void _authenticateWithGoogle() async {
  final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth =
  await googleUser.authentication;
  final AuthCredential creds = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken);
  final FirebaseUser user = await
  auth.signInWithCredential(creds
  );
  // do something with signed-in user
}

void _signOut() async {
  await FirebaseAuth.instance.signOut();
  await googleSignIn.signOut();
}