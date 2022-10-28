import 'package:fluttertoast/fluttertoast.dart';
import '../const/colors.dart';

showToast({required String message}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor:skyBlue.withOpacity(.7),
      textColor: white,
      fontSize: 16.0
  );
}