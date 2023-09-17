import 'package:fitivation_app/models/review.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Comment extends StatelessWidget {
  final Review review;

  Comment({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://e7.pngegg.com/pngimages/348/800/png-clipart-man-wearing-blue-shirt-illustration-computer-icons-avatar-user-login-avatar-blue-child.png"),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${review.author?.displayName}'),
                    RatingBar.builder(
                      itemSize: 20,
                      initialRating: review.rate ?? 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                      ignoreGestures: true,
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text("${review.comment}"),
            Container(
              height: 80, // Chiều cao của ảnh
              child: ListView.builder(
                scrollDirection:
                    Axis.horizontal, // Đặt scroll direction thành ngang
                itemCount: review.images?.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 5), // Padding giữa các ảnh
                    child: Image.network(
                      "${dotenv.env['BASE_URL']}/api/file/${review.images?[index].name}",
                      width: 80, // Kích thước chiều rộng của ảnh
                    ),
                  );
                },
              ),
            ),

            // Container(
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: 5,
            //     itemBuilder: (context, index) {
            //       return Image.network(
            //         "https://hdfitness.vn/wp-content/uploads/2022/02/A-50-scaled.jpg",
            //         width: 10,
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
