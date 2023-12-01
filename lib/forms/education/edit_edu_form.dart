import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/instance_manager.dart';
import 'package:afrikunet/components/button/roundedbutton.dart';
import 'package:afrikunet/components/inputfield/datefield.dart';
import 'package:afrikunet/components/inputfield/textfield.dart';
import 'package:afrikunet/components/picker/img_picker.dart';
import 'package:afrikunet/components/text_components.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';

class EditEducationForm extends StatefulWidget {
  final PreferenceManager manager;
  var itemData;
  int index;
  EditEducationForm({
    Key? key,
    required this.index,
    required this.manager,
    required this.itemData,
  }) : super(key: key);

  @override
  State<EditEducationForm> createState() => _UpdateEducationFormState();
}

class _UpdateEducationFormState extends State<EditEducationForm> {
  final _controller = Get.find<StateController>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _dateController = TextEditingController();

  final double _kItemExtent = 32.0;
  bool _stillHere = false;

  bool _isImagePicked = false;
  var _croppedFile;

  final List<String> _degreeNames = <String>[
    'O\'Level',
    'ND',
    'HND',
    'Bachelor',
    'Masters',
    'PhD',
  ];

  String _selectedDegree = "Select Degree";

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.itemData['school'];
      _courseController.text = widget.itemData['course'];
      _dateController.text = widget.itemData['endate'] ?? "";
      _stillHere = widget.itemData['stillSchooling'];
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  _onImageSelected(var file) {
    setState(() {
      _isImagePicked = true;
      _croppedFile = file;
    });
    // debugPrint("VALUIE::: :: $file");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.grey.shade300,
      child: Form(
        key: _formKey,
        child: Localizations(
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: const Locale('en', ''),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: _isImagePicked
                          ? Image.file(
                              File(_controller.croppedPic.value),
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "assets/images/placeholder.png",
                                width: 128,
                                height: 128,
                                fit: BoxFit.cover,
                              ),
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.itemData['schoolLogo'],
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "assets/images/placeholder.png",
                                width: 128,
                                height: 128,
                                fit: BoxFit.cover,
                              ),
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      bottom: -4,
                      right: -6,
                      child: CircleAvatar(
                        child: IconButton(
                          onPressed: () {
                            showCupertinoDialog(
                              context: context,
                              useRootNavigator: true,
                              builder: (context) => CupertinoAlertDialog(
                                title: TextPoppins(
                                  text: "Image Picker".toUpperCase(),
                                  fontSize: 18,
                                ),
                                content: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.96,
                                  height: 160,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 21,
                                      ),
                                      ImgPicker(
                                        onCropped: _onImageSelected,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: TextRoboto(
                                        text: "Close",
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              const Text(
                "Institution's Logo (optional)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              const SizedBox(
                height: 28.0,
              ),
              CustomTextField(
                hintText: "Institution name",
                onChanged: (val) {},
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name of institution is required';
                  }

                  return null;
                },
                inputType: TextInputType.text,
                capitalization: TextCapitalization.words,
              ),
              const SizedBox(
                height: 24.0,
              ),
              CustomTextField(
                hintText: "Course of study",
                onChanged: (val) {},
                controller: _courseController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Course of study is required';
                  }

                  return null;
                },
                inputType: TextInputType.text,
                capitalization: TextCapitalization.words,
              ),
              const SizedBox(
                height: 21.0,
              ),
              RoundedButton(
                bgColor: Colors.transparent,
                child: Text(
                  "Degree: $_selectedDegree",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ), //TextInter(text: "Select gender", fontSize: 16),
                borderColor: Colors.black54,
                foreColor: Colors.black54,
                onPressed: () {
                  _showDialog(
                    CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: _kItemExtent,

                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          _selectedDegree = _degreeNames[selectedItem];
                        });
                      },
                      children: List<Widget>.generate(_degreeNames.length,
                          (int index) {
                        return Text(
                          _degreeNames[index],
                          textAlign: TextAlign.left,
                        );
                      }),
                    ),
                  );
                },
                variant: "Outlined",
              ),
              const SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomDateField(
                      isEnabled: !_stillHere,
                      hintText: "Graduation Date",
                      onDateSelected: (String raw, String val) {
                        setState(() {
                          _dateController.text = val;
                        });
                      },
                      controller: _dateController,
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Row(
                    children: [
                      const Text("Still Schooling"),
                      CupertinoSwitch(
                        value: _stillHere,
                        activeColor: Constants.primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _stillHere = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                bgColor: Constants.primaryColor,
                child: const TextInter(text: "SAVE CHANGES", fontSize: 16),
                borderColor: Colors.transparent,
                foreColor: Colors.white,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _save(widget.index);
                  }
                },
                variant: "Filled",
              ),
            ],
          ),
        ),
      ),
    );
  }

  _save(index) async {
    _controller.setLoading(true);
    var li = widget.manager.getUser()['education'];
    var filter = li?.removeAt(index);

    try {
      if (_controller.croppedPic.value.isNotEmpty) {
        //Now upload to Firebase Storage first
        final storageRef = FirebaseStorage.instance.ref();
        final fileRef =
            storageRef.child("education").child(_nameController.text);
        final _resp = await fileRef.putFile(File(_controller.croppedPic.value));
        final url = await _resp.ref.getDownloadURL();

        //Now save this url to server
        Map _payload = {
          "education": [
            ...li,
            {
              "school": _nameController.text.toLowerCase(),
              "degree": _selectedDegree.toLowerCase(),
              "course": _courseController.text.toLowerCase(),
              "schoolLogo": url,
              "endate": _stillHere ? "" : _dateController.text,
              "stillSchooling": _stillHere
            }
          ]
        };

        // print("DATARIZZED::: $_payload}");

        final resp = await APIService().updateProfile(
          body: _payload,
          accessToken: widget.manager.getAccessToken(),
          email: widget.manager.getUser()['email'],
        );

        _controller.setLoading(false);
        debugPrint("EDU NEW RESPONSE:: ${resp.body}");

        if (resp.statusCode == 200) {
          Map<String, dynamic> _map = jsonDecode(resp.body);
          Constants.toast(_map['message']);

          //Nw save user's data to preference
          String userData = jsonEncode(_map['data']);
          widget.manager.setUserData(userData);
          _controller.userData.value = _map['data'];

          _controller.onInit();

          _controller.shouldExitExpEdu.value = true;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });
          // Navigator.of(context).pop();
        } else {
          Map<String, dynamic> _map = jsonDecode(resp.body);
          Constants.toast(_map['message']);
        }
      } else {
        Map payload = {
          "education": [
            ...li,
            {
              "school": _nameController.text.toLowerCase(),
              "degree": _selectedDegree.toLowerCase(),
              "course": _courseController.text.toLowerCase(),
              "schoolLogo": "",
              "endate": _stillHere ? "" : _dateController.text,
              "stillSchooling": _stillHere
            }
          ]
        };

        debugPrint("DATARIZZED::: $payload}");

        final _resp = await APIService().updateProfile(
          body: payload,
          accessToken: widget.manager.getAccessToken(),
          email: widget.manager.getUser()['email'],
        );

        _controller.setLoading(false);
        debugPrint("EDU EDIT RESPONSE:: ${_resp.body}");

        if (_resp.statusCode == 200) {
          Map<String, dynamic> _map = jsonDecode(_resp.body);
          Constants.toast(_map['message']);

          //Nw save user's data to preference
          String userData = jsonEncode(_map['data']);
          widget.manager.setUserData(userData);
          _controller.userData.value = _map['data'];

          _controller.onInit();

          // Navigator.pop(context);
          _controller.shouldExitExpEdu.value = true;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });

          // Navigator.of(context).pop();
        } else {
          Map<String, dynamic> _map = jsonDecode(_resp.body);
          Constants.toast(_map['message']);
        }
      }
    } catch (e) {
      _controller.setLoading(false);
      debugPrint(e.toString());
    }
  }
}
