import 'package:flutter/material.dart';
import 'package:focus_security/home_screen.dart';
import 'package:focus_security/license_screen.dart';
import 'package:focus_security/login.dart';
import 'package:focus_security/venue_tab.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Get.off(LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}

class HomeMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Focus Security"),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Employee",
                ),
              ),
              Tab(
                child: Text(
                  "License Expiry",
                ),
              ),
              Tab(
                child: Text(
                  "Venues",
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[HomeScreen(), LicenseScreen(), VenueScreen()],
        ),
      ),
    );
  }
}
