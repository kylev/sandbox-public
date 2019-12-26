from setuptools import setup, find_packages

setup(
    name="opsbot",
    version="0.1",
    packages=find_packages(),
    install_requires=['boto3>=1.10', 'nose'],
    test_suite='nose.collector',
    tests_require=['moto', 'nose'],
)
