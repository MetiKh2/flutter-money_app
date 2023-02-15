import 'package:hive/hive.dart';
import 'package:money_app/models/money.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

Box<Money> hiveBox = Hive.box<Money>('moneyBox');
String year = Jalali.now().year.toString();
String month = Jalali.now().month.toString().length == 1
    ? '0${Jalali.now().month.toString()}'
    : Jalali.now().month.toString();
String day = Jalali.now().day.toString().length == 1
    ? '0${Jalali.now().day.toString()}'
    : Jalali.now().day.toString();

class Calculate {
  static String today() {
    return year + '/' + month + '/' + day;
  }

  static double payToday() {
    double result = 0;
    for (var val in hiveBox.values) {
      if (val.date == today() && val.isReceived == false) {
        result += double.parse(val.price);
      }
    }
    return result;
  }

  static double incomeToday() {
    double result = 0;
    for (var val in hiveBox.values) {
      if (val.date == today() && val.isReceived == true) {
        result += double.parse(val.price);
      }
    }
    return result;
  }

  static double payMonth() {
    double result = 0;
    for (var val in hiveBox.values) {
      if (val.date.substring(0, 4) == year &&
          val.date.substring(5, 7) == month &&
          val.isReceived == false) {
        result += double.parse(val.price);
      }
    }
    return result;
  }

  static double incomeMonth() {
    double result = 0;
    for (var val in hiveBox.values) {
      if (val.date.substring(0, 4) == year &&
          val.date.substring(5, 7) == month &&
          val.isReceived == true) {
        result += double.parse(val.price);
      }
    }
    return result;
  }

  static double payYear() {
    double result = 0;
    for (var val in hiveBox.values) {
      if (val.date.substring(0, 4) == year && val.isReceived == false) {
        result += double.parse(val.price);
      }
    }
    return result;
  }

  static double incomeYear() {
    double result = 0;
    for (var val in hiveBox.values) {
      if (val.date.substring(0, 4) == year && val.isReceived == true) {
        result += double.parse(val.price);
      }
    }
    return result;
  }
}
