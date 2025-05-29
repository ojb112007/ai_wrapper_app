import 'package:ai_wrapper_app/common/auth_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Wrapper App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return; // User canceled the sign-in flow
      }

      // Get authentication details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Get UUID
      final String uuid = userCredential.user!.uid;
      print('Signed in with Google: $uuid');

      // Navigate to home screen or handle success
      _handleSuccessfulAuth(userCredential.user!);
    } catch (e) {
      _showErrorDialog('Google sign-in failed: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithApple() async {
    // try {
    //   setState(() {
    //     _isLoading = true;
    //   });

    //   // Check if Apple Sign In is available on this device
    //   final isAvailable = await SignInWithApple.isAvailable();
    //   if (!isAvailable) {
    //     _showErrorDialog('Apple Sign In is not available on this device');
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     return;
    //   }

    //   // Start the Apple sign-in flow
    //   final credential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //   );

    //   // Create an OAuthCredential for Firebase
    //   final oauthCredential = OAuthProvider('apple.com').credential(
    //     idToken: credential.identityToken,
    //     accessToken: credential.authorizationCode,
    //   );

    //   // Sign in with Firebase using the Apple credential
    //   final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);

    //   // Get UUID
    //   final String uuid = userCredential.user!.uid;
    //   print('Signed in with Apple: $uuid');

    //   // Handle successful authentication
    //   _handleSuccessfulAuth(userCredential.user!);

    // } catch (e) {
    //   _showErrorDialog('Apple sign-in failed: ${e.toString()}');
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  void _navigateToEmailSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailSignInScreen()),
    );
  }

  void _navigateToEmailSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailSignUpScreen()),
    );
  }

  void _handleSuccessfulAuth(User user) {
    // Here you can navigate to your home screen or dashboard
    print('Successfully authenticated with UUID: ${user.uid}');
    // Navigate to home screen
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Authentication Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
                  // const Text(
                  //   "Let's brainstorm",
                  //   style: TextStyle(
                  //     fontSize: 36,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //   ),
                  // ),

                  const Spacer(flex: 3),

                  // Sign in with Apple button
                  AuthButton(
                    onPressed: _signInWithApple,
                    text: 'Continue with Apple',
                    icon: const Icon(Icons.apple, color: Colors.white),
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                  ),

                  const SizedBox(height: 16),

                  // Sign in with Google button
                  AuthButton(
                    onPressed: _signInWithGoogle,
                    text: 'Continue with a',
                    icon: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      height: 24,
                      width: 24,
                    ),
                    backgroundColor: const Color(0xFF4A4A4A),
                    textColor: Colors.white,
                  ),

                  const SizedBox(height: 16),

                  // Sign up button
                  AuthButton(
                    onPressed: _navigateToEmailSignUp,
                    text: 'Sign up',
                    backgroundColor: const Color(0xFF333333),
                    textColor: Colors.white,
                  ),

                  const SizedBox(height: 16),

                  // Log in button
                  AuthButton(
                    onPressed: _navigateToEmailSignIn,
                    text: 'Log in',
                    backgroundColor: Colors.transparent,
                    textColor: Colors.white,
                    borderColor: Colors.white.withOpacity(0.3),
                  ),

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

// Email Sign In Screen
class EmailSignInScreen extends StatefulWidget {
  const EmailSignInScreen({super.key});

  @override
  State<EmailSignInScreen> createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> _signInWithEmail() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text,
  //     );

  //     // Get UUID
  //     final String uuid = userCredential.user!.uid;
  //     print('Signed in with Email: $uuid');

  //     // Handle successful authentication
  //     _handleSuccessfulAuth(userCredential.user!);

  //   } on FirebaseAuthException catch (e) {
  //     String message = 'An error occurred';
  //     if (e.code == 'user-not-found') {
  //       message = 'No user found with this email.';
  //     } else if (e.code == 'wrong-password') {
  //       message = 'Incorrect password.';
  //     }
  //     _showErrorDialog(message);
  //   } catch (e) {
  //     _showErrorDialog('Login failed: ${e.toString()}');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // void _handleSuccessfulAuth(User user) {
  //   // Here you would navigate to your home screen or dashboard
  //   print('Successfully signed in with email: ${user.uid}');
  //   // Navigate to home screen
  //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
  // }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Authentication Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      //  onPressed: _signInWithEmail,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
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

// Email Sign Up Screen
class EmailSignUpScreen extends StatefulWidget {
  const EmailSignUpScreen({super.key});

  @override
  State<EmailSignUpScreen> createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> _signUpWithEmail() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text,
  //     );

  //     // Get UUID
  //     final String uuid = userCredential.user!.uid;
  //     print('Signed up with Email: $uuid');

  //     // Handle successful authentication
  //     _handleSuccessfulAuth(userCredential.user!);

  //   } on FirebaseAuthException catch (e) {
  //     String message = 'An error occurred';
  //     if (e.code == 'weak-password') {
  //       message = 'The password provided is too weak.';
  //     } else if (e.code == 'email-already-in-use') {
  //       message = 'An account already exists for that email.';
  //     }
  //     _showErrorDialog(message);
  //   } catch (e) {
  //     _showErrorDialog('Sign up failed: ${e.toString()}');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // void _handleSuccessfulAuth(User user) {
  //   // Here you would navigate to your home screen or dashboard
  //   print('Successfully signed up with email: ${user.uid}');
  //   // Navigate to home screen
  //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
  // }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Authentication Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password field
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Sign up button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      // onPressed: _signUpWithEmail,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Terms and conditions
                  Center(
                    child: Text(
                      'By signing up, you agree to our Terms and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
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
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AI Chat App',
//       theme: ThemeData.dark().copyWith(
//         primaryColor: Color(0xFF1F1F1F),
//         scaffoldBackgroundColor: Color(0xFF121212),
//         cardColor: Color(0xFF1E1E1E),
//         colorScheme: ColorScheme.dark(
//           primary: Color(0xFF8B5CF6),
//           secondary: Color(0xFF4F46E5),
//           surface: Color(0xFF1E1E1E),
//           background: Color(0xFF121212),
//         ),
//       ),
//       home: ChatListScreen(),
//     );
//   }
// }

// // Model class for Chat
// class Chat {
//   final String id;
//   final String title;
//   final String lastMessage;
//   final DateTime timestamp;

//   Chat({
//     required this.id,
//     required this.title,
//     required this.lastMessage,
//     required this.timestamp,
//   });
// }

// // Model class for Message
// class Message {
//   final String id;
//   final String content;
//   final bool isUserMessage;
//   final DateTime timestamp;

//   Message({
//     required this.id,
//     required this.content,
//     required this.isUserMessage,
//     required this.timestamp,
//   });
// }

// // Screen showing the list of conversations
// class ChatListScreen extends StatelessWidget {
//   // Hardcoded chat list
//   final List<Chat> chats = [
//     Chat(
//       id: '1',
//       title: 'Flutter Development Help',
//       lastMessage: 'Could you explain how to implement state management?',
//       timestamp: DateTime.now().subtract(Duration(minutes: 5)),
//     ),
//     Chat(
//       id: '2',
//       title: 'Project Ideas',
//       lastMessage: 'What about an AI-powered note-taking app?',
//       timestamp: DateTime.now().subtract(Duration(hours: 2)),
//     ),
//     Chat(
//       id: '3',
//       title: 'Dart Programming',
//       lastMessage: 'How do I use async/await in Dart?',
//       timestamp: DateTime.now().subtract(Duration(days: 1)),
//     ),
//     Chat(
//       id: '4',
//       title: 'Mobile App Design',
//       lastMessage: 'What are the best practices for dark mode implementation?',
//       timestamp: DateTime.now().subtract(Duration(days: 3)),
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Conversations'),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         elevation: 0,
//       ),
//       body: ListView.builder(
//         itemCount: chats.length,
//         itemBuilder: (context, index) {
//           final chat = chats[index];
//           return ChatListItem(chat: chat);
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Create a new chat
//           // For now, we'll just navigate to a new chat detail screen
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ChatDetailScreen(
//                 chatId: 'new',
//                 title: 'New Conversation',
//               ),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//     );
//   }
// }

// // Widget for individual chat list item
// class ChatListItem extends StatelessWidget {
//   final Chat chat;

//   ChatListItem({required this.chat});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ChatDetailScreen(
//                 chatId: chat.id,
//                 title: chat.title,
//               ),
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       chat.title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Text(
//                     _formatTimestamp(chat.timestamp),
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Text(
//                 chat.lastMessage,
//                 style: TextStyle(color: Colors.grey[400]),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);

//     if (difference.inDays > 0) {
//       return DateFormat('MMM d').format(timestamp);
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}m ago';
//     } else {
//       return 'Just now';
//     }
//   }
// }

// // Chat detail screen to show conversation
// class ChatDetailScreen extends StatefulWidget {
//   final String chatId;
//   final String title;

//   ChatDetailScreen({
//     required this.chatId,
//     required this.title,
//   });

//   @override
//   _ChatDetailScreenState createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   // Hardcoded message history
//   late List<Message> messages;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize with hardcoded messages based on chatId
//     _loadMessages();
//   }

//   void _loadMessages() {
//     // Hardcoded messages for different conversations
//     switch (widget.chatId) {
//       case '1':
//         messages = [
//           Message(
//             id: '1',
//             content: 'Hi, I need help with Flutter development.',
//             isUserMessage: true,
//             timestamp: DateTime.now().subtract(Duration(minutes: 30)),
//           ),
//           Message(
//             id: '2',
//             content:
//                 'Of course! What specific aspect of Flutter can I help you with?',
//             isUserMessage: false,
//             timestamp: DateTime.now().subtract(Duration(minutes: 29)),
//           ),
//           Message(
//             id: '3',
//             content: 'Could you explain how to implement state management?',
//             isUserMessage: true,
//             timestamp: DateTime.now().subtract(Duration(minutes: 25)),
//           ),
//           Message(
//             id: '4',
//             content:
//                 'State management in Flutter has several approaches. The most common ones include Provider, Riverpod, Bloc, and GetX. Would you like me to explain any of these in detail?',
//             isUserMessage: false,
//             timestamp: DateTime.now().subtract(Duration(minutes: 24)),
//           ),
//         ];
//         break;
//       case '2':
//         messages = [
//           Message(
//             id: '1',
//             content: 'I\'m looking for project ideas for my portfolio.',
//             isUserMessage: true,
//             timestamp: DateTime.now().subtract(Duration(hours: 3)),
//           ),
//           Message(
//             id: '2',
//             content:
//                 'That\'s exciting! What kind of technologies are you interested in working with?',
//             isUserMessage: false,
//             timestamp: DateTime.now().subtract(Duration(hours: 3)),
//           ),
//           Message(
//             id: '3',
//             content: 'I\'m interested in AI and mobile development.',
//             isUserMessage: true,
//             timestamp: DateTime.now().subtract(Duration(hours: 2)),
//           ),
//           Message(
//             id: '4',
//             content:
//                 'For AI and mobile, you could build a smart personal assistant, an image recognition app, or a language learning tool. What about an AI-powered note-taking app?',
//             isUserMessage: false,
//             timestamp: DateTime.now().subtract(Duration(hours: 2)),
//           ),
//         ];
//         break;
//       case '3':
//         messages = [
//           Message(
//             id: '1',
//             content: 'I\'m learning Dart programming.',
//             isUserMessage: true,
//             timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
//           ),
//           Message(
//             id: '2',
//             content:
//                 'That\'s great! Dart is a powerful language, especially with Flutter. What would you like to know about it?',
//             isUserMessage: false,
//             timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
//           ),
//           Message(
//             id: '3',
//             content: 'How do I use async/await in Dart?',
//             isUserMessage: true,
//             timestamp: DateTime.now().subtract(Duration(days: 1, hours: 1)),
//           ),
//           Message(
//             id: '4',
//             content:
//                 'Async/await in Dart is used for asynchronous programming. You mark functions with `async` and use `await` to wait for Future values. This makes asynchronous code read like synchronous code, improving readability and error handling.',
//             isUserMessage: false,
//             timestamp: DateTime.now().subtract(Duration(days: 1, hours: 1)),
//           ),
//         ];
//         break;
//       case '4':
//         messages = [
//           Message(
//             id: '1',
//             content: 'I\'m designing a mobile app and need advice.',
//             isUserMessage: true,
//             timestamp: DateTime.now().subtract(Duration(days: 3, hours: 5)),
//           ),
//           Message(
//             id: '2',
//             content:
//                 'I\'d be happy to help with your app design. What kind of advice are you looking for?',
//             isUserMessage: false,
//             timestamp: DateTime.now().subtract(Duration(days: 3, hours: 5)),
//           ),
//           Message(
//             id: '3',
//             content:
//                 'What are the best practices for dark mode implementation?',
//             isUserMessage: true,
//             timestamp: DateTime.now().subtract(Duration(days: 3, hours: 4)),
//           ),
//           Message(
//             id: '4',
//             content:
//                 'For dark mode, consider these best practices: use a consistent color palette, maintain sufficient contrast, test with users, offer manual and automatic switching, and use system-friendly default themes.',
//             isUserMessage: false,
//             timestamp: DateTime.now().subtract(Duration(days: 3, hours: 4)),
//           ),
//         ];
//         break;
//       default:
//         // New conversation
//         messages = [];
//         break;
//     }
//   }

//   void _sendMessage() {
//     if (_messageController.text.trim().isEmpty) return;

//     setState(() {
//       messages.add(
//         Message(
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           content: _messageController.text,
//           isUserMessage: true,
//           timestamp: DateTime.now(),
//         ),
//       );
//     });

//     // Clear the input field
//     _messageController.clear();

//     // Scroll to bottom
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });

//     // Simulate AI response after a delay
//     Future.delayed(Duration(seconds: 1), () {
//       if (mounted) {
//         setState(() {
//           messages.add(
//             Message(
//               id: DateTime.now().millisecondsSinceEpoch.toString(),
//               content:
//                   'This is a simulated AI response to your message: "${_messageController.text}"',
//               isUserMessage: false,
//               timestamp: DateTime.now(),
//             ),
//           );
//         });

//         // Scroll to bottom again after AI response
//         Future.delayed(Duration(milliseconds: 100), () {
//           if (_scrollController.hasClients) {
//             _scrollController.animateTo(
//               _scrollController.position.maxScrollExtent,
//               duration: Duration(milliseconds: 300),
//               curve: Curves.easeOut,
//             );
//           }
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.more_vert),
//             onPressed: () {
//               // Show options for this chat
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Messages list
//           Expanded(
//             child: messages.isEmpty
//                 ? Center(
//                     child: Text(
//                       'Start a new conversation',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   )
//                 : ListView.builder(
//                     controller: _scrollController,
//                     padding: EdgeInsets.all(16),
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       final message = messages[index];
//                       return MessageBubble(message: message);
//                     },
//                   ),
//           ),
//           // Message input area
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: Theme.of(context).cardColor,
//               boxShadow: [
//                 BoxShadow(
//                   offset: Offset(0, -2),
//                   blurRadius: 4,
//                   color: Colors.black12,
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(24),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Theme.of(context).colorScheme.surface,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                     ),
//                     maxLines: null,
//                     textCapitalization: TextCapitalization.sentences,
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 CircleAvatar(
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   child: IconButton(
//                     icon: Icon(Icons.send),
//                     color: Colors.white,
//                     onPressed: _sendMessage,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

// // Widget for individual message bubbles
// class MessageBubble extends StatelessWidget {
//   final Message message;

//   MessageBubble({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment:
//           message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.only(
//           bottom: 12,
//           left: message.isUserMessage ? 64 : 0,
//           right: message.isUserMessage ? 0 : 64,
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: message.isUserMessage
//               ? Theme.of(context).colorScheme.primary
//               : Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               message.content,
//               style: TextStyle(
//                 color: message.isUserMessage ? Colors.white : null,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               _formatTimestamp(message.timestamp),
//               style: TextStyle(
//                 color: message.isUserMessage ? Colors.white70 : Colors.grey,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatTimestamp(DateTime timestamp) {
//     return DateFormat('h:mm a').format(timestamp);
//   }
// }
