import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    // Obtener la información del usuario
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // Crear credenciales de Google para Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Obtener el usuario actual
    final User? user = userCredential.user;

    // Verificar si el usuario existe
    if (user != null) {
      // Obtener el nombre del usuario
      final String? displayName = user.displayName;
      // Verificar si se proporcionó un nombre
      String username = displayName ?? 'Usuario Anónimo';

      // Crear el documento del usuario en la colección "Usuarios"
      await FirebaseFirestore.instance
          .collection("Usuarios")
          .doc(user.email!)
          .set({
        'usuario': username,
        'biografia': 'Cuentale al mundo quien eres..',
        // Agregar otros elementos del usuario aquí
      });
    }
  }
}



/*import 'package:firebase_auth/firebase_auth.dart';
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
*/