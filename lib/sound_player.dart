import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSound(String assetPath) async {
    // Set the audio source to an asset
    await _audioPlayer.setSource(AssetSource(assetPath));
    // Play the sound
    await _audioPlayer.resume();  // Start playback after setting the source
  }
}
