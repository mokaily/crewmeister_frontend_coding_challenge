import 'package:flutter/material.dart';
import 'create_material_color.dart';

class Themes {
  BuildContext baseContext;

  Themes({required this.baseContext});

  static final mainTheme = ThemeData(
    primarySwatch: createMaterialColor(Color(0xff04192D)),
    useMaterial3: false,

    cardTheme: CardThemeData(color: Colors.white, shadowColor: Colors.white, elevation: 2.0),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    // dividerTheme: DividerThemeData(thickness: 2, color: ColorPalettes.primary[30]),

    // chipTheme: ChipThemeData(
    //   iconTheme: const IconThemeData(color: ColorPalettes.purple, size: 12),
    //   backgroundColor: ColorPalettes.purple[60],
    //   labelStyle: ThemeData.light().textTheme.labelSmall?.copyWith(color: Colors.white),
    //   padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 9),
    //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
    //   showCheckmark: false,
    // ),
  );
}
