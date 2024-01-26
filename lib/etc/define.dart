import 'package:flutter/material.dart';

const appName = String.fromEnvironment('APP_NAME');
const appEnv = String.fromEnvironment('APP_ENV');

bool get isTesting => appEnv == 'test' || appEnv.isEmpty;

const questions = [
  '当社では2014年より再生可能エネルギー事業に\n取り組み、国内の保有施設の電力を100％再生可能エネルギー化達成していること。',
  '全国80カ所以上で再生可能エネルギーを発電し、原子力発電所1基分を超える発電を行っていること。',
  '総合ディベロッパーとして、企画・施工・アフターサービス・管理までの一元化やリゾート施設・シェアオフィスなど様々な暮らしのサポートを行っていること。',
  '東急コミュニティーではBRANZ推進センターを設置。東急不動産の商品企画から携わり、管理までのお客様の声をフィードバックすることにより、今後のBRANZに活かされること。'
];

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
const answers2Colors = [Colors.greenAccent, Color(0xFFAAAAAA), Color(0xFF484039)];
