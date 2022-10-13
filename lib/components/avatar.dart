import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tollpay/utils/constants.dart';

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
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75.0),
                          child: Container(
                            width: 120,
                            height: 120,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 200, 200, 200),
                            ),
                            child: Image.asset("assets/images/avatar_icon.png"),
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(75.0), 
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(75.0),
                        child: Image.network(
                          widget.imageUrl!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ]),
          Padding(
            padding: const EdgeInsets.only(top: 80.0, right: 90.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _upload(),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 18.0,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ]));
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
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
