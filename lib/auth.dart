part of './main.dart';



final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;

Future<GoogleSignInAccount> getSignedInAccount(
    GoogleSignIn googleSignIn) async {
  // Is the user already signed in?
  GoogleSignInAccount account = googleSignIn.currentUser;
  // Try to sign in the previous user:
  if (account == null) {
    account = await googleSignIn.signInSilently();
  }
  return account;
}

Future<FirebaseUser> signIntoFirebase(
    GoogleSignInAccount googleSignInAccount) async {
  final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth =
  await googleUser.authentication;
  final AuthCredential creds = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken);
  final FirebaseUser user = await
   auth.signInWithCredential(creds
  );
  return user;
  // do something with signed-in user
}

void _signOut() async {
  await FirebaseAuth.instance.signOut();
  await googleSignIn.signOut();
}