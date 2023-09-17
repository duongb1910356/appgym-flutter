import 'package:fitivation_app/models/fitivation.model.dart';
import 'package:flutter/material.dart';

class ReviewSummary extends StatelessWidget {
  final dynamic reviewSummary;
  final Fitivation facility;

  const ReviewSummary(
      {super.key, required this.facility, required this.reviewSummary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              "${facility.avagerstar} sao (${reviewSummary?[1]['total']} lượt đánh giá)"),
          Column(
            children: [
              Text(
                  "${reviewSummary?[4]['rate']} sao - (${reviewSummary?[4]['percent']}%)"),
              Text(
                  "${reviewSummary[3]['rate']} sao - (${reviewSummary?[3]['percent']}%)"),
              Text(
                  "${reviewSummary[2]['rate']} sao - (${reviewSummary?[2]['percent']}%)"),
              Text(
                  "${reviewSummary[1]['rate']} sao - (${reviewSummary?[1]['percent']}%)"),
              Text(
                  "${reviewSummary[0]['rate']} sao - (${reviewSummary?[0]['percent']}%)"),
            ],
          )
        ],
      ),
    );
  }
}
