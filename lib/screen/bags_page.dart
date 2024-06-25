import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BasketPage extends StatefulWidget {
  final List<dynamic> basket;

  BasketPage({required this.basket});

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    double newTotalPrice = widget.basket
        .fold(0.0, (previous, current) => previous + current['price']);

    setState(() {
      totalPrice = newTotalPrice;
    });

    // Update total price in Firestore
    FirebaseFirestore.instance.collection('basket').doc('total').set({
      'totalPrice': newTotalPrice,
    }).then((value) {
      print('Total price updated successfully');
    }).catchError((error) {
      print('Failed to update total price: $error');
    });
  }

  void removeFromBasket(Map<String, dynamic> product) {
    setState(() {
      widget.basket.remove(product);
      calculateTotalPrice();
    });
    FirebaseFirestore.instance
        .collection('basket')
        .where('id', isEqualTo: product['id'])
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        FirebaseFirestore.instance.collection('basket').doc(doc.id).delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сагслах'),
      ),
      body: ListView.builder(
        itemCount: widget.basket.length,
        itemBuilder: (context, index) {
          final product = widget.basket[index];
          return ListTile(
            title: Text(product['title']),
            leading: Image.network(
              product['image'],
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
            subtitle: Text('Price: \$${product['price']}'),
            trailing: IconButton(
              icon: Icon(Icons.remove_from_queue_outlined),
              onPressed: () => removeFromBasket(product),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          calculateTotalPrice();
        },
        child: Icon(Icons.calculate),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Total Price: \$${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
