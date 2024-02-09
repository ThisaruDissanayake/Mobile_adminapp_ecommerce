
import 'package:flutter/material.dart';
import 'package:newcosmetic2/components/custom_button.dart';
import 'package:newcosmetic2/orderhistory.dart';
import 'package:newcosmetic2/utils/application_state.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loadingButton = false;

  void signOutButtonPressed() {
    setState(() {
      _loadingButton = true;
    });
    Provider.of<ApplicationState>(context, listen: false).signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 237, 157, 128),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 500),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 8, 8, 8),
          
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CompletedOrdersScreen(),
              ),
            );
          },
          child: Icon(
            Icons.assignment_turned_in_rounded,
            color: Colors.white,
          ),
        ),
      ),
       appBar: AppBar(
        title: Text(
          'Profile',
         // style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Color.fromARGB(255, 236, 108, 108),
        foregroundColor: Colors.white,

     
       ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Padding(
            padding: EdgeInsets.only(bottom: 20),
           child: Text(
              "Hi There",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          CustomButton(
            text: "SIGN OUT",
            onPress: signOutButtonPressed,
            loading: _loadingButton,
          ),
          ],
        ),
      ),
    );
  }
}



