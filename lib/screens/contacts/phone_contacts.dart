import 'package:afrikunet/components/shimmer/banner_shimmer.dart';
import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class PhoneContacts extends StatefulWidget {
  const PhoneContacts({Key? key}) : super(key: key);

  @override
  State<PhoneContacts> createState() => _PhoneContactsState();
}

class _PhoneContactsState extends State<PhoneContacts> {
  final _controller = Get.find<StateController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Constants.primaryColor,
                ),
              ),
            ),
            TextMedium(
              text: "My Contacts",
              color: Colors.black,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<List<Contact>>(
        future: FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) => const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: BannerShimmer(),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      SizedBox(
                        height: 32,
                        width: 100,
                        child: BannerShimmer(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                    width: 36,
                    child: BannerShimmer(),
                  ),
                ],
              ),
            );
          }

          final List<Contact>? contacts = snapshot.data;
          // debugPrint("LIST OF CONtacts $contacts");

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              return TextButton(
                onPressed: () {
                  // if (contacts?[index].emails!.isEmpty!) {
                  //   _controller.selectedContact.value = {
                  //     "email": "",
                  //     "phone": "${contacts?[index].phones[0].number ?? ""}"
                  //   };
                  // } else {
                  _controller.selectedContact.value = {
                    "email": "${contacts?[index].emails[0].address ?? ""}",
                    "phone": "${contacts?[index].phones[0].number ?? ""}"
                  };
                  // }

                  Get.back();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 5.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // CircleAvatar(
                        // backgroundImage: MemoryImage(
                        //   contacts![index].thumbnail!,
                        // ),
                        // ),
                        TextSmall(text: contacts?[index].displayName),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: (contacts ?? []).length,
          );
        },
      ),
    );
  }
}
