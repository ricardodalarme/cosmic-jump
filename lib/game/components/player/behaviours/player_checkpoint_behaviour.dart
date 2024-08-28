import 'package:cosmic_jump/game/audio/sound_controller.dart';
import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:flame/components.dart';
import 'package:leap/leap.dart';

class PlayerCheckpointBehavior extends PhysicalBehavior<PlayerComponent>
    with HasGameRef<CosmicJump> {
  @override
  Future<void> update(double dt) async {
    if (!parent.hasReachedCheckpoint) {
      return;
    }

    await SoundController.instance.play('disappear.wav');

    parent.reachedCheckpoint = false;
  }
}
