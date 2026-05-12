import 'package:nextcart/features/categories/domain/models/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchAll();
  Future<List<Category>> getAll();
  Future<Category?> getById(String id);
}
