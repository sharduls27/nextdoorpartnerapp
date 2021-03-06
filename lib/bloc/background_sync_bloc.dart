import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';

///30/09/20
///Used to sync notifications and product Categories
class BackgroundSyncBloc {
  final _repository = Repository();

  Future<ApiResponse> syncProductCategories(int vendorType) async {
    try {
      Response response = await _repository.syncProductCategories(vendorType);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse.hasData(jsonResponse['message'],
            data: jsonResponse['data']['product_categories']);
      } else {
        return ApiResponse.error(jsonResponse['message']);
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error(e.toString());
    }
  }

  Future<DbResponse> insertProductCategoriesInDb(
      List<ProductCategoryModel> productCategoryModelList) async {
    try {
      await _repository.insertProductCategories(productCategoryModelList);
      return DbResponse.successful('Loaded');
    } catch (e) {
      print(e.toString());
      return DbResponse.error(e.toString());
    }
  }

  ///Check if any new notifications has been made on server
  ///Notifications are still received, it is being used to make sure that
  ///App has notifications stored in db
  Future<ApiResponse> syncNotifications(String authorisationToken) async {
    try {
      Response response =
          await _repository.syncNotifications(authorisationToken);
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(jsonResponse);
        return ApiResponse.hasData(jsonResponse['message'],
            data: jsonResponse['data']['notifications']);
      } else {
        return ApiResponse.error(jsonResponse['message']);
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse.error(e.toString());
    }
  }

  Future<DbResponse> insertNotificationsInDb(
      List<NotificationModel> notificationModelList) async {
    try {
      if (notificationModelList.length == 0) {
        return DbResponse.successful('Loaded');
      }
      await _repository.insertNotifications(notificationModelList);

      ///Once notifications has been inserted in local DB
      ///make an api call to delete notifications
      await _repository.deleteNotifications();
      return DbResponse.successful('Loaded');
    } catch (e) {
      print(e.toString());
      return DbResponse.error(e.toString());
    }
  }
}
