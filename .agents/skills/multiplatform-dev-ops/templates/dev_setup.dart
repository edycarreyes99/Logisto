import 'dart:io';

/// Automated setup script to clean, fetch dependencies, generate localizations, and analyze code.
void main() async {
  stdout.writeln('=== Climatica Multiplatform Environment Setup ===');

  await _runStep('1. Flutter Clean', 'flutter', ['clean']);
  await _runStep('2. Pub Get Dependencies', 'flutter', ['pub', 'get']);
  await _runStep('3. Generate Localizations', 'flutter', ['gen-l10n']);
  await _runStep('4. Analyze Static Code', 'flutter', ['analyze']);
  await _runStep('5. Validate Dart Documentation', 'dart', ['doc', '--validate-links']);

  stdout.writeln('=== All Environment Checks Passed Successfully ===');
}

Future<void> _runStep(String label, String executable, List<String> arguments) async {
  stdout.writeln('\n--> Running: $label');
  final result = await Process.run(executable, arguments, runInShell: true);
  if (result.stdout.toString().isNotEmpty) {
    stdout.write(result.stdout);
  }
  if (result.stderr.toString().isNotEmpty) {
    stderr.write(result.stderr);
  }
  if (result.exitCode != 0) {
    stderr.writeln('FAILURE in $label. Exiting with code ${result.exitCode}.');
    exit(result.exitCode);
  }
}
