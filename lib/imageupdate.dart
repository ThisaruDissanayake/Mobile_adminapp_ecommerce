import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newcosmetic2/homeimage.dart';
//import 'package:newcosmetic2/home.dart';
import 'package:newcosmetic2/main.dart';

class UpdateImageRecord extends StatefulWidget {
  String Iproduct_Key;

  UpdateImageRecord({required this.Iproduct_Key});

  @override
  State<UpdateImageRecord> createState() => _UpdateImageRecordState();
}

class _UpdateImageRecordState extends State<UpdateImageRecord> {

  TextEditingController productName = TextEditingController();

  var image;
  File? file;
  ImagePicker iimage = ImagePicker();
  CollectionReference carousel = FirebaseFirestore.instance.collection('carousel-slider');

  @override
  void initState() {
    super.initState();
    IproductData();
  }

  void IproductData() async {
    DocumentSnapshot snapshot = await carousel.doc(widget.Iproduct_Key).get();

    Map<String, dynamic> Iproduct = snapshot.data() as Map<String, dynamic>;

    setState(() {
  
      productName.text = Iproduct['name'];
      image = Iproduct['image'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 157, 128),
      appBar: AppBar(
        title: Text('Update Offers'),
          backgroundColor: Color.fromARGB(255, 236, 108, 108),
          foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 300,
                width: 300,
                child: file == null
                    ? MaterialButton(
                        height: 100,
                        child: image == null
                            ? Text('Choose Image')
                            :// CircleAvatar( foregroundColor: Colors.black,
                            CircleAvatar( foregroundColor: Colors.black,
                                maxRadius: 150,
                                backgroundImage: NetworkImage(image),
                              ),
                        onPressed: () {
                          getImage();
                        },
                      )
                    : MaterialButton(
                        height: 300,
                        child: Image.file(
                          file!,
                          fit: BoxFit.fill,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: productName,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Product Name',
              ),
            ),
           
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              height: 40,
              onPressed: () {
                if (file != null) {
                  uploadFile();
                } else {
                  directUpdate();
                }
              },
              child: Text(
                "Update",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    var img = await iimage.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        file = File(img.path);
      });
    }
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance.ref().child("Iproduct_photo").child("/${productName.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      image = await snapshot.ref.getDownloadURL();
      setState(() {
        image = image;
      });
      if (image != null) {
        Map<String, dynamic> Iproduct = {
          'name': productName.text,
          'image': image,
        };

        await carousel.doc(widget.Iproduct_Key).update(Iproduct).whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeImageScreen(),
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  directUpdate() async {
    if (image != null) {
      Map<String, dynamic> Iproduct = {  
        'name': productName.text,
        'image': image,
      };

      await carousel.doc(widget.Iproduct_Key).update(Iproduct).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeImageScreen(),
          ),
        );
      });
    }
  }
}
