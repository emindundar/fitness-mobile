import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<User?> signInWithGoogle() async {
  try {
    // Google Sign-In işlemi
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null; // Kullanıcı giriş yapmadı
    }

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    // Firebase için kimlik doğrulama
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Firebase ile giriş yap
    final UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential.user;
  } catch (e) {
    print("Google ile giriş hatası: $e");
    return null;
  }
}