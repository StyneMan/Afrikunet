import 'package:afrikunet/components/text/textComponents.dart';
import 'package:afrikunet/data/temp_history.dart';
import 'package:afrikunet/helper/formatters/date_formatter.dart';
import 'package:afrikunet/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    CupertinoIcons.back,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              TextMedium(
                text: "History",
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: _controller.userHistory.value.isEmpty
            ? const SizedBox()
            : ListView.separated(
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
                            index == 2 || index == 5
                                ? SvgPicture.asset(
                                    "assets/images/${tempHistory[index].icon}",
                                    color: index == 5 ? Colors.red : null,
                                  )
                                : SvgPicture.asset(
                                    "assets/images/${tempHistory[0].icon}",
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
                                    "${_controller.userHistory.value[index]['title']}",
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  TextBody2(
                                    text: formatDate(
                                      DateTime.parse(_controller.userHistory
                                          .value[index]['created_at']),
                                    ),
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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
                itemCount: _controller.userHistory.value.length,
              ),
      ),
    );
  }
}
