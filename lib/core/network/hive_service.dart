import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sajilo_style/app/constant/hive_table_constant.dart';
import 'package:sajilo_style/features/auth/data/model/user_hive_model.dart';

class HiveService {
  Future<void> init() async{
    // initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path =  '${directory.path}sajilo_style.db';

    Hive.init(path);

    Hive.registerAdapter(UserHiveModelAdapter());
  }

   // Auth Queries
  Future<void> register(UserHiveModel auth) async {
    var box = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.userBox,
    );
    await box.put(auth.userId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.userBox,
    );
    await box.delete(id);
  }

  Future<List<UserHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.userBox,
    );
    return box.values.toList();
  }

   // Login using email and password
  Future<UserHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(
      HiveTableConstant.userBox,
    );
    var student = box.values.firstWhere(
      (element) => element.email == email && element.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
    box.close();
    return student;
  }

   // Clear all data and delete database
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    
  }

   Future<void> close() async {
    await Hive.close();
  }

}
