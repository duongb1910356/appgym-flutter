import 'package:fitivation_app/components/item_component.dart';
import 'package:fitivation_app/components/my_bottom_navigator_bar.dart';
import 'package:fitivation_app/components/shared/square_tile.dart';
import 'package:fitivation_app/models/fitivation.model.dart';
import 'package:fitivation_app/presentation/cart_page.dart';
import 'package:fitivation_app/presentation/manager/ModifieFacilityPage.dart';
import 'package:fitivation_app/provider/model/user.provider.dart';
import 'package:fitivation_app/services/fitivation.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagerFacility extends StatefulWidget {
  @override
  State<ManagerFacility> createState() => _ManagerFacilityState();
}

class _ManagerFacilityState extends State<ManagerFacility> {
  final FitivationService fitivationService = FitivationService();
  List<Fitivation>? faclities;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<List<Fitivation>?> _initializeData() async {
    print("chuan bi goi manger fitivation day");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Fitivation>? temp =
        await fitivationService.getFacilitiesByOwnerId(userProvider.user!.id!);
    return temp;
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
      body: Container(
        padding: const EdgeInsets.all(15),
        // child: ListView.builder(
        //     itemCount: faclities?.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return ItemComponent(item: faclities![index], onTap: () {});
        //     }),
        child: FutureBuilder(
          future: _initializeData(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Fitivation>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Hiển thị nội dung khi đợi Future hoàn thành
              return CircularProgressIndicator(); // Ví dụ: Hiển thị vòng tròn tiến trình
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                // Xử lý trường hợp dữ liệu trống
                return Center(child: Text('Không có dữ liệu.'));
              } else {
                // Trả về Widget chứa dữ liệu sau khi Future hoàn thành
                // Ví dụ: Trả về ListView chứa dữ liệu
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Tạo Widget cho mỗi phần tử dữ liệu
                    return ItemComponent(
                        item: snapshot.data![index], onTap: () {});
                  },
                );
              }
            } else {
              // Xử lý lỗi
              return Text('Đã xảy ra lỗi: ${snapshot.error}');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModifieFacilityPage(),
            ),
          );
        },
        child: Icon(Icons.add), // Biểu tượng của nút FAB
      ),
      bottomNavigationBar: MyBottomNavigationBar(originState: 3),
    );
  }
}
