import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newcosmetic2/imageinsert.dart';
import 'package:newcosmetic2/imageupdate.dart';

class HomeImageScreen extends StatefulWidget {
  const HomeImageScreen({super.key});

  @override
  State<HomeImageScreen> createState() => _HomeImageScreenState();
}

class _HomeImageScreenState extends State<HomeImageScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference carousel =
        FirebaseFirestore.instance.collection('carousel-slider');
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 157, 128),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55.0),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => iccreate(),
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
        title: Text('OFFERS'),
        backgroundColor: Color.fromARGB(255, 236, 108, 108),
        foregroundColor: Colors.white,
      ),
      //backgroundColor: Color.fromARGB(255, 12, 12, 12),
      body: StreamBuilder<QuerySnapshot>(
        stream: carousel.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> Iproduct =
                  document.data() as Map<String, dynamic>;
              Iproduct['key'] = document.id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateImageRecord(
                        Iproduct_Key: Iproduct['key'],
                      ),
                    ),
                  );
                },
                child: Container(
                  
                  margin: const EdgeInsets.all(8),
                  child: Card(

                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color.fromARGB(255, 236, 108, 108),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 150, 
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                Iproduct['image'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color.fromARGB(255, 236, 108, 108),
                                
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // title: Text(
                            //   "Your Title",
                            //   style: TextStyle(
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // subtitle: Text(
                            //   "Your Subtitle",
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //   ),
                            // ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[900],
                              ),
                              onPressed: () {
                                carousel.doc(Iproduct['key']).delete();
                              },
                            ),
                          ),
                        ),
                      ],
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
