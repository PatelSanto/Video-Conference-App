import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:video_conference_app/Models/user.dart';
import 'package:video_conference_app/Models/user_provider.dart';
import 'package:video_conference_app/Widgets/appbar.dart';
import 'package:video_conference_app/Widgets/auth_widgets.dart';
import 'package:video_conference_app/constants/assets_path.dart';
import 'package:video_conference_app/constants/const_widgets.dart';
import 'package:video_conference_app/services/auth_services.dart';
import 'package:video_conference_app/services/database_services.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  late AuthService _authServices;
  File? selectedImage;
  bool uploadLoader = false;

  @override
  void initState() {
    _authServices = GetIt.instance.get<AuthService>();
    ref
        .read(userDataNotifierProvider.notifier)
        .fetchCurrentUserData(_authServices.user?.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataNotifierProvider);

    return Scaffold(
      appBar: homeAppBar("User Details"),
      body: _body(userData),
    );
  }

  Widget _body(UserData userData) {
    final dob =
        "${userData.dateOfBirth?.day ?? 0}/${userData.dateOfBirth?.month ?? 0}/${userData.dateOfBirth?.year ?? 0}";
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              userImageCircle(
                userData,
                40,
                canEdit: true,
                isLoading: uploadLoader,
                onTap: () async {
                  setState(() {
                    uploadLoader = true;
                  });
                  File? file = await getImageFromGallery();
                  if (file != null) {
                    selectedImage = file;
                    print(selectedImage?.path);
                    changePhotoDilog(context, ref, file, userData);
                  }
                },
              ),
              sbw20,
              Text(
                userData.name ?? "User Name",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          sbh20,
          const Divider(),
          sbh15,
          _dataField(
            emailIcon,
            (userData.email!.isEmpty)
                ? "Add Email Address"
                : userData.email ?? "Add Email Address",
          ),
          sbh15,
          _dataField(
            phoneIcon,
            (userData.phoneNumber!.isEmpty)
                ? "Add Phone Number"
                : userData.phoneNumber ?? "Add Phone Number",
          ),
          sbh15,
          _dataField(
            dobIcon,
            (dob == "0/0/0") ? "Add Date of Birth" : dob,
          ),
        ],
      ),
    );
  }

  Widget _dataField(String iconPath, String data) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          height: 30,
          color: primaryColor,
        ),
        sbw15,
        AutoSizeText(
          data,
          style: Theme.of(context).textTheme.titleMedium,
          minFontSize: 20,
          maxFontSize: 20,
          maxLines: 1,
        ),
      ],
    );
  }

  void changePhotoDilog(
    BuildContext context,
    WidgetRef ref,
    File file,
    UserData userData,
  ) {
    print("profile pic change function called");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: const Text('Change Profile Picture'),
          content: const Text('Are you sure ?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final String? newPfPic = await uploadUserPfpic(
                  file: file,
                  uid: "${userData.uid}",
                );
                ref
                    .watch(userDataNotifierProvider.notifier)
                    .updateCurrentUserData(profilePicUrl: newPfPic);
                setState(() {
                  uploadLoader = false;
                });
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
            ElevatedButton(
                onPressed: () {
                  print("profile pic change canceled");
                  setState(() {
                    uploadLoader = false;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("No")),
          ],
        );
      },
    );
  }
}