class SettingsModel {
  bool playSounds;
  double soundVolume;
  bool showTutorial;
  bool isFirstTime;

  SettingsModel({
    required this.playSounds,
    required this.soundVolume,
    required this.showTutorial,
    required this.isFirstTime,
  });

  SettingsModel.empty({
    this.playSounds = false,
    this.soundVolume = 1,
    this.showTutorial = true,
    this.isFirstTime = true,
  });

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      playSounds: map['playSounds'] as bool,
      soundVolume: map['soundVolume'] as double,
      showTutorial: map['showTutorial'] as bool,
      isFirstTime: map['isFirstTime'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playSounds': playSounds,
      'soundVolume': soundVolume,
      'showTutorial': showTutorial,
      'isFirstTime': isFirstTime,
    };
  }
}
