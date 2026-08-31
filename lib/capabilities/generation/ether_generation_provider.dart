import 'dart:io';

abstract class EtherGenerationProvider {
  Future<File> generateImage({
    required String prompt,
    String? outputPath,
    String aspectRatio = '1:1',
  });

  Future<File> generateVideo({
    required String prompt,
    String? outputPath,
    int duration = 5,
  });
}
