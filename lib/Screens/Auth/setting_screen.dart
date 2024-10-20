import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:video_conference_app/constants/colors.dart';
import 'package:video_conference_app/services/auth_services.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  late AuthService _authService;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _customListtile(
              iconOrImage: const Icon(Icons.key),
              title: "Your Account",
              onTap: () {},
              subTitle: "Privacy, security, change number"),
          const SizedBox(
            height: 10,
          ),
          _customListtile(
            iconOrImage: const Icon(Icons.chat),
            title: "Chat",
            onTap: () {},
            subTitle: "Chat history,theme,wallpapers",
          ),
          const SizedBox(
            height: 10,
          ),
          _customListtile(
            iconOrImage: const Icon(Icons.notifications),
            title: "Notifications",
            onTap: () {},
            subTitle: "Messages, group and others",
          ),
          const SizedBox(
            height: 10,
          ),
          _customListtile(
            iconOrImage: const Icon(Icons.help),
            title: "Help",
            subTitle: "Help center,contact us, privacy policy",
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          _customListtile(
            iconOrImage: const Icon(Icons.group),
            title: "Invite a friend",
            onTap: () {},
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          _customListtile(
            iconOrImage: const Icon(Icons.logout_outlined),
            title: "Logout",
            onTap: () {
              _authService.logoutDilog(context, ref);
            },
          ),
        ],
      ),
    );
  }

  Widget _customListtile({
    required Widget iconOrImage,
    required String title,
    String? subTitle = "",
    required void Function() onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        foregroundColor: primaryColor,
        backgroundColor: Colors.grey.shade300,
        child: iconOrImage,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: (subTitle!.isNotEmpty)
          ? Text(
              subTitle,
              style: const TextStyle(
                color: Colors.grey,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}