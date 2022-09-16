import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

void packageRenameCreate(
  String newProjectPath, {
  required String appName,
  required String packageName,
  String? androidPackageName,
  String? androidAppName,
  String? iosAppName,
  String? iosBundleName,
  String? iosPackageName,
  String? webAppName,
  String? webDescription,
  String? linuxAppName,
  String? linuxPackageName,
  String? linuxExeName,
  String? windowsAppName,
  String? windowsOrganization,
  String? windowsCopyrightNotice,
  String? windowsExeName,
  String? macOsAppName,
  String? macOsPackageName,
  String? macOsCopyrightNotice,
}) {
  String packageRenamePath = path.join(
    newProjectPath,
    "package_rename_config.yaml",
  );
  File packageRenameFile = File(packageRenamePath);

  var yamlWriter = YAMLWriter();

  var packageRename = yamlWriter.write({
    "package_rename_config": {
      'android': {
        'app_name': androidAppName ?? appName,
        'package_name': androidPackageName ?? packageName,
      },
      'ios': {
        'app_name': iosAppName ?? appName,
        'bundle_name': iosBundleName ?? appName,
        'package_name': iosPackageName ?? packageName,
      },
      'web': {
        'app_name': webAppName ?? appName,
        'description':
            webDescription ?? 'Package to change project configurations.',
      },
      'linux': {
        'app_name': linuxAppName ?? appName,
        'package_name': linuxPackageName ?? packageName,
        'exe_name': linuxExeName ?? 'executable-linux',
      },
      'windows': {
        'app_name': windowsAppName ?? appName,
        'organization': windowsOrganization ?? appName,
        'copyright_notice': windowsCopyrightNotice ??
            'Copyright ©️ 2022 $appName. All rights reserved.',
        'exe_name': windowsExeName ?? 'executable-windows',
      },
      'macos': {
        'app_name': macOsAppName ?? appName,
        'package_name': macOsPackageName ?? packageName,
        'copyright_notice': macOsCopyrightNotice ??
            'Copyright ©️ 2022 $appName. All rights reserved.',
      },
    },
  });
  packageRenameFile.writeAsStringSync(packageRename);
}

void pubspecCreate(
  String newProject, {
  required String name,
  String? description,
  String? version,
  String? environmentSdk,
  String? nativeSplashColor,
  String? adaptiveIconBackground,
}) {
  String pubspecPath = path.join(newProject, "pubspec.yaml");
  File pubspecFile = File(pubspecPath);
  String pubspecYamlString = pubspecFile.readAsStringSync();
  Map pubspecYaml = loadYaml(pubspecYamlString);

  var yamlWriter = YAMLWriter();

  var pubspec = yamlWriter.write({
    "name": name,
    "description": description ?? "Aplicativo para rastreamento veicular.",
    "publish_to": "none",
    "version": version ?? pubspecYaml['version'],
    "environment": {"sdk": environmentSdk ?? pubspecYaml['environment']['sdk']},
    "dependencies": pubspecYaml['dependencies'],
    "flutter_native_splash": {
      "color":
          nativeSplashColor ?? pubspecYaml['flutter_native_splash']['color'],
      "image": pubspecYaml['flutter_native_splash']['image'],
      "android": pubspecYaml['flutter_native_splash']['android'],
      "android12": pubspecYaml['flutter_native_splash']['android12'],
      "ios": pubspecYaml['flutter_native_splash']['ios']
    },
    "flutter_icons": {
      "image_path": pubspecYaml['flutter_icons']['image_path'],
      "ios": pubspecYaml['flutter_icons']['ios'],
      "remove_alpha_ios": pubspecYaml['flutter_icons']['remove_alpha_ios'],
      "android": pubspecYaml['flutter_icons']['android'],
      "adaptive_icon_background": adaptiveIconBackground ??
          pubspecYaml['flutter_icons']['adaptive_icon_background'],
      "adaptive_icon_foreground": pubspecYaml['flutter_icons']
          ['adaptive_icon_foreground'],
    },
    "package_rename": {"path": "../"},
    "dev_dependencies": pubspecYaml['dev_dependencies'],
    "flutter": pubspecYaml['flutter'],
  });

  pubspecFile.writeAsStringSync(pubspec);
}

Future<Map<String, String>> readDotEnvFile(String mainPath) async {
  File envFile = File(path.join(mainPath, ".env"));
  Stream<String> lines =
      envFile.openRead().transform(utf8.decoder).transform(LineSplitter());
  RegExp exp = RegExp(r'(.*)=(.*)');
  Map<String, String> env = {};
  try {
    await for (var line in lines) {
      exp.allMatches(line).forEach((element) {
        var temp = {
          element[1].toString(): element[2].toString(),
        };
        env.addEntries(temp.entries);
      });
    }
    print(env);
  } catch (e) {
    print('Error: $e');
  }

  return env;
}

void writeDotEnv(String mainPath, Map<String, String> newEnv) {
  File envFile = File(path.join(mainPath, ".env"));
  String envString = '';
  newEnv.forEach((key, value) {
    envString += "$key=$value\n";
  });
  envFile.writeAsBytesSync(utf8.encode(envString));
}
