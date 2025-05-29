import 'package:ai_wrapper_app/common/auth_button.dart';
import 'package:ai_wrapper_app/routing/scaffold_nested.dart';
import 'package:ai_wrapper_app/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  Future<void> _signInWithGoogle() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // if (googleUser == null) {
      //   if (!mounted) return;
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   return;
      // }

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final user = userCredential.user;
        if (user == null) {
          throw Exception('Google sign-in succeeded but user is null');
        }

        print('Signed in with Google: ${user.uid}');
        _handleSuccessfulAuth(user);
      }
    } catch (e) {
      print('Google sign-in failed: $e');
      // _showErrorDialog('Google sign-in failed: ${e.toString()}');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        context.go('/a');

        // final User userDetails =
        //     (await firebaseAuth.signInWithCredential(credential)).user!;
        // state = state.copyWith(
        //   uidNew: userDetails.uid,
        //   nameNew: userDetails.displayName,
        //   emailNew: userDetails.email,
        //   imageUrlNew: userDetails.photoURL,
        //   providerNew: "GOOGLE",
        // );
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            // state = state.copyWith(
            //     errorCode:
            //         "You already have an account with us. Use correct provider",
            //     hasErrorNew: true);

            break;

          case "null":
            // state = state.copyWith(
            //     errorCode: "Some unexpected error while trying to sign in",
            //     hasErrorNew: true);

            break;
          default:
          //        state = state.copyWith(errorCode: e.toString(), hasErrorNew: true);
        }
      }
    } else {
      //   state = state.copyWith(hasErrorNew: true);
    }
  }

  void _handleSuccessfulAuth(User user) {
    // Here you can navigate to your home screen or dashboard
    print('Successfully authenticated with UUID: ${user.uid}');
    // Navigate to home screen
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // App title or logo would go here
                  const Text(
                    "Let's brainstorm",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // // Sign in with Apple button
                  // AuthButton(
                  //   onPressed: _signInWithApple,
                  //   text: 'Continue with Apple',
                  //   icon: const Icon(Icons.apple, color: Colors.white),
                  //   backgroundColor: Colors.white,
                  //   textColor: Colors.black,
                  // ),

                  // const SizedBox(height: 16),

                  // Sign in with Google button
                  AuthButton(
                    onPressed: signInWithGoogle,
                    text: 'Continue with Google',
                    icon: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      height: 24,
                      width: 24,
                    ),
                    backgroundColor: const Color(0xFF4A4A4A),
                    textColor: Colors.white,
                  ),

                  const SizedBox(height: 16),
                  AuthButton(
                    onPressed: () {},
                    text: 'Continue with Apple',
                    icon: const Icon(Icons.apple, color: Colors.white),
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 16),

                  // Sign up button
                  AuthButton(
                    onPressed: () {},
                    text: 'Sign up',
                    backgroundColor: const Color(0xFF333333),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 16),

                  // Log in button
                  AuthButton(
                    onPressed: () {},
                    text: 'Log in',
                    backgroundColor: Colors.transparent,
                    textColor: Colors.white,
                    borderColor: Colors.white.withOpacity(0.3),
                  ),

                  // // Sign up button
                  // AuthButton(
                  //   onPressed: _navigateToEmailSignUp,
                  //   text: 'Sign up',
                  //   backgroundColor: const Color(0xFF333333),
                  //   textColor: Colors.white,
                  // ),

                  // const SizedBox(height: 16),

                  // // Log in button
                  // AuthButton(
                  //   onPressed: _navigateToEmailSignIn,
                  //   text: 'Log in',
                  //   backgroundColor: Colors.transparent,
                  //   textColor: Colors.white,
                  //   borderColor: Colors.white.withOpacity(0.3),
                  // ),

                  const Spacer(),

                  // Bottom indicator
                  Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
