// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// //import 'package:table_calendar/table_calendar.dart';
//
// class CustomDatePicker extends FormField<DateTime> {
//   final String? label;
//   final Function(DateTime?) onDateSelected;
//   final DateTime? initialDate;
//   final Color backgroundColor;
//   final String dateFormat;
//   final DateTime firstDay;
//   final DateTime lastDay;
//   final int initialYear;
//   final int firstYear;
//   final int lastYear;
//
//   CustomDatePicker({
//     super.key,
//     required this.label,
//     required this.onDateSelected,
//     this.initialDate,
//     super.validator,
//     this.backgroundColor = const Color(0xFFF9F9F9),
//     this.dateFormat = 'yyyy-MM-dd',
//     required this.firstDay,
//     required this.lastDay,
//     required this.initialYear,
//     required this.firstYear,
//     required this.lastYear,
//   }) : super(
//          initialValue: initialDate,
//          builder: (FormFieldState<DateTime> state) {
//            return _CustomDatePickerView(
//              state: state,
//              label: label,
//              onDateSelected: onDateSelected,
//              backgroundColor: backgroundColor,
//              dateFormat: dateFormat,
//              firstDay: firstDay,
//              lastDay: lastDay,
//              initialYear: initialYear,
//              firstYear: firstYear,
//              lastYear: lastYear,
//            );
//          },
//        );
// }
//
// class _CustomDatePickerView extends StatelessWidget {
//   final FormFieldState<DateTime> state;
//   final String? label;
//   final Function(DateTime?) onDateSelected;
//   final Color backgroundColor;
//   final String dateFormat;
//   final DateTime firstDay;
//   final DateTime lastDay;
//   final int initialYear;
//   final int firstYear;
//   final int lastYear;
//
//   const _CustomDatePickerView({
//     required this.state,
//     required this.label,
//     required this.onDateSelected,
//     required this.backgroundColor,
//     required this.dateFormat,
//     required this.firstDay,
//     required this.lastDay,
//     required this.initialYear,
//     required this.firstYear,
//     required this.lastYear,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if( label != null )
//         Text(
//           label!,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         if( label != null )
//         const SizedBox(height: 8),
//         Card(
//           //Change border color if there is an error
//           color: backgroundColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             side: BorderSide(
//               width: 1,
//               color: state.hasError ? Colors.red : Color(0xFFE0E0E0),
//             ),
//           ),
//           elevation: 0,
//           child: Padding(
//             padding: EdgeInsets.only(left: 12.w),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   state.value != null
//                       ? DateFormat(dateFormat).format(state.value!)
//                       : AppStrings.ddmmyyyy,
//                   style: TextStyle(
//                     color: state.value == null ? Colors.grey : Colors.black,
//                     fontSize: 14,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.calendar_month, color: AppColors.grey92,),
//                   onPressed: () {
//                     showCustomDatePicker(
//                       context: context,
//                       initialYear: initialYear,
//                       firstYear: firstYear,
//                       lastYear: lastYear,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // 4. Display the error message
//         if (state.hasError)
//           Padding(
//             padding: EdgeInsets.only(left: 12.w, top: 5.h),
//             child: Text(
//               state.errorText ?? '',
//               style: TextStyle(color: Colors.red.shade700, fontSize: 12.sp),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Future<DateTime?> showCustomDatePicker({
//     required BuildContext context,
//     required int initialYear,
//     required int firstYear,
//     required int lastYear,
//   }) async {
//     DateTime selectedDate = state.value ?? DateTime.now();
//     DateTime focusedDate = state.value ?? DateTime.now();
//     int newInitialYear = initialYear;
//
//     return await showDialog<DateTime>(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       /// Calendar
//                       TableCalendar(
//                         focusedDay: focusedDate,
//                         firstDay: firstDay,
//                         lastDay: lastDay,
//                         onHeaderTapped: (selectedYear) async {
//                           int? year = await showYearPickerDialog(
//                             context: context,
//                             initialYear: newInitialYear,
//                             firstYear: firstYear,
//                             lastYear: lastYear,
//                           );
//
//                           if (year != null) {
//                             newInitialYear = year;
//                             final tempDate = DateTime(
//                               year,
//                               selectedDate.month,
//                               selectedDate.day,
//                             );
//                             if (tempDate.isAfter(lastDay)) {
//                               selectedDate = lastDay;
//                               focusedDate = lastDay;
//                               setState(() {});
//                               return;
//                             }
//                             selectedDate = DateTime(
//                               year,
//                               selectedDate.month,
//                               selectedDate.day,
//                             );
//                             focusedDate = DateTime(
//                               year,
//                               focusedDate.month,
//                               focusedDate.day,
//                             );
//                             setState(() {});
//                           }
//                         },
//                         selectedDayPredicate: (day) =>
//                             isSameDay(selectedDate, day),
//                         onDaySelected: (selectedDay, newFocusedDay) {
//                           setState(() {
//                             selectedDate = selectedDay;
//                             focusedDate = newFocusedDay;
//                           });
//                         },
//                         headerStyle: const HeaderStyle(
//                           titleCentered: true,
//                           formatButtonVisible: false,
//                           leftChevronIcon: Icon(
//                             Icons.chevron_left,
//                             color: Colors.green,
//                           ),
//                           rightChevronIcon: Icon(
//                             Icons.chevron_right,
//                             color: Colors.green,
//                           ),
//                           titleTextStyle: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         daysOfWeekStyle: const DaysOfWeekStyle(
//                           weekdayStyle: TextStyle(color: Colors.green),
//                           weekendStyle: TextStyle(color: Colors.green),
//                         ),
//                         calendarStyle: const CalendarStyle(
//                           selectedDecoration: BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                           ),
//                           todayDecoration: BoxDecoration(
//                             color: Colors.grey,
//                             shape: BoxShape.circle,
//                           ),
//                           defaultTextStyle: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w800,
//                           ),
//                           holidayTextStyle: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w800,
//                           ),
//                           weekendTextStyle: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 16),
//
//                       /// Buttons
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w900,
//                                 ),
//                               ),
//                             ),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 backgroundColor: Colors.green,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 30,
//                                   vertical: 10,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 final onlyDate = DateTime(
//                                   selectedDate.year,
//                                   selectedDate.month,
//                                   selectedDate.day,
//                                 );
//                                 //Update the FormField state
//                                 state.didChange(onlyDate);
//                                 onDateSelected(onlyDate);
//                                 Navigator.pop(context, selectedDate);
//                               },
//                               child: const Text(
//                                 "Done",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<int?> showYearPickerDialog({
//     required BuildContext context,
//     required int initialYear,
//     required int firstYear,
//     required int lastYear,
//   }) async {
//     debugPrint("initialYear: $initialYear");
//     debugPrint("firstYear: $firstYear");
//     debugPrint("lastYear: $lastYear");
//     return await showDialog<int>(
//       context: context,
//       builder: (context) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Colors.green,
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//             textTheme: Theme.of(context).textTheme.copyWith(
//               bodyLarge: const TextStyle(fontWeight: FontWeight.w700),
//             ),
//           ),
//           child: Dialog(
//             child: SizedBox(
//               height: 300,
//               child: YearPicker(
//                 firstDate: DateTime(firstYear),
//                 lastDate: DateTime(lastYear, 12, 31, 23, 59, 59),
//                 selectedDate: DateTime(initialYear),
//                 onChanged: (dateTime) {
//                   Navigator.pop(context, dateTime.year);
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
