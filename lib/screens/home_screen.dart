import 'package:flutter/material.dart';
import 'package:metatube/services/file_service.dart';
import 'package:metatube/utils/styles.dart';
import 'package:metatube/widgets/custom_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FileService fileService = FileService();

  @override
  void initState() {
    super.initState();
    addListeners();
  }

  @override
  void dispose() {
    super.dispose();
    removeListeners();
  }

  void removeListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController,
      fileService.descriptionController,
      fileService.tagsController,
    ];

    for (TextEditingController controller in controllers) {
      controller.removeListener(_onFieldChanged);
    }
  }

  void addListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController,
      fileService.descriptionController,
      fileService.tagsController,
    ];

    for (TextEditingController controller in controllers) {
      controller.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    setState(() {
      fileService.fieldsNotEmpty =
        fileService.titleController.text.isNotEmpty &&
        fileService.descriptionController.text.isNotEmpty &&
        fileService.tagsController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _mainButton(() => fileService.newFile(context), 'New File'),
                Row(
                  children: [
                    _actionButton(() => fileService.loadFile(context), Icons.file_upload),
                    const SizedBox(width: 8),
                    _actionButton(() => fileService.newDirectory(context), Icons.folder),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              maxLength: 100,
              maxLines: 3,
              hintText: 'Enter video title',
              controller: fileService.titleController,
            ),
            const SizedBox(height: 40),
            CustomTextfield(
              maxLength: 5000,
              maxLines: 6,
              hintText: 'Enter video description',
              controller: fileService.descriptionController,
            ),
            CustomTextfield(
              maxLength: 500,
              maxLines: 4,
              hintText: 'Enter video tags',
              controller: fileService.tagsController,
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                _mainButton(fileService.fieldsNotEmpty ? () => fileService.saveContent(context) : null, 'Save File'),
              ],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton _mainButton(Function()? onPressed, String text) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _buttonStyle(),
      child: Text(text),
    );
  }

  IconButton _actionButton(Function()? onPressed, IconData icon) {
    return IconButton(
      onPressed: onPressed,
      // splashRadius: 20, // If [ThemeData.useMaterial3] is set to true, this will not be used.
      highlightColor: AppTheme.accent,
      icon: Icon(icon, color: AppTheme.medium),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.accent,
      foregroundColor: AppTheme.dark,
      disabledBackgroundColor: AppTheme.disabledBackgroundColor,
      disabledForegroundColor: AppTheme.disabledForegroundColor,
    );
  }
}
