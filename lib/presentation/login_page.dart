import 'package:fitivation_app/components/shared/my_button.dart';
import 'package:fitivation_app/components/shared/my_textfield.dart';
import 'package:fitivation_app/components/shared/square_tile.dart';
import 'package:fitivation_app/helper/dialog_helper.dart';
import 'package:fitivation_app/presentation/fitivation_page.dart';
import 'package:fitivation_app/presentation/loading_page.dart';
import 'package:fitivation_app/presentation/register_page.dart';
import 'package:fitivation_app/services/authservice.service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final double fem = 1.0;
  bool _isLoading = false;
  final AuthService authService = AuthService();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ErrorHandler.showErroDialog(context,
          description: 'Tên đăng nhập và mật khẩu không được để trống');
    }

    setState(() {
      _isLoading = true;
    });

    final user = await authService.signIn(username, password, context);

    if (user != null) {
      navigateToFitivationPage(context);
    } else {
      setState(() {
        _isLoading = false;
      });
      ErrorHandler.showErroDialog(context, description: 'Đăng nhập thất bại');
      print("Đăng nhập thất bại");
    }
  }

  void navigateToRegisterPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );
  }

  void navigateToFitivationPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FitivationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _isLoading
      ? LoadingPage()
      : Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[300],
          body: SafeArea(
            child: Center(
              child: Column(children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SquareTile(imagePath: 'lib/assets/logo_app_gym.png'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('BEEGYM',
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 1.65,
                            letterSpacing: 3.2 * fem,
                            color: const Color(0xe226a8f2))),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                    controller: usernameController,
                    hintText: 'Email',
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        navigateToRegisterPage(
                            context); // Gọi hàm để điều hướng đến trang đăng ký
                      },
                      child: const Text('Chưa có tài khoản?',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.underline,
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                MyButton(
                  onTap: () {
                    signIn(context);
                  },
                  textButton: 'ĐĂNG NHẬP',
                ),
              ]),
            ),
          ),
        );
}
