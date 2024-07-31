import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/clients_transefer_provider.dart';
import 'package:cashes/app/providers/project_provider.dart';
import 'package:cashes/app/widget/custom_dialog_widget.dart';
import 'package:cashes/app/widget/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/overlayed_box_widget.dart';
import 'client_transfer_add_update_widget.dart';

class ClientMoney extends StatelessWidget {
  const ClientMoney({super.key});

  @override
  Widget build(BuildContext context) {
    var clientMoneyProvider = Provider.of<ClientsTranseferProvider>(context);
    var projectProvider = Provider.of<ProjectProvider>(context);
    var authProvider = Provider.of<AuthManagerProvider>(context);
    return Scaffold(
      body: clientMoneyProvider.clintes!.isEmpty
          ? EmptyScreen(message: 'No Clients Transefer Yet...')
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: clientMoneyProvider.clintes!.length,
              itemBuilder: (context, index) {
                String imageUrl =
                    clientMoneyProvider.clintes![index].imageURL ?? '';
                String name = clientMoneyProvider.clintes![index].name!;
                return imageCard(
                  onPressedDelete: () {
                    DialogUtls.showDeleteConfirmationDialog(
                        context: context,
                        deleteFunction: () {
                          clientMoneyProvider.deleteClientTransfer(
                            userId: authProvider.currentUser!.id,
                            projectId: projectProvider.currentProject!.id,
                            client: clientMoneyProvider.clintes![index],
                            context: context,
                          );
                        });
                  },
                  image: imageUrl != ''
                      ? NetworkImage(imageUrl)
                      : const AssetImage('assets/images/no_image.png'),
                  name: name,
                  context: context,
                  edit: true,
                  onPressed: () {
                    print("============================");
                    print(clientMoneyProvider.clintes![index].id);
                    print("============================");
                    showClientTransferDialog(
                      context: context,
                      isAdd: false,
                      index: index,
                    );
                  },
                );
              },
            ),
    );
  }

  showClientTransferDialog({
    required BuildContext context,
    required isAdd,
    index,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUpdateClientTransefer(isAdd: isAdd, index: index);
      },
    );
  }
}
