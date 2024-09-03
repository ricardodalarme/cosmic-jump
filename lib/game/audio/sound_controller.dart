import 'package:cosmic_jump/data/resources/settings.dart';
import 'package:flame_audio/flame_audio.dart';

class SoundController {
  static SoundController get instance => _instance;
  static final SoundController _instance = SoundController._();

  SoundController._();

  Future<void> play(String sound) async {
    if (settings.playSounds) {
      await FlameAudio.play(sound, volume: settings.soundVolume);
    }
  }
}
