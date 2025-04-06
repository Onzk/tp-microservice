import 'dart:async';

import 'package:billing_app/entities/client.dart';
import 'package:billing_app/properties.dart';
import 'package:billing_app/providers/client_provider.dart';
import 'package:billing_app/widgets/form_widget.dart';
import 'package:billing_app/widgets/input_widget.dart';
import 'package:billing_app/widgets/loading.dart';
import 'package:billing_app/widgets/old_form_widget.dart';
import 'package:billing_app/widgets/state_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _makeLoad();
  }

  void _makeLoad() async {
    setState(() => _isLoading = true);
    await context.read<ClientProvider>().fetchClients();
    if (!mounted) return;
    Timer(const Duration(milliseconds: 200),
        () => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de vos clients'),
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
          : Consumer<ClientProvider>(
              builder: (context, clientProvider, child) {
                if (clientProvider.clients == null) {
                  return const Statewidget(
                    iconData: Icons.error,
                    text: "Une erreur est survenue",
                    color: Colors.black,
                  );
                }
                if (clientProvider.clients!.isEmpty) {
                  return const Statewidget(
                    iconData: Icons.person,
                    text: "Aucun client trouvée",
                    color: baseColor,
                  );
                }
                return ListView.builder(
                  itemCount: clientProvider.clients?.length ?? 0,
                  padding: const EdgeInsets.only(top: 0, bottom: 80),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final Client? client = clientProvider.clients?[index];
                    return client == null
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
                              leading: Container(
                                margin: const EdgeInsets.only(top: 4, left: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: baseColor.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: baseColor,
                                ),
                              ),
                              title: Text(
                                "${client.firstName} ${client.lastName}",
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              subtitle: Text(
                                client.email,
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
                                              _showEditDialog(context, client),
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
                                              context, client),
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
        String lastname = '';
        String firstname = '';
        String email = '';
        return FormWidget(
          title: "Ajouter un client",
          color: baseColor,
          inputs: [
            InputWidget(
              labelText: "Nom",
              onChanged: (value) => lastname = value,
              autofocus: true,
            ),
            InputWidget(
              labelText: "Prénoms",
              onChanged: (value) => firstname = value,
            ),
            InputWidget(
              labelText: "Email",
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value,
            ),
          ],
          check: () =>
              lastname.isNotEmpty &&
              firstname.isNotEmpty &&
              (email.isNotEmpty && email.contains("@")),
          validate: () => context.read<ClientProvider>().addClient(
                Client(
                  lastName: lastname,
                  firstName: firstname,
                  email: email,
                ),
              ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Client client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        String lastName = client.lastName;
        String firstName = client.firstName;
        String email = client.email;
        return FormWidget(
          title: "Modifier ce client",
          color: Colors.black,
          inputs: [
            InputWidget(
              labelText: "Nom",
              onChanged: (value) => lastName = value,
              autofocus: true,
              controller: TextEditingController(text: lastName),
            ),
            InputWidget(
              labelText: "Prénoms",
              onChanged: (value) => firstName = value,
              controller: TextEditingController(text: firstName),
            ),
            InputWidget(
              labelText: "Email",
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value,
              controller: TextEditingController(text: email),
            ),
          ],
          check: () =>
              lastName.isNotEmpty &&
              firstName.isNotEmpty &&
              (email.isNotEmpty && email.contains("@")),
          validate: () => context.read<ClientProvider>().updateClient(
                Client(
                  id: client.id,
                  lastName: lastName,
                  firstName: firstName,
                  email: email,
                ),
              ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Client client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext context) {
        return OldFormWidget(
          title: "Supprimer ce client",
          color: Colors.red,
          inputs: const [
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                'Vous êtes sûr de vouloir supprimer ce client ?',
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
              context.read<ClientProvider>().deleteClient(client.id!),
        );
      },
    );
  }
}
