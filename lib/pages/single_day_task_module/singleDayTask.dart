import 'package:flutter/material.dart';
import 'package:gigX/pages/single_day_task_module/single_day_task_state.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../constant/constants.dart';

class SingleDayTask extends StatelessWidget {
  const SingleDayTask({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SingleDayTaskState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Tasks', style: kkBoldTextStyle().copyWith(fontSize: 24, color: Colors.grey[800]),),
        iconTheme: IconThemeData().copyWith(color: darkGrey),
        elevation: 0,
      ),
      body: state.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : state.myTodosResponse.data == null ||
                  state.myTodosResponse.data!.isEmpty
              ? Center(
                  child: Text(
                    'No task found!',
                    style: kkBoldTextStyle(),
                  ),
                )
              : Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Row(
                        //   children: [
                        //     Text(
                        //       'Tasks',
                        //       style: kkBoldTextStyle(),
                        //     ),
                        //   ],
                        // ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: state.myTodosResponse.data!.map((e) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    // border: Border.all(color: Color(0xffEE2841)),
                                    color: Color(0xff916BFE)),
                                padding: kStandardPadding(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            e.title ?? '',
                                            style: kkWhiteBoldTextStyle()
                                                .copyWith(fontSize: 20),
                                          ),
                                        ),
                                        Icon(
                                          Icons.notifications_outlined,
                                          color: Colors.white,
                                          size: 30,
                                        )
                                      ],
                                    ),
                                    // kText(
                                    //   txt: e.title,
                                    //   style:
                                    //       kkWhiteBoldTextStyle().copyWith(fontSize: 26),
                                    // ),
                                    kSizedBox(),
                                    // Text(e.description ?? ''),
                                    kText(
                                      txt: e.description,
                                      style: kkWhiteTextStyle(),
                                    ),
                                    // sSizedBox(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Due date: ',
                                          style: kWhiteTextStyle(),
                                        ),
                                        maxWidthSpan(),
                                        Text(
                                          e.endDate ?? '',
                                          style: kWhiteTextStyle(),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.white.withOpacity(0.4),
                                    ),

                                    // width: 200,
                                    // child: Row(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   children: [
                                    //     Stack(

                                    //       //alignment:new Alignment(x, y)
                                    //       children: <Widget>[
                                    //         new Icon(Icons.monetization_on,
                                    //             size: 36.0,
                                    //             color:
                                    //                 const Color.fromRGBO(218, 165, 32, 1.0)),
                                    //         new Positioned(
                                    //           left: 40.0,
                                    //           child: new Icon(Icons.monetization_on,
                                    //               size: 36.0,
                                    //               color: const Color.fromRGBO(
                                    //                   218, 165, 32, 1.0)),
                                    //         ),
                                    //         new Positioned(
                                    //           left: 80.0,
                                    //           child: new Icon(Icons.monetization_on,
                                    //               size: 36.0,
                                    //               color: const Color.fromRGBO(
                                    //                   218, 165, 32, 1.0)),
                                    //         )
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      // width: 200.0,
                                      width: double.infinity,
                                      // alignment: FractionalOffset.center,
                                      child: new Stack(
                                        //alignment:new Alignment(x, y)
                                        alignment: Alignment.centerRight,
                                        children: <Widget>[
                                          // new Icon(Icons.monetization_on,
                                          //     size: 36.0,
                                          //     color: const Color.fromRGBO(
                                          //         218, 165, 32, 1.0)),
                                          // Color(0xff916BFE)

                                          Positioned(
                                            right: 60,
                                            child: CircleAvatar(
                                              radius: 24,
                                              backgroundColor:
                                                  Color(0xff916BFE),
                                              child: CircleAvatar(
                                                  radius: 22,
                                                  backgroundImage: AssetImage(
                                                      'assets/person.png')),
                                            ),
                                          ),
                                          new Positioned(
                                            right: 30.0,
                                            child: CircleAvatar(
                                              radius: 24,
                                              backgroundColor:
                                                  Color(0xff916BFE),
                                              child: CircleAvatar(
                                                  radius: 22,
                                                  backgroundImage: AssetImage(
                                                      'assets/person.png')),
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundColor: Color(0xff916BFE),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.amber,
                                              radius: 22,
                                              // backgroundImage:
                                              //     AssetImage('assets/person.png'),
                                              child: Icon(
                                                Icons.plus_one_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        state.onCommentChanged(e.title!);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'Comments',
                                            style: kWhiteBoldTextStyle(),
                                          ),
                                          minWidthSpan(),
                                          Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                    sSizedBox(),
                                    if (state.commentMap[e.title] == true)
                                      if (e.comments == null ||
                                          e.comments!.isEmpty ||
                                          e.comments == [])
                                        Padding(
                                          padding: kStandardPadding(),
                                          child: Text(
                                            'No comments!',
                                            style: kWhiteTextStyle(),
                                          ),
                                        )
                                      else
                                        Column(
                                          children: e.comments!.map((f) {
                                            // Jiffy.parse('2021/01/19').format('MMMM do yyyy, h:mm:ss a');
                                            var dateTime = Jiffy(f.createdAt)
                                                .format("dd/MMM/yyyy");
                                            var expires = Jiffy(f.createdAt)
                                                .endOf(Units.DAY)
                                                .fromNow();

                                            return Container(
                                              padding: kStandardPadding(),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.mode_comment_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  minWidthSpan(),
                                                  Expanded(
                                                      child: Text(
                                                    f.comment!,
                                                    style: kWhiteTextStyle(),
                                                  )),
                                                  minWidthSpan(),
                                                  Text(
                                                    expires,
                                                    // '${f.createdAt!}',
                                                    style: sWhiteTextStyle(),
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}