import 'package:flutter/material.dart';
import 'package:gpd/core/constants/color_constants.dart';
import 'package:gpd/core/utils/responsive.dart';
import 'package:gpd/src/models/calendar_data.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';

class CalendarItem extends StatelessWidget {
  final CalendarData calendarItemData;

  const CalendarItem({Key? key, required this.calendarItemData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.only(bottom: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextAvatar(
                text: calendarItemData.eventName,
                size: 50,
                backgroundColor: Colors.white,
                textColor: Colors.white,
                fontSize: 16,
                upperCase: true,
                numberLetters: 1,
                shape: Shape.Rectangle,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: getIdealSize(context, 120, 110, 250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(calendarItemData.eventName,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: 5),
                    Text(calendarItemData.description,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis)
                  ],
                ),
              )
            ],
          ),
          Column(children: [
            _Date(date: calendarItemData.getStartDate()),
            SizedBox(height: 6),
            _Date(date: calendarItemData.getEndDate()),
          ])
        ],
      ),
    );
  }
}

class _Date extends StatelessWidget {
  final String date;

  const _Date({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: primaryColor.withOpacity(0.5),
        ),
      ),
      child: Text(
        date,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
