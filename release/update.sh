#!/bin/bash


#####################################################################################
## ACTUALIZADOR DE ARCHIVO EJECUTABLE .JAR DEL PROYECTO: BrawlStars_TelegramBot    ##
#####################################################################################




######################################## SETEO COLORES ########################################

NEGRITA='\e[1m'
ROJO='\033[0;31m'
NARANJA='\033[0;33m'
VERDE='\033[0;32m'
AMARILLO='\e[93m'
CYAN='\e[96m'
NC='\033[0m' # No Color

#############################################################################################




######################################## SETEO RUTAS ########################################

# Ruta del proyecto: BrawlStars_JavaWrapper
RUTA_PROYECTO_JAVA_WRAPPER="/mnt/Datos/01_MEGA/01_ESTUDIOS/Proyectos_Eclipse/BrawlStars_JavaWrapper/"

# Ruta del proyecto: BrawlStars_TelegramBot 
RUTA_PROYECTO_TELEGRAM_BOT="/mnt/Datos/01_MEGA/01_ESTUDIOS/Proyectos_Eclipse/BrawlStars_TelegramBot/"

#############################################################################################




######################################## GENERO PRIMER JAR ########################################


echo -e "${AMARILLO}Generando libreria .jar de BrawlStars_JavaWrapper...${NC}${CYAN}"

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
	echo -e
	echo -e "${NC}############################################################################################"
	echo -e
	echo -e "${ROJO}${NEGRITA}ERROR update.sh${NC}"
	echo -e "${NARANJA}No se pudo generar el .jar de BrawlStars_JavaWrapper. Revisar salida de \"mvn install\""
	echo -e "Pista: tambien se puede revisar la salida de \"mvn test\"${NC}"
	echo -e
	echo -e "############################################################################################"
	echo -e
	echo -e
    exit 1 # en caso de que haya habido un error, el script finaliza
else 	
	echo -e "${NC}${VERDE}${NEGRITA}[OK]${NC} Libreria .jar de JavaWrapper generada correctamente."
	echo 
	echo
	echo
fi


# Actualizo la libreria JavaWrapper en el proyecto TelegramBot
# es decir, copio el .jar recien generado del JavaWrapper, hacia el proyecto del TelegramBot
echo -e "${AMARILLO}Copiando liberia .jar en BrawlStars_TelegramBot...${NC}"
cp target/*.jar ${RUTA_PROYECTO_TELEGRAM_BOT}/lib/bs_javawrapper.jar
echo -e "${VERDE}${NEGRITA}[OK]${NC} Libreria copiada correctamente."
echo -e 
echo -e
echo -e

# Limpio el proyecto JavaWrapper de todos los archivos generados por Maven (mvn install)
echo -e "${AMARILLO}Borrando archivos maven generados...${NC}"
mvn -q clean
echo -e "${VERDE}${NEGRITA}[OK]${NC} Limpieza terminada"
echo -e 
echo -e
echo -e

######################################################################################################





################################ GENERO EJECUTABLE DEL BOT DE TELEGRAM ################################

echo -e "${AMARILLO}Creando .jar ejecutable del bot de telegram...${NC}"

cd ${RUTA_PROYECTO_TELEGRAM_BOT}

# Genero .classes y empaqueto todo
mvn -q package

# Genero el .jar
ant -buildfile release/ant-BrawlStars_TelegramBot.xml

echo -e "${VERDE}${NEGRITA}[OK]${NC} Ejecutable generado exitosamente."
echo -e
echo -e
echo -e

echo -e "${AMARILLO}Borrando archivos maven generados...${NC}"
# Limpio el proyecto JavaWrapper de todos los archivos generados por Maven (mvn package)
mvn -q clean
echo -e "${VERDE}${NEGRITA}[OK]${NC} Limpieza terminada"
echo
echo
echo

#######################################################################################################





##################################### ACTUALIZO BOT EN RASPBERRY PI #####################################


echo -e "${AMARILLO}Enviando .jar actualizado a la Raspberry Pi...${NC}"

scp /mnt/Datos/01_MEGA/01_ESTUDIOS/Proyectos_Eclipse/BrawlStars_TelegramBot/release/BrawlStars_TelegramBot.jar pi@192.168.0.2:/home/pi/BrawlStars_TelegramBot/new.jar

echo -e "${VERDE}${NEGRITA}[OK]${NC} .jar enviado correctamente"
echo
echo
echo


echo -e "${AMARILLO}Actualizando bot en Raspberry Pi...${NC}"
ssh pi@192.168.0.2 'cd BrawlStars_TelegramBot/ ; ./admin-bot.sh actualizar'
echo
echo -e "${VERDE}${NEGRITA}[OK]${NC} ¡Actualizacion terminada!"
echo


#######################################################################################################
