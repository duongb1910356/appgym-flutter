import 'package:fitivation_app/components/cart_item.dart';
import 'package:fitivation_app/components/header_homepage.dart';
import 'package:fitivation_app/components/my_button.dart';
import 'package:fitivation_app/models/cart.model.dart';
import 'package:fitivation_app/services/cartservice.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:money_formatter/money_formatter.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartState();
}

class _CartState extends State<CartPage> {
  final CartService cartService = CartService();
  bool _ready = false;
  Cart? cart;

  void _initializeData() async {
    Cart? cartTemp = await cartService.getCartOfMe();
    setState(() {
      cart = cartTemp;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      // final data = await _createTestPaymentSheet();

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: 'paymentIntent',
          // Customer keys
          customerEphemeralKeySecret: 'ephemeralKey',
          customerId: 'customer',
          // Extra options
          style: ThemeMode.dark,
        ),
      );
      setState(() {
        _ready = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart?.items?.length,
                  itemBuilder: (context, index) {
                    return CartItem(item: cart!.items![index]);
                  },
                ),
                Divider(
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tổng',
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    Text(
                      '${MoneyFormatter(amount: (cart?.originPrice ?? 0).toDouble()).output.withoutFractionDigits}',
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Giảm',
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    Text(
                      '${MoneyFormatter(amount: ((-(cart?.totalPrice ?? 0).toDouble() + (cart?.originPrice ?? 0).toDouble()).toDouble())).output.withoutFractionDigits}',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Color(0xfff81000)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Thanh toán',
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                    Text(
                      '${MoneyFormatter(amount: (cart?.totalPrice ?? 0).toDouble()).output.withoutFractionDigits} đồng',
                      style: TextStyle(
                          fontSize: 21,
                          fontFamily: 'Poppins',
                          color: Color(0xba6726f2),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                MyButton(
                    onTap: () async {
                      print("da goi UI STRIPE");
                      await Stripe.instance.presentPaymentSheet();
                    },
                    textButton: "THANH TOÁN")
              ],
            ),
          ),
        ));
  }
}
