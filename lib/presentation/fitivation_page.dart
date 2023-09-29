import 'package:dio/src/response.dart';
import 'package:fitivation_app/components/header_homepage.dart';
import 'package:fitivation_app/components/item_component.dart';
import 'package:fitivation_app/components/my_bottom_navigator_bar.dart';
import 'package:fitivation_app/components/shared/square_tile.dart';
import 'package:fitivation_app/models/fitivation.model.dart';
import 'package:fitivation_app/models/user.model.dart';
import 'package:fitivation_app/presentation/detail_page.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:fitivation_app/services/fitivation.service.dart';
import 'package:fitivation_app/services/user.service.dart';
import 'package:fitivation_app/shared/store.service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class FitivationPage extends StatefulWidget {
  const FitivationPage({Key? key}) : super(key: key);

  @override
  State<FitivationPage> createState() => _FitivationState();
}

class _FitivationState extends State<FitivationPage> {
  late double lat;
  late double long;
  late List<Fitivation>? items = [];
  final UserService userService = UserService();
  final FitivationService fitivationService = FitivationService();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    // Fetch và lưu thông tin người dùng
    await fetchAndSaveUser(context);

    // Lấy vị trí địa lý
    final position = await _determinePosition();
    lat = position.latitude;
    long = position.longitude;

    // Lấy danh sách cơ sở gần đây và cập nhật trạng thái của widget
    final result =
        await fitivationService.getNearByFacilities(context, long, lat);
    setState(() {
      items = result;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> fetchAndSaveUser(BuildContext context) async {
    String? accessToken = await Store.getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken!);
    String username = decodedToken["sub"];

    User? userResponse = await userService.fetchUser(username);

    // ignore: use_build_context_synchronously
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.login(userResponse!.toJson());

    print("fetchAndSaveUser ${userProvider.user?.id}");
  }

  void onTapItemComponent(Fitivation item) {
    print("onTapItemComponent>> ${item.id}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailFitivationPage(
          facilityId: item.id!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SquareTile(imagePath: 'lib/assets/logo_app_gym.png'),
        title: Container(
          child: HeaderHomePage(),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
            itemCount: items?.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemComponent(
                  item: items![index],
                  onTap: () {
                    onTapItemComponent(items![index]);
                  });
            }),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        originState: 0,
      ),
    );
  }
}
