// ignore_for_file: avoid_print

import 'dart:io';

/// 🌱 Automatiza la configuración del entorno de desarrollo Flutter.
///
/// Ejecuta los comandos esenciales en orden:
/// 1️⃣ flutter clean  
/// 2️⃣ flutter pub get  
/// 3️⃣ flutter gen-l10n  
/// 4️⃣ flutter pub run flutter_launcher_icons  
/// 5️⃣ flutter pub run build_runner build --delete-conflicting-outputs
///
/// Compatible con Windows, macOS y Linux.
Future<void> main() async {
  print('\x1B[36m🚀 Iniciando preparación del entorno Flutter...\x1B[0m\n');

  final commands = [
    ['flutter', ['clean']],
    ['flutter', ['pub', 'get']],
    ['flutter', ['gen-l10n']],
    ['flutter', ['pub', 'run', 'flutter_launcher_icons']],
    ['flutter', ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs']],
  ];

  for (final cmd in commands) {
    final command = cmd[0] as String;
    final args = cmd[1] as List<String>;

    print('\x1B[33m▶️ Ejecutando: $command ${args.join(" ")}\x1B[0m');

    final success = await _runCommand(command, args);

    if (!success) {
      print('\x1B[31m❌ Error ejecutando "$command ${args.join(" ")}"\x1B[0m');
      exit(1);
    }
  }

  print('\n\x1B[32m✅ Configuración completada exitosamente.\x1B[0m');
}

/// Ejecuta un comando y muestra su salida en tiempo real.
/// Devuelve `true` si el proceso finaliza con código 0.
Future<bool> _runCommand(String command, List<String> args) async {
  final process = await Process.start(
    command,
    args,
    runInShell: true, // 👈 necesario en Windows
  );

  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);

  final exitCode = await process.exitCode;
  return exitCode == 0;
}
