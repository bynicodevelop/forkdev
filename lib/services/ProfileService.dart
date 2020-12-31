import 'package:flutter_api_services/FirestorageService.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_api_services/exceptions/AuthenticationException.dart';
import 'package:flutter_models/models/UserModel.dart';

class ProfileService {
  UserService userService;
  FirestorageService firestorageService;

  ProfileService({
    this.firestorageService,
    this.userService,
  });

  Future<void> updateProfile(
    String uid,
    String value,
    String propertyId,
  ) async {
    if (propertyId == UserModel.AVATAR_URL) {
      value = await firestorageService.uploadAvatar(value, uid);
    }

    try {
      await userService.update(propertyId, value);
    } on AuthenticationException catch (e) {
      print(e.code);
    }
  }
}
