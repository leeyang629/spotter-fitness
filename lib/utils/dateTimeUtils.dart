formatDateDDMMMYYYY(DateTime date) {
  var result = '';
  result = result + date.day.toString();
  switch (date.month) {
    case 1:
      result = '$result Jan';
      break;
    case 2:
      result = '$result Feb';
      break;
    case 3:
      result = '$result Mar';
      break;
    case 4:
      result = '$result Apr';
      break;
    case 5:
      result = '$result May';
      break;
    case 6:
      result = '$result Jun';
      break;
    case 7:
      result = '$result Jul';
      break;
    case 8:
      result = '$result Aug';
      break;
    case 9:
      result = '$result Sep';
      break;
    case 10:
      result = '$result Oct';
      break;
    case 11:
      result = '$result Nov';
      break;
    case 12:
      result = '$result Dec';
      break;
  }
  result = '$result ${date.year.toString()}';
  return result;
}

formatDateTime(DateTime date) {
  final dateString = formatDateDDMMMYYYY(date);
  final hour = date.hour > 12 ? date.hour - 12 : date.hour;
  final meridian = date.hour > 12 ? "PM" : "AM";
  return "$dateString $hour:${date.minute} $meridian";
}
