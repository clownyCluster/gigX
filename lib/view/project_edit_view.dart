import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/service/toastService.dart';
import 'package:gigX/view_model/project_edit_view_model.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import '../constant/constants.dart';

class ProjectEditView extends StatelessWidget {
  const ProjectEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.put(ProjectDetailsEditViewModel());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Details',
          // style:
          //     kkBoldTextStyle().copyWith(fontSize: 20, color: Colors.grey[800]),
        ),
        elevation: 0,
        // backgroundColor: whiteColor,
        // actionsIconTheme: IconThemeData(color: Colors.grey[800]),
        // iconTheme: IconThemeData(color: Colors.grey[800]),
        // leading: InkWell(
        //     onTap: () {},
        //     child: Icon(
        //       Icons.arrow_back,
        //       color: Colors.grey[800],
        //     )),
        actions: [
          Icon(Icons.more_horiz),
          largeWidthSpan(),
        ],
      ),
      body: Container(
        padding: kStandardPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              // width: width * 0.55,
                              margin: EdgeInsets.only(left: 10.0),
                              child: Text(
                                state.taskData!.title.toString(),
                                maxLines: 1,
                                // style: kkBoldTextStyle().copyWith(fontSize: 18),
                              )),
                        ),
                        TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                side: BorderSide(
                                    color:
                                        // category_id == 0
                                        //     ? ColorsTheme.uIUxColor
                                        //     : category_id == 1
                                        //         ? ColorsTheme.inProgbtnColor
                                        //         : category_id == 2
                                        //             ? ColorsTheme.dangerColor
                                        //             :
                                        ColorsTheme.compbtnColor),
                                borderRadius: BorderRadius.circular(14.0),
                              )),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered) ||
                                    states.contains(MaterialState.focused))
                                  return ColorsTheme.txtDescColor;
                                return ColorsTheme.txtDescColor;
                              }),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered) ||
                                    states.contains(MaterialState.focused))
                                  return ColorsTheme.bgColor;

                                return ColorsTheme.bgColor;
                              }),
                            ),
                            child: Text(
                              state.taskData!.status == 0
                                  ? 'Todo'
                                  : state.taskData!.status == 1
                                      ? 'In Progress'
                                      : state.taskData!.status == 2
                                          ? 'Pending'
                                          : 'Complete',
                              style: TextStyle(
                                  color:
                                      // category_id == 0
                                      //     ? ColorsTheme.uIUxColor
                                      //     : category_id == 1
                                      //         ? ColorsTheme.inProgbtnColor
                                      //         : category_id == 2
                                      //             ? ColorsTheme.dangerColor
                                      //             :
                                      ColorsTheme.compbtnColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400),
                            ))
                      ],
                    ),
                    kSizedBox(),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            state.taskData!.icon!.isEmpty == true
                                ? Image.asset('assets/sample_logo.png')
                                : Image.network(
                                    state.taskData!.icon.toString(),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.fill,
                                  ),
                            SizedBox(
                              width: 10.0,
                            ),
                            AutoSizeText('eFleetPass', style: TextStyle(
                              fontSize: 16
                            ))
                          ]),
                    ),
                    LSizedBox(),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // showAssigneeDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage:
                                      AssetImage('assets/profile.png'),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      new AutoSizeText('Assigned to',
                                          style: TextStyle(
                                              
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w400)),
                                      Container(
                                        width: 120,
                                        child: new AutoSizeText(
                                          state.taskData!.assignTo == null ||
                                                  state.taskData!.assignTo == ''
                                              ? 'Unassigned'
                                              : state.taskData!.assignTo
                                                  .toString(),
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                    ])
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // var results = await showCalendarDatePicker2Dialog(
                              //   context: context,
                              //   barrierLabel: 'Date',
                              //   config: CalendarDatePicker2WithActionButtonsConfig(
                              //       selectedDayHighlightColor: ColorsTheme.btnColor,
                              //       okButton: Text(
                              //         'Done',
                              //         style: TextStyle(
                              //             color: ColorsTheme.btnColor,
                              //             fontWeight: FontWeight.w600,
                              //             fontSize: 16.0),
                              //       ),
                              //       shouldCloseDialogAfterCancelTapped: true),
                              //   dialogSize: const Size(325, 400),
                              //   borderRadius: BorderRadius.circular(15),
                              // );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/due_date_icon.png',
                                  color: ColorsTheme.compbtnColor,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                new RichText(
                                    text: TextSpan(children: [
                                  new TextSpan(
                                      text: 'Due Date \n',
                                      style: TextStyle(
                                          
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w400)),
                                  if (state.taskData!.endDate != null)
                                    new TextSpan(
                                        text: state.taskData!.endDate!,
                                        // TextSpan(text: '2078/09/08'),
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 46, 218, 83),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600)),
                                ]))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    LSizedBox(),
                    Container(
                      child: Text(
                        'PRIORITY',
                        style: kkBoldTextStyle(),
                      ),
                    ),
                    kSizedBox(),
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.grey[200],
                              border: Border.all(
                                  color: state.taskData!.priority == 0
                                      ? Colors.green
                                      : Colors.grey[600]!)),
                          child: Text('Low',
                              style: TextStyle(
                                  color: state.taskData!.priority == 0
                                      ? Colors.green
                                      : Colors.grey[600]!)),
                        ),
                        maxWidthSpan(),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.grey[200],
                              border: Border.all(
                                  color: state.taskData!.priority == 1
                                      ? Colors.yellow
                                      : Colors.grey[600]!)),
                          child: Text(
                            'High',
                            style: TextStyle(
                                color: state.taskData!.priority == 1
                                    ? Colors.yellow
                                    : Colors.grey[600]!),
                          ),
                        ),
                        maxWidthSpan(),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.grey[200],
                              border: Border.all(
                                  color: state.taskData!.priority == 2
                                      ? Colors.red
                                      : Colors.grey[600]!)),
                          child: Text(
                            'Urgent',
                            style: TextStyle(
                                color: state.taskData!.priority == 2
                                    ? Colors.red
                                    : Colors.grey[600]!),
                          ),
                        )
                      ],
                    ),
                    LSizedBox(),
                    Container(
                      // padding: EdgeInsets.all(20.0),
                      child: Text(
                        'DESCRIPTION',
                        // style: TextStyle(
                        //     color: Colors.grey.withOpacity(0.7),
                        //     fontSize: 14.0,
                        //     fontWeight: FontWeight.w600),
                        style: kkBoldTextStyle(),
                      ),
                    ),
                    kSizedBox(),
                    Text(
                      state.taskData!.description.toString(),
                      maxLines: 3,
                      style: TextStyle(
                          
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                    LSizedBox(),
                    Container(
                      child: Text(
                        'COMMENTS',
                        // style: TextStyle(
                        //     color: Colors.grey.withOpacity(0.7),
                        //     fontSize: 14.0,
                        //     fontWeight: FontWeight.w600),
                        style: kkBoldTextStyle(),
                      ),
                    ),
                    Obx(() {
                      return state.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: blueColor,
                              ),
                            )
                          : Container(
                              // margin: EdgeInsets.only(left: 20.0),
                              height: 150.0,
                              width: Get.width,
                              child: state.commentResponse!.data!.length == 0
                                  ? Center(
                                      child: Text(
                                        'No Comments Found!',
                                        style: TextStyle(
                                            
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.0),
                                      ),
                                    )
                                  : MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      removeBottom: true,
                                      child: ListView.builder(
                                          itemCount: state
                                              .commentResponse!.data!.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                radius: 20.0,
                                                backgroundImage: AssetImage(
                                                    'assets/profile.png'),
                                              ),
                                              title: new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    new AutoSizeText(
                                                        state
                                                            .commentResponse!
                                                            .data![index]
                                                            .comment!,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    new AutoSizeText(
                                                        state
                                                            .commentResponse!
                                                            .data![index]
                                                            .createdAt!,
                                                        style: TextStyle(
                                                            
                                                            fontSize: 10.0))
                                                  ]),
                                            );
                                          }),
                                    ),
                            );
                    })
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              // height: 150,
              width: Get.width,
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: Get.width * 0.7,
                          child: TextField(
                            onChanged: (value) {
                              // setState(() {
                              //   comment = value.toString();
                              // });
                            },
                            decoration:
                                InputDecoration(hintText: 'Add a comment'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 80,
                            height: 50,
                            child: TextButton(
                              onPressed: () async {
                                // bool result = await saveComment();
                                // if (result) {
                                //   ToastService().s('Comment Posted!');
                                //   getComments();
                                //   FocusScope.of(context).unfocus();
                                // }
                              },
                              style: ButtonStyle(
                                  // alignment: Alignment.bottomRight,
                                  // shape: MaterialStateProperty.all(
                                  //     RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(14.0))),
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorsTheme.btnColor)),
                              child: AutoSizeText(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
