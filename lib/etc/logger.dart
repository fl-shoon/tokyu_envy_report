import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logger = Logger('root');
void setupLogger({disabled = false}) {
  if (disabled) {
    Logger.root.level = Level.OFF;
    return;
  }

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    print('${event.level.name}: ${event.time}: ${event.message}');
  });
  
  logger.shout('shout');
  logger.severe('severe');
  logger.warning('warning');
  logger.info('info');
  logger.config('config');
  logger.fine('fine');
  logger.finer('finer');
  logger.finest('finest');
}

class ProviderLogger extends ProviderObserver {
  const ProviderLogger();

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (provider.name == null) return;
    logger.info('''
{
  "provider": "${provider.name}:${provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}
