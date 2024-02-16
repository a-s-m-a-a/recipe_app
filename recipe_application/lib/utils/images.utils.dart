import 'package:image_picker/image_picker.dart';

class ImagesPath {
  static const String _path = 'assets/images/';
  static String background = '${_path}background.jpg';
  static String logo = '${_path}logo.png';
  static String today1 = '${_path}frensh_toast.png';
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("no Image Selected");
}
