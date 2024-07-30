import 'package:cashes/app/providers/cash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/overlayed_box_widget.dart';

class CashImagesWidget extends StatelessWidget {
  const CashImagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var cashProvider = Provider.of<CashProvider>(context);
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: cashProvider.cashes.length,
      itemBuilder: (context, index) {
        String imageUrl = cashProvider.cashes[index].imageURl ?? '';
        String name = cashProvider.cashes[index].name!;
        return imageCard(
          image: imageUrl != ''
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/images/no_image.png'),
          name: name,
          context: context,
        
        );
      },
    );
  }
}
