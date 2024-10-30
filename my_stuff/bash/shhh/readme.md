# SHHH
Simple sHell-based (bash) tool to encrypt and Hashed messages based on public and private RSA keys.

## Features
- It uses Bash so it runs in any (?) linux machine
- ./basic.shh.sh has a menu. Use it
- It is based on OpenSSL CLI



### Principles
- Creates keys using: openssl genpkey -algorithm RSA -out private.pem -aes256 -pkeyopt rsa_keygen_bits:16386
- Extracts its public key using: openssl rsa -in private.pem -pubout -out public.pem
- Encrypts by: echo "Message" | openssl rsautl -encrypt -pubin -inkey public_key.pem | base64
- Decrypts by: base64 -d <<< "$message" | openssl rsautl -decrypt -inkey private_key.pem

##### Lvl 1
At the first stage, you can create your keys, share your public key with your friends and when they send you a short encripted message you can copy and paste it to be decrypted.
##### Lvl 2 (current)
The keys can be up to 16kb long to receive messages of up to 2kb long
##### lvl 3
The model will be migrated to an hibrid model so the messages can be of any length. There it'd be the 3rd "h"
##### lbl 4
Make it prettier using dialog. But in my current distribution, dialog has a bug on --editbox that doesn't allow text bigger than about 2k long

