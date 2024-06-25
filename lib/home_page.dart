import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/authentication.dart';
import 'package:firebase_app/screen/shop_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        if (appState.loggedIn) {
          return ShoppingPage();
        } else {
          return Scaffold(
            backgroundColor: Color.fromRGBO(45, 11, 75, 1),
            appBar: AppBar(
              title: const Text(
                'Тавтай морилно уу',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView(
              children: <Widget>[
                Image.asset(
                  'assets/codelab.png',
                  width: 100,
                  height: 500,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => AuthFunc(
                    loggedIn: appState.loggedIn,
                    signOut: () {
                      FirebaseAuth.instance.signOut();
                    },
                    enableFreeSwag: appState.enableFreeSwag,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
