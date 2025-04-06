import 'dart:async';

import 'package:billing_app/entities/product.dart';
import 'package:billing_app/properties.dart';
import 'package:billing_app/providers/product_provider.dart';
import 'package:billing_app/widgets/form_widget.dart';
import 'package:billing_app/widgets/input_widget.dart';
import 'package:billing_app/widgets/loading.dart';
import 'package:billing_app/widgets/old_form_widget.dart';
import 'package:billing_app/widgets/state_widget.dart';
import 'package:billing_app/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _makeLoad();
  }

  void _makeLoad() async {
    setState(() => _isLoading = true);
    await context.read<ProductProvider>().fetchProducts();
    if (!mounted) return;
    Timer(const Duration(milliseconds: 200),
        () => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de vos produits'),
        elevation: 0,
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _makeLoad,
              icon: const Icon(Icons.refresh),
            )
        ],
      ),
      body: _isLoading
          ? const Loading()
          : Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.products == null) {
                  return const Statewidget(
                    iconData: Icons.error,
                    text: "Une erreur est survenue",
                    color: Colors.black,
                  );
                }
                if (productProvider.products!.isEmpty) {
                  return const Statewidget(
                    iconData: Icons.stacked_bar_chart,
                    text: "Aucun produit trouvé",
                    color: baseColor,
                  );
                }
                return ListView.builder(
                  itemCount: productProvider.products?.length ?? 0,
                  padding: const EdgeInsets.only(top: 0, bottom: 80),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final Product? product = productProvider.products?[index];
                    return product == null
                        ? const SizedBox()
                        : Container(
                            margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12)
                                .copyWith(bottom: 0),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: const Border(
                                  left: BorderSide(color: baseColor, width: 6),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade100,
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  ),
                                ]),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  TagWidget(text: "${product.price.round()}F"),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      product.name,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ].reversed.toList(),
                              ),
                              subtitle: Text(
                                product.description,
                                maxLines: 3,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              trailing: PopupMenuButton(
                                  menuPadding: EdgeInsets.zero,
                                  elevation: 0,
                                  offset: const Offset(0, -8),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          onTap: () =>
                                              _showEditDialog(context, product),
                                          height: 32,
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                size: 14,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Modifier",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          height: 32,
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.delete_forever_sharp,
                                                size: 14,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Supprimer",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () => _showDeleteConfirmation(
                                              context, product),
                                        ),
                                      ]),
                            ),
                          );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        String name = '';
        String description = '';
        String price = '';
        return FormWidget(
          title: "Ajouter un produit",
          color: baseColor,
          inputs: [
            InputWidget(
              labelText: "Nom",
              onChanged: (value) => name = value,
              autofocus: true,
            ),
            InputWidget(
              labelText: "Prix",
              keyboardType: const TextInputType.numberWithOptions(),
              onChanged: (value) => price = value,
            ),
            InputWidget(
              labelText: "Description",
              onChanged: (value) => description = value,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
          ],
          check: () {
            return name.isNotEmpty &&
                description.isNotEmpty &&
                (price.isNotEmpty && price != "0");
          },
          validate: () => context.read<ProductProvider>().addProduct(
                Product(
                  name: name,
                  price: double.parse(price),
                  description: description,
                ),
              ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        String name = product.name;
        String price = product.price.toString();
        String description = product.description;
        return FormWidget(
          title: "Modifier ce produit",
          color: Colors.black,
          inputs: [
            InputWidget(
              labelText: "Nom",
              onChanged: (value) => name = value,
              controller: TextEditingController(text: name),
              autofocus: true,
            ),
            InputWidget(
              labelText: "Prix",
              keyboardType: const TextInputType.numberWithOptions(),
              onChanged: (value) => price = value,
              controller: TextEditingController(text: price),
            ),
            InputWidget(
              labelText: "Description",
              onChanged: (value) => description = value,
              controller: TextEditingController(text: description),
              maxLines: 8,
              keyboardType: TextInputType.multiline,
            ),
          ],
          check: () =>
              name.isNotEmpty &&
              description.isNotEmpty &&
              (price.isNotEmpty && price != "0"),
          validate: () => context.read<ProductProvider>().updateProduct(
                Product(
                  id: product.id,
                  name: name,
                  price: double.parse(price),
                  description: description,
                ),
              ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return OldFormWidget(
          title: "Supprimer ce produit",
          color: Colors.red,
          inputs: const [
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                'Vous êtes sûr de vouloir supprimer ce produit ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          check: () => true,
          validate: () =>
              context.read<ProductProvider>().deleteProduct(product.id!),
        );
      },
    );
  }
}
