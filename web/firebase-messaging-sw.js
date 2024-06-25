import firebase from 'firebase/app';
import 'firebase/messaging';

firebase.initializeApp({
  apiKey: "your-api-key",
  authDomain: "PROJECT_NAME.firebaseapp.com",
  databaseURL: "https://PROJECT_NAME.firebaseio.com",
  projectId: "PROJECT_NAME",
  storageBucket: "PROJECT_NAME.appspot.com",
  messagingSenderId: "MESSAGING_SENDER_ID",
  appId: "APP_ID"
});

if (firebase.messaging.isSupported()) {
  const messaging = firebase.messaging();
}
