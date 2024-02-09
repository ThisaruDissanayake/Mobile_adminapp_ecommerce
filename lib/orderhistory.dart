import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  State<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 157, 128),
      appBar: AppBar(
        title: Text(
          'Past Orders',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 236, 108, 108),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('CompletedOrders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading orders: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {


            // return ListView.builder(
            //   itemCount: snapshot.data!.docs.length,
            //   itemBuilder: (context, index) {
            //     DocumentSnapshot orderDocument = snapshot.data!.docs[index];
            //     Map<String, dynamic> orderData = orderDocument.data() as Map<String, dynamic>;

            //     // Display the completed order here, using orderData
            //     // Example:
            //     return ListTile(
            //       title: Text(orderData['orderId'] ?? 'Unknown Order ID'), // Assuming you have an 'orderId' field
            //       subtitle: Text(orderData['customerName'] ?? 'Unknown Customer'), 
            //       trailing: Text(orderData['totalCost'].toString()),// Replace with appropriate fields
            //     );
            //   },
            // );
 return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot orderDocument = snapshot.data!.docs[index];
              Map<String, dynamic> orderData = orderDocument.data() as Map<String, dynamic>;

              return Card(
                   margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Order for ${orderData['customername']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: ${orderData['address']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      Text('Order Date: ${orderData['orderdate']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      Text('Delivery Method: ${orderData['delivermethod']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      Text('Receiver\'s Phone: ${orderData['receiversphone']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      Text('Customer Name: ${orderData['customername']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                       Text('Total Payment: ${orderData['totalCost']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                       
                      SizedBox(height: 10),
                      Text('Cart Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        children: (orderData['cartItems'] as List).map((item) {
                          return ListTile(
                            title: Text('Name: ${item['name']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Price: ${item['price']}'),
                                // Retrieve the image of the cart item
                                Image.network(
                                  item['url'], // Assuming 'url' is the field containing the image URL
                                  width: 100, // Adjust the width as needed
                                  height: 100, // Adjust the height as needed
                                ),
                             
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                            Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red[900],
                                      ),
                                       onPressed: () async {
                              try {
                                await orderDocument.reference.delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Order deleted successfully!'),
                                  ),
                                );
                              } catch (error) {
                                // Handle any errors that might occur during deletion
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting order: ${error.toString()}'),
                                  ),
                                );
                              }
                            },
                                    ),
                                  ],
                                ),
                    ],
                  ),
                ),
              );
            },
          );



          } else {
            return Center(child: Text('No completed orders found'));
          }
        },
      ),
    );
  }
}



