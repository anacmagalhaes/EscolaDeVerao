import 'package:escoladeverao/utils/colors_utils.dart';
import 'package:escoladeverao/utils/fonts_utils.dart';
import 'package:flutter/material.dart';

class CustomCardConnections extends StatelessWidget {
  final Connection connection;

  CustomCardConnections({required this.connection});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: connection.image,
              radius: 40,
            ),
            SizedBox(height: 8.0),
            Fonts(
              text: connection.name,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.0),
            Fonts(
              text: 'ID: ',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.blueMarine,
              additionalSpans: [
                TextSpan(
                  text: connection.id,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blueMarine,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Connection {
  final ImageProvider image;
  final String name;
  final String id;

  Connection({
    required this.image,
    required this.name,
    required this.id,
  });
}
