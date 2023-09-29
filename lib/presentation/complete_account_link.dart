import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class CompleteAccountLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            "lib/assets/gift.gif",
            height: 250,
            width: 250,
          ),
          Text(
            'Đã đăng ký thành công tài khoản bán hàng',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text('Tắt và khỏi động lại để bắt đầu bán hàng!'),
        ]),
      )),
    );
  }
}
