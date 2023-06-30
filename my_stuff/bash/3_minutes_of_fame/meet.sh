#!/bin/bash

## Funciones
function err() {
  txt=$(cat <<EndOfTexto
Error...
Falta la variables de entorno MEET_PEOPLE

Se puede cargar fijas (por ejemplo) en el .bashrc. Ejemplo:
  export MEET_PEOPLE="John Paul George Ringo"

O, se pueden pasar localmente. 
MEET_PEOPLE="John Paul George Ringo" ./meet.sh
EndOfTexto
)
  dialog $DIALOG_PARAM --msgbox "$txt" 18 70
  exit 1
}


function timer() {
  dialog $DIALOG_PARAM --ok-label " Terminé antes " --no-cancel --pause "${1}'s time" 8 70 $MEET_SECONDS
}


## Verificar dependencias
which dialog>/dev/null; [ $? -ne 0 ] && echo "Please install dialog" && exit 1
which bc>/dev/null;     [ $? -ne 0 ] && echo "Please install bc" && exit 1
which sed>/dev/null;    [ $? -ne 0 ] && echo "Please install sed" && exit 1
which tr>/dev/null;     [ $? -ne 0 ] && echo "Please install tr" && exit 1
which shuf>/dev/null;   [ $? -ne 0 ] && echo "Please install shuf" && exit 1

if [ "$1" == "" ]; then
	DIALOG_PARAM="--no-shadow"
else
	DIALOG_PARAM="$1"
fi


## Pasar lista al principio
parsed=$(echo $MEET_PEOPLE |tr " " "\n"|sort|tr "\n" " "|sed -E "s/([^ ]+)/\1 \1 0/g")
asistencia=$(dialog $DIALOG_PARAM --stdout --visit-items --buildlist "Presentes" 25 70 22 $parsed | tr " " "\n" | shuf | tr "\n" " " )
if [ "${asistencia}" == "" ]; then
  dialog $DIALOG_PARAM --infobox "Nada por acá. Cerranding." 5 70
  exit 0
fi
personas=$asistencia



## Pregunto el tiempo después de saber quienes están porque varía segun quienes somos
while 
  MEET_SECONDS=$(dialog $DIALOG_PARAM --no-cancel --stdout --inputbox "¿Cuantos segudos?" 8 30 180)
  [[ -z $MEET_SECONDS || $MEET_SECONDS  == *[^0-9]* ]]
do true;done

mm=$(bc <<< "$MEET_SECONDS / 60")
[ $mm -lt 10 ] && mm=0${mm}

ss=$(bc <<< "$MEET_SECONDS % 60")
[ $ss -lt 10 ] && ss=0${ss}
mins=${mm}:${ss}

if [ x$MEET_PEOPLE == x ] 2>/dev/null; then
  err
fi



## MAIN
for a in $asistencia; do
  who=$(dialog $DIALOG_PARAM --no-items --no-cancel --stdout --menu "${mins} minutos" 20 70 18 $personas)
  # echo "Dale ${who}. Te toca" | espeak -v es-la
  timer ${who}
  personas=$(echo $personas | sed -E "s/$who([ ]?)//g")
done


dialog $DIALOG_PARAM --stdout --yesno "¿Entró alguien después de empezar?" 6 40

if [ $? == 0 ]; then
  facturas=$(echo -e "\\U1f950")
  asistencia=$(dialog $DIALOG_PARAM --stdout --visit-items --buildlist "¿Quién falta? (${facturas})" 25 70 22 $parsed | tr " " "\n" | shuf | tr "\n" " " )
  personas=$asistencia

  for a in $asistencia; do
    who=$(dialog $DIALOG_PARAM --no-items --stdout --no-cancel --menu "${mins} minutos" 20 70 18 $personas)
    timer "$facturas team: ${who}"
    personas=$(echo $personas | sed -E "s/$who([ ]?)//g")
  done
fi


hoy=$(date +%u)
dias=(Domingo Lunes Martes Antepreviernes Previernes Viernes Sábado)
fin="Que tengan todos un excelente ${dias[$hoy]}"

dialog --ok-label "joya" $DIALOG_PARAM --msgbox "$fin" 6 70



