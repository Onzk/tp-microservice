import 'package:billing_app/entities/product.dart';
import 'package:billing_app/services/product_service.dart';
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product>? _products = [];

  List<Product>? get products => _products;

  Future<void> fetchProducts() async {
    try {
      _products = await _productService.getProducts();
      notifyListeners();
    } catch (e) {
      //
    }
  }

  Future<Product?> addProduct(Product product) async {
    try {
      final newProduct = await _productService.createProduct(product);
      if (newProduct != null) _products?.add(newProduct);
      notifyListeners();
      return newProduct;
    } catch (e) {
      //
    }
    return null;
  }

  Future<Product?> updateProduct(Product product) async {
    try {
      final updatedProduct = await _productService.updateProduct(product);
      final index =
          _products?.indexWhere((t) => t.id == updatedProduct?.id) ?? -1;
      if (index != -1) {
        _products?[index] = updatedProduct!;
        notifyListeners();
        return updatedProduct;
      }
    } catch (e) {
      //
    }
    return null;
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      _products?.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}
