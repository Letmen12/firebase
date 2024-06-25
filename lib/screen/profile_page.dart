import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String selectedValue = 'Option 1';
  late User _user;
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isExpanded = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: 160.0,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(seconds: 1),
                            curve: Curves.easeInOut,
                            width: _isExpanded ? 70.0 : 30.0,
                            height: _isExpanded ? 70.0 : 30.0,
                            child: CircleAvatar(
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : AssetImage('assets/avatar.png'),
                              radius: 30.0,
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: _isExpanded ? 1.0 : 0.0,
                            duration: Duration(seconds: 1),
                            child: Text(
                              _user.email!,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w200),
                            ),
                          ),
                          Text(
                            "Мэдээлэл засах",
                            style:
                                TextStyle(fontSize: 9, color: Colors.black26),
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    const Color.fromARGB(255, 252, 253, 253)),
                              ),
                              child: Row(
                                children: const [
                                  SizedBox(width: 4),
                                  Text(
                                    'Зураг илгээх',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.getImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {}
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Container(
                      width: 160.0,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              Text(
                                "Хувийн мэдээлэл",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            "Мэдээлэл засах",
                            style:
                                TextStyle(fontSize: 9, color: Colors.black26),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 160.0,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.phone,
                                    color: const Color.fromARGB(255, 5, 4, 4),
                                    size: 25,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Гар утас",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("Баталгаажаагүй",
                                        style: TextStyle(
                                            fontSize: 9, color: Colors.black26))
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 160.0,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.key,
                              color: const Color.fromARGB(255, 5, 4, 4),
                              size: 25,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Нууц үг",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("Шинэчлэх",
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.black26))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Манай компанид тавтай морилно уу",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              color: Color.fromARGB(255, 67, 67, 67),
              thickness: 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  child: Image.asset(
                    'assets/click.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value * 0.5,
                      child: child,
                    );
                  },
                ),
                Text(
                  "Энд дарна уу",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hours: Open ⋅ Closes 6PM",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Phone: 7777 8985",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Address: Olympic Street, Ulaanbaatar 14210",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/app.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/play.png',
                  width: 130,
                  height: 60,
                  fit: BoxFit.fitHeight,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void showSignOutMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
