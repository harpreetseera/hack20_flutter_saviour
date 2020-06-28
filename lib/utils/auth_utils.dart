import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saviour/utils/saviour.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  print(user.uid);
  Saviour.prefs.setString(Saviour.PREF_UID, user.uid);
  Saviour.prefs.setString(Saviour.PREF_EMAIL, user.email);
  Saviour.prefs.setBool(Saviour.PREF_LOGGED_IN, true);
  return 'signInWithGoogle succeeded: $user';
}

Future<GoogleSignInAccount> signOutGoogle() async {
  return await googleSignIn.signOut();
  // print("User Sign Out");
}
