import 'dart:io';

import 'package:fitivation_app/components/my_bottom_navigator_bar.dart';
import 'package:fitivation_app/components/my_menu_profile.dart';
import 'package:fitivation_app/components/shared/switch_button.dart';
import 'package:fitivation_app/presentation/history_bill.dart';
import 'package:fitivation_app/presentation/login_page.dart';
import 'package:fitivation_app/presentation/profile_detail_page.dart';
import 'package:fitivation_app/presentation/update_profile_page.dart';
import 'package:fitivation_app/provider/model/config.provider.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:fitivation_app/shared/store.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late UserProvider userProvider;
    userProvider = Provider.of<UserProvider>(context, listen: true);

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
          'Profile',
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
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: userProvider.user?.avatar != null
                          ? NetworkImage("${userProvider.user?.avatar}")
                          : const AssetImage('lib/assets/avt.png')
                              as ImageProvider<Object>),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${userProvider.user?.displayName}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfileScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: Text('Sửa thông tin'),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 50,
                ),
                ProfileMenuWidget(
                  title: 'Thông tin',
                  icon: Icons.info_outline,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileDetailScreen()));
                  },
                ),
                ProfileMenuWidget(
                  title: 'Lịch sử thanh toán',
                  icon: Icons.history_edu_outlined,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryBillPage()));
                  },
                ),
                ProfileMenuWidget(
                  title: 'Đăng xuất',
                  icon: Icons.logout_outlined,
                  onPress: () {
                    Store.clear();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blue[50],
                    ),
                    child: Icon(
                      Icons.manage_history_rounded,
                      color: Colors.black,
                    ),
                  ),
                  title: Text('Trở thành chủ quản lý'),
                  trailing: SwitchExample(
                    taskSwitch: () {
                      PermissionProvider permissionProvider =
                          Provider.of<PermissionProvider>(context,
                              listen: false);

                      permissionProvider.togglePermission();
                    },
                  ),
                ),
              ]),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        originState: 2,
      ),
    );
  }
}
