import 'package:file_picker/file_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final localFileInterfaceProvider =
    Provider<LocalFileInterface>((ref) => const LocalFileInterface());

class LocalFileInterface {
  const LocalFileInterface();

  Future<FilePickerResult?> pickGlbFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['glb'],
    );
    return result;
  }

  Future<FilePickerResult?> pickPngFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'],
    );
    return result;
  }

  Future<FilePickerResult?> pickJpegFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );
    return result;
  }

  Future<FilePickerResult?> pickJpegFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );
    return result;
  }
}
