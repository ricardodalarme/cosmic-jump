import 'package:cosmic_jump/game/components/jetpack/jetpack_status.dart';
import 'package:flame/components.dart';

class JetpackComponent extends Component {
  static const double duration = 1000;
  static const double _rechargeSpeed = 100;
  static const double _consumptionSpeed = 800;

  double force = 50;
  JetpackStaus status = JetpackStaus.ready;
  double remainingTime = duration;

  @override
  void update(double dt) {
    switch (status) {
      case JetpackStaus.recharging:
        _recharge(dt);
      case JetpackStaus.using:
        _consume(dt);
      case JetpackStaus.ready:
        break;
    }
  }

  void _recharge(double dt) {
    remainingTime += dt * _rechargeSpeed;
    if (remainingTime >= duration) {
      status = JetpackStaus.ready;
      remainingTime = duration;
    }
  }

  void _consume(double dt) {
    remainingTime -= dt * _consumptionSpeed;
    if (remainingTime <= 0) {
      status = JetpackStaus.recharging;
      remainingTime = 0;
    }
  }

  void use() {
    if (status == JetpackStaus.ready) {
      status = JetpackStaus.using;
    }
  }

  void stop() {
    if (status == JetpackStaus.using) {
      status = JetpackStaus.recharging;
    }
  }
}
