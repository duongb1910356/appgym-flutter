import 'dart:io';

import 'package:fitivation_app/models/user.model.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:fitivation_app/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: Text(
          'Thông tin chi tiết',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userProvider.user?.avatar == null
                            ? AssetImage('lib/assets/avt.png')
                                as ImageProvider<Object>
                            : NetworkImage(userProvider.user?.avatar)),
                  ),
                ]),
                const SizedBox(
                  height: 50,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      initialValue: userProvider.user?.displayName,
                      readOnly: true,
                      decoration: const InputDecoration(
                        label: Text('Tên hiển thị'),
                        prefixIcon: Icon(Icons.account_circle_outlined),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: userProvider.user?.phone,
                      readOnly: true,
                      decoration: const InputDecoration(
                        label: Text('Số điện thoại'),
                        prefixIcon: Icon(Icons.phone_android_outlined),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        label: Text('Ngày sinh'),
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                      controller: TextEditingController(
                        text: userProvider.user?.birth == null
                            ? DateFormat('dd/MM/yyyy').format(DateTime.now())
                            : DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(userProvider.user?.birth)),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ))
              ]),
        ),
      ),
    );
  }
}
