import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme.dart';
import '../../models/client_transefer.dart';
import '../../providers/auth_manager_provider.dart';
import '../../providers/clients_transefer_provider.dart';
import '../../providers/project_provider.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_textfield.dart';

// ignore: must_be_immutable
class AddUpdateClientTransefer extends StatelessWidget {
  AddUpdateClientTransefer({super.key, required this.isAdd, this.index});
  bool isAdd;
  var index;
  @override
  Widget build(BuildContext context) {
    var clientTranferProvider = Provider.of<ClientsTranseferProvider>(context);
    var projectProvider = Provider.of<ProjectProvider>(context);
    var authProvider = Provider.of<AuthManagerProvider>(context);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    var nameController = TextEditingController(
        text: !isAdd ? clientTranferProvider.clintes![index].name : '');
    return AlertDialog(
      backgroundColor: AppTheme.white,
      title: const Text(
        'Invoice Date',
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
                children: [
                  CustomTextFormField(
                    controller: nameController,
                    text: 'Client Transfer Name',
                    keyboardType: TextInputType.text,
                    hasIcon: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter client transfer name';
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
                          clientTranferProvider
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
                    text: isAdd
                        ? 'Add Client Transfer'
                        : 'Update Client Transfer',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var uuid = const Uuid();
                        isAdd
                            ? clientTranferProvider.addClientTranserfer(
                                client: ClientTransefer(
                                  id: uuid.v4(),
                                  name: nameController.text,
                                ),
                                projectId: projectProvider.currentProject!.id,
                                userId: authProvider.currentUser!.id,
                                imageFile: clientTranferProvider.currentImage,
                                context: context,
                              )
                            : clientTranferProvider.updateClientTransfer(
                                client: ClientTransefer(
                                  id: clientTranferProvider.clintes![index].id,
                                  name: nameController.text,
                                ),
                                projectId: projectProvider.currentProject!.id,
                                userId: authProvider.currentUser!.id,
                                imageFile: clientTranferProvider.currentImage,
                                context: context,
                              );

                        clientTranferProvider.changeCurrentImage(null);
                        nameController.clear();
                        // Navigator.pop(context);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text(
                        //       isAdd
                        //           ? 'Added successfully'
                        //           : 'Updated successfully',
                        //     ),
                        //     duration: const Duration(seconds: 2),
                        //   ),
                        // );
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
