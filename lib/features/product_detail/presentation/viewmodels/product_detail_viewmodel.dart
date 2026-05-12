import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_detail_viewmodel.g.dart';

@riverpod
class ProductQuantity extends _$ProductQuantity {
  @override
  int build(String productId) => 1;

  void set(int qty) {
    if (qty < 1 || qty > 99) return;
    state = qty;
  }
}
