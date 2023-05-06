import 'package:deniz_gold/core/theme/app_colors.dart';
import 'package:deniz_gold/core/theme/app_text_style.dart';
import 'package:deniz_gold/presentation/dimens.dart';
import 'package:deniz_gold/presentation/strings.dart';
import 'package:deniz_gold/presentation/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shamsi_date/shamsi_date.dart';

class PersianDateWidget extends StatelessWidget {
  const PersianDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = Jalali.now();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(now.dayOfWeek(), textStyle: AppTextStyle.body6, color: AppColors.nature.shade600),
            const SizedBox(width: Dimens.standard6),
            SvgPicture.asset(
              'assets/images/calendar.svg',
              fit: BoxFit.fitWidth,
              color: AppColors.nature.shade700,
              width: Dimens.standard18,
            ),
          ],
        ),
        AppText('${now.year}/${now.month}/${now.day}', textStyle: AppTextStyle.body5, color: AppColors.nature.shade800),
      ],
    );
  }
}

extension DateExt on Jalali{

  String dayOfWeek(){
    if(weekDay == 1){
      return Strings.shanbe;
    }else if(weekDay == 2){
      return Strings.yekshanbe;
    }else if(weekDay == 3){
      return Strings.doshanbe;
    }else if(weekDay == 4){
      return Strings.seshanbe;
    }else if(weekDay == 5){
      return Strings.chaharshanbe;
    }else if(weekDay == 6){
      return Strings.panjshanbe;
    }else {
      return Strings.jome;
    }
  }
}
