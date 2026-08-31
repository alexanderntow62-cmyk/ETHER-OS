import 'dart:io';

import 'ether_generation_provider.dart';
import 'ether_pollinations_provider.dart';

class EtherGenerationService {
  final EtherGenerationProvider provider;

  EtherGenerationService({EtherGenerationProvider? provider})
    : provider = provider ?? EtherPollinationsProvider();

  Future<File> generateImage({
    required String prompt,
    String? outputPath,
    String aspectRatio = '1:1',
  }) {
    return provider.generateImage(
      prompt: prompt,
      outputPath: outputPath,
      aspectRatio: aspectRatio,
    );
  }

  Future<File> generateVideo({
    required String prompt,
    String? outputPath,
    int duration = 5,
  }) {
    return provider.generateVideo(
      prompt: prompt,
      outputPath: outputPath,
      duration: duration,
    );
  }

  void close() {
    if (provider is EtherPollinationsProvider) {
      (provider as EtherPollinationsProvider).close();
    }
  }
}
