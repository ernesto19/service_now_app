import 'package:service_now/features/home/data/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';
import 'package:service_now/core/db/db.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<void> createCategory(CategoryModel category);
  Future<void> createCategories(List<CategoryModel> categories);
  Future<void> deleteCategories();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final SharedPreferences sharedPreferences;

  CategoryLocalDataSourceImpl({ @required this.sharedPreferences });

  Database _db = DB.instance.database;
  StoreRef _store = StoreRef('categories');

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final snapshot = await this._store.find(this._db);
    return snapshot.map<CategoryModel>((e) => CategoryModel.fromJson(e.value)).toList();
  }

  @override
  Future<void> createCategory(CategoryModel category) async {
    await this._store.record(category.id).put(this._db, category.toJson());
  }

  @override
  Future<void> createCategories(List<CategoryModel> categories) async {
    this._db.transaction((transaction) async {
      for (final category in categories) {
        await this._store.record(category.id).put(transaction, category.toJson());
      }
    });
  }

  @override
  Future<void> deleteCategories() async {
    await this._store.delete(this._db);
  }
}