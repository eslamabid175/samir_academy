import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: ListView(
        children: [
          ListTile(
            title: Text('language'.tr()),
            subtitle: const Text('English'),
            onTap: () {
              // TODO: Implement language switcher
              Fluttertoast.showToast(msg: 'Language switcher not implemented yet');
            },
          ),
          SwitchListTile(
            title: Text('dark_mode'.tr()),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              // TODO: Implement dark mode toggle
              Fluttertoast.showToast(msg: 'Dark mode toggle not implemented yet');
            },
          ),
          ListTile(
            title: Text('logout'.tr()),
            onTap: () {
              context.read<AuthBloc>().add(LogOutEvent());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}