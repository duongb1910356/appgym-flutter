import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 227, 227),
      body: Center(
        child: SpinKitThreeBounce(
          color: Color.fromRGBO(61, 61, 61, 50),
          size: 50.0,
        ),
      ),
    );
  }
}
