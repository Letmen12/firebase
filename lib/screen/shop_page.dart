import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_app/screen/bags_page.dart';
import 'package:firebase_app/screen/favorite_page.dart';
import 'package:firebase_app/screen/profile_page.dart';
import 'package:firebase_app/screen/produc_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  int _currentIndex = 0;
  String dropdownvalue = "men's clothing";
  var items = [
    "men's clothing",
    "jewelery",
    "electronics",
    "women's clothing",
    "all",
  ];

  List<dynamic> products = [];
  List<dynamic> basket = [];
  List<dynamic> favorites = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void toggleFavorite(dynamic product) {
    setState(() {
      if (favorites.contains(product)) {
        favorites.remove(product);
        FirebaseFirestore.instance
            .collection('favorites')
            .where('id', isEqualTo: product['id'])
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            FirebaseFirestore.instance
                .collection('favorites')
                .doc(doc.id)
                .delete();
          }
        });
      } else {
        favorites.add(product);
        FirebaseFirestore.instance.collection('favorites').add(product);
      }
    });
  }

  void toggleBasket(dynamic product) {
    setState(() {
      if (basket.contains(product)) {
        basket.remove(product);
        FirebaseFirestore.instance
            .collection('basket')
            .where('id', isEqualTo: product['id'])
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            FirebaseFirestore.instance
                .collection('basket')
                .doc(doc.id)
                .delete();
          }
        });
      } else {
        basket.add(product);
        FirebaseFirestore.instance.collection('basket').add(product);
      }
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget getBody() {
    switch (_currentIndex) {
      case 1:
        return FavoritePage(favorites: favorites);
      case 2:
        return ProfilePage();
      case 3:
        return ProductDetailPage(
            product: products.isNotEmpty ? products[0] : null);
      case 4:
        return BasketPage(basket: basket);
      default:
        return getProductListView();
    }
  }

  Widget getProductListView() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey, thickness: 2.5),
          SizedBox(
            height: 10,
          ),
          Column(
            children: List.generate(
              (products.length / 10).ceil(),
              (rowIndex) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      10,
                      (columnIndex) {
                        final index = rowIndex * 10 + columnIndex;
                        if (index < products.length) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                      product: products[index]),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  products[index]['image'],
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 150.0,
                                    child: Text(
                                      products[index]['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$${products[index]['price']}',
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        favorites.contains(products[index])
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: favorites
                                                .contains(products[index])
                                            ? Colors.red
                                            : Color.fromARGB(255, 161, 25, 185),
                                      ),
                                      onPressed: () =>
                                          toggleFavorite(products[index]),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        color: basket.contains(products[index])
                                            ? Colors.green
                                            : const Color.fromARGB(
                                                255, 2, 2, 2),
                                      ),
                                      onPressed: () =>
                                          toggleBasket(products[index]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              Divider(
                                color: Colors.grey,
                                thickness: 2.5,
                                indent: 0,
                                endIndent: 0,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(color: Colors.grey, thickness: 2.5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 248),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 30,
              width: 100,
            ),
            Column(
              children: [
                Text(
                  "+баяр",
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
                Text(
                  "нэмнэ",
                  style: TextStyle(fontSize: 10, color: Colors.red),
                ),
              ],
            ),
            SizedBox(width: 50),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showSignOutMenu(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 38, 94, 139),
                    ),
                    child: Text(
                      'Манай үйлчилгээнүүд',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Нүүр',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    
                    onTap: () {
                      Navigator.pop(context);
                      onTabTapped(0);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Сагслах',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onTabTapped(4);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Дуртай бараа',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onTabTapped(1);
                    },
                  ),
                  Image.asset(
                    'assets/ticket.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                  Container(
                    child: GradientText(
                      '  Тасалбар захиалах',
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.red,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Гарах'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Color.fromARGB(255, 250, 145, 127),
        unselectedItemColor: Colors.grey,
        selectedIconTheme:
            IconThemeData(color: Color.fromARGB(255, 250, 145, 127)),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            label: 'Product Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bags',
          ),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    required this.gradient,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}
