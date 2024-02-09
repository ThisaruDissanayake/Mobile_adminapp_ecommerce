import 'package:flutter/material.dart';
import 'package:newcosmetic2/components/custom_button.dart';
import 'package:newcosmetic2/components/custom_text_input.dart';
import 'package:newcosmetic2/utils/application_state.dart';
import 'package:newcosmetic2/utils/custom_theme.dart';
import 'package:newcosmetic2/utils/login_data.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loadingButton = false;

  Map<String, String> data = LoginData.SignIn;

  void switchLogin() {
    setState(() {
      if (data == LoginData.SignUp) {
        data = LoginData.SignIn;
      } else {
        data = LoginData.SignUp;
      }
    });
  }

  loginError(FirebaseAuthException e) {
    print("error");
    if (e.message != ' ') {
      setState(() {
        _loadingButton = false;
      });
      // need to show alert
    }
  }

  void loginButtonPressed() {
    setState(() {
      _loadingButton = true;
    });
    ApplicationState applicationState =
        Provider.of<ApplicationState>(context, listen: false);
    if (data == LoginData.SignUp) {
      applicationState.signUp(
          _emailController.text, _passwordController.text, loginError);
    } else {
      applicationState.signIn(
          _emailController.text, _passwordController.text, loginError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
   // backgroundColor: const Color.fromARGB(255, 237, 157, 128),
     body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/t.jpg'), // Load background image
            fit: BoxFit.cover,
          ),
        ),
    
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0, bottom: 30, top:70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      data["heading"]!,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  Text(
                    data["subHeading"]!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            model(data, _emailController, _passwordController),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: switchLogin,
                    child: SizedBox(
                      
                      height: 50,
                      child: Text(
                        data["footer"]!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
     )
    );
  }

  model(Map<String, String> data, TextEditingController emailController,
      TextEditingController passwordController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(right: 20, left: 20, top: 30, bottom: 56),
      decoration: CustomTheme.getCardDecoration(),
      child: Column(
        children: [
          CustomTextInput(
            label: "Your email address",
            placeholder: "email@address.com",
            icon: Icons.person_outline,
            textEditingController: _emailController,
          ),
          CustomTextInput(
            label: "Password",
            placeholder: "password",
            icon: Icons.lock_outlined,
            password: true,
            textEditingController: _passwordController,
          ),
          CustomButton(
            text: data["label"]!,
            onPress: loginButtonPressed,
            loading: _loadingButton,
          ),
        ],
      ),
    );
  }
}
