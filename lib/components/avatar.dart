import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ysave/utils/constants.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    Key? key,
    required this.imageUrl,
    required this.onUpload,
  }) : super(key: key);

  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(75.0),
            ),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(75.0),
            child: Image.network(
              widget.imageUrl!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ElevatedButton(
          onPressed: _isLoading ? null : _upload,
          child: const Text('Upload'),
        ),
      ],
    );
  }

  Future<void> _upload() async {
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    final bytes = await imageFile.readAsBytes();
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;
    final response =
        await supabase.storage.from('avatars').uploadBinary(filePath, bytes);

    setState(() => _isLoading = false);

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
      return;
    }
    final imageUrlResponse =
        supabase.storage.from('avatars').getPublicUrl(filePath);
    widget.onUpload(imageUrlResponse.data!);
  }
}
