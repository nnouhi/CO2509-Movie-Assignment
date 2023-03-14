// Packages
import 'package:flutter/material.dart';

// Models

class CommonWidgets {
  ElevatedButton getElevatedButtons(String displayText, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.black54,
          ),
      child: Text(displayText),
    );
  }

  DropdownMenuItem getDropDownItems(String value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        value,
        // style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
