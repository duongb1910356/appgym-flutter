import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fitivation_app/helper/dialog_helper.dart';
import 'package:fitivation_app/models/user.model.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:fitivation_app/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String? _displayName;
  late String? _email;
  late String? _phone;
  late DateTime? selectedDate = null;
  TextEditingController _dateController = TextEditingController();

  final UserService userService = UserService();

  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2025),
        initialEntryMode: DatePickerEntryMode.input);
    if (picked != selectedDate)
      setState(() {
        selectedDate = picked!;
      });
  }

  Future<void> _submitForm(String userId) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> formData = {
        "displayName": _displayName,
        "phone": _phone,
        "birth": selectedDate?.toUtc().toIso8601String()
      };

      await userService.updateUser(userId, formData);
    }
  }

  Future<void> updateImageProfile() async {
    late UserProvider userProvider;
    userProvider = Provider.of<UserProvider>(context, listen: false);
    User? user =
        await userService.updateAvatarUser(userProvider.user!.id!, _image!);

    userProvider.updateUser(user!);
  }

  Future<void> updateProfile() async {
    try {
      late UserProvider userProvider;
      userProvider = Provider.of<UserProvider>(context, listen: false);
      print("chua goi update");
      if (_image != null) {
        print("co goi update image");
        await userService.updateAvatarUser(userProvider.user!.id!, _image!);
      }
      await _submitForm(userProvider.user!.id!);

      User? user = await userService.fetchUser(userProvider.user!.username!);
      userProvider.updateUser(user!);

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Đã cập nhật',
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      ErrorHandler.showErroDialog(context, description: 'Lỗi cập nhật');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          'Edit profile',
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
                        backgroundImage: _image == null
                            ? userProvider.user?.avatar == null
                                ? AssetImage('lib/assets/avt.png')
                                    as ImageProvider<Object>
                                : NetworkImage(userProvider.user?.avatar)
                            : FileImage(File(_image!.path))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.orange),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black45,
                          size: 20,
                        ),
                        onPressed: () {
                          print("da nhan");
                          _pickImage();
                        },
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 50,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: userProvider.user?.displayName,
                          onSaved: (value) {
                            _displayName = value!;
                          },
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
                          onSaved: (value) {
                            _phone = value!;
                          },
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
                          onTap: () {
                            _selectDate(context);
                          },
                          decoration: const InputDecoration(
                            label: Text('Ngày sinh'),
                            prefixIcon: Icon(Icons.calendar_month_outlined),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          controller: TextEditingController(
                            text: selectedDate != null
                                ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                                : userProvider.user?.birth != null
                                    ? DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(
                                            userProvider.user?.birth))
                                    : DateFormat('dd/MM/yyyy')
                                        .format(DateTime.now()),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          onPressed: updateProfile,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: Text('Lưu thông tin'),
                        ),
                      ],
                    ))
              ]),
        ),
      ),
    );
  }
}
