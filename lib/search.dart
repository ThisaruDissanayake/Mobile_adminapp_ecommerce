import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = " Search product code";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           backgroundColor: const Color.fromARGB(255, 237, 157, 128),
      appBar: AppBar(
        title: Text(
          'Search  ',
          // style: TextStyle(
          //   fontSize: 25,
          // ),
        ),
         backgroundColor: Color.fromARGB(255, 236, 108, 108),
          foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    inputText = val;
                    print(inputText);
                  });
                },
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("bproducts")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Something went wrong"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading"),
                        );
                      }

                      List<DocumentSnapshot> filteredProducts = snapshot.data!.docs
                          .where((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return data['pid'].contains(inputText);
                      }).toList();

                      if (inputText.isNotEmpty && filteredProducts.isEmpty) {
                        return Center(
                          child: Text("Product not found"),
                        );
                      }

                      return ListView(
                        children: (inputText.isEmpty || filteredProducts.isEmpty)
                            ? snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                return Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: Text(data['name']),
                                    leading: Image.network(data['url']),
                                    subtitle: Text(data['pid']),
                                  ),
                                );
                              }).toList()
                            : filteredProducts
                                .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                return Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: Text(data['name']),
                                    leading: Image.network(data['url']),
                                    subtitle: Text(data['pid']),
                                  ),
                                );
                              }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
