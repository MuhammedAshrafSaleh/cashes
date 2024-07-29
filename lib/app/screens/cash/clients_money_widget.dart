import 'package:cashes/app/providers/clients_transefer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/overlayed_box_widget.dart';

class ClientMoney extends StatelessWidget {
  const ClientMoney({super.key});

  @override
  Widget build(BuildContext context) {
    var clientMoneyProvider = Provider.of<ClientsTranseferProvider>(context);

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: clientMoneyProvider.clintes!.length,
        itemBuilder: (context, index) {
          String imageUrl = clientMoneyProvider.clintes![index].imageURL ?? '';
          String name = clientMoneyProvider.clintes![index].name!;
          return Column(
            children: [
              imageCard(
                image: imageUrl != ''
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/images/no_image.png'),
                name: name,
                context: context,
              ),
            ],
          );
        },
      ),
    );
  }
}
