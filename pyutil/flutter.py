import os, subprocess, yaml, shutil
from pyutil.conf import conf,conf_dev,conf_prod

def pub():
  subprocess.run(["fvm flutter pub get"], shell=True)

def icon(env="dev"):
  shutil.copyfile('./pyutil/assets/icon_'+env+'.png', './assets/icon.png')
  os.system("fvm flutter pub run flutter_launcher_icons:main")

def splash(env='dev'):
  os.system("fvm flutter pub run flutter_native_splash:create --path=./pyutil/assets/splash_"+env+".yaml")

def l10n():
  subprocess.run(["fvm flutter gen-l10n"], shell=True)

def get_defines(prod=False):
  with open('./pubspec.yaml', mode='r') as file:
    pubspec = yaml.safe_load(file)
  
  defines = conf | (conf_prod if prod else conf_dev)
  defines["APP_VERSION"] = pubspec["version"]
  return defines

def convert_to_define_str(defines=dict()):
  list = []
  for k, v in defines.items():
    list.append(f"--dart-define={k}={v}")
  return " ".join(list)

def run(
  target="./lib/main.dart",  
  mode="debug",
  device="",
  verbose=False,
  prod=False,
):
  '''
  -t: target file
  -m: specify mode
  '''

  defines = get_defines(prod)

  env = defines["APP_ENV"]
  icon(env)
  splash(env)

  pub()
  l10n()

  options = ["--" + mode]
  if verbose: options.append("--verbose")
  if device: options.append(f"-d {device}")
  exec = f"fvm flutter run -t {target} {' '.join(options)} {convert_to_define_str(defines)}"

  print(exec)
  os.system(exec)

def android_jks():
  alias = conf["APP_KEY_ALIAS"]
  subprocess.run(["sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk"], shell=True)
  # FIXME: -storetype JKSをつけないとbuildできない（なぜ？？
  os.system("keytool -genkey -v -keystore ./android/"+alias+".jks -keyalg RSA -keysize 2048 -validity 10000 -alias "+alias+" -storetype JKS")

def android_build(prod=False):
  defines = get_defines(prod)

  env = defines["APP_ENV"]
  icon(env)
  splash(env)

  pub()
  l10n()
    
  exec = f"fvm flutter build appbundle {convert_to_define_str(defines)}"
  os.system(exec)

def web_deploy(prod=False):
  defines = get_defines(prod)
  exec = f"fvm flutter build web {convert_to_define_str(defines)}"
  print(exec)
  
  subprocess.run([exec], shell=True)
  
  if prod:
      os.system("firebase deploy -P production --only hosting:app")
  else:
      os.system("firebase deploy -P default --only hosting:app")