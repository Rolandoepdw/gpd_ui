import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpd/core/constants/color_constants.dart';

SuccessNotification(BuildContext context, String text) {
  ElegantNotification.success(
      title: Text("Éxito"),
      width: 300,
      background: secondaryColor,
      description: Text(text))
      .show(context);
}

ErrorNotification(BuildContext context, String text) {
  ElegantNotification.error(
          title: Text("Error"),
          width: 300,
          background: secondaryColor,
          description: Text(text))
      .show(context);
}

InfoNotification(BuildContext context, String text) {
  ElegantNotification.info(
          title: Text("Información"),
          width: 300,
          background: secondaryColor,
          description: Text(text))
      .show(context);
}
