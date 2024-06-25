import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_app/guest_book.dart';
import 'package:firebase_app/app_state.dart';

class ProductDetailPage extends StatefulWidget {
  final dynamic product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<String> comments = [];

  String commentText = '';

  void addComment() {
    if (commentText.isNotEmpty) {
      setState(() {
        comments.add(commentText);
        commentText = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double productRating;
    try {
      productRating = widget.product['rating'] != null
          ? double.parse(widget.product['rating'].toString())
          : 0.0;
    } catch (e) {
      productRating = 5.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 49, 43, 43)
                          .withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(10, 3),
                    ),
                  ],
                ),
                child: Image.network(
                  widget.product['image'],
                  fit: BoxFit.fill,
                  height: 200,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Price: \$${widget.product['price']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 140),
                Text(
                  productRating.toStringAsFixed(1),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                RatingBarIndicator(
                  rating: productRating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 14.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 2.5,
              indent: 0,
              endIndent: 0,
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 22, 96, 54),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.product['description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GuestBook(
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.guestBookMessages,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
