import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fitivation_app/components/my_button.dart';
import 'package:fitivation_app/components/my_droplist.dart';
import 'package:fitivation_app/components/my_textfield.dart';
import 'package:fitivation_app/components/square_tile.dart';
import 'package:fitivation_app/helper/dialog_helper.dart';
import 'package:fitivation_app/presentation/fitivation_page.dart';
import 'package:fitivation_app/presentation/loading_page.dart';
import 'package:fitivation_app/presentation/login_page.dart';
import 'package:fitivation_app/services/authservice.service.dart';
import 'package:fitivation_app/services/payment.service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final double fem = 1.0;

  final AuthService authService = AuthService();

  bool _isLoading = false;

  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final rePasswordController = TextEditingController();

  final displayNameController = TextEditingController();

  late String selectedRole = 'ROLE_USER';

  void handleItemSelected(String newValue) {
    selectedRole = newValue;
  }

  void signUp(BuildContext context) async {
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String rePassword = rePasswordController.text;
    final String displayName = displayNameController.text;

    if (rePassword != password) {
      // AwesomeDialog(
      //   context: context,
      //   dialogType: DialogType.error, // Kiểu hộp thoại lỗi
      //   title: 'Lỗi',
      //   desc: 'Mật khẩu nhập lại không khớp.',
      //   btnOkOnPress: () {},
      // ).show();
      ErrorHandler.showErroDialog(context,
          description: "Mật khẩu nhập lại không khớp");
    }

    setState(() {
      _isLoading = true;
    });

    final user = await authService.signUp(
        context, username, email, password, displayName, selectedRole);
    if (user != null) {
      navigateToFitivationPage(context);
    } else {
      setState(() {
        _isLoading = false;
      });
      ErrorHandler.showErroDialog(context, description: 'Đăng ký thất bại');
    }
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
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
          body: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 40),
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
                    hintText: 'Nhập username',
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: displayNameController,
                    hintText: 'Nhập tên hiển thị',
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: emailController,
                    hintText: 'Nhập email',
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: passwordController,
                    hintText: 'Nhập password',
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: rePasswordController,
                    hintText: 'Nhập lại password',
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                MyDropList(onItemSelected: handleItemSelected),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        navigateToLoginPage(context);
                      },
                      child: const Text('Đã có tài khoản?',
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
                    signUp(context);
                  },
                  textButton: 'ĐĂNG KÝ',
                ),
                const SizedBox(
                  height: 20,
                )
              ]),
            ),
          ),
        );
}
