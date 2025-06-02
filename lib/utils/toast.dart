import 'package:fluttertoast/fluttertoast.dart';
import 'package:recruitment_agents/utils/colors.dart';

class AppToast {
  static void showToastSuccess(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.PRIMARY,
      textColor: AppColors.TEXTWHITE,
      fontSize: 12,
    );
  }

  static void showToastInfo(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.PRIMARY,
      textColor: AppColors.TEXTWHITE,
      fontSize: 16,
    );
  }

  static void showToastError(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: AppColors.RED,
      textColor: AppColors.TEXTWHITE,
      fontSize: 12.0,
    );
  }
}
