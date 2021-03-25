import 'package:face_mask_detector/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterSeconds: Home(),
      seconds: 2,
      title: Text(
        'Face Mask Detector',
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
      image: Image.asset('assets/splash.png'),
      photoSize: 150,
      useLoader: false,

    );
  }
}
