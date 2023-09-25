import 'package:fitivation_app/components/header_homepage.dart';
import 'package:fitivation_app/components/my_bottom_navigator_bar.dart';
import 'package:fitivation_app/components/my_button.dart';
import 'package:fitivation_app/helper/dialog_helper.dart';
import 'package:fitivation_app/models/package.model.dart';
import 'package:fitivation_app/presentation/cart_page.dart';
import 'package:fitivation_app/services/cartservice.service.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:money_formatter/money_formatter.dart';

class DetailPackage extends StatelessWidget {
  late final List<PackageFacility>? packages;
  final MoneyFormatter fmf = MoneyFormatter(amount: 12345678);
  final CartService cartService = CartService();

  Future<bool> addToCart(String packageId) async {
    bool checkAddCart = await cartService.addPackageToCart(packageId);
    print("bool checkAddCart $checkAddCart");
    return checkAddCart;
  }

  DetailPackage({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          child: HeaderHomePage(),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: packages?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0x19000000)),
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3f000000),
                            offset: Offset(0, 2),
                            blurRadius: 1,
                          )
                        ]),
                    child: GestureDetector(
                      onTap: () async {
                        bool check =
                            await addToCart(packages![index].id.toString());
                        if (check) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartPage(),
                            ),
                          );
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 59,
                            height: 23,
                            decoration: BoxDecoration(
                              color: Color(0xba6726f2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                              "${packages?[index].type} tháng",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            )),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${(packages![index].basePrice ?? 0) * ((1 - (packages![index].discount ?? 0)))} / tháng',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff000000)),
                              ),
                              Text(
                                'Giảm ${packages![index].discount! * 100} %',
                              ),
                              Text(
                                'Tổng ${MoneyFormatter(amount: ((packages![index].basePrice ?? 0) * (1 - (packages![index].discount ?? 0)) * (packages![index].type ?? 0)).toDouble()).output.withoutFractionDigits} đồng',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xff000000)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // MyButton(onTap: () {}, textButton: "Thêm vào giỏ")
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        originState: 0,
      ),
    );
  }
}
