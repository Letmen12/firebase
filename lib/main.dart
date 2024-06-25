import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app/firebase_notification.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_state.dart';
import 'home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.instance.getToken().then((token) {
      print('Firebase Messaging Token: $token');
    }).catchError((error) {
      print('Error getting Firebase Messaging Token: $error');
    });

    runApp(ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, child) => const App(),
    ));
  } catch (error, stackTrace) {
    print('Error during Firebase initialization: $error');
    print('Stack trace: $stackTrace');
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  context.push('/sign-in/forgot-password?email=$email');
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null,
                  };
                  if (user != null) {
                    if (state is UserCreated) {
                      user.updateDisplayName(user.email!.split('@')[0]);
                    }
                    if (!user.emailVerified) {
                      user.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please check your email to verify your email address')),
                      );
                    }
                    context.pushReplacement('/');
                  }
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final email = state.uri.queryParameters['email'];
                return ForgotPasswordScreen(
                  email: email,
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return Consumer<ApplicationState>(
              builder: (context, appState, _) => ProfileScreen(
                key: ValueKey(appState.emailVerified),
                providers: const [],
                actions: [
                  SignedOutAction(
                    (context) {
                      context.pushReplacement('/');
                    },
                  ),
                ],
                children: [
                  if (!appState.emailVerified)
                    OutlinedButton(
                      onPressed: () {
                        appState.refreshLoggedInUser();
                      },
                      child: const Text('Recheck Verification State'),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseMessage firebaseMessage = FirebaseMessage();

    firebaseMessage.firebaseOnMessage(context);

    return MaterialApp.router(
      title: 'Тавтай морилнуу',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.deepPurple,
            ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
