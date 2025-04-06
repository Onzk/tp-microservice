import 'dart:async';

import 'package:billing_app/entities/bill.dart';
import 'package:billing_app/properties.dart';
import 'package:billing_app/providers/bill_provider.dart';
import 'package:billing_app/providers/client_provider.dart';
import 'package:billing_app/screens/bill_details_screen.dart';
import 'package:billing_app/widgets/form_widget.dart';
import 'package:billing_app/widgets/loading.dart';
import 'package:billing_app/widgets/old_form_widget.dart';
import 'package:billing_app/widgets/select_widget.dart';
import 'package:billing_app/widgets/state_widget.dart';
import 'package:billing_app/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _makeLoad();
  }

  void _makeLoad() async {
    setState(() => _isLoading = true);
    await context.read<BillProvider>().fetchBills();
    if (!mounted) return;
    Timer(const Duration(milliseconds: 200),
        () => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de vos factures'),
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _makeLoad,
              icon: const Icon(Icons.refresh),
            )
        ],
        elevation: 0,
      ),
      body: _isLoading
          ? const Loading()
          : Consumer<BillProvider>(
              builder: (context, billProvider, child) {
                if (billProvider.bills == null) {
                  return const Statewidget(
                    iconData: Icons.error,
                    text: "Une erreur est survenue",
                    color: Colors.black,
                  );
                }
                if (billProvider.bills!.isEmpty) {
                  return const Statewidget(
                    iconData: Icons.line_style_outlined,
                    text: "Aucune facture trouvée",
                    color: baseColor,
                  );
                }
                return ListView.builder(
                  itemCount: billProvider.bills?.length ?? 0,
                  padding: const EdgeInsets.only(top: 0, bottom: 80),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final Bill? bill = billProvider.bills?[index];
                    return bill == null
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _header(bill),
                                _card(context, bill),
                                ...bill.details?.map((detail) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minLeadingWidth: 0,
                                        leading: const Icon(
                                          Icons.add,
                                          size: 32,
                                          color: baseColor,
                                        ),
                                        title: Row(
                                          children: [
                                            TagWidget(
                                              text: "x ${detail.quantity}",
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                  "${detail.product?.name}"),
                                            ),
                                            const SizedBox(width: 8),
                                            TagWidget(
                                              text:
                                                  "${detail.price * detail.quantity} F",
                                              color: Colors.blueAccent,
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList() ??
                                    [],
                              ],
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

  Row _header(Bill bill) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TagWidget(text: "FCT00${bill.id}"),
        Text(
          bill.parsedDate(),
          style: const TextStyle(color: Colors.black45, fontSize: 12),
        )
      ],
    );
  }

  Card _card(BuildContext context, Bill bill) {
    return Card(
      elevation: 0,
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillDetailsScreen(bill: bill),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        title: Text(
          "Client : ${bill.client?.lastName ?? "--"} ${bill.client?.firstName ?? "--"}",
          maxLines: 2,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          bill.client?.email ?? "Aucune donnée",
          maxLines: 3,
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: PopupMenuButton(
            menuPadding: EdgeInsets.zero,
            elevation: 0,
            offset: bill.client == null ? Offset.zero : const Offset(0, -8),
            itemBuilder: (context) => [
                  if (bill.client != null)
                    PopupMenuItem(
                      onTap: () => _showEditDialog(
                        context,
                        bill,
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
                      bill,
                    ),
                  ),
                ]),
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
        String? clientId;
        return FormWidget(
          title: "Ajouter une nouvelle facture",
          color: baseColor,
          inputs: [
            Consumer<ClientProvider>(builder: (context, clientProvider, child) {
              if (clientProvider.clients == null ||
                  clientProvider.clients!.isEmpty) {
                clientProvider.fetchClients();
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 16),
                  child: const CircularProgressIndicator(),
                ));
              }
              return SelectWidget(
                items: clientProvider.clients,
                value: clientId,
                labelText: "Client à facturer",
                itemValue: (item) => item.id.toString(),
                onChanged: (String? value) => setState(() => clientId = value!),
                itemText: (item) => "${item.firstName} ${item.lastName}",
              );
            }),
          ],
          check: () => (clientId ?? "").isNotEmpty,
          validate: () => context.read<BillProvider>().addBill(
                Bill(
                  clientId: int.parse(clientId ?? "0"),
                  client: null,
                  date: DateTime.now().toLocal().toString().split(" ")[0],
                  details: [],
                ),
              ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Bill bill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        String clientId = bill.client?.id?.toString() ?? "";
        return FormWidget(
          title: "Modifier cette facture",
          color: Colors.black,
          inputs: [
            Consumer<ClientProvider>(builder: (context, clientProvider, child) {
              if (clientProvider.clients == null ||
                  clientProvider.clients!.isEmpty) {
                clientProvider.fetchClients();
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 16),
                  child: const CircularProgressIndicator(),
                ));
              }
              return SelectWidget(
                items: clientProvider.clients,
                value: clientId,
                labelText: "Client facturé",
                itemValue: (item) => item.id.toString(),
                onChanged: (String? value) => setState(() => clientId = value!),
                itemText: (item) => "${item.firstName} ${item.lastName}",
              );
            }),
          ],
          check: () => clientId.isNotEmpty,
          validate: () => context.read<BillProvider>().updateBill(
                Bill(
                  id: bill.id,
                  date: bill.date,
                  clientId: int.parse(clientId),
                  details: [],
                  client: null,
                ),
              ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Bill bill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return OldFormWidget(
          title: "Supprimer cette facture",
          color: Colors.red,
          inputs: const [
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                'Vous êtes sûr de vouloir supprimer cette facture ?',
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
          validate: () => context.read<BillProvider>().deleteBill(bill.id!),
        );
      },
    );
  }
}
