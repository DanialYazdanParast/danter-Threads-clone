import 'package:danter/core/constants/custom_colors.dart';
import 'package:danter/screen/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:danter/screen/root/screens/root.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditScreenFild extends StatefulWidget {
  const EditScreenFild({
    super.key,
    required this.nameFild,
    required this.bio,
    required this.name,
  });
  final String nameFild;
  final String bio;
  final String name;

  @override
  State<EditScreenFild> createState() => _EditScreenFildState();
}

class _EditScreenFildState extends State<EditScreenFild> {
  late final TextEditingController controllerbio =
      TextEditingController(text: widget.bio);

  late final TextEditingController controllername =
      TextEditingController(text: widget.name);

  @override
  void dispose() {
    controllerbio.dispose();
    controllername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit ${widget.nameFild}'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              if (widget.name == controllername.text &&
                  widget.bio == controllerbio.text) {
                Navigator.pop(context);
              } else {
                BlocProvider.of<EditProfileBloc>(context)
                    .add(
                        ChengEditProfileEvent(
                            bio: widget.nameFild == 'Bio'
                                ? controllerbio.text.trim()
                                : widget.bio,
                            name: widget.nameFild != 'Bio'
                                ? controllername.text.trim()
                                : widget.name));
                Navigator.pop(context);
              }
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  CupertinoIcons.check_mark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            CupertinoIcons.multiply,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: !RootScreen.isMobile(context)
                ? MediaQuery.of(context).size.width * 0.2
                : 20,
            right: !RootScreen.isMobile(context)
                ? MediaQuery.of(context).size.width * 0.2
                : 20),
        child: Container(
          decoration: BoxDecoration(
              color: themeData.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 0.5,
                color: themeData.colorScheme.secondary,
              )),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.nameFild,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                )),
                        GestureDetector(
                          onTap: () {
                            if (widget.nameFild == 'Bio') {
                              controllerbio.text = '';
                            } else {
                              controllername.text = '';
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: LightThemeColors.secondaryTextColor
                                    .withOpacity(0.8),
                                borderRadius: BorderRadius.circular(100)),
                            child: const Icon(
                              CupertinoIcons.multiply,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: widget.nameFild == 'Bio'
                          ? controllerbio
                          : controllername,
                      autofocus: true,
                      minLines: 3,
                      maxLines: 50,
                      maxLength: widget.nameFild == 'Bio' ? 100 : 30,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        hintText: 'Write a ${widget.nameFild}...',
                        hintStyle: Theme.of(context).textTheme.titleSmall,
                        isCollapsed: true,
                        // floatingLabelBehavior:
                        //     FloatingLabelBehavior.always,
                        alignLabelWithHint: true,
                        // label: Text(
                        //   'Write a ${widget.nameFild}...',
                        //   style: Theme.of(context).textTheme.titleSmall,
                        // ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
