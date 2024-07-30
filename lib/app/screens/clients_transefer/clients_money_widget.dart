import 'package:cashes/app/providers/clients_transefer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/overlayed_box_widget.dart';
import '../cash/cash_screen.dart';
import 'client_transfer_add_update_widget.dart';

class ClientMoney extends StatelessWidget {
  const ClientMoney({super.key});

  @override
  Widget build(BuildContext context) {
    var clientMoneyProvider = Provider.of<ClientsTranseferProvider>(context);

    return Scaffold(
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: clientMoneyProvider.clintes!.length,
        itemBuilder: (context, index) {
          String imageUrl = clientMoneyProvider.clintes![index].imageURL ?? '';
          String name = clientMoneyProvider.clintes![index].name!;
          return Stack(
            children: [
              imageCard(
                  image: imageUrl != ''
                      ? NetworkImage(imageUrl)
                      : const AssetImage('assets/images/no_image.png'),
                  name: name,
                  context: context,
                  edit: true,
                  onPressed: () {
                    showClientTransferDialog(
                        context: context, isAdd: false, index: index);
                  }),
            ],
          );
        },
      ),
    );
  }

  showClientTransferDialog(
      {required BuildContext context, required isAdd, index}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddUpdateClientTransefer(isAdd: isAdd, index: index);
      },
    );
  }
}
