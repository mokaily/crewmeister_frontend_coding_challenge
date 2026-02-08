import 'package:intl/intl.dart';

///  Get difference in days between two dates
int differenceInDays(DateTime startDate, DateTime endDate) {
  return endDate.difference(startDate).inDays;
}

///  Format date to "2021-01-23", etc.
String formatDateShort(DateTime date) {
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date);
}
