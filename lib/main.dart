import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newcosmetic2/firebase_options.dart';
//import 'package:newcosmetic2/home.dart';
import 'package:newcosmetic2/homeimage.dart';
import 'package:newcosmetic2/insert.dart';
import 'package:newcosmetic2/order.dart';
import 'package:newcosmetic2/profile.dart';
import 'package:newcosmetic2/screens/login.dart';
import 'package:newcosmetic2/search.dart';
import 'package:newcosmetic2/update.dart';
import 'package:newcosmetic2/utils/application_state.dart';
import 'package:newcosmetic2/utils/custom_theme.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Stripe setup
  final String response =
      await rootBundle.loadString("assets/config/stripe.json");
  final data = await json.decode(response);
  Stripe.publishableKey = data["publishablekey"];
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => Consumer<ApplicationState>(
      builder: (context, applicationState, _) {
        Widget child;
        switch (applicationState.loginState) {
          case ApplicationLoginState.loggetout:
            child = LoginScreen();
            break;
          case ApplicationLoginState.loggedIn:
            child = MyApp();
            break;
          default:
            child = LoginScreen();
        }
        return MaterialApp(
          theme: CustomTheme.getTheme(),
          home: child,
        );
      },
    ),
  ));
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 108, 108),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: CustomTheme.cardShadow,
          ),
          child: const TabBar(
            padding: EdgeInsets.symmetric(vertical: 10),
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.image)),
              Tab(icon: Icon(Icons.search)),
              Tab(icon: Icon(Icons.shopping_bag)),
              //Tab(icon: Icon(Icons.assignment_turned_in_rounded)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            Home(),
            HomeImageScreen(),
            SearchScreen(),
            AdminOrderScreen(),
            //CompletedOrdersScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
 

  @override
  Widget build(BuildContext context) {
    CollectionReference bproducts = FirebaseFirestore.instance.collection('bproducts');
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55.0),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 8, 8, 8),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ccreate(),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text( 'Cosmetics Shop'),
           backgroundColor: Color.fromARGB(255, 236, 108, 108),
          foregroundColor: Colors.white, 
        ),
  
       
      body: StreamBuilder<QuerySnapshot>(
        stream: bproducts.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> Bproduct = document.data() as Map<String, dynamic>;
              Bproduct['key'] = document.id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateRecord(
                        Bproduct_Key: Bproduct['key'],
                      ),
                    ),
                  );
                },
                child: SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color.fromARGB(255, 236, 108, 108),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                Bproduct['url'],
                              ),
                            ),
                            tileColor: Color.fromARGB(255, 237, 157, 128),
                            title: Text(
                              Bproduct['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Product Code: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('${Bproduct['pid']}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Category: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('${Bproduct['category']}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Price: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('${Bproduct['price']}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Brand: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('${Bproduct['brand']}'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red[900],
                                      ),
                                      onPressed: () {
                                        bproducts.doc(Bproduct['key']).delete();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
