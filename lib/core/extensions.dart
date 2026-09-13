import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension WidgetExtensions on Widget {
  Widget padY(double size) => Padding(
    padding: EdgeInsets.symmetric(vertical: size),
    child: this,
  );

  Widget padX(double size) => Padding(
    padding: EdgeInsets.symmetric(horizontal: size),
    child: this,
  );

  Widget padAll(double size) =>
      Padding(padding: EdgeInsets.all(size), child: this);

  Widget padOnly({double? l, double? r, double? t, double? b}) => Padding(
    padding: EdgeInsets.only(
      left: l ?? 0,
      right: r ?? 0,
      top: t ?? 0,
      bottom: b ?? 0,
    ),
    child: this,
  );

  Widget centralize() => Center(child: this);

  Widget expanded([int flex = 1]) => Expanded(flex: flex, child: this);
}

extension NairaFormatter on num {
  String toNaira() {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'en_NG',
      name: "₦",
    );
    return formatCurrency.format(this);
  }
}

extension BuildContextExts on BuildContext {
  double get bottomPadding => MediaQuery.of(this).viewPadding.bottom;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
