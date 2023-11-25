import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;
import 'package:dvhcvn/dvhcvn.dart';
import 'package:fitivation_app/components/shared/my_droplist.dart';
import 'package:fitivation_app/components/shared/my_textfield.dart';
import 'package:fitivation_app/components/shared/square_tile.dart';
import 'package:fitivation_app/models/dvhc.model.dart';
import 'package:fitivation_app/models/fitivation.model.dart';
import 'package:fitivation_app/models/package.model.dart';
import 'package:fitivation_app/presentation/cart_page.dart';
import 'package:fitivation_app/provider/model/address.provider.dart';
import 'package:fitivation_app/services/fitivation.service.dart';
import 'package:fitivation_app/services/packagefacility.service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateFacilityPage extends StatefulWidget {
  const CreateFacilityPage({super.key});

  @override
  State<CreateFacilityPage> createState() => _CreateFacilityPageState();
}

class _CreateFacilityPageState extends State<CreateFacilityPage> {
  AddressProvider? addressProvider;
  int _activeStepIndex = 0;
  final FitivationService fitivationService = FitivationService();
  final PackageService packageService = PackageService();
  final GlobalKey<FormState> _formKeyCreateFacility = GlobalKey<FormState>();
  late String? name;
  late String? phone;
  late String? email;
  late String? describe;

  late String? province = addressProvider!.level1.name;
  late String? district = addressProvider!.level2.name;
  late String? ward = addressProvider!.level3.name;

  late String valueProvinceChoose = level1s[0].name;
  List<String> listItemProvince = level1s.map((e) => e.name).toList();

  late String valueDistrictChoose = "Quận Ba Đình";
  List<String> listItemDistrict =
      dvhcvn.findLevel1ById("01")!.children.map((e) => e.name).toList();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  final packageNameController = TextEditingController();
  final basePriceController = TextEditingController();
  final discountController = TextEditingController();
  final streetController = TextEditingController();

  Completer<GoogleMapController> mapController = Completer();
  late Set<Marker> marker = {};
  LatLng? _currentPosition = const LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  Future<void> _submitCreateFacility() async {
    if (_formKeyCreateFacility.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      _formKeyCreateFacility.currentState!.save();

      Map<String, dynamic> formData = {
        "name": name,
        "phone": phone,
        "describe": describe,
        "address": {
          "province": addressProvider!.level1.name,
          "district": addressProvider!.level2.name,
          "ward": addressProvider!.level3.name,
          "street": streetController.text
        },
        "location": {
          "coordinates": [
            marker.toList()[0].position.longitude,
            marker.toList()[0].position.latitude
          ]
        }
      };

      Fitivation? fitivation = await fitivationService.createFacility(formData);
      dynamic result = await fitivationService.uploadImagesFacility(
          fitivation!.id.toString(), imageFileList);

      // List<PackageFacility>? packagesFacility =
      await packageService.createPackage(
          packageNameController.text,
          int.tryParse(basePriceController.text)!,
          discountController.text,
          fitivation.id.toString());

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    addressProvider = Provider.of<AddressProvider>(context, listen: false);
  }

  List<Step> stepList() => [
        Step(
            state:
                _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 0,
            title: Text("Thông tin"),
            content: Container(
              // padding: EdgeInsets.all(),
              child: Form(
                  key: _formKeyCreateFacility,
                  child: Column(
                    children: [
                      TextFormField(
                        // initialValue: userProvider.user?.displayName,
                        onSaved: (value) {
                          name = value!;
                        },
                        decoration: const InputDecoration(
                          label: Text('Tên phòng tập'),
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
                        // initialValue: userProvider.user?.phone,
                        onSaved: (value) {
                          phone = value!;
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
                        // initialValue: userProvider.user?.phone,
                        onSaved: (value) {
                          describe = value!;
                        },
                        decoration: const InputDecoration(
                          label: Text('Mô tả'),
                          prefixIcon: Icon(Icons.description_rounded),
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
                        // initialValue: userProvider.user?.phone,
                        onSaved: (value) {
                          email = value!;
                        },
                        decoration: const InputDecoration(
                          label: Text('Email'),
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  )),
            )),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text("Địa chỉ"),
            content: Column(
              children: [
                MyTextField(
                    controller: streetController,
                    hintText: 'Tên đường',
                    obscureText: false),
                MyDropList(
                    valueChoose: addressProvider!.level1.id,
                    listItem: level1s.toList(),
                    onItemSelected: (Object e) {
                      addressProvider?.level1 =
                          dvhcvn.findLevel1ById(e.toString())!;
                      province = addressProvider!.level1.name;
                      print("province $province");
                    }),
                MyDropList(
                    valueChoose: addressProvider!.level2.id,
                    listItem: addressProvider!.level1.children,
                    onItemSelected: (Object e) {
                      addressProvider?.level2 =
                          addressProvider!.level1.findLevel2ById(e.toString())!;
                      district = addressProvider?.level2.name;
                      print("district $district");
                    }),
                MyDropList(
                    valueChoose: addressProvider!.level3.id,
                    listItem: addressProvider!.level2.children,
                    onItemSelected: (Object e) {
                      addressProvider?.level3 =
                          addressProvider!.level2.findLevel3ById(e.toString())!;
                      ward = addressProvider?.level3.name;
                      print("ward $ward");
                    }),
              ],
            )),
        Step(
            state:
                _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text("Hình ảnh"),
            content: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      selectImages();
                    },
                    child: Text('Nhấn chọn ảnh')),
                SizedBox(
                  height: 30,
                ),
                GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8),
                    itemCount: imageFileList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Image.file(
                          File(imageFileList[index].path),
                          fit: BoxFit.cover,
                        ),
                      );
                    })
              ],
            )),
        Step(
            state:
                _activeStepIndex <= 3 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 3,
            title: const Text("Gói tập"),
            content: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      MyTextField(
                          controller: packageNameController,
                          hintText: 'Tên gói',
                          obscureText: false),
                      MyTextField(
                          controller: basePriceController,
                          hintText: 'Giá cơ bản',
                          obscureText: false),
                      MyTextField(
                          controller: discountController,
                          hintText: 'Chiết khấu theo tháng',
                          obscureText: false),
                      Text(
                        'Chiết khấu nhập theo tháng có dạng: <tháng> - <chiết khấu>, ví dụ 1 - 0.1 ngăn cách các cặp bằng dấu phẩy',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                )
              ],
            )),
        Step(
          state: _activeStepIndex <= 4 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 4,
          title: const Text("Toạ độ thực"),
          content: Container(
            height: 450,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              markers: marker,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: _currentPosition!, zoom: 11.0),
              onTap: (LatLng latLng) {
                print("da tap");
                print("toa do chon ${latLng.latitude} - ${latLng.longitude}");
                Marker newMarker = Marker(
                    markerId: MarkerId("selectd_location"), position: latLng);
                marker.add(newMarker);
                setState(() {});
              },
            ),
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: _activeStepIndex >= 5,
          title: const Text("Hoàn thành"),
          content: Container(
              // child: ElevatedButton(onPressed: () {}, child: Text('Tạo')),
              ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _activeStepIndex,
              steps: stepList(),
              onStepContinue: () async {
                if (_activeStepIndex == (stepList().length - 1)) {
                  await _submitCreateFacility();
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    title: 'Đã tạo phòng tập',
                    btnOkOnPress: () {},
                  ).show();
                }
                if (_activeStepIndex < (stepList().length - 1)) {
                  _activeStepIndex += 1;
                }
                setState(() {});
              },
              onStepCancel: () {
                if (_activeStepIndex == 0) {
                  return;
                }
                _activeStepIndex -= 1;
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }
}
