import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fitivation_app/components/comment.dart';
import 'package:fitivation_app/components/header_homepage.dart';
import 'package:fitivation_app/components/my_bottom_navigator_bar.dart';
import 'package:fitivation_app/components/shared/my_button.dart';
import 'package:fitivation_app/components/review_summary.dart';
import 'package:fitivation_app/components/shared/square_tile.dart';
import 'package:fitivation_app/models/fitivation.model.dart';
import 'package:fitivation_app/models/package.model.dart';
import 'package:fitivation_app/models/review.model.dart';
import 'package:fitivation_app/models/schedule.model.dart';
import 'package:fitivation_app/presentation/detail_package.dart';
import 'package:fitivation_app/presentation/loading_page.dart';
import 'package:fitivation_app/services/fitivation.service.dart';
import 'package:fitivation_app/services/packagefacility.service.dart';
import 'package:fitivation_app/services/review.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class DetailFitivationPage extends StatefulWidget {
  final String facilityId;

  const DetailFitivationPage({Key? key, required this.facilityId})
      : super(key: key);

  @override
  State<DetailFitivationPage> createState() =>
      _DetailFitivationState(facilityId: facilityId);
}

class _DetailFitivationState extends State<DetailFitivationPage> {
  final String facilityId;
  late Fitivation? facility;
  late List<PackageFacility>? packages;
  late Schedule? schedule;
  late dynamic reviewSummary;
  late List<Review>? reviews;
  bool _isLoading = true;

  final FitivationService fitivationService = FitivationService();
  final PackageService packageService = PackageService();
  final ReviewService reviewService = ReviewService();

  late Set<Marker> marker = {
    new Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(10.0497, 105.778274),
      infoWindow: InfoWindow(title: 'Marker Title', snippet: 'Marker Snippet'),
    ),
  };
  LatLng? _currentPosition = const LatLng(0, 0);
  // GoogleMapController? mapController;
  Completer<GoogleMapController> mapController = Completer();

  _DetailFitivationState({required this.facilityId});

  void _initializeData() async {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    Fitivation? temp = await fitivationService.getFitivationById(facilityId);
    List<PackageFacility>? tempPackages =
        await packageService.getPackageOfFacilityId(facilityId);
    Schedule? tempSchedule =
        await fitivationService.getScheduleByFacilityId(facilityId);

    dynamic reviewSummaryTemp =
        await reviewService.getReviewSummary(facilityId);

    List<Review>? reviewsTemp =
        await reviewService.getReviewByFacilityId(facilityId);

    setState(() {
      facility = temp;
    });
    setState(() {
      packages = tempPackages;
    });
    setState(() {
      schedule = tempSchedule;
    });
    setState(() {
      reviewSummary = reviewSummaryTemp;
    });
    setState(() {
      reviews = reviewsTemp;
    });
    setState(() {
      marker = {
        Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(facility?.location['coordinates'][1],
              facility?.location['coordinates'][0]),
          infoWindow: InfoWindow(title: '${facility?.name}'),
        ),
      };
    });

    await _determinePosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  Future<void> moveCamera() async {
    final GoogleMapController controller = await mapController.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _currentPosition!,
      zoom: 15,
    )));
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    await moveCamera();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
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
            child: Column(
              children: [
                ConditionalBuilder(
                    condition: facility?.images?.length != null,
                    builder: (context) => CarouselSlider.builder(
                          itemCount: facility?.images?.length,
                          itemBuilder: (context, index, realIndex) {
                            final imageUrl =
                                "${dotenv.env['BASE_URL']}/api/file/${facility?.images?[index]["name"]}";
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          },
                          options: CarouselOptions(
                              viewportFraction: 1.1,
                              height: 345,
                              enableInfiniteScroll: true,
                              padEnds: false),
                        ),
                    fallback: (context) => Text("Not image")),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${facility?.name}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: const Color(0xff000000)),
                      ),
                      Text(
                        "${facility?.address?.street}, ${facility?.address?.ward} ${facility?.address?.district} ${facility?.address?.province}",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            height: 1.5),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "${facility?.avagerstar == 0 ? "chưa có điểm đánh giá" : "${facility?.avagerstar} điểm đánh"}",
                          ),
                        ],
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                        padding: EdgeInsets.fromLTRB(10.26, 7, 14.11, 7),
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0x19000000)),
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x16000000),
                              offset: Offset(2, 2),
                              blurRadius: 1.5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPackage(packages: packages),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 39.74, 0),
                                    constraints: BoxConstraints(
                                      maxWidth: 159,
                                    ),
                                    child: Text('Gói định kỳ chỉ'),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                                    child: Text(
                                      '${packages?[0].basePrice} đồng/tháng',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          color: const Color(0xff000000)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Xem thêm >',
                              style: TextStyle(
                                decoration: TextDecoration
                                    .underline, // Gạch chân văn bản
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 230, 232, 237),
                        ),
                        child: Text(
                          "${facility?.describe}",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              height: 1.5),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (schedule != null)
                            Text(
                              "Lịch hoạt động",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          if (schedule != null &&
                              schedule?.openTimes?.length != 0)
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: schedule != null
                                    ? (schedule?.openTimes?.length ?? 0)
                                    : 0,
                                itemBuilder: (BuildContext context, index) {
                                  final openTime = schedule!.openTimes![index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 80),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${openTime.dayOfWeek ?? 'Không có dữ liệu'}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge,
                                        ),
                                        Text(
                                          "${openTime.shiftTimes?[0].startTime} - ${openTime.shiftTimes?[0].endTime}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight:
                                                      FontWeight.normal),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 230, 232, 237),
                          ),
                          child: ReviewSummary(
                              facility: facility!,
                              reviewSummary: reviewSummary),
                        ),
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      Container(
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          markers: marker,
                          myLocationEnabled: true,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                              target: _currentPosition!, zoom: 11.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: MyButton(
                            onTap: () {
                              MapsLauncher.launchCoordinates(
                                  10.0497, 105.778274);
                            },
                            textButton: "Mở ứng dụng Google Maps"),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Column(
                        //binh luan
                        children: [
                          Comment(
                            review: reviews![1],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: MyBottomNavigationBar(
            originState: 0,
          ),
        );
}
