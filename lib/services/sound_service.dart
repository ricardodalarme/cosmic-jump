import 'package:cosmic_jump/data/resources/settings.dart';
import 'package:flame_audio/flame_audio.dart';

class SoundService {
  static SoundService get instance => _instance;
  static final SoundService _instance = SoundService._();

  SoundService._();

  Future<void> play(String sound) async {
    if (settings.playSounds) {
      await FlameAudio.play(sound, volume: settings.soundVolume);
    }
  }
}
