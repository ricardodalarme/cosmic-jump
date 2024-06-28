import 'dart:async';
import 'dart:math';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/cosmic_world.dart';
import 'package:cosmic_jump/features/checkpoint/checkpoint_component.dart';
import 'package:cosmic_jump/features/item/item_model.dart';
import 'package:cosmic_jump/features/jetpack/jetpack_component.dart';
import 'package:cosmic_jump/features/jetpack/jetpack_status.dart';
import 'package:cosmic_jump/features/map/map_item_component.dart';
import 'package:cosmic_jump/features/meteor/meteor_component.dart';
import 'package:cosmic_jump/features/player/player_state.dart';
import 'package:cosmic_jump/features/trap/saw_component.dart';
import 'package:cosmic_jump/utils/check_collision.dart';
import 'package:cosmic_jump/utils/collision_block.dart';
import 'package:cosmic_jump/utils/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart' hide PlayerState;
import 'package:flutter/services.dart';

class PlayerComponent extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<CosmicJump>, KeyboardHandler, CollisionCallbacks {
  String character;
  PlayerComponent({
    super.position,
    this.character = 'Virtual Guy',
  });

  static const double _stepTime = 0.05;

  static const double _defaultJumpForce = 260;
  static const double _terminalVelocity = 300;

  double horizontalMovement = 0;
  static const double _moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;

  bool hasUsedJetpack = false;

  JetpackComponent? jetpack;

  bool gotHit = false;
  bool reachedCheckpoint = false;

  static const double maxHealth = 10;
  double health = maxHealth;

  static const double maxEnergy = 10;
  double energy = maxEnergy;

  List<CollisionBlock> collisionBlocks = [];
  static const CustomHitbox hitbox = CustomHitbox(
    offsetX: 6,
    offsetY: 4,
    width: 20,
    height: 28,
  );
  static const double _fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  double _timeSinceLastDecrease = 0;
  static const double decreaseInterval = 2; // 5 seconds

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    startingPosition = Vector2(position.x, position.y);

    if (hasJetpack) {
      jetpack = JetpackComponent();
      add(jetpack!);
    }

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= _fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _updatePlayerState();
        _updatePlayerMovement(_fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(_fixedDeltaTime);
        _checkVerticalCollisions();
      }

      accumulatedTime -= _fixedDeltaTime;
    }

    _timeSinceLastDecrease += dt;
    if (health == 0) {
      _respawn();
      health = 5;
    }
    if (_timeSinceLastDecrease >= decreaseInterval) {
      final planetToxity = findParent<CosmicWorld>()!.planet.poison;
      final damage = max(0, planetToxity - poisonResistance);

      if (damage > 0) {
        health -= damage;
        current = PlayerState.hit;
        _timeSinceLastDecrease = 0;
      }
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    hasUsedJetpack = keysPressed.contains(LogicalKeyboardKey.keyX);

    // Return false to indicate that we have handled the key event.
    return false;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (!reachedCheckpoint) {
      if (other is MapItemComponent) other.collidedWithPlayer();
      if (other is SawComponent) _respawn();
      if (other is MeteorComponent) {
        other.explode();
        _respawn();
      }
      if (other is CheckpointComponent) _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    // List of all animations
    animations = {
      PlayerState.idle: _spriteAnimation('Idle', 11),
      PlayerState.running: _spriteAnimation('Run', 12),
      PlayerState.jumping: _spriteAnimation('Jump', 1),
      PlayerState.falling: _spriteAnimation('Fall', 1),
      PlayerState.hit: _spriteAnimation('Hit', 7)..loop = false,
      PlayerState.appearing: _specialSpriteAnimation('Appearing', 7),
      PlayerState.disappearing: _specialSpriteAnimation('Desappearing', 7),
    };

    // Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _stepTime,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    // check if Falling set to falling
    if (velocity.y > 0) playerState = PlayerState.falling;

    // Checks if jumping, set to jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    if (hasUsedJetpack) {
      jetpack?.use();

      if (jetpack?.status == JetpackStaus.using) {
        _playerUseJetpack(dt);
      }
    } else {
      jetpack?.stop();
    }

    // if (velocity.y > _gravity) isOnGround = false; // optional

    velocity.x = horizontalMovement * _moveSpeed;
    position.x += velocity.x * dt;
  }

  double get _jumpForce => _defaultJumpForce;

  void _playerJump(double dt) {
    if (game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _playerUseJetpack(double dt) {
    velocity.y = -JetpackComponent.force;
    position.y += velocity.y * dt;
    isOnGround = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, hitbox, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += findParent<CosmicWorld>()!.planet.gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, hitbox, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, hitbox, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  Future<void> _respawn() async {
    if (game.playSounds) {
      await FlameAudio.play('hit.wav', volume: game.soundVolume);
    }
    const canMoveDuration = Duration(milliseconds: 400);
    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    health = maxHealth;
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(canMoveDuration, () => gotHit = false);
  }

  Future<void> _reachedCheckpoint() async {
    reachedCheckpoint = true;
    if (game.playSounds) {
      await FlameAudio.play('disappear.wav', volume: game.soundVolume);
    }
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640);

    const waitToChangeDuration = Duration(seconds: 3);
    Future.delayed(waitToChangeDuration, () => game.loadNextLevel());
  }

  void collidedwithEnemy() {
    _respawn();
  }

  bool get hasJetpack => game.account.equipments.equippedItems
      .whereType<JetpackItemModel>()
      .isNotEmpty;

  bool get hasNightVision => game.account.equipments.equippedItems
      .whereType<VisibilityItemModel>()
      .isNotEmpty;

  double get poisonResistance =>
      game.account.equipments.equippedItems.fold(0, (prev, item) {
        return prev + (item?.poisonResistance ?? 0);
      });
}
