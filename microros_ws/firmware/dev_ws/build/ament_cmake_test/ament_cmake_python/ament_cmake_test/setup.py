from setuptools import find_packages
from setuptools import setup

setup(
    name='ament_cmake_test',
    version='2.0.3',
    packages=find_packages(
        include=('ament_cmake_test', 'ament_cmake_test.*')),
)
