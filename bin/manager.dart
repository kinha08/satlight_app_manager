import 'dart:convert';
import 'dart:io';

import 'package:manager/copy_directory.dart';
import 'package:manager/manager.dart' as manager;
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:yaml_modify/yaml_modify.dart';

void main(List<String> arguments) async {
  Directory githubPath = Directory("C:/Users/Lucas/Documents/GitHub");
  String mainProjectPath = path.join(githubPath.path, "satlight_pro_app");

  if (arguments.isNotEmpty && arguments.length < 2) {
    if (arguments.contains("create")) {
      // Copy file from main project to new project
      Directory newProject =
          Directory(path.join(githubPath.path, "new_project_app"));
      newProject.createSync();

      Directory mainProject = Directory(mainProjectPath);

      copyDirectory(mainProject, newProject);

      // Change pubspec.yaml for new project configuration
      manager.pubspecCreate(
        newProject.path,
        name: "Projeto Novo",
      );

      // Change package_rename_config.yaml for new project configuration
      manager.packageRenameCreate(
        newProject.path,
        appName: "Teste",
        packageName: "teste_app",
      );

      Map<String, String> env = await manager.readDotEnvFile(mainProjectPath);
      print('ENV $env');
      env.forEach((key, value) {
        print("Enter value to $key");
        String? newValue = stdin.readLineSync();
        env[key] = newValue.toString();
      });

      manager.writeDotEnv(newProject.path, env);
    }
  } else {
    print("""Usage manager
dart run manager [argument]

arguments:

create      create a new project
update      update one project
""");
  }
}
