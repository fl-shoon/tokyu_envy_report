import subprocess
from pyutil.conf import conf,conf_test,conf_dev,conf_prod
from pyutil.flutter import get_defines, convert_to_define_str

def unit_test():
  defines = convert_to_define_str(get_defines(conf_test))
  subprocess.run(['fvm flutter test test/sample_unit_test.dart ' + defines], shell=True)

def widget_test():
  defines = convert_to_define_str(get_defines(conf_test))
  subprocess.run(['fvm flutter test test/sample_widget_test.dart ' + defines], shell=True)

def integration_test(device=""):
  options = []
  if device: options.append(f"-d {device}")

  defines = convert_to_define_str(get_defines(conf_test))
  subprocess.run([f"fvm flutter test integration_test/sample_integration_test.dart  {' '.join(options)} {defines}"], shell=True)

def integration_test_drive(device=""):
  options = []
  if device: options.append(f"-d {device}")

  defines = convert_to_define_str(get_defines(conf_test))
  subprocess.run([f"fvm flutter drive --driver=integration_test/sample_driver.dart --target=integration_test/sample_integration_drive.dart  {' '.join(options)} {defines}"], shell=True)
