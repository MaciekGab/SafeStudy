import 'package:flutter/material.dart';

extension StringExtension on String {
  String authReturn() {
    return "${this[0].toUpperCase()}${this.substring(1)}".replaceAll('-', ' ');
  }
}
final String passwordRegex = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';

enum ValidationError {
  isRequired,
  invalidEmail,
  shortPassword,
  weakPassword,
}

String returnValidationError(ValidationError validationError){
  switch(validationError) {
    case ValidationError.isRequired:
      return 'Filed is required';
    case ValidationError.invalidEmail:
      return 'Enter an email';
    case ValidationError.shortPassword:
      return 'Password must be at least 6 characters long';
    case ValidationError.weakPassword:
      return 'Password must contain an uppercase, lowercase, digit and special character';
    default:
      return 'Unhandled case';
  }
}
Future<DateTime> pickDate(BuildContext context, DateTime initialDate) async{
  var pickedDate = await showDatePicker(
      context: context, initialDate: initialDate,
      firstDate: DateTime(initialDate.year - 5),
      lastDate: DateTime(initialDate.year + 5)
  );
  if(pickedDate == null)
    return DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day
    );
  else
    return pickedDate;
}

Future<TimeOfDay> pickTime(BuildContext context, DateTime initialDate) async{
  final initialTime = TimeOfDay.fromDateTime(initialDate);
  final pickedTime = await showTimePicker(context: context, initialTime: initialTime);

  if(pickedTime == null)
    return initialTime;
  else
    return pickedTime;
}

Future<DateTime> pickDateAndTime(BuildContext context,DateTime date) async{
  final pickedDate = await pickDate(context, date);
  if(pickedDate == date)
    return date;
  else{
    final pickedTime = await pickTime(context, date);
    if(pickedTime == null)
      return date;
    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}

final String titleOfWaring = 'Warning';
final String bodyOfWaring = 'You have had contact with an infected person!';