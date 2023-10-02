import 'package:get/get.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/home.dart';
import 'package:gigX/model/home_model.dart';
import 'package:gigX/pages/chat_module/single_chat_module/single_chat_screen.dart';
import 'package:gigX/pages/register_module/register_screen.dart';
import 'package:gigX/pages/single_day_task_module/single_day_task_state.dart';
import 'package:gigX/view/login_view.dart';
import 'package:gigX/view/notification_old_view.dart';
import 'package:gigX/view/privacy_policy_view.dart';
import 'package:gigX/view/project_details_view.dart';
import 'package:gigX/view/project_edit_view.dart';
import 'package:gigX/view/task_view.dart';
import 'package:gigX/view/terms_and_condition_view.dart';
import 'package:gigX/view/time_box_view.dart';
import 'package:provider/provider.dart';

class AppRoute {
  static getRoutes() => [
        GetPage(
          name: RouteName.homeScreen,
          page: () => HomeView(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 500),
        ),
        GetPage(
            name: RouteName.loginScreen,
            page: () => LoginView(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: Duration(milliseconds: 500)),
        GetPage(
          name: RouteName.projectDetailsScreen,
          page: () => ProjectDetailsView(),
          transition: Transition.noTransition,
          // transition: Transition.rightToLeftWithFade,
          // transitionDuration: Duration(milliseconds: 500)
        ),
        GetPage(
          name: RouteName.taskScreen,
          page: () => TaskViewScreen(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 500),
        ),
        GetPage(
          name: RouteName.termsAndConditionScreen,
          page: () => TermsAndConditionView(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 500),
        ),
        GetPage(
          name: RouteName.privacyPolicyScreen,
          page: () => PriavcyPolicyView(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 500),
        ),
        GetPage(
          name: RouteName.timeBoxScreen,
          page: () => TimeboxView(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 500),
        ),
        GetPage(
          name: RouteName.projectEditScreen,
          page: () => ProjectEditView(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 500),
        ),
        GetPage(
          name: RouteName.registerScreen,
          page: () => RegisterScreen(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 500),
        ),
        GetPage(
          name: RouteName.oldNotificationScreen,
          page: () => NotificationOldView(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 500),
        ),
        GetPage(
          name: RouteName.singleChatScreen,
          page: () => SingleChatScreen(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: Duration(milliseconds: 500),
        ),
      ];
}
