import 'package:flutter/material.dart';

class S {
  S._();
  static const double xs = 4, sm = 8, md = 12, lg = 16, xl = 20, xxl = 24, xxxl = 32;
  static const double page = 16;
  static const double cardGap = 12;
  static const double btnH = 52;
  static const double btnSmH = 40;
  static const double r_xs = 6, r_sm = 8, r_md = 10, r_lg = 12, r_xl = 16, r_full = 999;

  static BorderRadius get cardR   => BorderRadius.circular(r_xl);
  static BorderRadius get btnR    => BorderRadius.circular(r_lg);
  static BorderRadius get inputR  => BorderRadius.circular(r_md);
  static BorderRadius get tagR    => BorderRadius.circular(r_sm);
  static BorderRadius get chipR   => BorderRadius.circular(r_full);

  static const EdgeInsets pageAll = EdgeInsets.all(page);
  static const EdgeInsets pageH   = EdgeInsets.symmetric(horizontal: page);
  static const EdgeInsets cardAll = EdgeInsets.all(page);
}
