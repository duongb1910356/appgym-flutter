import 'package:fitivation_app/presentation/fitivation_page.dart';
import 'package:fitivation_app/presentation/login_page.dart';
import 'package:fitivation_app/services/authservice.service.dart';
import 'package:fitivation_app/shared/store.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3))
        .then((value) => checkTokenAndNavigate(context));
  }

  Future<void> checkTokenAndNavigate(BuildContext context) async {
    final token = await Store.getToken();

    if (token != null && token.isNotEmpty) {
      bool hasExpired = JwtDecoder.isExpired(token);
      if (hasExpired == false) {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (ctx) => FitivationPage()),
          (route) => false,
        );
      } else {
        await Store.removeKey('accessToken');
        String? refreshToken = await Store.getRefreshToken();
        bool getAccessToken = await authService
            .refreshAccesssTokenFromRefreshToken(refreshToken!);

        if (getAccessToken == true) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (ctx) => FitivationPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (ctx) => LoginPage()),
          );
        }
      }
    } else {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (ctx) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("lib/assets/bee-gym.png"),
              width: 300,
            ),
            SizedBox(
              height: 50,
            ),
            SpinKitThreeBounce(
              color: Color.fromRGBO(61, 61, 61, 50),
              size: 50.0,
            )
          ],
        ),
      ),
    );
  }
}
