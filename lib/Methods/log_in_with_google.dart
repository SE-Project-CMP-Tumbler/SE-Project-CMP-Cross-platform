import 'package:google_sign_in/google_sign_in.dart';

void logInWithGoogle() {
  // still not working
  // need to add the sha1 to the firebase
  GoogleSignIn().signIn().then((final GoogleSignInAccount? userData) async {
    print("1");
    print(userData!.serverAuthCode);
    print("2");
    print(userData.id);
    print("3");
    print(userData.displayName);
    print("4");
    print(userData.email);
    print("5");
    print(await userData.authentication);
  });
}
