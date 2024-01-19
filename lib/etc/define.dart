const appName = String.fromEnvironment('APP_NAME');
const appEnv = String.fromEnvironment('APP_ENV');

bool get isTesting => appEnv == 'test' || appEnv.isEmpty;

const answers1 = [
  'よく知っている',
  '何となく知っていた',
  '知らなかった',
];
const answers2 = [
  'よく理解できた',
  'なんとなく理解できた',
  'よくわからなかった',
];
