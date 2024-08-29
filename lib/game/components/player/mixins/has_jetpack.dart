import 'package:cosmic_jump/game/components/jetpack/jetpack_component.dart';
import 'package:cosmic_jump/game/components/jetpack/jetpack_status.dart';
import 'package:leap/leap.dart';

mixin HasJetpack on PhysicalEntity {
  bool get isUsingJetpack => jetpack.status == JetpackStaus.using;

  double energy = 0;

  final JetpackComponent jetpack = JetpackComponent();
}
