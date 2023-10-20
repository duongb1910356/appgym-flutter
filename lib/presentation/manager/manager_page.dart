import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fitivation_app/components/manager/managermenu.dart';
import 'package:fitivation_app/components/my_bottom_navigator_bar.dart';
import 'package:fitivation_app/components/shared/square_tile.dart';
import 'package:fitivation_app/models/accountlink.model.dart';
import 'package:fitivation_app/presentation/cart_page.dart';
import 'package:fitivation_app/presentation/complete_account_link.dart';
import 'package:fitivation_app/presentation/manager/detailmanagerfacilitypage.dart';
import 'package:fitivation_app/presentation/manager/satisfiedpage.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:fitivation_app/services/payment.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ManagerFacilityPage extends StatefulWidget {
  @override
  State<ManagerFacilityPage> createState() => _ManagerFacilityPageState();
}

class _ManagerFacilityPageState extends State<ManagerFacilityPage> {
  final PaymentService paymentService = PaymentService();
  int _currentIndex = 0;

  void redirectToAccountLink(String url) async {
    String accountLinkURL = url; // Đặt URL của tài khoản của bạn ở đây
    print("chuan bi mo url $accountLinkURL");

    if (await canLaunchUrlString(accountLinkURL)) {
      await launchUrlString(accountLinkURL);
    } else {
      print("khong the mo url $accountLinkURL");

      throw "Không thể mở URL";
    }
  }

  Future<void> createAccountStripe() async {
    AccountLink? accountLink =
        await paymentService.createAccountConnectStripe();
    print("accountLink $accountLink");
    redirectToAccountLink(accountLink!.url!);
  }

  void _initializeData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user?.accountIdStripe == null) {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.question, // Kiểu hộp thoại lỗi
        title: 'Bạn chưa đăng ký tài khoản bán hàng?',
        desc: 'Nhấn ok tạo tài khoản bán hàng với Stripe',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          createAccountStripe();
        },
        dismissOnBackKeyPress: false,
      ).show();
    }
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Gọi hàm sau khi initState hoàn thành
      _initializeData();
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   initDynamicLinks();
  // }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print('Met moi');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CompleteAccountLink(),
        ),
      );
    }).onError((error) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CompleteAccountLink(),
        ),
      );
      print(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SquareTile(imagePath: 'lib/assets/logo_app_gym.png'),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BEEGYM",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ),
                  );
                },
                child: const Icon(
                  IconData(0xe57f, fontFamily: 'MaterialIcons'),
                  size: 25,
                  color: Color.fromARGB(255, 88, 63, 63),
                  weight: 0.5,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Column(children: [
          ManagerMenuComponent(
            title: "Quản lý phòng gym",
            icon: Icons.manage_accounts_rounded,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DetailManagerFacilityPage(),
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          ManagerMenuComponent(
              title: 'Thống kê',
              icon: IconData(0xebef, fontFamily: 'MaterialIcons'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SatisfiedPage(),
                  ),
                );
              }),
          SizedBox(
            height: 10,
          ),
        ]),
      ),
      bottomNavigationBar: MyBottomNavigationBar(originState: 3),
    );
  }
}
