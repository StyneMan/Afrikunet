import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/temp_history.dart';
import 'package:afrikunet/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

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
                  color: Colors.black54,
                ),
              ),
            ),
            TextMedium(
              text: "History",
              color: Colors.black,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4.0,
                    ),
                    SvgPicture.asset(
                      "assets/images/${tempHistory[index].icon}",
                      color: index == 3 ? Colors.red : null,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tempHistory[index].title,
                            softWrap: true,
                          ),
                          TextBody2(
                            text: tempHistory[index].date,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // const SizedBox(width: 8.0),
              // IconButton(
              //   onPressed: () {},
              //   icon: SvgPicture.asset("assets/images/delete.svg"),
              // ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const Column(
            children: <Widget>[
              SizedBox(height: 8.0),
              Divider(),
              SizedBox(height: 8.0),
            ],
          );
        },
        itemCount: tempHistory.length,
      ),
    );
  }
}
