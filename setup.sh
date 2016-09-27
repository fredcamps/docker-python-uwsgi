#!/bin/bash
pip"${PYTHON_VER:0:1}" install --upgrade pip virtualenvwrapper setuptools
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python${PYTHON_VER:0:1}" >> /root/.bashrc
echo "export VIRTUALENVWRAPPER_VIRTUALENV=/opt/python/bin/virtualenv" >> /root/.bashrc
echo "source /opt/python/bin/virtualenvwrapper.sh" >> /root/.bashrc
