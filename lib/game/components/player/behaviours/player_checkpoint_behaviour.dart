import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:cosmic_jump/services/sound_service.dart';
import 'package:flame/components.dart';
import 'package:leap/leap.dart';

class PlayerCheckpointBehavior extends PhysicalBehavior<PlayerComponent>
    with HasGameRef<CosmicJump> {
  @override
  Future<void> update(double dt) async {
    if (!parent.reachedCheckpoint || parent.completedLevel) {
      return;
    }

    await SoundService.instance.play('disappear.wav');

    parent.reachedCheckpoint = false;
    await game.completeLevel();
  }
}
