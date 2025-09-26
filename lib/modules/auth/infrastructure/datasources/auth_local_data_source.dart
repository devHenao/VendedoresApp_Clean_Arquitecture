import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_vendedores/core/errors/exceptions.dart';
import 'package:app_vendedores/modules/auth/infrastructure/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> getLastUser();
  Future<void> cacheUser(UserModel userToCache);
}

const cachedUser = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getLastUser() {
    final jsonString = sharedPreferences.getString(cachedUser);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException('No user found in cache');
    }
  }

  @override
  Future<void> cacheUser(UserModel userToCache) {
    return sharedPreferences.setString(
      cachedUser,
      json.encode(userToCache.toJson()),
    );
  }
}
