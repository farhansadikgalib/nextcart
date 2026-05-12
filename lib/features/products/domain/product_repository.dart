import 'package:nextcart/features/products/domain/models/product.dart';

enum ProductSort { newest, priceAsc, priceDesc }

abstract class ProductRepository {
  Stream<List<Product>> watchAll({ProductSort sort = ProductSort.newest});
  Stream<List<Product>> watchByCategory(
    String categoryId, {
    ProductSort sort = ProductSort.newest,
  });
  Future<List<Product>> getAll();
  Future<Product?> getById(String id);
}
