import 'dart:convert';
export 'package:collection/collection.dart' show ListEquality;

typedef StructBuilder<T> = T Function(Map<String, dynamic> data);

abstract class BaseStruct {
  Map<String, dynamic> toSerializableMap();
  String serialize() => json.encode(toSerializableMap());
}


