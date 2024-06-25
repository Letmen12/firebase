import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  final List<dynamic> favorites;

  FavoritePage({required this.favorites});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  void _deleteFavorite(int index) {
    setState(() {
      widget.favorites.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Дуртай бараа   ',
          style: TextStyle(
            color: Color.fromARGB(255, 250, 145, 127),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.favorites.length,
        itemBuilder: (context, index) {
          final product = widget.favorites[index];
          return Dismissible(
            key: Key(product['id'].toString()),
            onDismissed: (direction) {
              _deleteFavorite(index);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              title: Text(product['title']),
              subtitle: Text(product['description']),
              leading: Image.network(
                product['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
