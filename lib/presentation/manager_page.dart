import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fitivation_app/components/my_bottom_navigator_bar.dart';
import 'package:fitivation_app/components/shared/square_tile.dart';
import 'package:fitivation_app/models/accountlink.model.dart';
import 'package:fitivation_app/presentation/cart_page.dart';
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

    if (await canLaunchUrlString(accountLinkURL)) {
      await launchUrlString(accountLinkURL);
    } else {
      throw "Không thể mở URL";
    }
  }

  Future<void> createAccountStripe() async {
    AccountLink? accountLink =
        await paymentService.createAccountConnectStripe();
    print(accountLink);
    redirectToAccountLink(accountLink!.url!);
  }

  void _initializeData() async {
    print("chua tao init");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("da tao init");

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
      ).show();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Gọi hàm sau khi initState hoàn thành
      _initializeData();
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
          ListTile(
            tileColor: Colors.amber,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blue[50],
              ),
              child: Icon(
                Icons.manage_accounts_rounded,
                color: Colors.black,
              ),
            ),
            title: Text('Quản lý phòng gym'),
            trailing: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black45,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_right_outlined,
                  size: 15,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.amber,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blue[50],
              ),
              child: Icon(
                IconData(0xebef, fontFamily: 'MaterialIcons'),
                color: Colors.black,
              ),
            ),
            title: Text('Thống kê'),
            trailing: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black45,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_right_outlined,
                  size: 15,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ]),
      ),
      bottomNavigationBar: MyBottomNavigationBar(originState: 3),
    );
  }
}
