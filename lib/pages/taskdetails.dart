import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/pages/projectdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Details Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: ColorsTheme.bgColor),
      home: const TaskDetailsPage(),
    );
  }
}

var height, width;

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Container(
            width: width,
            height: orientation == Orientation.portrait
                ? height * 1.58
                : height * 3.2,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: IconButton(
                          onPressed: () async {
                            Navigator.of(context, rootNavigator: false).push(
                                MaterialPageRoute(
                                    builder: (context) => ProjectDetails()));
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          )),
                    ),
                    Container(
                      child: Image(image: AssetImage('assets/dots_icon.png')),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(18.0),
                margin: EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: width * 0.55,
                        margin: EdgeInsets.only(left: 10.0),
                        child: AutoSizeText(
                          'Create a Landing Page',
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600),
                        )),
                    FittedBox(
                      child: SizedBox(
                        height: 40.0,
                        width: width * 0.3,
                        child: TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                side: BorderSide(
                                    color: ColorsTheme.inProgbtnColor),
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
                              'Inprogress',
                              style: TextStyle(
                                  color: ColorsTheme.inProgbtnColor,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(30.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Image.asset('assets/sample_logo.png'),
                  SizedBox(
                    width: 10.0,
                  ),
                  AutoSizeText(
                    'eFleetPass',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  )
                ]),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showAssigneeDialog(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          new RichText(
                              text: TextSpan(children: [
                            new TextSpan(
                                text: 'Assigned to \n',
                                style: TextStyle(
                                    color: ColorsTheme.txtDescColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400)),
                            new TextSpan(
                                text: 'Anil Shrestha',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600)),
                          ]))
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var results = await showCalendarDatePicker2Dialog(
                          context: context,
                          barrierLabel: 'Date',
                          config: CalendarDatePicker2WithActionButtonsConfig(
                              selectedDayHighlightColor: ColorsTheme.btnColor,
                              okButton: Text(
                                'Done',
                                style: TextStyle(
                                    color: ColorsTheme.btnColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              ),
                              shouldCloseDialogAfterCancelTapped: true),
                          dialogSize: const Size(325, 400),
                          borderRadius: BorderRadius.circular(15),
                        );
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
                                    color: ColorsTheme.txtDescColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400)),
                            new TextSpan(
                                text: 'Anil Shrestha',
                                style: TextStyle(
                                    color: ColorsTheme.compbtnColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600)),
                          ]))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: AutoSizeText(
                  'PRIORITY',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Row(children: [
                  SizedBox(
                    width: width * 0.2,
                    height: 40.0,
                    child: TextButton(
                        onPressed: () {
                          setState(() {});
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
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
                              return Colors.red.shade100;

                            return Colors.red.shade100;
                          }),
                        ),
                        child: Text(
                          'High',
                          style: TextStyle(
                              color: ColorsTheme.inCompbtnColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: width * 0.3,
                    height: 40.0,
                    child: TextButton(
                        onPressed: () {
                          setState(() {});
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(30.0),
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
                          'Medium',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    width: width * 0.2,
                    height: 40.0,
                    child: TextButton(
                        onPressed: () {
                          setState(() {});
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(30.0),
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
                          'Low',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400),
                        )),
                  ),
                ]),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: AutoSizeText(
                  'DESCRIPTION',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                width: width * 0.95,
                child: AutoSizeText(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ',
                  style: TextStyle(
                      color: ColorsTheme.txtDescColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: AutoSizeText(
                  'ATTACHMENTS',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Container(
                  height: 90.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 90.0,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/attachment_1.png'))),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            height: 90.0,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/attachment_1.png'))),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            height: 90.0,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/attachment_1.png'))),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(8),
                              dashPattern: [6, 6],
                              color: Colors.grey,
                              strokeWidth: 2,
                              child: Container(
                                height: 90.0,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/upload_image_button_icon.png'))),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: AutoSizeText(
                  'ACTIVITIES',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                // margin: EdgeInsets.only(left: 20.0),
                height: 150.0,
                width: width,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                          title: new RichText(
                              text: TextSpan(children: [
                            new TextSpan(
                                text:
                                    'Leonardo De La Vega created this task \n',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text: 'Yesterday at 01:23 PM',
                                style: TextStyle(
                                    color: ColorsTheme.txtDescColor,
                                    fontSize: 10.0))
                          ])),
                        );
                      }),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: AutoSizeText(
                  'NOTES',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  new RichText(
                      text: TextSpan(children: [
                    new TextSpan(
                        text: 'Anil Shrestha',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600)),
                    new TextSpan(
                        text: '\n Just Now',
                        style: TextStyle(
                            color: ColorsTheme.txtDescColor,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400)),
                  ]))
                ]),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                width: width * 0.95,
                child: AutoSizeText(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ',
                  style: TextStyle(
                      color: ColorsTheme.txtDescColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                height: 150,
                width: width,
                color: Colors.white,
                child: Column(children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Add a Note or post an update'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.alternate_email)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.camera_alt)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.photo)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.attach_file)),
                    ],
                  ),
                ]),
              ),
            ]),
          ),
        );
      }),
    );
  }
}

Future<dynamic> showAssigneeDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        "ASSIGNEE",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14.0),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                  fillColor: Color(0xffEBEBEB), hintText: "Name or Email"),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text(
            "Save",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                color: ColorsTheme.btnColor),
          ),
        ),
      ],
    ),
  );
}
