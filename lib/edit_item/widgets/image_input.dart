part of '../views/edit_item_page.dart';

class _ImageInput extends StatefulWidget {
  const _ImageInput({this.item});

  final Item? item;

  @override
  State<_ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<_ImageInput> {
  String? imageFilePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (imageFilePath != null) {
      deleteFile(imageFilePath!);
    }
    super.dispose();
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> downloadImage(String imageUrl) async {
    final uri = Uri.parse(imageUrl);

    // Perform the HTTP request to download the file
    final response = await get(uri);

    final fileBytes = response.bodyBytes;

    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final filename = DateTime.now().millisecondsSinceEpoch.toString();
    final tempFile = File('$tempPath/$filename');
    if (mounted) {
      await tempFile.writeAsBytes(fileBytes);

      imageFilePath = '$tempPath/$filename';
      context.read<EditItemBloc>().add(ImageChanged(tempFile));
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      EditItemBloc? bloc;
      if (context.mounted) {
        bloc = context.read<EditItemBloc>()
          ..add(const LoadingChanged(isLoading: true));
        await Future.delayed(Duration.zero, () {});
      }
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        compressQuality: 50, // Set the compression quality of the cropped image
        maxWidth: 150, // Set the maximum width of the cropped image
        maxHeight: 150, // Set the maximum height of the cropped image
        cropStyle: CropStyle.rectangle,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Theme.of(context).colorScheme.secondary,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
          IOSUiSettings(),
        ],
      );
      if (croppedImage != null) {
        final pickedImageFile = File(croppedImage.path);
        bloc?.add(ImageChanged(pickedImageFile));
      }
      bloc?.add(const LoadingChanged(isLoading: false));
      await Future.delayed(Duration.zero, () {});
    }
  }

  void _deleteImage(BuildContext context) {
    context.read<EditItemBloc>().add(const ImageChanged(null));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.item?.image != null &&
              context.read<EditItemBloc>().state.imageFile == null
          ? downloadImage(widget.item!.image!)
          : Future.delayed(Duration.zero, () {}),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : BlocBuilder<EditItemBloc, EditItemState>(
                  buildWhen: (previous, current) =>
                      previous.imageFile?.path != current.imageFile?.path,
                  builder: (context, state) {
                    return Column(
                      children: [
                        if (state.imageFile != null)
                          Image.file(state.imageFile!)
                        else
                          GestureDetector(
                            onTap: () => _pickImage(context),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                Center(
                                  child: Stack(
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 80,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (state.imageFile != null)
                          ElevatedButton(
                            onPressed: () {
                              _pickImage(context);
                            },
                            child: Text('Change Image'),
                          ),
                        if (state.imageFile != null)
                          ElevatedButton(
                            onPressed: () {
                              _deleteImage(context);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.error)),
                            child: Text('Delete Image'),
                          ),
                      ],
                    );
                  },
                ),
    );
  }
}
