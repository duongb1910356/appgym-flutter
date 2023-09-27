import 'dart:ffi';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fitivation_app/components/cart_item.dart';
import 'package:fitivation_app/components/header_homepage.dart';
import 'package:fitivation_app/components/my_bottom_navigator_bar.dart';
import 'package:fitivation_app/components/shared/my_button.dart';
import 'package:fitivation_app/models/cart.model.dart';
import 'package:fitivation_app/presentation/loading_page.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:fitivation_app/services/cartservice.service.dart';
import 'package:fitivation_app/services/payment.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartState();
}

class _CartState extends State<CartPage> {
  final CartService cartService = CartService();
  final PaymentService paymentService = PaymentService();

  bool _ready = false;
  late Cart? cart;
  bool _isLoading = true;
  int total = 0;

  void deleteItemFromCart(BuildContext context, String itemId) async {
    Cart? cartTemp = await cartService.deleteItemfromCart(itemId);
    if (cartTemp != null) {
      setState(() {
        cart = cartTemp;
      });
      setState(() {
        total = cartTemp.totalPrice!;
      });
    }
  }

  void _initializeData() async {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    Cart? cartTemp = await cartService.getCartOfMe();
    setState(() {
      cart = cartTemp!;
      total = cart!.totalPrice!;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> initPaymentSheet(int amount, String currency) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String? customerId = userProvider.user?.customerIdStripe;
      final String? ephmeralKey =
          await paymentService.getEphemeralKey(customerId!);

      final data = await paymentService.createPaymentIntentService(
          amount, currency, customerId);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: ephmeralKey,
          customerId: customerId,
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

  void createPaymentIntent(Cart? cart) async {
    try {
      await initPaymentSheet(cart?.totalPrice ?? 0, 'vnd');
      await Stripe.instance.presentPaymentSheet();
      Cart? cartTemp = await cartService.deleteAllItemfromCart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment succesfully completed'),
        ),
      );

      deleteItemFromCart(context, cart!.items![0].id!);
      print("cart >>>>>>>> ${cart.items!.length}");
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: ${e}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => _isLoading
      ? LoadingPage()
      : Scaffold(
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
                  Container(
                      child: ConditionalBuilder(
                          condition: (cart == null || cart?.items?.length == 0),
                          builder: (context) =>
                              Center(child: Text('Chưa có dữ liệu')),
                          fallback: (context) => ListView.builder(
                                shrinkWrap: true,
                                itemCount: cart?.items?.length,
                                itemBuilder: (context, index) {
                                  return CartItem(
                                    item: cart!.items![index],
                                    deleteItemFromCart: () {
                                      deleteItemFromCart(
                                          context, cart!.items![index].id!);
                                    },
                                  );
                                },
                              ))),
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
                        '${MoneyFormatter(amount: (cart?.originPrice)!.toDouble()).output.withoutFractionDigits} đồng',
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
                        '${MoneyFormatter(amount: (cart!.totalPrice ?? 0).toDouble()).output.withoutFractionDigits} đồng',
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
                        createPaymentIntent(cart);
                      },
                      textButton: "THANH TOÁN")
                ],
              ),
            ),
          ),
          bottomNavigationBar: MyBottomNavigationBar(
            originState: 0,
          ),
        );
}
