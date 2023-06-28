import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    //empezar el proceso de login
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //clickear el email
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    //crear credencial
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    //permitir el login
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
