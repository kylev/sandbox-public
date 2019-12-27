from setuptools import setup, find_packages

setup(
    name="opsbot",
    version="0.1",
    packages=find_packages(),
    test_suite='nose.collector',
    extras_require={
        'development': ['moto', 'nose'],
    }
)
