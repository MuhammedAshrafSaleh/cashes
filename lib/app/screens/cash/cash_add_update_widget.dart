import 'dart:io';

import 'package:cashes/app/core/utls.dart';
import 'package:cashes/app/models/project.dart';
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

class AddUpdateTask extends StatefulWidget {
  final bool isAdd;
  final int? index;
  const AddUpdateTask({super.key, required this.isAdd, this.index});

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  late final TextEditingController nameController;

  late final TextEditingController priceController;

  late final TextEditingController dateController;
  File? image;
  void selectImage(bool isGallary) async {
    final pickedImage =
        isGallary ? await pickGallaryImage() : await pickCameraImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    final cashProvider = Provider.of<CashProvider>(context, listen: false);
    final index = widget.index;

    nameController = TextEditingController(
        text: widget.isAdd ? cashProvider.cashes[index!].name : '');
    priceController = TextEditingController(
        text: widget.isAdd ? cashProvider.cashes[index!].price : '');
    dateController = TextEditingController(
        text: widget.isAdd ? cashProvider.cashes[index!].date : '');
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthManagerProvider>(context);
    var cashProvider = Provider.of<CashProvider>(context);
    var projectProvider = Provider.of<ProjectProvider>(context);
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      backgroundColor: AppTheme.white,
      title: Text(
        AppLocalizations.of(context)!.cashDetails,
        style: const TextStyle(
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
                      await showDialog<ImageSource>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                Text(AppLocalizations.of(context)!.selectImage),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  selectImage(false);
                                  // Navigator.pop(context);
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.camera),
                              ),
                              TextButton(
                                onPressed: () {
                                  selectImage(true);
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.gallery),
                              ),
                            ],
                          );
                        },
                      );

                      // Log the selected source
                      print('Selected ImageSource: $image');
                      if (image != null) {
                        cashProvider.changeCurrentImage(image);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .imageAddedSuccess),
                          ),
                        );
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
                    text: widget.isAdd
                        ? AppLocalizations.of(context)!.updateCash
                        : AppLocalizations.of(context)!.addCash,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        Project project = projectProvider.currentProject!;
                        var uuid = const Uuid();
                        if (widget.isAdd) {
                          await cashProvider.updateCash(
                            cash: Cash(
                              id: cashProvider.cashes[widget.index!].id,
                              name: nameController.text,
                              cashNumber: '',
                              price: priceController.text,
                              date: dateController.text,
                              imageURl:
                                  cashProvider.cashes[widget.index!].imageURl,
                            ),
                            project: projectProvider.currentProject,
                            userId: authProvider.currentUser!.id,
                            imageFile: cashProvider.currentImage,
                            context: context,
                            isImageUpdated: cashProvider.currentImage != null
                                ? true
                                : false,
                          );
                          project.hasNotification = "تم التعديل";
                        } else {
                          if (cashProvider.cashes.length >= 25) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("لا يمكنك الاضافة أكثر من 25"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            await cashProvider.addCash(
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
                            project.hasNotification = "تم الاضافة";
                          }
                        }
                        print(project.hasNotification);
                        projectProvider.updateProject(
                          project: project,
                          userId: authProvider.currentUser!.id,
                          context: context,
                        );
                        cashProvider.changeCurrentImage(null);
                        nameController.clear();
                        priceController.clear();
                        dateController.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.isAdd
                                  ? AppLocalizations.of(context)!.updateProject
                                  : AppLocalizations.of(context)!.addCash,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
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

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
