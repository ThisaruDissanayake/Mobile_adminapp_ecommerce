import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ApplicationLoginState { loggetout, loggedIn }

class ApplicationState extends ChangeNotifier {
  List<Map<dynamic, dynamic>> cartList = [];

  User? user;
  ApplicationLoginState loginState = ApplicationLoginState.loggetout;
  

  ApplicationState() {
    init();
  }
  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((userFir) {
      if (userFir != null) {
        loginState = ApplicationLoginState.loggedIn;
        user = userFir;
      } else {
        loginState = ApplicationLoginState.loggetout;
      }
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password,
      void Function(FirebaseAuthException e) errorCallBack) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorCallBack(e);
    }
  }

  Future<void> signUp(String email, String password,
      void Function(FirebaseAuthException e) errorCallBack) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      //stripe user create
    } on FirebaseAuthException catch (e) {
      errorCallBack(e);
    }
  }

  void addToCart(Map<dynamic, dynamic> product) {
    cartList.add(product);
    notifyListeners();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  
}
