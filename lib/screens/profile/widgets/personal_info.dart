import 'dart:convert';
import 'dart:io';

import 'package:afrikunet/components/buttons/primary.dart';
import 'package:afrikunet/components/dialog/custom_dialog.dart';
import 'package:afrikunet/components/inputfield/lineddropdown2.dart';
import 'package:afrikunet/components/inputfield/lineddropdown3.dart';
import 'package:afrikunet/components/inputfield/lineddropdown4.dart';
import 'package:afrikunet/components/inputfield/lineddropdown5.dart';
import 'package:afrikunet/components/inputfield/llinedtextfield.dart';
import 'package:afrikunet/components/picker/img_picker.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/constants/countries.dart';
import 'package:afrikunet/helper/preference/preference_manager.dart';
import 'package:afrikunet/helper/service/api_service.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Personal extends StatefulWidget {
  final PreferenceManager manager;
  const Personal({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  final _fnameController = TextEditingController();
  final _mnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isImagePicked = false;
  var _croppedFile;

  List<Map<String, String>> _states = [];

  String _selectedGender = "Male";
  Map _selectedCountry = {};
  Map _selectedState = {};
  var _selectedLanguage = {"flag": "🇬🇧", "code": "en", "label": 'English'};

  String? _genderLabel = "Male";
  bool _shouldEdit = false;
  String _isoCode = "+234", _countryCode = "NG";

  // final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  List<Map<String, dynamic>> _countries = [];

  _onSelected(val) {
    setState(() {
      _selectedGender = val;
      _shouldEdit = true;
    });
  }

  _onCountryFiltered(val) {
    setState(() {
      _countries = val;
    });
  }

  _onStateSelected(val) {
    setState(() {
      _shouldEdit = true;
      _selectedState = val;
    });
  }

  _onCountrySelected(val) {
    print("SELECTED COUNTRY ::: $val");

    setState(() {
      _states = [];
      _selectedCountry = val;
      _shouldEdit = true;
    });

    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() => _states = val['states']),
    );
  }

  _onLanguageSelected(val) {
    print("SELECTED LANGUAGE ::: $val");
    setState(() {
      _selectedLanguage = val;
      _shouldEdit = true;
    });
  }

  _onImageSelected(var file) {
    setState(() {
      _isImagePicked = true;
      _croppedFile = file;
    });
    debugPrint("VALUIE::: :: $file");
  }

  @override
  void initState() {
    super.initState();
    print("USER DATA ::: ${widget.manager.getUser()}");

    try {
      setState(() {
        _countries = countries['data'];
        _fnameController.text =
            _controller.userData.value['first_name'].toString().capitalize ??
                widget.manager.getUser()['first_name'].toString().capitalize ??
                "";
        _mnameController.text = _controller.userData.value['middle_name'] !=
                null
            ? _controller.userData.value['middle_name'].toString().capitalize ??
                widget.manager.getUser()['middle_name'].toString().capitalize ??
                ""
            : "";
        _lnameController.text = _controller.userData.value['last_name'] != null
            ? _controller.userData.value['last_name'].toString().capitalize ??
                widget.manager.getUser()['last_name'].toString().capitalize ??
                ""
            : "";
        _phoneController.text = _controller.userData.value['phone_number'] ??
            widget.manager.getUser()['phone_number'] ??
            "";
        _emailController.text = _controller.userData.value['email_address'] ??
            widget.manager.getUser()['email_address'] ??
            "";
        _genderLabel =
            _controller.userData.value['gender'].toString().capitalize ??
                widget.manager.getUser()['gender'].toString().capitalize ??
                "Male";

        _addressController.text =
            _controller.userData.value['address']['street'] != null
                ? _controller.userData.value['address']['street']
                        .toString()
                        .capitalize ??
                    widget.manager
                        .getUser()['address']['street']
                        .toString()
                        .capitalize ??
                    ""
                : "";
        _cityController.text = _controller.userData.value['address']['city'] !=
                null
            ? _controller.userData.value['address']['city']
                    .toString()
                    .capitalize ??
                widget.manager
                    .getUser()['address']['city']
                    .toString()
                    .capitalize ??
                ""
            : "";
        _shouldEdit = _controller.croppedPic.value.isNotEmpty;
      });
    } catch (e) {
      print("JKS ERR :: $e");
    }
  }

  _updateProfile() async {
    _controller.setLoading(true);

    if (_controller.croppedPic.value.isEmpty) {
      Map _payload = {
        "first_name": _fnameController.text.toLowerCase(),
        "middle_name": _mnameController.text.toLowerCase(),
        "last_name": _lnameController.text.toLowerCase(),
        "gender": _selectedGender.toLowerCase(),
        "language": _selectedLanguage['code'].toString().toLowerCase(),
        "iso_code": _isoCode,
        "country_code": _countryCode,
        "phone_number": _phoneController.text,
        "is_profile_set": true,
        "international_phone_format": "$_isoCode ${_phoneController.text}",
        "address": {
          "street": _addressController.text.toLowerCase(),
          "state": _selectedState['name'].toLowerCase(),
          "country": _selectedCountry['name'].toLowerCase(),
          "city": _cityController.text.toLowerCase(),
        },
      };

      debugPrint("PAY:LOAD UPDATE:  >> ${_payload}");
      debugPrint("USER ID:  >> ${widget.manager.getUser()}");

      try {
        final resp = await APIService().updateProfile(
          accessToken: widget.manager.getAccessToken(),
          body: _payload,
          id: widget.manager.getUser()['email_address'],
        );

        debugPrint("ABOUT UPDATE:  >> ${resp.body}");
        _controller.setLoading(false);

        if (resp.statusCode == 200) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          Constants.toast(map['message']);

          final _prefs = await SharedPreferences.getInstance();

          //Refresh user profile
          String userData = jsonEncode(map['user']);
          widget.manager.setUserData(userData);
          _prefs.setString('user', userData);
          _controller.setUserData(map['user']);

          setState(() {
            _fnameController.text = map['user']['first_name'];
            _mnameController.text = map['user']['middle_name'];
            _lnameController.text = map['user']['last_name'];
            _phoneController.text = map['user']['phone_number'];

            _shouldEdit = false;
          });

          Constants.showSuccessDialog(
            context: context,
            title: "Profile Update",
            message:
                "${Constants.toast(map['message']) ?? "Profile updated successfully"}",
          );
        } else {
          Map<String, dynamic> map = jsonDecode(resp.body);
          Constants.toast(map['message']);
        }
      } catch (e) {
        _controller.setLoading(false);
        debugPrint(e.toString());
      }
    } else {
      try {
        //Now upload to Firebase Storage first
        final storageRef = FirebaseStorage.instance.ref();
        final fileRef = storageRef
            .child("photos")
            .child("${widget.manager.getUser()['email']}");
        final _resp = await fileRef.putFile(File(_controller.croppedPic.value));
        final url = await _resp.ref.getDownloadURL();

        //Now save this url to server
        Map _payload = {
          "first_name": _fnameController.text.toLowerCase(),
          "middle_name": _mnameController.text.toLowerCase(),
          "last_name": _lnameController.text.toLowerCase(),
          "gender": _selectedGender.toLowerCase(),
          "language": _selectedLanguage['code'].toString().toLowerCase(),
          "iso_code": _isoCode,
          "country_code": _countryCode,
          "phone_number": _phoneController.text.toString(),
          "photo": url,
          "international_phone_format": "$_isoCode ${_phoneController.text}",
          "address": {
            "street": _addressController.text.toLowerCase(),
            "state": _selectedState['name'].toLowerCase(),
            "country": _selectedCountry['name'].toLowerCase(),
            "city": _cityController.text.toLowerCase(),
          },
        };

        debugPrint("PAY:LOAD UPDATE:  >> ${_payload}");

        final resp = await APIService().updateProfile(
            accessToken: widget.manager.getAccessToken(),
            body: _payload,
            id: widget.manager.getUser()['id']);

        debugPrint("ABOUT UPDATE:  >> ${resp.body}");
        _controller.setLoading(false);

        if (resp.statusCode == 200) {
          Map<String, dynamic> map = jsonDecode(resp.body);
          Constants.toast(map['message']);

          //Refresh user profile
          String userData = jsonEncode(map['data']);
          widget.manager.setUserData(userData);

          setState(() {
            _fnameController.text = map['user']['first_name'];
            _mnameController.text = map['user']['middle_name'];
            _lnameController.text = map['user']['last_name'];
            _phoneController.text = map['user']['phone_number'];
            _cityController.text = map['user']['address']['city'];
            _phoneController.text = map['user']['phone_number'];
            _addressController.text = map['data']['address']['street'];

            _shouldEdit = false;
          });

          _controller.croppedPic.value = "";

          Constants.showSuccessDialog(
              context: context,
              title: "Profile Update",
              message:
                  "${Constants.toast(map['message']) ?? "Profile updated successfully"}");
        } else {
          Map<String, dynamic> map = jsonDecode(resp.body);
          print("JKJS SSS::: ${map}");
          Constants.toast(map['message']);
        }
      } catch (e) {
        _controller.setLoading(false);
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(
                      child: _isImagePicked
                          ? Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Image.file(
                                File(_croppedFile),
                                errorBuilder: (context, error, stackTrace) =>
                                    ClipOval(
                                  child: SvgPicture.asset(
                                    "assets/images/personal.svg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 128,
                              width: 128,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(64),
                              ),
                              child: Image.network(
                                "${widget.manager.getUser()['photo']}",
                                errorBuilder: (context, error, stackTrace) =>
                                    ClipOval(
                                  child: SvgPicture.asset(
                                    "assets/images/personal.svg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: -3,
                      child: CircleAvatar(
                        backgroundColor: Constants.primaryColor,
                        child: IconButton(
                          onPressed: () {
                            showBarModalBottomSheet(
                              expand: false,
                              context: context,
                              topControl: ClipOval(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        16,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.close,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              builder: (context) => SizedBox(
                                height: 175,
                                child: ImgPicker(
                                  onCropped: _onImageSelected,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: TextBody1(
                    text:
                        "Fill out the form below to update your profile information.",
                    align: TextAlign.center,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          LinedTextField(
            label: "First Name",
            onChanged: (val) {
              setState(() {
                _shouldEdit = true;
              });
            },
            controller: _fnameController,
            validator: (value) {
              if (value.toString().isEmpty || value == null) {
                return "First name is required";
              }
              return null;
            },
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 10.0,
          ),
          LinedTextField(
            label: "Middle Name",
            onChanged: (val) {
              setState(() {
                _shouldEdit = true;
              });
            },
            controller: _mnameController,
            validator: (value) {
              return null;
            },
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 10.0,
          ),
          LinedTextField(
            label: "Last Name",
            onChanged: (val) {
              setState(() {
                _shouldEdit = true;
              });
            },
            controller: _lnameController,
            validator: (value) {
              if (value.toString().isEmpty || value == null) {
                return "Last name is required";
              }
              return null;
            },
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 10.0,
          ),
          LinedTextField(
            label: "Email",
            isEnabled: false,
            onChanged: (val) {},
            controller: _emailController,
            validator: (value) {
              if (value.toString().isEmpty || value == null) {
                return "Email address is required";
              }
              return null;
            },
            inputType: TextInputType.emailAddress,
            capitalization: TextCapitalization.words,
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 6.0,
          ),
          LinedTextField(
            label: "Phone ",
            onChanged: (val) {
              setState(() {
                _shouldEdit = true;
              });
            },
            isFlexed: true,
            prefix: SizedBox(
              width: 110,
              child: CountryCodePicker(
                alignLeft: true,
                onChanged: (val) {
                  setState(() {
                    _countryCode = "${val.code}";
                    _isoCode = "${val.dialCode}";
                  });
                  // print("SELECTED CODE ::: ${val.code}");
                  // print("SELECTED DIAL CODE ::: ${val.dialCode}");
                },
                padding: const EdgeInsets.all(0.0),
                initialSelection: 'NG',
                favorite: const ['+234', 'NG'],
                showCountryOnly: true,
                showFlag: true,
                showDropDownButton: false,
                hideMainText: false,
                showOnlyCountryWhenClosed: false,
              ),
            ),
            controller: _phoneController,
            validator: (value) {
              if (value.isEmpty || value == null) {
                return "Phone number is required";
              }
              return null;
            },
            inputType: TextInputType.number,
            capitalization: TextCapitalization.none,
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 6.0,
          ),
          LinedDropdown2(
            label: "$_genderLabel",
            title: "Gender",
            onSelected: _onSelected,
            items: const ["Male", "Female"],
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 6.0,
          ),
          LinedDropdown3(
            label: _selectedLanguage,
            title: "Language",
            onSelected: _onLanguageSelected,
            items: const [
              {"flag": '🇬🇧', "code": 'en', "label": "English"},
              {"flag": '🇫🇷', "code": 'fr', "label": "French"},
              {"flag": '🇪🇸', "code": 'es', "label": "Spanish"},
              {"flag": '🇵🇹', "code": 'pt', "label": "Portuguese"},
            ],
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 6.0,
          ),
          LinedDropdown4(
            label: _selectedCountry,
            title: "Country",
            onSelected: _onCountrySelected,
            items: countries['data'],
            onFiltered: _onCountryFiltered,
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 6.0,
          ),
          LinedDropdown5(
            label: _selectedState,
            title: "State/Region",
            onSelected: _onStateSelected,
            items: _states,
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 6.0,
          ),
          LinedTextField(
            label: "City",
            onChanged: (val) {
              setState(() {
                _shouldEdit = true;
              });
            },
            controller: _cityController,
            validator: (value) {
              if (value.toString().isEmpty || value == null) {
                return "City name is required";
              }
              return null;
            },
            inputType: TextInputType.text,
            capitalization: TextCapitalization.words,
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 6.0,
          ),
          LinedTextField(
            label: "Address",
            onChanged: (val) {
              setState(() {
                _shouldEdit = true;
              });
            },
            controller: _addressController,
            validator: (value) {
              if (value.toString().isEmpty || value == null) {
                return "Street address is required";
              }
              return null;
            },
            inputType: TextInputType.streetAddress,
            capitalization: TextCapitalization.words,
          ),
          const Divider(
            color: Constants.accentColor,
          ),
          const SizedBox(
            height: 21.0,
          ),
          Obx(
            () => PrimaryButton(
              buttonText: _controller.isLoading.value
                  ? "Processing..."
                  : "Save Changes",
              foreColor: Colors.white,
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: !_shouldEdit && _controller.croppedPic.value.isEmpty ||
                      _controller.isLoading.value
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _updateProfile();
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
