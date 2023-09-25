import 'package:fitivation_app/models/cart.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:money_formatter/money_formatter.dart';

class CartItem extends StatelessWidget {
  final Item item;
  Function()? deleteItemFromCart;

  CartItem({required this.item, required this.deleteItemFromCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 6, 10, 5),
      width: double.infinity,
      // height: 104,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            width: 91,
            height: 91,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                "${dotenv.env['BASE_URL']}/api/file/${item.packageFacility?.facility?.images?[0]['name']}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 6, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                  child: Text(
                    '${item.packageFacility?.facility?.name}',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
                  child: Text(
                    '${item.packageFacility!.facility?.address?.street} ${item.packageFacility!.facility?.address?.ward} ${item.packageFacility!.facility?.address?.district} ${item.packageFacility!.facility?.address?.province}',
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Text(
                  '${MoneyFormatter(amount: ((item.packageFacility!.basePrice ?? 0) * (item.packageFacility!.type ?? 0)).toDouble()).output.withoutFractionDigits}',
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
                Row(
                  children: [
                    Text(
                        '${MoneyFormatter(amount: ((item.packageFacility!.basePrice ?? 0) * (item.packageFacility!.type ?? 0) * (1 - (item.packageFacility?.discount ?? 0))).toDouble()).output.withoutFractionDigits} đồng',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: Color(0xba6726f2))),
                    SizedBox(
                      width: 10,
                    ),
                    Text('(${item.packageFacility?.type} tháng)'),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: deleteItemFromCart,
            child: Container(
              width: 12,
              height: 12,
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
