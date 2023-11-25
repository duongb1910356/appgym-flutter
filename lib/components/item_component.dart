import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fitivation_app/models/fitivation.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ItemComponent extends StatelessWidget {
  final Fitivation item; // Định nghĩa tham số item
  final Function() onTap;
  final Function() onLongPress;

  ItemComponent({
    required this.item,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 282,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0x19000000)),
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x16000000),
              offset: Offset(3, 4),
              blurRadius: 1.5,
            ),
          ],
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: ConditionalBuilder(
                    condition: item.images?.length != 0,
                    builder: (context) => Image.network(
                      "${dotenv.env['BASE_URL']}/api/file/${item.images?[0]["name"]}",
                      fit: BoxFit.cover,
                    ),
                    fallback: (context) => Image.network(
                      "https://i.pinimg.com/736x/ae/8a/c2/ae8ac2fa217d23aadcc913989fcc34a2---page-empty-page.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name!,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: const Color(0xff000000)),
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
                          Text("${item.avagerstar}"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text("${item.distance!.toStringAsFixed(2)} km"),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_city_outlined),
                      Expanded(
                        child: Text(
                          "${item.address?.street}, ${item.address?.ward} ${item.address?.district} ${item.address?.province}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
