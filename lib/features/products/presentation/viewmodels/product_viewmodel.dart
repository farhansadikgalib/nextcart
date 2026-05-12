import 'package:nextcart/features/products/domain/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_viewmodel.g.dart';

@riverpod
class ProductSortController extends _$ProductSortController {
  @override
  ProductSort build() => ProductSort.newest;

  void set(ProductSort sort) => state = sort;
}
