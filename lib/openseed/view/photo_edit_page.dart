import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class PhotoEditPage extends StatelessWidget {
  final String photo;

  const PhotoEditPage({required this.photo, super.key});

  static Route<Uint8List> route(String photo) {
    return MaterialPageRoute<Uint8List>(builder: (_) => PhotoEditPage(photo: photo));
  }

  @override
  Widget build(BuildContext context) {
    return ProImageEditor.file(
      photo,
      configs: const ProImageEditorConfigs(
        paintEditor: PaintEditorConfigs(enabled: false),
        textEditor: TextEditorConfigs(enabled: false),
        emojiEditor: EmojiEditorConfigs(enabled: false),
      ),
      callbacks: ProImageEditorCallbacks(
        onImageEditingComplete: (Uint8List bytes) async {
          Navigator.pop(context, bytes);
        },
      ),
    );
  }
}
