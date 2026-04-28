import 'package:intl/intl.dart';

String formatCurrency(num amount) {
  return '৳${NumberFormat('#,##0').format(amount)}';
}

String formatDate(DateTime date) {
  return DateFormat('d MMM y', 'en').format(date);
}

String formatTime(DateTime date) {
  return DateFormat('h:mm a').format(date);
}

String formatPhone(String phone) {
  if (phone.startsWith('+880')) return phone;
  if (phone.startsWith('0')) return '+880${phone.substring(1)}';
  return '+880$phone';
}

String orderStatusBn(String status) {
  switch (status) {
    case 'pending': return 'অপেক্ষামান';
    case 'assigned': return 'নির্ধারিত';
    case 'picked': return 'সংগৃহীত';
    case 'paid': return 'পরিশোধিত';
    case 'cancelled': return 'বাতিল';
    default: return status;
  }
}

int statusStep(String status) {
  switch (status) {
    case 'pending': return 0;
    case 'assigned': return 1;
    case 'picked': return 2;
    case 'paid': return 3;
    default: return 0;
  }
}
