import 'dart:async';

import 'package:billing_app/entities/bill.dart';
import 'package:billing_app/entities/bill_detail.dart';
import 'package:billing_app/properties.dart';
import 'package:billing_app/providers/bill_detail_provider.dart';
import 'package:billing_app/providers/product_provider.dart';
import 'package:billing_app/screens/base_screen.dart';
import 'package:billing_app/widgets/form_widget.dart';
import 'package:billing_app/widgets/input_widget.dart';
import 'package:billing_app/widgets/loading.dart';
import 'package:billing_app/widgets/old_form_widget.dart';
import 'package:billing_app/widgets/select_widget.dart';
import 'package:billing_app/widgets/state_widget.dart';
import 'package:billing_app/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillDetailsScreen extends StatefulWidget {
  final Bill bill;
  const BillDetailsScreen({super.key, required this.bill});

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _makeLoad();
  }

  void _makeLoad() async {
    setState(() => _isLoading = true);
    await context.read<BillDetailProvider>().fetchBillDetails(widget.bill.id!);
    if (!mounted) return;
    Timer(const Duration(milliseconds: 200),
        () => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BaseScreen(),
              ),
              (r) => false),
      child: Consumer<BillDetailProvider>(
          builder: (context, billDetailProvider, child) {
        Bill? bill = widget.bill;
        return Scaffold(
          appBar: AppBar(
            title: Text("FCT00${bill.id} : ${bill.parsedDate()}"),
            elevation: 0,
            actions: [
              if (!_isLoading)
                IconButton(
                  onPressed: _makeLoad,
                  icon: const Icon(Icons.refresh),
                )
            ],
          ),
          body: Builder(
            builder: (context) {
              if (_isLoading) {
                return const Loading();
              }
              if (billDetailProvider.billDetails!.isEmpty) {
                return const Statewidget(
                  iconData: Icons.list,
                  text: "Aucun détail enregistré pour cette facture",
                  color: baseColor,
                );
              }
              return ListView.builder(
                itemCount: billDetailProvider.billDetails?.length ?? 0,
                padding: const EdgeInsets.only(top: 0, bottom: 80),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final BillDetail? billDetail =
                      billDetailProvider.billDetails?[index];
                  return (billDetail == null)
                      ? const SizedBox()
                      : Container(
                          margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12)
                              .copyWith(bottom: 0),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.05),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.add,
                              size: 32,
                              color: baseColor,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "${billDetail.product?.name}",
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                TagWidget(
                                  text: "${billDetail.price} F",
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "x ${billDetail.quantity} =",
                                  maxLines: 3,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                TagWidget(
                                  text:
                                      "${billDetail.quantity * billDetail.price} F",
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                                menuPadding: EdgeInsets.zero,
                                elevation: 0,
                                offset: const Offset(0, -8),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        onTap: () => _showEditDialog(
                                          context,
                                          billDetail,
                                        ),
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
                                          context,
                                          billDetail,
                                        ),
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
      }),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        String? productId;
        String quantity = "1";
        return FormWidget(
          title: "Ajouter un détail",
          color: baseColor,
          inputs: [
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(bottom: 24),
                child: Builder(builder: (context) {
                  if (productProvider.products == null ||
                      productProvider.products!.isEmpty) {
                    productProvider.fetchProducts();
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(bottom: 16),
                      child: const CircularProgressIndicator(),
                    ));
                  }
                  return DropdownButtonFormField<String>(
                    value: productId,
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(maxHeight: 52),
                      labelText: "Produit acheté",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 0.0),
                      ),
                    ),
                    icon: Transform.rotate(
                        angle: 33,
                        child: const Icon(
                          Icons.chevron_right,
                          color: baseColor,
                        )),
                    elevation: 16,
                    onChanged: (value) => setState(() => productId = value!),
                    items: (productProvider.products ?? [])
                        .map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item.id?.toString(),
                        child: Text("${item.name} à ${item.price} F"),
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
            InputWidget(
              labelText: "Quantité",
              onChanged: (value) => quantity = value,
              keyboardType: const TextInputType.numberWithOptions(),
              controller: TextEditingController(text: quantity),
            ),
          ],
          check: () =>
              (productId ?? "").isNotEmpty &&
              (quantity.isNotEmpty && quantity != "0") &&
              int.parse(quantity) > 0,
          validate: () => context.read<BillDetailProvider>().addBillDetail(
                BillDetail(
                  billId: widget.bill.id!,
                  productId: int.parse(productId ?? "0"),
                  price: context
                          .read<ProductProvider>()
                          .products
                          ?.where((p) => p.id == int.parse(productId ?? "0"))
                          .first
                          .price ??
                      0,
                  quantity: int.parse(quantity),
                ),
              ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, BillDetail billDetail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        String productId = billDetail.product?.id.toString() ?? "";
        String quantity = billDetail.quantity.toString();
        return FormWidget(
          title: "Modifier ce détail",
          color: Colors.black,
          inputs: [
            Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
              if (productProvider.products == null ||
                  productProvider.products!.isEmpty) {
                productProvider.fetchProducts();
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 16),
                  child: const CircularProgressIndicator(),
                ));
              }
              return SelectWidget(
                items: productProvider.products,
                value: productId,
                labelText: "Prouit acheté",
                itemValue: (item) => item.id.toString(),
                onChanged: (String? value) =>
                    setState(() => productId = value!),
                itemText: (item) => "${item.name} à ${item.price} F",
              );
            }),
            InputWidget(
              labelText: "Quantité",
              onChanged: (value) => quantity = value,
              autofocus: true,
              controller: TextEditingController(text: quantity),
              keyboardType: const TextInputType.numberWithOptions(),
            ),
          ],
          check: () =>
              (productId).isNotEmpty &&
              (quantity.isNotEmpty && quantity != "0") &&
              int.parse(quantity) > 0,
          validate: () => context.read<BillDetailProvider>().updateBillDetail(
                BillDetail(
                  id: billDetail.id,
                  billId: widget.bill.id!,
                  productId: int.parse(productId),
                  price: context
                          .read<ProductProvider>()
                          .products
                          ?.where((p) => p.id == int.parse(productId))
                          .first
                          .price ??
                      0,
                  quantity: int.parse(quantity),
                ),
              ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, BillDetail detail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return OldFormWidget(
          title: "Supprimer ce détail",
          color: Colors.red,
          inputs: const [
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                'Vous êtes sûr de vouloir supprimer ce détail ?',
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
              context.read<BillDetailProvider>().deleteBillDetail(detail.id!),
        );
      },
    );
  }
}
