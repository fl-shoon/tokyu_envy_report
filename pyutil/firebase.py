from datetime import datetime
import json
import os, subprocess
import firebase_admin
from firebase_admin import credentials,auth,firestore,storage

storageBucket = "daiyame-44bdf.appspot.com"

def set_security_rules():
    subprocess.run(["firebase deploy --only firestore:rules"], shell=True)
    subprocess.run(["firebase deploy --only firestore:indexes"], shell=True)
    subprocess.run(["firebase deploy --only storage"], shell=True)

def set_cors():
    os.system("gsutil cors set ./cors.json gs://" + storageBucket)

def get_cors():
    os.system("gsutil cors get gs://" + storageBucket)

def _init():
    cred = credentials.Certificate("secrets/firebase_admin.json")
    firebase_admin.initialize_app(cred, {
       'storageBucket': storageBucket
    })

def set_email_verified(email, value='true'):
    _init()

    user = auth.get_user_by_email(email)
    uid: str = user.uid
    if value == 'true':
        value = True
    elif value == 'false':
        value = False
    else: return
    
    auth.update_user(uid, email_verified=value)
    user = auth.get_user_by_email(email)
    print(user.uid)
    print(user.email_verified)

def set_claims(email, param, value='', remove=False):
    _init()

    user = auth.get_user_by_email(email)
    uid: str = user.uid
    claims = user.custom_claims or {}

    if remove:
        claims.pop(param)
    else:
        if value == 'true' or value == 'false':
            value = bool(value.capitalize())
        claims[param] = value
    
    print('uid: ' + uid)
    print(email)
    print(claims)
    auth.set_custom_user_claims(uid, claims)

# 以下サンプル
def f_store():
    db = firestore.client()
    docs = db.collection(u'users').stream()

    for doc in docs:
        print(f'{doc.id} => {doc.to_dict()}')

def f_storage():
    bucket = storage.bucket(storageBucket)
    bucket = storage.bucket()
    source_file_name = 'imagefile'
    destination_blob_name = 'storage/01.jpg'
    
    #bucket = storage.bucket(bucket_name)
    blob = bucket.blob(source_file_name)
    blob.upload_from_filename(destination_blob_name)
    print(
        f"File {source_file_name} uploaded to {destination_blob_name}."
    )