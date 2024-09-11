import 'package:cashes/app/core/theme.dart';
import 'package:cashes/app/models/cash.dart';
import 'package:cashes/app/providers/auth_manager_provider.dart';
import 'package:cashes/app/providers/cash_provider.dart';
import 'package:cashes/app/providers/project_provider.dart';
import 'package:cashes/app/widget/custom_dialog_widget.dart';
import 'package:cashes/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widget/empty_screen.dart';
import '../../widget/overlayed_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CashImagesWidget extends StatefulWidget {
  const CashImagesWidget({super.key});

  @override
  State<CashImagesWidget> createState() => _CashImagesWidgetState();
}

class _CashImagesWidgetState extends State<CashImagesWidget> {
  bool _isLoading = false;
  var cashProvider;
  var authProvider;
  var projectProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the providers now
      projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      authProvider = Provider.of<AuthManagerProvider>(context, listen: false);

      // Ensure authProvider is initialized
      if (authProvider.currentUser != null) {
        _fetchData();
      }
    });
  }

  void _fetchData() async {
    setState(() {
      _isLoading =
          true; // Set loading state to true when starting to fetch data
    });
    try {
      await cashProvider.getCashes(
        userId: authProvider.currentUser.id!,
        project: projectProvider.currentProject,
      ); // Assuming you have a method to fetch data// Assuming you have a method to fetch data
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false once data is fetched
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    cashProvider = Provider.of<CashProvider>(context);
    if (_isLoading) {
      return const Loader(
        color1: AppTheme.primaryColor,
        color2: AppTheme.secondaryColor,
      );
    }
    return cashProvider.cashes.isEmpty
        ? EmptyScreen(message: AppLocalizations.of(context)!.noCashes)
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: cashProvider.cashes.length,
            itemBuilder: (context, index) {
              String imageUrl = cashProvider.cashes[index].imageURl ?? '';
              String name = cashProvider.cashes[index].name!;
              return imageCard(
                deleteButton: true,
                onPressedDelete: () async {
                  if (imageUrl != '' || imageUrl.isNotEmpty) {
                    DialogUtls.showLoading(
                        context: context,
                        message: AppLocalizations.of(context)!.deletingNow);
                    await cashProvider.deleteImageCash(
                      cash: Cash(
                        id: cashProvider.cashes[index].id,
                        name: cashProvider.cashes[index].name,
                        cashNumber: '',
                        price: cashProvider.cashes[index].price,
                        date: cashProvider.cashes[index].date,
                        imageURl: imageUrl,
                      ),
                      project: projectProvider.currentProject,
                      userId: authProvider.currentUser!.id,
                      context: context,
                    );
                    DialogUtls.hideLoading(context: context);
                    DialogUtls.showMessage(
                      context: context,
                      message:
                          AppLocalizations.of(context)!.deletedSuccessfully,
                    );
                    Navigator.pop(context);
                  }
                },
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
