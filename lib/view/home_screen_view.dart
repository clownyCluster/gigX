import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/model/constant_models.dart';
import 'package:gigX/service/toastService.dart';
import 'package:gigX/view_model/home_screen_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import '../constant/constants.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final state = Get.put(HomeScreenViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Init state chalyo haii');
    state.getDeviceToken();
    state.getProjects();
  }

  @override
  Widget build(BuildContext context) {
    showColorPickUpDialog() {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  // insetPadding: EdgeInsets.zero,
                  title: Text('Pick a Color!', style: kBoldTextStyle()),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: state.pickerColor.value,
                      onColorChanged: (val) {
                        state.onColorChanged(val);
                      },
                    ),
                    // Use Material color picker:
                    //
                    // child: MaterialPicker(
                    //   pickerColor: pickerColor,
                    //   onColorChanged: changeColor,
                    //   showLabel: true, // only on portrait mode
                    // ),
                    //
                    // Use Block color picker:
                    //
                    // child: BlockPicker(
                    //   pickerColor: currentColor,
                    //   onColorChanged: changeColor,
                    // ),
                    //
                    // child: MultipleChoiceBlockPicker(
                    //   pickerColors: currentColors,
                    //   onColorsChanged: changeColors,
                    // ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "Cancel",
                        style: kTextStyle().copyWith(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                        child: Text(
                          'Ok',
                          style: kTextStyle().copyWith(color: primaryColor),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        }),
                  ],
                );
              },
            );
          });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // backgroundColor: whiteColor,
        appBar: AppBar(
            // backgroundColor: state.isDark.value ? greyColor : Colors.white,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('MFA Projects',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${state.isLoading.value ? '' : state.productList['data']?.length} projects',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (this.mounted) if (state.isSearchVisible ==
                                      true) state.changeSearchStatus(false);
                                },
                                child: Container(
                                  child: Icon(Icons.search),
                                ),
                              )
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
                                  if (this.mounted)
                                    state.changeSearchStatus(true);
                                  print(state.keySearch);
                                },
                                child: Container(
                                  child: Icon(Icons.search),
                                ),
                              )
                            ],
                          ),
                        ),
                ],
              ),
            )),
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          return state.isLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : state.productList['data'] == null ||
                      state.productList['data']!.isEmpty
                  ? Center(
                      child: Text('No project found'),
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      width: Get.width,
                      child: ListView.builder(
                          // controller: controller,
                          itemCount: state.productList['data']!.length,
                          // shrinkWrap: true,
                          // itemExtent: 105.0,
                          itemBuilder: (BuildContext context, index) {
                            return GestureDetector(
                              onTap: () async {
                                Get.toNamed(RouteName.projectDetailsScreen,
                                    arguments: state.productList['data']![index]
                                        ['id']);
                                print(state.productList['data']![index]
                                    .toString());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  children: [
                                    state.productList['data'][index]
                                                ['logo_url'] ==
                                            null
                                        ? Image.asset(
                                            'assets/sample_logo.png',
                                            height: 50,
                                            width: 50,
                                          )
                                        : Image.network(
                                            state.productList['data'][index]
                                                ['logo_url'],
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.fill,
                                          ),
                                    maxWidthSpan(),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.productList['data'][index]
                                                  ['title'],
                                              maxLines: 1,
                                              style: TextStyle().copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            AutoSizeText(
                                              state.productList['data'][index]
                                                  ['description'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ]),
                                    ),
                                    maxWidthSpan(),
                                    // InkWell(
                                    //   onTap: () {},
                                    //   child: Image(
                                    //     image: AssetImage(
                                    //         'assets/arrow_details.png'),
                                    //   ),
                                    // )
                                    Icon(Icons.arrow_circle_right_outlined)
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
        }),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
            // backgroundColor: state.isDark.value ? buttonColor : blueColor,
            child: ImageIcon(
              AssetImage('assets/add_project.png'),
              color: state.isDark.value ? darkGrey : whiteColor,
            ),
            onPressed: () {
              Get.bottomSheet(Obx(() => Form(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color:
                              Get.isDarkMode ? Colors.grey[800] : whiteColor),
                      // height: 600.0,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PROJECT NAME',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14.0),
                          ),
                          TextFormField(
                            controller: state.titleController.value,
                            decoration: InputDecoration(
                              hintText: 'Name',
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Name cannot be null';
                              }
                            },
                          ),
                          LSizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // if (picked == false)
                              GestureDetector(
                                onTap: () {
                                  state.pickImage(ImageSource.gallery);
                                },
                                child: Image(
                                  image:
                                      AssetImage('assets/plus_add_project.png'),
                                ),
                              ),
                              largeWidthSpan(),
                              state.image1 != null
                                  ? Image.file(
                                      File(state.image1!.path.toString()),
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.cover,
                                    )
                                  : AutoSizeText('Add Project Thumbnail')
                            ],
                          ),
                          LSizedBox(),
                          Text(
                            'Description',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14.0),
                          ),
                          TextField(
                            // controller: txtProjectDescController,
                            // onChanged: (value) {
                            //   setState(() {
                            //     txtProjectDesc = value.toString();
                            //   });
                            // },
                            controller: state.descriptionController.value,
                            decoration: InputDecoration(
                              hintText: 'Description',
                            ),
                          ),
                          kSizedBox(),
                          Text(
                            'Duration',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14.0),
                          ),
                          LSizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  DateTimeRangePicker(
                                      startText: "From",
                                      endText: "To",
                                      doneText: "Yes",
                                      cancelText: "Cancel",
                                      interval: 5,
                                      initialStartTime: DateTime.now(),
                                      initialEndTime: DateTime.now()
                                          .add(Duration(days: 20)),
                                      mode: DateTimeRangePickerMode.dateAndTime,
                                      minimumTime: DateTime.now()
                                          .subtract(Duration(days: 5)),
                                      maximumTime: DateTime.now()
                                          .add(Duration(days: 365)),
                                      use24hFormat: false,
                                      onConfirm: (start, end) {
                                        state.onStartAndEndDateTimeChanged(
                                            start, end);
                                        // formatted_start_date =
                                        // DateFormat('dd/MM/yyyy HH:mm')
                                        //     .format(start);
                                        // formatted_end_date =
                                        //     DateFormat('dd/MM/yyyy HH:mm')
                                        //         .format(end);

                                        // setState(() {
                                        //   duration_selected = true;
                                        //   print(formatted_end_date);
                                        // });
                                      }).showPicker(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Image(
                                    image:
                                        AssetImage('assets/due_date_icon.png'),
                                  ),
                                ),
                              ),
                              // duration_selected
                              //     ? AutoSizeText(formatted_end_date!)
                              //     :
                              state.startDate.value == null ||
                                      state.endDate.value == null
                                  ? AutoSizeText('Select Duration')
                                  : Text(
                                      '${DateFormat('dd/MM/yyyy').format(state.startDate.value!)} - ${DateFormat('dd/MM/yyyy').format(state.endDate.value!)}')
                            ],
                          ),
                          LSizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Colors',
                                style: kBoldTextStyle(),
                              ),
                              sSizedBox(),
                              InkWell(
                                onTap: () {
                                  showColorPickUpDialog();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: kStandardPadding(),
                                  child: Row(
                                    children: [
                                      Obx(
                                        () => SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Container(
                                            color: state.pickerColor.value,
                                          ),
                                        ),
                                      ),
                                      Center(
                                          child: Text(
                                        ' Pick Color',
                                      )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          LSizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              
                              ElevatedButton(
                                  onPressed: () {
                                    state.createProjects();
                                  },
                                  child: Text('Create')),
                            ],
                          )
                        ],
                      ),
                    ),
                  )));
            }),
      ),
    );
  }
}
