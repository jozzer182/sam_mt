import 'dart:convert';
import 'package:collection/collection.dart';

class GroupBy {
  static List<Map<String, dynamic>> list({
    required List<Map<String, dynamic>> data,
    required List<String> keysToSelect,
    required List<String> keysToSum,
  }) {
    // print('groupByList from forecast model');
    // print(keysToSelect);
    List<Map<String, dynamic>> dataKeyAsJson = data.map((e) {
      e['asJson'] = {};
      for (var key in keysToSelect) {
        e['asJson'].addAll({key: e[key]});
        e.remove(key);
      }
      e['asJson'] = jsonEncode(e['asJson']);
      return e;
    }).toList();
    // print('dataKeyAsJson = $dataKeyAsJson');

    Map<dynamic, Map<String, double>> groupAsMap =
        groupBy(dataKeyAsJson, (Map e) => e['asJson'])
            .map((key, value) => MapEntry(key, {
                  for (var keySum in keysToSum)
                    keySum: value.fold<double>(
                        0, (p, a) => p + (a[keySum] as double))
                }));
    // print('groupAsMap = $groupAsMap');

    List<Map<String, dynamic>> result = groupAsMap.entries.map((e) {
      Map<String, dynamic> newMap = jsonDecode(e.key);
      return {...newMap, ...e.value};
    }).toList();
    // print('result = $result');

    return result;
  }

  static aDoble(String valor) {
    if (valor == "") {
      return 0.0;
    } else {
      return double.parse(valor);
    }
  }

  static aInt(String valor) {
    if (valor == "") {
      return 0.0;
    } else {
      return int.parse(valor);
    }
  }
}

// initialisation
GroupBy groupByObj = GroupBy();
