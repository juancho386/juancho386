## Inicial

### Generar claves
openssl genpkey -algorithm RSA -out shhh_private.pem -aes256 -pkeyopt rsa_keygen_bits:16386
openssl rsa -in shhh.private.pem -pubout -out shhh.public.pem

### Encriptar
echo "Mensaje secreto" | openssl rsautl -encrypt -pubin -inkey public_key.pem | base64 > mensajito

### desencriptar
cat mensajito | base64 -d | openssl rsautl -decrypt -inkey private_key.pem 2>/dev/null

idea:
- bash con dialog
- que se puedan pegar mensajes para encriptar y desencriptar
- que use archivos temporales
- documentar el tamaÑo máximo
- que tenga trap para borrar los archivos temporales
- output a consola y potencialemente al buffer de pegado
- V2: detectar ambiente: tmux? bash normal?
- repo propio en github
- ponerle nombre copado?

