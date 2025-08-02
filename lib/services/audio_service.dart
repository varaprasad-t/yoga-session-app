import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String path) async {
    await _player.play(AssetSource(path));
  }

  Future<void> pause() async => _player.pause();

  Future<void> resume() async => _player.resume();

  Future<void> stop() async => _player.stop();
}
