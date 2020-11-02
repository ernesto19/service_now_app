import 'package:service_now/features/home/data/models/category_model.dart';
import 'package:service_now/features/login/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';
import 'package:service_now/core/db/db.dart';

abstract class HomeLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<void> createCategory(CategoryModel category);
  Future<void> createCategories(List<CategoryModel> categories);
  Future<void> deleteCategories();

  Future<List<PermissionModel>> getAllPermissions();
  Future<void> createPermission(PermissionModel permission);
  Future<void> createPermissions(List<PermissionModel> permissions);
  Future<void> deletePermissions();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SharedPreferences sharedPreferences;

  HomeLocalDataSourceImpl({ @required this.sharedPreferences });

  Database _db = DB.instance.database;
  StoreRef _storeCategory = StoreRef('categories');
  StoreRef _storePermission = StoreRef('permissions');

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final snapshot = await this._storeCategory.find(this._db);
    return snapshot.map<CategoryModel>((e) => CategoryModel.fromJson(e.value)).toList();
  }

  @override
  Future<void> createCategory(CategoryModel category) async {
    await this._storeCategory.record(category.id).put(this._db, category.toJson());
  }

  @override
  Future<void> createCategories(List<CategoryModel> categories) async {
    this._db.transaction((transaction) async {
      for (final category in categories) {
        await this._storeCategory.record(category.id).put(transaction, category.toJson());
      }
    });
  }

  @override
  Future<void> deleteCategories() async {
    await this._storeCategory.delete(this._db);
  }

  @override
  Future<List<PermissionModel>> getAllPermissions() async {
    final snapshot = await this._storePermission.find(this._db);
    return snapshot.map<PermissionModel>((e) => PermissionModel.fromJson(e.value)).toList();
  }

  @override
  Future<void> createPermission(PermissionModel permission) async {
    await this._storePermission.record(permission.id).put(this._db, permission.toJson());
  }
  
  @override
  Future<void> createPermissions(List<PermissionModel> permissions) async {
    this._db.transaction((transaction) async {
      for (final permission in permissions) {
        await this._storePermission.record(permission.id).put(transaction, permission.toJson());
      }
    });
  }

  @override
  Future<void> deletePermissions() async {
    await this._storePermission.delete(this._db);
  }
}