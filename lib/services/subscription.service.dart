import 'package:dio/dio.dart';
import 'package:fitivation_app/models/subscription.model.dart';
import 'package:fitivation_app/shared/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SubscriptionService {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/subscription";
  final API api = API();

  SubscriptionService();

  Future<List<Subsciption>?> getSubscriptionOfMe() async {
    try {
      String endpoint = '$baseUrl/me';
      List<Subsciption>? subscriptions = [];

      print("endpoint subscription $endpoint");
      final Response response = await api.get(endpoint);
      final jsonData = response.data;

      if (jsonData != null) {
        final List<dynamic> tempList = jsonData;
        subscriptions =
            tempList.map((item) => Subsciption.fromJson(item)).toList();
      }

      return subscriptions;
    } catch (ex) {
      print('Error get subscriptions of me: ${ex}');
      return null;
    }
  }
}
