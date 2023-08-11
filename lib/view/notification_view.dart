import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/view_model/notification_view_model.dart';

import '../colors.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.put(NotificationViewModel());
    return Scaffold(
        appBar: AppBar(
            
            centerTitle: false,
            elevation: 0,
            title: Obx(
              () => Column(
                children: [
                  state.isSearchVisible == true
                      ? Container(
                          // padding: EdgeInsets.only(
                          //     left: 30, right: 30, top: 40, bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          // margin: EdgeInsets.only(top: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                // padding: EdgeInsets.all(50.0),

                                child: Text('Nofifications',)
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (state.isSearchVisible ==
                                      true) state.changeSearchStatus(false);
                                },
                                child: Icon(Icons.search))
                            ],
                          ),
                        )
                      : Container(
                          // padding: EdgeInsets.all(40.0),
                          // margin: EdgeInsets.only(top: 20.0),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration:
                                      InputDecoration(hintText: 'Search here'),
                                  // onChanged: (value) {
                                  //   if (this.mounted)
                                  //     setState(() {
                                  //       search_query = value.toString();
                                  //       getProjectsFromSearch(search_query);
                                  //     });
                                  // },
                                  controller: state.searchController,
                                  onChanged: (query) {
                                    // getSuggestion(query);
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // if (this.mounted)
                                    state.changeSearchStatus(true);
                                  print(state.keySearch);
                                },
                                child: Icon(Icons.search)
                              )
                            ],
                          ),
                        ),
                ],
              ),
            )),
        body: OrientationBuilder(builder: (context, orientation) {
          return SingleChildScrollView(
            child: Container(
              height:
                  orientation == Orientation.portrait ? Get.height : Get.height * 2.0,
              width: Get.width,
              child: Column(children: [
                // is_search_visible == true
                //     ? Container(
                //         padding: EdgeInsets.all(40.0),
                //         margin: EdgeInsets.only(top: 40.0),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: <Widget>[
                //             Container(
                //                 // padding: EdgeInsets.all(50.0),

                //                 child: Text(
                //               'Messages',
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w600,
                //                   fontSize: 20.0,
                //                   color: Colors.black),
                //             )),
                //             GestureDetector(
                //               onTap: () {
                //                 if (this.mounted)
                //                   setState(() {
                //                     if (is_search_visible == true)
                //                       setState(() {
                //                         is_search_visible = false;
                //                       });
                //                   });
                //               },
                //               child: Container(
                //                 child: Image(
                //                     image: AssetImage('assets/icon_search.png')),
                //               ),
                //             )
                //           ],
                //         ),
                //       )
                //     : Container(
                //         padding: EdgeInsets.all(40.0),
                //         margin: EdgeInsets.only(top: 40.0),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             SizedBox(
                //               width: width * 0.7,
                //               height: 60,
                //               child: TextField(
                //                 decoration:
                //                     InputDecoration(hintText: 'Search here'),
                //                 onChanged: (value) {
                //                   if (this.mounted)
                //                     setState(() {
                //                       search_query = value.toString();
                //                       getNotificationsFromSearch(search_query);
                //                     });
                //                 },
                //               ),
                //             ),
                //             GestureDetector(
                //               onTap: () {
                //                 if (this.mounted)
                //                   setState(() {
                //                     is_search_visible = true;
                //                   });
                //               },
                //               child: Container(
                //                 child: Image(
                //                     image: AssetImage('assets/icon_search.png')),
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                
                  Container(
                    height: orientation == Orientation.portrait
                        ? Get.height * 0.68
                        : Get.height * 1.2,
                    padding: orientation == Orientation.portrait
                        ? EdgeInsets.all(10.0)
                        : EdgeInsets.all(20.0),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                          itemCount: 4,
                          shrinkWrap: true,
                          itemExtent: 100.0,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              padding: EdgeInsets.only(left: 10.0, top: 10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.black26))),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.pink,
                                  // backgroundImage:
                                  //     NetworkImage(profileUrl.toString()),
                                ),
                                title: new RichText(
                                  text: TextSpan(children: [
                                    new TextSpan(
                                        // text: notifications[index]
                                        //         ['notification'] +
                                        //     '\n',
                                        text: 'Notification title',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13.0,
                                            color: Colors.black)),
                                    new TextSpan(
                                        // text: notifications[index]
                                        //     ['updated_at'],
                                        text: 'Updated at',

                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: ColorsTheme.txtDescColor)),
                                  ]),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: Get.height * 0.3),
                    // margin: EdgeInsets.only(to),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorsTheme.btnColor),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: Get.height * 0.3),
                    // margin: EdgeInsets.only(to),
                    child: Text(
                      'No Notifications Found!',
                    ),
                  ),
              ]),
            ),
          );
        }));
  }
}
