import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:v_al_sam_v02/resources/constant/apis.dart';
import 'package:v_al_sam_v02/user/user_model.dart';

class FileUploadToDrive {
  Uri get url => Api.sam;

  Future<String> uploadAndGetUrl({
    required PlatformFile file,
    required String carpeta,
    required User user,
  }) async {
    var bytes = file.bytes!;
    var s = base64.encode(bytes);
    final mimeType = lookupMimeType('.${file.extension!}');
    var dataSend = {
      'dataReq': {
        'data': s,
        'name': file.name,
        'type': mimeType,
        'pdi': user.pdi,
        'carpeta': carpeta
      },
      'fname': "uploadFilesToGoogleDrive"
    };
    // print(jsonEncode(dataSend));
    var response = await http.post(url, body: jsonEncode(dataSend));
    // print(response.body);
    var data = jsonDecode(response.body) ?? 'Error';
    // print(data['url']);
    return data['url'];
  }

  static Future<String> uploadConciliacionAndGetUrl({
    required PlatformFile file,
    required String pdi,
    required String carpeta,
  }) async {
    Uri url = Api.sam;
    var bytes = file.bytes!;
    var s = base64.encode(bytes);
    final mimeType = lookupMimeType('.${file.extension!}');
    var dataSend = {
      'dataReq': {
        'data': s,
        'name': file.name,
        'type': mimeType,
        'pdi': pdi,
        'carpeta': carpeta,
      },
      'fname': "uploadFilesToGoogleDrive"
    };
    // print(jsonEncode(dataSend));
    var response = await http.post(url, body: jsonEncode(dataSend));
    // print(response.body);
    var data = jsonDecode(response.body) ?? 'Error';
    // print(data['url']);
    return data['url'];
  }
}
