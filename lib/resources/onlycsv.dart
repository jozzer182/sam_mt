import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:device_info/device_info.dart';
import 'package:file_saver/file_saver.dart'; // Added for WASM compatibility
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SaveAsCsv {
  Future<void> saveCSV({required List<List<String>> dataValue, required String fileName}) async {
    Directory? directory;
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (await _requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        if (directory == null) {
          return; // Exit if directory is null
        }

        DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        final androidInfo = await deviceInfoPlugin.androidInfo;
        if (androidInfo.version.sdkInt > 29 && await externalStoragePermission()) {
          String newPath = "";
          if (kDebugMode) {
            print(directory);
          }
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          newPath = "$newPath/Table_Plus";
          directory = Directory(newPath);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          String file = "${directory.path}/$fileName.csv";
          File f = File(file);
          String csv = const ListToCsvConverter().convert(dataValue);
          f.writeAsString(csv);
          // successMsg();
        } else if (androidInfo.version.sdkInt < 30) {
          directory = Directory(directory.path);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          String file = "${directory.path}/$fileName.csv";
          File f = File(file);
          String csv = const ListToCsvConverter().convert(dataValue);
          f.writeAsString(csv);
          // successMsg();
        }
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      if (await _requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
        directory = Directory(directory.path);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        File saveFile = File("${directory.path}/$fileName");
        String csv = const ListToCsvConverter().convert(dataValue);
        saveFile.writeAsString(csv);
        await ImageGallerySaver.saveFile(saveFile.path, isReturnPathOfIOS: true);
        // successMsg();
      }
    } else if (kIsWeb) {
      // Using file_saver package for WASM compatibility
      String csv = const ListToCsvConverter(fieldDelimiter: ';').convert(dataValue);
      
      // Convert to Uint8List for file_saver
      final Uint8List bytes = Uint8List.fromList(utf8.encode(csv));
      
      // Use FileSaver to download the CSV file
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        ext: 'csv',
        mimeType: MimeType.csv,
      );
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> externalStoragePermission() async {
    var status1 = await Permission.manageExternalStorage.status;
    if (!status1.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    return status1.isGranted;
  }
}