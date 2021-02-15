import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;


Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser = await _auth.currentUser;
  assert(user.uid == currentUser.uid);

  assert(currentUser.email != null);
  assert(currentUser.displayName != null);
  assert(currentUser.photoURL != null);
  name = currentUser.displayName;
  email = currentUser.email;
  imageUrl = currentUser.photoURL;

  return 'signInWithGoogle succeeded: $user';

}

void signOutGoogle() async{
  await googleSignIn.signOut();
  print("User Sign Out");

}