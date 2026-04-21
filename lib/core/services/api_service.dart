import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pcs_village/routes/app_pages.dart';

import '../utils/api_endpoints.dart';
import '../utils/api_response.dart';
import '../utils/app_constants.dart';

class ApiService extends GetxService {
  final storage = GetStorage();
  Completer<bool>? _refreshCompleter;
  bool _isRefreshing = false;


  Future<ApiService> init() async {
    return this;
  }

  //API REQUEST
  Future<ApiResponse> networkRequest({
    required String method,
    required bool isAuthRequired,
    required String endPoint,
    Map<String, dynamic>? body,
    int timeout = 12,
    bool shouldPrint = false
  }) async {
    var result;
    var code;
    try {
      Uri uri = Uri.parse(ApiEndpoints.baseUrl + endPoint);
      late Map<String, String> headers;

      if (isAuthRequired) {
        headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${storage.read(accessTokenKey)}",
        };
      } else {
        headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
        };
      }

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          {
            response = await http
                .get(uri, headers: headers)
                .timeout(Duration(seconds: timeout));
          }
          break;
        case 'POST':
          {
            response = await http
                .post(uri, body: body == null ? jsonEncode({}) : jsonEncode(body), headers: headers)
                .timeout(Duration(seconds: timeout));
          }
          break;
        case 'PUT':
          {
            response = await http
                .put(uri, body: jsonEncode(body), headers: headers)
                .timeout(Duration(seconds: timeout));
          }
          break;
        case 'PATCH':
          {
            response = await http
                .patch(uri, body: jsonEncode(body), headers: headers)
                .timeout(Duration(seconds: timeout));
          }
          break;
        case 'DELETE':
          {
            response = await http
                .delete(uri, body: body == null ? null : jsonEncode(body), headers: headers)
                .timeout(Duration(seconds: timeout));
          }
          break;
        default:
          {
            return ApiResponse(statusCode: -9, data: {});
          }
      }
      result = response.body;
      code = response.statusCode;
      print("🟢 Code: ${response.statusCode}");
      if( response.statusCode == 401 && isAuthRequired ) {
        bool isRefreshed = await refreshTokenOnce();

        if (isRefreshed) {
          return await networkRequest(
            method: method,
            isAuthRequired: isAuthRequired,
            endPoint: endPoint,
            body: body,
            timeout: timeout,
          );
        } else {
          return ApiResponse(statusCode: 401);
        }
      }
      return ApiResponse(
        statusCode: response.statusCode,
        data: jsonDecode(response.body),
      );
    } on SocketException {
      return ApiResponse(statusCode: 503);
    } on TimeoutException {
      return ApiResponse(statusCode: 408);
    } catch (e) {
      print("🛑 Error: $e");
      return ApiResponse(statusCode: 500);
    }finally{
      print("🌐 Endpoint: $endPoint");
      print("🟢 Code: $code");
      //developer.log("✅ Result: $result");
      if( shouldPrint ){
        logPrettyJson(result.toString());
      }
    }
  }

  //===================MULTIPART REQUEST=====================
  Future<ApiResponse> multipartRequest({
    required String method,
    required String endPoint,
    required bool isAuthRequired,
    required Map<String, String> fields,
    File? image,
    int timeout = 20,
    String? imageKey,
    List<File>? images
  }) async {
    var result;
    try {
      Uri uri = Uri.parse(ApiEndpoints.baseUrl + endPoint);

      var request = http.MultipartRequest( method, uri);

      request.fields.addAll(fields);
      if( isAuthRequired ){
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${storage.read( accessTokenKey )}",
        };
        request.headers.addAll(headers);
      }

      if (image != null) {
        final compressedImage = await compressImage(image);
        if (compressedImage != null) {
          final mimeType =
              lookupMimeType(compressedImage.path)?.split('/') ??
                  ['application', 'octet-stream'];

          request.files.add(
            await http.MultipartFile.fromPath(
              imageKey!,
              compressedImage.path,
              contentType: http.MediaType(mimeType[0], mimeType[1]),
            ),
          );
        }
      }

      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final compressedImage = await compressImage(images[i]);
          if (compressedImage != null) {
            final mimeType =
            lookupMimeType(compressedImage.path)?.split('/') ??
                ['application', 'octet-stream'];
            request.files.add(
              await http.MultipartFile.fromPath(
                imageKey!,
                compressedImage.path,
                contentType: http.MediaType(mimeType[0], mimeType[1]),
              ),
            );
          }
        }
      }

      // Send request
      var response = await request.send().timeout(Duration(seconds: timeout));
      var responseBody = await response.stream.bytesToString();
      result = responseBody;
      print("🟢 Code: ${response.statusCode}");
      if( response.statusCode == 401 && isAuthRequired ) {
        bool isRefreshed = await refreshTokenOnce();

        if (isRefreshed) {
          return await multipartRequest(
              method: method,
              endPoint: endPoint,
              isAuthRequired: isAuthRequired,
              fields: fields,
              imageKey: imageKey
          );
        } else {
          return ApiResponse(statusCode: 401);
        }
      }
      return ApiResponse(
        statusCode: response.statusCode,
        data: jsonDecode(responseBody),
      );
    } on SocketException {
      return ApiResponse(statusCode: 503);
    } on TimeoutException {
      return ApiResponse(statusCode: 408);
    } catch (e) {
      print("🛑 Error: $e");
      return ApiResponse(statusCode: 500);
    }finally{
      print("🌐 Endpoint: $endPoint");
      print("✅ Result: $result");

    }
  }

  //REFRESH TOKEN
  Future<bool> refreshTokenOnce() async {
    if (_isRefreshing) {
      return _refreshCompleter?.future ?? Future.value(false);
    }


    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = storage.read(refreshTokenKey);
      if (refreshToken == null) {
        await _forceLogout();
        _refreshCompleter!.complete(false);
        return false;
      }

      final response = await http.post(
        Uri.parse("${ApiEndpoints.baseUrl}${ApiEndpoints.refreshToken}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {
              "refreshToken": refreshToken
            }
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        storage.write(accessTokenKey, data['data']['accessToken']);

        if (data['data']['refreshToken'] != null) {
          storage.write(refreshTokenKey, data['data']['refreshToken']);
        }

        _refreshCompleter!.complete(true);
        return true;
      } else {
        await _forceLogout();
        _refreshCompleter!.complete(false);
        return false;
      }
    } catch (e) {
      await _forceLogout();
      if (!_refreshCompleter!.isCompleted) {
        _refreshCompleter!.complete(false);
      }
      return false;
    } finally {
      _isRefreshing = false;
    }
  }


  Future<void> _forceLogout() async {
    await storage.erase();
    if (Get.currentRoute != AppRoutes.authSelection) {
      Get.offAllNamed(AppRoutes.authSelection);
    }
  }


  //COMPRESS IMAGE
  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50, // 0 - 100
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }

  void logPrettyJson(String responseBody) {
    try {
      // 1. Parse the string into an object (Map or List)
      final dynamic decoded = json.decode(responseBody);

      // 2. Encode it back to a string with 2-space indentation
      final String prettyString = const JsonEncoder.withIndent('  ').convert(decoded);

      // 3. Log the result
      developer.log(prettyString, name: 'API_RESPONSE');
    } catch (e) {
      // If it's not valid JSON, just log the raw string
      developer.log("Invalid JSON: $responseBody", name: 'ERROR');
    }
  }
}
