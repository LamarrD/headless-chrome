#!/bin/bash
python3 -m venv venv
source venv/bin/activate

mkdir -p package/python
pip install -r requirements.txt -t package/python

cp lambda_function.py package/
cd package
zip -r ../lambda_function.zip .

cd ..
rm -rf package
deactivate
rm -rf venv