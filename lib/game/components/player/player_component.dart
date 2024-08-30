import 'package:cosmic_jump/game/components/block/block_component.dart';
import 'package:cosmic_jump/game/components/player/behaviours/player_checkpoint_behaviour.dart';
import 'package:cosmic_jump/game/components/player/behaviours/player_collision_behaviour.dart';
import 'package:cosmic_jump/game/components/player/behaviours/player_damage_behaviour.dart';
import 'package:cosmic_jump/game/components/player/behaviours/player_death_behaviour.dart';
import 'package:cosmic_jump/game/components/player/behaviours/player_input_behaviour.dart';
import 'package:cosmic_jump/game/components/player/mixins/has_jetpack.dart';
import 'package:cosmic_jump/game/components/player/player_animation.dart';
import 'package:cosmic_jump/game/components/player/player_state.dart';
import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:flame/components.dart';
import 'package:leap/leap.dart';

class PlayerComponent extends JumperCharacter
    with HasJetpack, HasAnimationGroup, HasGameRef<CosmicJump> {
  PlayerComponent({
    required this.character,
  }) {
    addAll([
      JumperAccelerationBehavior(),
      GravityAccelerationBehavior(),
      CollisionDetectionBehavior(),
      PlayerCheckpointBehavior(),
      PlayerDamageBehavior(),
      PlayerInputBehavior(),
      PlayerCollisionBehavior(),
      PlayerDeathBehavior(),
      ApplyVelocityBehavior(),
      AnimationVelocityFlipBehavior(),
    ]);

    add(animationGroup);
    health = maxHealth;

    solidTags.addAll([CommonTags.ground, BlockComponent.tag]);
  }

  final String character;
  late final Vector2 _spawn;

  static final Vector2 _hitbox = Vector2(28, 34);

  double timeHoldingJump = 0;
  bool didEnemyBop = false;

  int coins = 0;
  bool gotHit = false;
  bool reachedCheckpoint = false;
  bool completedLevel = false;

  static const int maxHealth = 10;
  static const double maxEnergy = 10;

  @override
  AnchoredAnimationGroup<PlayerState, PlayerComponent> animationGroup =
      PlayerSpriteAnimation();

  @override
  int get priority => 1;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(jetpack);

    _spawn = leapMap.playerSpawn;
    size = _hitbox;
    health = maxHealth;
    energy = maxEnergy;

    _updateMovementBasedOnGravity();

    respawn();
  }

  void _updateMovementBasedOnGravity() {
    // Get the gravity of the current planet
    final double planetGravity = game.planet.gravity;

    // Calculate a more balanced gravity factor
    final gravityFactor = planetGravity / 9.8;

    // Update walk speed based on gravity, using a gentler scaling factor
    walkSpeed = (leapWorld.gravity * leapMap.tileSize) /
        50 *
        (0.3 + 0.3 * gravityFactor);

    // Apply a smaller scaling factor for the jump impulse to avoid extreme jumps
    minJumpImpulse = leapWorld.gravity * (0.3 + 0.25 * gravityFactor);

    // Adjust jetpack force more conservatively to ensure it feels balanced across planets
    jetpack.force = leapWorld.gravity * (0.4 + 0.3 * gravityFactor) / 7.5;
  }

  void respawn() {
    x = _spawn.x;
    y = _spawn.y;
    velocity.x = 0;
    velocity.y = 0;
    airXVelocity = 0;
    faceLeft = false;
    jumping = false;
    health = maxHealth;
    energy = maxEnergy;
    coins = 0;
  }
}
