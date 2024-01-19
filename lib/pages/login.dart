import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokyu_envy_report/etc/stream.dart';
import 'package:tokyu_envy_report/service/service_auth.dart';

final _email = StateProvider.autoDispose((ref) => TextEditingController());
final _password = StateProvider.autoDispose((ref) => TextEditingController());
final _enter = Provider.autoDispose((ref) {
  return () {
    final email = ref.read(_email).text;
    final pass = ref.read(_password).text;
    ref.read(streamProvider).add(TrySignin(email: email, password: pass));
  };
});

class SLogin extends ConsumerWidget {
  const SLogin() : super(key: const Key('s_login'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TOKYU ENVY'),
      ),
      body: Center(
        child: Card(
          color: theme.colorScheme.surfaceVariant,
          child: SizedBox(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'LOGIN',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'email:',
                    style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  TextField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: ref.watch(_email),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'password:',
                    style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  TextField(
                    obscureText: true,
                    controller: ref.watch(_password),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(_enter)();
                      },
                      child: const Text('Login'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
