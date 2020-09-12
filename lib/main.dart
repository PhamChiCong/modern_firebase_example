import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _status = "";

  @override
  void initState() {
    
    super.initState();
  }

  void updateStatus(String str) {
    setState(() {
      _status =  str;
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen(
      (User user) {
        if (user == null) {
          print('User is currently signed out!');

          updateStatus("User is currently signed out!");
          
        } else {
          print('User is signed in!');
          updateStatus("User is signed in!");
          updateStatus(user.email);
        }
      },
    );
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      updateStatus(e.message);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase login"),
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () {
              //
              signInWithGoogle();
            },
            child: Text('Google Signin'),
          ),
          Text(_status),
          RaisedButton(
            onPressed: () {
              //
              //
              auth.signOut();
            },
            child: Text('Secure Storage'),
          ),
        ],
      ),
    );
  }
}
