import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DialogHelper {
  static Future showErroDialog(BuildContext context,
      {String tittle = 'Lỗi',
      String description = 'Có vẻ như lỗi nào đó đã xảy ra'}) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.error, // Kiểu hộp thoại lỗi
      title: tittle,
      desc: description,
      btnOkOnPress: () {},
    ).show();
  }
}

class ErrorHandler {
  static void showErroDialog(BuildContext context,
      {String title = 'Lỗi',
      String description = 'Có vẻ như lỗi nào đó đã xảy ra'}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    ).show();
    throw Exception();
  }

  static void handleHttpError(BuildContext context, dynamic error) {
    if (error is ClientException) {
      showErroDialog(context, description: 'Không thể kết nối đến máy chủ.');
    } else if (error is HttpException) {
      showErroDialog(context,
          title: 'Lỗi yêu cầu HTTP', description: error.message);
    } else {
      showErroDialog(context,
          title: 'Lỗi', description: 'Có lỗi xảy ra, vui lòng kiểm tra lại');
    }
  }
}
