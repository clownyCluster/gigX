import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Details Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: ColorsTheme.bgColor),
      home: const ProjectDetailsPage(),
    );
  }
}

var height, width;

class ProjectDetailsPage extends StatefulWidget {
  const ProjectDetailsPage({super.key});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(is_pressed_project_details);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Container(
            width: width,
            height: orientation == Orientation.portrait ? height : height * 2.2,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(40.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text('Hi'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
