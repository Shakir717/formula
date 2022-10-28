import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../preset/preset.dart';



class LocalStorageService {
//  static LocalStorageService _localStorageService;
  static SharedPreferences? _preferences;


  static Future init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }


  /// method to check if the cache provider contains given [key] or not.
  bool? containsKey(String key) {
    return _preferences?.containsKey(key);
  }


  dynamic getFromDisk(String key) {
    var value = _preferences?.get(key);
    debugPrint('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }


  Future<void> saveToDisk<T>(String key, T content)async{
    debugPrint('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
     await _preferences?.setString(key, content);
    }
    if (content is bool) {
      await _preferences?.setBool(key, content);
    }
    if (content is int) {
      await  _preferences?.setInt(key, content);
    }
    if (content is double) {
      await _preferences?.setDouble(key, content);
    }
    if (content is List<String>) {
      await _preferences?.setStringList(key, content);
    }

  }


  List<String> encodeList(List<PresetModel> list){
    List<String> usrList = list.map((item) => jsonEncode(PresetModel.toJson(item))).toList();
    return usrList;
  }

  List<PresetModel> decodeList(List listString){

/*In this part, we are taking each element that is there in the
  list (Referring to as 'item' here), decoding JSON string to a
  map (Referring here as jsonDecode)*/

   List<PresetModel> list = listString.map((item) => PresetModel.fromJson(json.decode(item))).toList();
   return list;
  }

  Future<bool?> clearCache() async {
    return await _preferences?.clear();
  }

}
final localStorageProvider=Provider((ref) => LocalStorageService());

