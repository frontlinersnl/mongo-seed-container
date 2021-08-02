# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0]

Added the ability to pass in "DYNAMIC_DATABASE_NAME" to enable users to replace a specific string (DB_NAME_PATTERN) within the connection url with the value of $MONGO_DB

## [2.1.0]

Added an extra param IGNORE_NON_EMPTY which, when set to true, will ignore collection that already exist and have documents in them.

## [2.0.0]

moved the script into a separate folder

## [1.0.1]

script now fails if a single import fails :)

## [1.0.0]

initial implementation
