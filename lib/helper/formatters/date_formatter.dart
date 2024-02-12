import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  // Create a formatter with the desired format
  final formatter = DateFormat('MM/dd/yyyy hh:mma');

  // Format the DateTime using the formatter
  return formatter.format(dateTime);
}
