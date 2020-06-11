import 'package:flutter/material.dart';
import 'package:focus_security/splash_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  //HomeMainScreen()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            Spacer(),
            Image.asset('assets/images/logo.png'),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: username,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
                onPressed: () {
                  if (username.text == 'admin' && password.text == 'admin') {
                    Get.off(HomeMainScreen());
                  } else {
                    Get.snackbar(
                      'Error',
                      'Wrong credinitals',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline6,
                )),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
