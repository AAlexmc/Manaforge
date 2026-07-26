/// Finder del indicador de foco del tour (el marco que el overlay pinta
/// sobre la diana): el único Container con borde del color de forja.
/// Compartido entre los tests de tour — si un paso se queda sin diana, el
/// overlay degrada a burbuja centrada SIN este marco, y eso es lo que los
/// tests deben cazar.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaforge_app/theme/mf_theme.dart';

Finder indicadorDeFoco() => find.byWidgetPredicate((w) =>
    w is Container &&
    w.decoration is BoxDecoration &&
    (w.decoration! as BoxDecoration).border != null &&
    (((w.decoration! as BoxDecoration).border! as Border).top.color ==
        MFColors.forge));
