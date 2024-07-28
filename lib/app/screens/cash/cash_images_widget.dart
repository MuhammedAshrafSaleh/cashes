import 'package:cashes/app/providers/cash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CashImagesWidget extends StatelessWidget {
  const CashImagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var cashProvider = Provider.of<CashProvider>(context);
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: cashProvider.cashes.length,
        itemBuilder: (context, index) {
          String imageUrl = cashProvider.cashes[index].imageURl ?? '';
          String name = cashProvider.cashes[index].name!;
          return Column(
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              imageUrl != ''
                  ? Image.network(imageUrl)
                  : Image.asset('assets/images/no_image.png'),
            ],
          );
        },
      ),
    );
  }
}
