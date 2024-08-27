import 'package:cosmic_jump/data/account.dart';
import 'package:cosmic_jump/game/components/jetpack/jetpack_component.dart';
import 'package:cosmic_jump/game/components/player/behaviours/player_collision_behaviour.dart';
import 'package:cosmic_jump/game/components/player/behaviours/player_damage_behaviour.dart';
import 'package:cosmic_jump/game/components/player/behaviours/player_death_behaviour.dart';
import 'package:cosmic_jump/game/components/player/behaviours/player_input_behaviour.dart';
import 'package:cosmic_jump/game/components/player/mixins/has_jetpack.dart';
import 'package:cosmic_jump/game/components/player/player_animation.dart';
import 'package:cosmic_jump/game/components/player/player_state.dart';
import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:cosmic_jump/models/item_model.dart';
import 'package:flame/components.dart';
import 'package:leap/leap.dart';

class PlayerComponent extends JumperCharacter
    with HasGameRef<CosmicJump>, HasHealth, HasJetpack, HasAnimationGroup {
  PlayerComponent({
    this.character = 'Virtual Guy',
  }) {
    // Behaviors, ordering is important for processing
    // collision detection and reacting to inputs
    //
    // Acceleration from movement should go before global collision detection
    addAll([
      JumperAccelerationBehavior(),
      GravityAccelerationBehavior(),
      CollisionDetectionBehavior(),
      PlayerDamageBehavior(),
      PlayerInputBehavior(),
      PlayerCollisionBehavior(),
      PlayerDeathBehavior(),
      ApplyVelocityBehavior(),
      AnimationVelocityFlipBehavior(),
    ]);

    // Children
    add(animationGroup);

    solidTags.addAll([CommonTags.ground, 'Block']);
  }

  final String character;
  late final Vector2 _spawn;

  static final Vector2 _hitbox = Vector2(28, 34);

  int coins = 0;
  double timeHoldingJump = 0;
  bool didEnemyBop = false;

  bool hasReachedCheckpoint = false;

  JetpackComponent? jetpack;

  bool gotHit = false;
  bool reachedCheckpoint = false;

  static const int maxHealth = 10;
  static const double maxEnergy = 10;

  @override
  AnchoredAnimationGroup<PlayerState, PlayerComponent> animationGroup =
      PlayerSpriteAnimation();

  /// Render on top of the map tiles.
  @override
  int get priority => 1;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    if (hasJetpack) {
      jetpack = JetpackComponent();
      add(jetpack!);
    }

    _spawn = leapMap.playerSpawn;
    size = _hitbox;
    walkSpeed = leapMap.tileSize * 7;
    minJumpImpulse = leapWorld.gravity * 0.6;

    respawn();
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
  }

  bool get hasNightVision => account.equipments.equippedItems
      .whereType<VisibilityItemModel>()
      .isNotEmpty;

  double get poisonResistance => account.equipments.equippedItems.fold(
        0,
        (prev, item) => prev + (item?.poisonResistance ?? 0),
      );
}
