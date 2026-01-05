---
title: Encryption at Rest Glossary
html_title: Encryption at Rest Glossary
permalink: encryption-at-rest-glossary
layout: docs
section: encryption_at_rest
edition: enterprise
description: Technical glossary of key encryption at rest terms and concepts
---

# Encryption at Rest Glossary

This glossary provides definitions of key technical terms and concepts used throughout the Encryption at Rest documentation.

## A

**AES (Advanced Encryption Standard)**
: A symmetric encryption algorithm widely used for securing data. Search Guard uses AES-256 for encrypting index data.

**AES-256**
: A variant of AES using 256-bit keys, providing strong encryption for data at rest.

## C

**Ciphertext**
: Data that has been encrypted and is unreadable without the decryption key.

**Crypto Store**
: The component responsible for managing encryption keys and performing encryption/decryption operations.

## D

**Data at Rest**
: Data stored on disk in a persistent state, as opposed to data in transit or in memory.

**Decryption**
: The process of converting encrypted data back to its original plaintext form using the appropriate key.

## E

**Encrypted Index**
: An Elasticsearch index configured to store its data in encrypted form on disk.

**Encrypted Store**
: A custom Lucene store implementation that encrypts data before writing to disk and decrypts when reading.

**Encryption**
: The process of converting plaintext data into ciphertext to protect it from unauthorized access.

**Encryption at Rest**
: The encryption of data while it is stored on disk, protecting against unauthorized access to physical storage.

**Encryption Key**
: The secret value used to encrypt and decrypt data. Search Guard uses symmetric keys for encryption at rest.

**enctl**
: The command-line tool for managing encryption at rest, including key initialization and rotation.

## I

**Index Setting**
: Configuration parameters that control index behavior, including encryption settings.

**Initialization**
: The process of setting up encryption for the first time, including generating master keys.

## K

**Key Rotation**
: The process of replacing encryption keys with new ones to enhance security, involving re-encryption of data.

**Keystore**
: A secure storage location for encryption keys, protecting them from unauthorized access.

## L

**Lucene**
: The underlying search library used by Elasticsearch. Encryption at rest integrates at the Lucene store level.

## M

**Master Key**
: The primary encryption key used to encrypt data encryption keys or directly encrypt index data.

**Metadata**
: Information about encrypted data, such as which key was used for encryption and algorithm parameters.

## P

**Plaintext**
: Unencrypted, readable data before encryption or after decryption.

## R

**Re-encryption**
: The process of decrypting data with an old key and encrypting it with a new key, typically during key rotation.

## S

**Store Type**
: The Lucene store implementation used by an index. Encrypted indices use the `encrypted` store type.

**Symmetric Encryption**
: An encryption method where the same key is used for both encryption and decryption.

## T

**Transparent Encryption**
: Encryption that happens automatically without requiring application-level changes, handled by the storage layer.
