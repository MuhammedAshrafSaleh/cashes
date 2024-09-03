import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme.dart';
import '../../models/cash.dart';
import '../../providers/auth_manager_provider.dart';
import '../../providers/cash_provider.dart';
import '../../providers/project_provider.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/date_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddUpdateTask extends StatelessWidget {
  final bool isAdd;
  final int? index;
  const AddUpdateTask({super.key, required this.isAdd, this.index});
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthManagerProvider>(context);
    var cashProvider = Provider.of<CashProvider>(context);
    var projectProvider = Provider.of<ProjectProvider>(context);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
        text: isAdd ? cashProvider.cashes[index!].name : '');
    final priceController = TextEditingController(
        text: isAdd ? cashProvider.cashes[index!].price : '');
    final dateController = TextEditingController(
        text: isAdd ? cashProvider.cashes[index!].date : '');
    return AlertDialog(
      backgroundColor: AppTheme.white,
      title: const Text(
        'Cash Details',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    controller: nameController,
                    text: AppLocalizations.of(context)!.cashName,
                    keyboardType: TextInputType.text,
                    hasIcon: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterCashName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: priceController,
                    text: AppLocalizations.of(context)!.cashPrice,
                    keyboardType: TextInputType.number,
                    hasIcon: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterCashPrice;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DatePickerFormField(
                    controller: dateController,
                    text: AppLocalizations.of(context)!.cashDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterCashDate;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomBtn(
                    onPressed: () async {
                      // Show a dialog to let the user choose between camera and gallery
                      final ImageSource? source = await showDialog<ImageSource>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                Text(AppLocalizations.of(context)!.selectImage),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pop(ImageSource.camera),
                                child:
                                    Text(AppLocalizations.of(context)!.camera),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pop(ImageSource.gallery),
                                child: Text(
                                  AppLocalizations.of(context)!.gallery,
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (source != null) {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(
                          source: source,
                          imageQuality: 50,
                        );

                        if (pickedFile != null) {
                          cashProvider
                              .changeCurrentImage(File(pickedFile.path));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .imageAddedSuccess),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .noImageSelected),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.noImageSelected),
                          ),
                        );
                      }
                    },
                    text: AppLocalizations.of(context)!.uploadImage,
                  ),
                  const SizedBox(height: 20),
                  CustomBtn(
                    text: isAdd ? 'Update Cash' : 'Add Cash',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var uuid = const Uuid();
                        if (isAdd) {
                          cashProvider.updateCash(
                              cash: Cash(
                                id: cashProvider.cashes[index!].id,
                                name: nameController.text,
                                cashNumber: '',
                                price: priceController.text,
                                date: dateController.text,
                                imageURl: cashProvider.cashes[index!].imageURl,
                              ),
                              project: projectProvider.currentProject,
                              userId: authProvider.currentUser!.id,
                              imageFile: cashProvider.currentImage,
                              context: context,
                              isImageUpdated: cashProvider.currentImage != null
                                  ? true
                                  : false);
                        } else {
                          cashProvider.addCash(
                            cash: Cash(
                              id: uuid.v4(),
                              name: nameController.text,
                              cashNumber: '',
                              price: priceController.text,
                              date: dateController.text,
                            ),
                            project: projectProvider.currentProject,
                            userId: authProvider.currentUser!.id,
                            imageFile: cashProvider.currentImage,
                            context: context,
                          );
                        }
                        projectProvider.getTotalMoney();
                        cashProvider.changeCurrentImage(null);
                        nameController.clear();
                        priceController.clear();
                        dateController.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAdd
                                  ? AppLocalizations.of(context)!.updateProject
                                  : AppLocalizations.of(context)!.addCash,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
