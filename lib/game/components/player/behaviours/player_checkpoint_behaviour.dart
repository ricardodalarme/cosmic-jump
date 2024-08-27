import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:leap/leap.dart';

class PlayerCheckpointBehavior extends PhysicalBehavior<PlayerComponent>
    with HasGameRef<CosmicJump> {
  @override
  Future<void> update(double dt) async {
    if (!parent.hasReachedCheckpoint) {
      return;
    }

    if (game.playSounds) {
      await FlameAudio.play('disappear.wav', volume: game.soundVolume);
    }

    parent.reachedCheckpoint = false;
  }
}