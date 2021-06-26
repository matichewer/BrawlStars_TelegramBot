#!/bin/bash


#########################################################################################################

# 	ADMINISTRADOR DE PROYECTOS: 
# 		- BrawlStars_JavaWrapper
# 		- BrawlStars_TelegramBot


# REQUISITOS:
#	- Tener los 2 proyectos descargados
#	- Tener las siguientes programas:
#		. Minimo Java 8
#		. Maven
#		. Ant y el archivo XML de configuracion para generar el proyecto TelegramBot
#	- Revisar la funcion "opcion4()": se debe configurar una RaspberryPi para alojar y ejecutar el bot


#########################################################################################################




############################################### SETEO RUTAS ###############################################

# Ruta del proyecto: BrawlStars_JavaWrapper
RUTA_PROYECTO_JAVA_WRAPPER="/mnt/Datos/01_MEGA/01_ESTUDIOS/Proyectos_Eclipse/BrawlStars_JavaWrapper/"

# Ruta del proyecto: BrawlStars_TelegramBot 
RUTA_PROYECTO_TELEGRAM_BOT="/mnt/Datos/01_MEGA/01_ESTUDIOS/Proyectos_Eclipse/BrawlStars_TelegramBot/"

###########################################################################################################





############################################## SETEO COLORES ##############################################

NEGRITA='\e[1m'
ROJO='\033[0;31m'
NARANJA='\033[0;33m'
VERDE='\033[0;32m'
AMARILLO='\e[93m'
CYAN='\e[96m'
NC='\033[0m' # No Color

###########################################################################################################





# Genero libreria .jar del proyecto JavaWrapper
opcion1(){

	echo -e "${AMARILLO}Generando libreria .jar de BrawlStars_JavaWrapper...${NC}${CYAN}"
	echo 

	# Entro a la ruta del JavaWrapper
	cd ${RUTA_PROYECTO_JAVA_WRAPPER}

	# Genero el .jar para usarlo como libreria (no es un ejecutable)
	mvn -q install # "-q" para que se haga en silencio, solo escribe si encuentra error

	# Chequeo que se haya generado el .jar
	CANT_JAR_FILES=$(ls target/*.jar 2> /dev/null | wc -l)
	if [ "$CANT_JAR_FILES" = "0" ]
	then
		echo -e 
		echo -e 
		echo -e
		echo -e "${NC}##################################################################################################"
		echo -e
		echo -e "${ROJO}${NEGRITA}[ERROR]${NC} No se pudo generar el .jar de BrawlStars_JavaWrapper. Revisar salida de \"mvn install\""
		echo -e "Pista: tambien se puede revisar la salida de \"mvn test\""
		echo -e
		echo -e "##################################################################################################"
		echo -e
		echo -e
	    exit 1 # en caso de que haya habido un error, el script finaliza
	else 	
		echo
		echo -e "${NC}${VERDE}${NEGRITA}[OK]${NC} Libreria .jar de JavaWrapper generada correctamente."
		echo 
	fi
}



# Muevo la libreria de la opcion 1 hacia el proyecto TelegramBot
opcion2(){

	cd ${RUTA_PROYECTO_JAVA_WRAPPER}

	echo -e "${AMARILLO}Copiando liberia .jar en BrawlStars_TelegramBot...${NC}"

	# Actualizo la libreria JavaWrapper en el proyecto TelegramBot
	# es decir, copio el .jar recien generado del JavaWrapper, hacia el proyecto del TelegramBot
	cp target/*.jar ${RUTA_PROYECTO_TELEGRAM_BOT}/lib/bs_javawrapper.jar

	echo -e "${VERDE}${NEGRITA}[OK]${NC} Libreria copiada correctamente."
	echo -e 
}



# Genero ejecutable .jar del proyecto TelegramBot
opcion3(){

	cd ${RUTA_PROYECTO_TELEGRAM_BOT}

	echo -e "${AMARILLO}Creando .jar ejecutable del bot de telegram...${NC}"

	# Genero .classes y empaqueto todo
	mvn -q package

	# Genero el .jar
	# RECORDAR TENER EL .XML PARA QUE FUNCIONE ANT
	ant -buildfile release/ant-BrawlStars_TelegramBot.xml

	echo -e "${VERDE}${NEGRITA}[OK]${NC} Ejecutable generado exitosamente."
	echo -e
}



# Actualizo el bot de telegram que está ejecutandose en la Raspberry
opcion4(){
	echo -e "${AMARILLO}Enviando .jar actualizado a la Raspberry Pi...${NC}"

	scp ${RUTA_PROYECTO_TELEGRAM_BOT}/release/BrawlStars_TelegramBot.jar pi@192.168.0.2:/home/pi/BrawlStars_TelegramBot/new.jar

	echo -e "${VERDE}${NEGRITA}[OK]${NC} .jar enviado correctamente"
	echo

	echo -e "${AMARILLO}Actualizando bot en Raspberry Pi...${NC}"
	ssh pi@192.168.0.2 'cd BrawlStars_TelegramBot/ ; ./bot.sh actualizar'
	echo -e "${VERDE}${NEGRITA}[OK]${NC} ¡Actualizacion terminada!"
	echo
}



# Limpio el proyecto de todos los archivos generados por Maven (mvn install)
# REQUIERE DE ANTEMANO ESTAR DENTRO EN LA CARPETA DEL PROYECTO QUE SE QUIERA LIMPIAR
limpiezaMaven(){
	echo -e "${AMARILLO}Borrando archivos maven generados...${NC}"
	mvn -q clean
	echo -e "${VERDE}${NEGRITA}[OK]${NC} Limpieza terminada"
	echo
}



echo -e
echo -e "${NEGRITA}${AMARILLO}Selecciona la opcion que desee:${NC}"
echo -e 
echo -e "   ${NEGRITA}${AMARILLO}1.${NC} Generar libreria .jar del proyecto JavaWrapper."
echo -e "   ${NEGRITA}${AMARILLO}2.${NC} Mover la libreria de la opcion 1 hacia el proyecto TelegramBot."
echo -e "   ${NEGRITA}${AMARILLO}3.${NC} Generar ejecutable .jar del proyecto TelegramBot."
echo -e "   ${NEGRITA}${AMARILLO}4.${NC} Actualizar el bot de telegram que está ejecutandose en la Raspberry."
echo -e 
echo -e "   ${NEGRITA}${AMARILLO}5.${NC} Realiza la opcion 1,2 (en ese orden)."
echo -e "   ${NEGRITA}${AMARILLO}6.${NC} Realiza la opcion 1,2,3 (en ese orden)."
echo -e "   ${NEGRITA}${AMARILLO}7.${NC} Realiza la opcion 1,2,3,4 (en ese orden)."
echo -e
echo -e "   ${NEGRITA}${AMARILLO}8.${NC} Limpiar proyecto JavaWrapper (mvn clean)."
echo -e "   ${NEGRITA}${AMARILLO}9.${NC} Limpiar proyecto TelegramBot (mvn clean)."
echo -e


read opcion
echo
case $opcion in
  1)
    opcion1
  ;;
  2)
    opcion2
  ;;
  3)
    opcion3
  ;;
  4)
    opcion4
  ;;
  5)
    opcion1
    opcion2
  ;;
  6)
    opcion1
    opcion2
    opcion3
  ;;
  7)
    opcion1
    opcion2
    opcion3
    opcion4
  ;;
  8)
	cd ${RUTA_PROYECTO_JAVA_WRAPPER}
	limpiezaMaven
  ;;
  9)
	cd ${RUTA_PROYECTO_TELEGRAM_BOT}
    limpiezaMaven
  ;;
  *)
	echo -e "${ROJO}${NEGRITA}[ERROR]${NC} Opcion incorrecta. Saliendo...${NC}"
    exit 1
  ;;
esac

# Saliendo a la home
cd
$SHELL