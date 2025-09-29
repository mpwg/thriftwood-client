import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thriftwood/core.dart';

class LunaPopupMenuButton<T> extends PopupMenuButton<T> {
  LunaPopupMenuButton({
    required PopupMenuItemSelected<T> onSelected,
    required super.itemBuilder,
    super.key,
    IconData? icon,
    super.child,
    super.tooltip,
  }) : super(
          shape: LunaUI.shapeBorder,
          icon: icon == null ? null : Icon(icon),
          onSelected: (result) {
            HapticFeedback.selectionClick();
            onSelected(result);
          },
        );
}
