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
                    text: 'Cash Name',
                    keyboardType: TextInputType.text,
                    hasIcon: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cash name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: priceController,
                    text: 'Price',
                    keyboardType: TextInputType.number,
                    hasIcon: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DatePickerFormField(
                    controller: dateController,
                    text: 'Cash date',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your date';
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
                            title: const Text('Select Image Source'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pop(ImageSource.camera),
                                child: const Text('Camera'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pop(ImageSource.gallery),
                                child: const Text('Gallery'),
                              ),
                            ],
                          );
                        },
                      );

                      if (source != null) {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: source);

                        if (pickedFile != null) {
                          print('Image Added Successfully');
                          cashProvider
                              .changeCurrentImage(File(pickedFile.path));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Image Added Successfully'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No Image Selected'),
                            ),
                          );
                          print('No image selected.');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No Image Selected'),
                          ),
                        );
                        print('No image selected.');
                      }
                    },
                    text: 'Upload Image',
                  ),
                  const SizedBox(height: 20),
                  CustomBtn(
                    text: isAdd ? 'Update Cash' : 'Add Cash',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var uuid = const Uuid();
                        isAdd
                            ? cashProvider.updateCash(
                                cash: Cash(
                                  id: cashProvider.cashes[index!].id,
                                  name: nameController.text,
                                  cashNumber: '',
                                  price: priceController.text,
                                  date: dateController.text,
                                ),
                                projectId: projectProvider.currentProject!.id,
                                userId: authProvider.currentUser!.id,
                                imageFile: cashProvider.currentImage,
                              )
                            : cashProvider.addCash(
                                cash: Cash(
                                  id: uuid.v4(),
                                  name: nameController.text,
                                  cashNumber: '',
                                  price: priceController.text,
                                  date: dateController.text,
                                ),
                                projectId: projectProvider.currentProject!.id,
                                userId: authProvider.currentUser!.id,
                                imageFile: cashProvider.currentImage,
                              );
                        cashProvider.changeCurrentImage(null);
                        nameController.clear();
                        priceController.clear();
                        dateController.clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAdd
                                  ? 'Updated successfully'
                                  : 'Added successfully',
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
}
