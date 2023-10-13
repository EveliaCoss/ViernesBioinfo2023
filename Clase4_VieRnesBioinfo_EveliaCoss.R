# Title: Visualizacion de datos ggplot2
# Author: Evelia Coss
# Date:  12/10/2023

###---- Instalacion de paquetes ----
install.packages("dplyr")    # Manipulación de datos
install.packages("tidyr")    # Manipulación de datos
install.packages("tidyverse")# Manipulación de datos
install.packages("reshape2") # Transformación de datos

###---- Otra manera de Instalacion de paquetes ----
install.packages("pacman") # Paquete de instalacion de otros paquetes
library(pacman)
p_load("dplyr", "tidyr") # los instala de ser necesario y los carga en el ambiente

###---- Cargar paquetes ----
library(dplyr)     # Manipulación de datos
library(tidyr)     # Manipulación de datos
library(tidyverse) # Manipulación de datos
library(reshape2)  # Transformación de datos

###---- %>% pipeline ----

# Empleando el paquete `Tidyverse` y `dplyr` puedes acceder a usar `%>%`, 
# el cual nos permitirá enlazar funciones en la modificación de un dataframe. 

df <- data.frame(genes = paste0("Gen", seq_len(8)), 
                 expression = c(3.8, 5.5, 6.3, 1.8, 9, rep(3,3)), 
                 treatment =c(rep("Control", 4), rep("Condicion1",4)))

df %>% head()

###---- Script ----  

######
# Script de Manipulacion de datos
# Evelia Coss
# 12 de octubre 2023
#######

###--- Directorio ----
getwd() # nota de aqui saque la direccion
indir <- "C:/Users/ecoss/OneDrive - CINVESTAV/Documentos/Posdoc_LIIGH/Clases_Cursos_Medicina_Guadalajara2023/IntroR_BasesDeDatos2023/data/"
outdir <- "C:/Users/ecoss/OneDrive - CINVESTAV/Documentos/Posdoc_LIIGH/Clases_Cursos_Medicina_Guadalajara2023/IntroR_BasesDeDatos2023/"

###--- Data ----
infoCharacters <- read.csv(paste0(indir,"heroesInformation.csv"), na.strings = c("-", "-99")) # La opcion na.string nos permite sustituir valores - y -99 por NA
infoPowers <- read.csv(paste0(indir,"superHeroPowers.csv"))
infoStats <- read.csv(paste0(indir,"charactersStats.csv"), na.strings = "")

###--- Nombres de las filas y columnas en un dataframe ----

# Para conocer el nombre de las **filas** se usa la función `rownames()`.

rownames(infoCharacters)

# En este dataframe los nombres de las filas son numéricas empezando de 1 hasta 734.
# Para conocer el nombre de las **columnas** se usa la función `colnames()`.

colnames(infoCharacters)

# > **Ejercicio:** 
# Obten el nombre las columnas de los demas dataframe (infoPowers e infoStats).

###--- PROCESAMIENTO DE DATOS, PASOS ----

###--- Paso 1. Renombrar la columna "name" en todos los dataframe ----

# Vamos a unificar el nombre las columnas que tienen los nombre en todas las columnas
# colocando el nombre `Name`. El dataframe `infoStats` ya contiene ese nombre en la columna 1.


colnames(infoCharacters)[colnames(infoCharacters) == "name"] <- "Name"
colnames(infoPowers)[colnames(infoPowers) == "hero_names"] <- "Name"

###--- Paso 2. Seleccionar SOLO los datos de Marvel Comics y DC Comics ----

# Podemos usar la función `unique()` para obtener los valores únicos en un vector o de una
# columna en un dataframe.

# Empresas comprendidas en esta base de datos
unique(infoCharacters$Publisher)

# Filtrar solo los datos de Marvel Comics y DC Comics.

marvelDcInfo <- infoCharacters[(infoCharacters$Publisher == "Marvel Comics" | infoCharacters$Publisher == "DC Comics"), ]

head(marvelDcInfo)


## Verificamos las dimensiones
  
# Esperariamos que cada fila sea un solo personaje, pero este dataframe contiene nombres repetidos.

dim(marvelDcInfo)

## Observar valores duplicados
  
# Observar cuales se duplican mediante la función `duplicated()`.

marvelDcInfo[duplicated(marvelDcInfo$Name), ] %>% head()

## Revisemos un ejemplo
  
# Si buscamos el primer dato que es Batgirl, podemos usar `subset()`.

subset(marvelDcInfo, Name== "Batgirl")
  
###--- Paso 3. Eliminar duplicados ----

marvelDcInfo <- marvelDcInfo[!duplicated(marvelDcInfo$Name), ]

###--- Paso 4. Seleccionar columnas ----

marvelDcInfo <- marvelDcInfo %>%
  select(Name, Gender, Race, Publisher)

# La información que estamos seleccionando se relaciona con:
  
#- `Name` - Nombre del personaje
#- `Gender` - Sexo
#- `Race` - Raza
#- `Publisher` - Empresa

###--- Paso 5. Unir dataframes con base en una columna en común (Join Datasets) ----

# Iniciamos con 3 dataframes (`infoCharacters`, `infoStats` e `infoPowers`).  
# A partir del dataframe `infoCharacters` seleccionamos solo los datos de **Marvel Comics 
# y DC Comics**
  
# - Primera unión, empleando la columna `Name` contenida en ambos dataframes. 
# Se unieron las columnas seleccionadas con la información básica de cada personaje con los 
# stats de cada uno.

marvelDcStatsInfo <- left_join(marvelDcInfo, infoStats, by = "Name")
head(marvelDcStatsInfo)[1:5]

# - Segunda unión, empleando la columna Name. Se el dataframe generado co la
# informacion de los poderes por cada personaje.

fullMarvelDc <- left_join(marvelDcStatsInfo, infoPowers, by = "Name")
head(fullMarvelDc)[1:5]

###--- Paso 6. Cambiar formatos en algunas columnas ----

# Debemos convertir las columnas **Name, Gender, Race, Publisher, Aligment**
# de *character* a  *factor*.

class(fullMarvelDc$Name)
class(fullMarvelDc$Gender)
class(fullMarvelDc$Race)
class(fullMarvelDc$Publisher)
class(fullMarvelDc$Alignment)

# Si usamos `str()` tendremos desplegado la informacion de toas las 179 
# columnas presentes en el dataframe, recuerda que puedes usar `dim()` 
# para checar las dimensiones.

dim(fullMarvelDc)

fullMarvelDc$Name <- as.factor(fullMarvelDc$Name)
fullMarvelDc$Gender <- as.factor(fullMarvelDc$Gender)
fullMarvelDc$Race <- as.factor(fullMarvelDc$Race)
fullMarvelDc$Publisher <- as.factor(fullMarvelDc$Publisher)
fullMarvelDc$Alignment <- as.factor(fullMarvelDc$Alignment)

# Verificamos que se cambiaran de formato:

class(fullMarvelDc$Name)
class(fullMarvelDc$Gender)
class(fullMarvelDc$Race)
class(fullMarvelDc$Publisher)
class(fullMarvelDc$Alignment)

###--- Ejercicios - Repaso ----

# 1) ¿Cuántos personajes hay por cada empresa?
  
# Opcion A
summary(fullMarvelDc$Publisher)

# Opcion B
table(fullMarvelDc$Publisher)

# 2) ¿Cuántos personajes son mujeres y hombres hay por cada empresa?
marvelDcGender <- fullMarvelDc %>% filter(!is.na(Gender)) %>%
  group_by(Gender) %>%
  dplyr::count(Publisher) %>%
  select(Gender, Publisher, Count = n)

marvelDcGender

# 3) ¿Cuántas razas hay en el dataframe?

nlevels(fullMarvelDc$Race)

# > **NOTA:** `nlevels()` nos permite obtener los niveles a apartir 
# de una columna convertida a factor.

# 4) ¿Cuáles son las razas predominantes de cada empresa?

marvelDcRace <- fullMarvelDc %>% filter(!is.na(Race)) %>%
  group_by(Publisher) %>%
  dplyr::count(Race) %>%
  select(Publisher,Race,  Count = n) %>%
  arrange(-Count) # ordenar de max a min

head(marvelDcRace)

# La raza `Human` o humana es la mas predominante en ambas empresas, 
# seguida de la mutante en el caso de Marvel Comics.

###--- Ejercicios - Trabajo en equipo (Parte 1) ----
# 20 min para terminar todos los ejercicios por equipo


#1) ¿Cuántos individuos tenemos de cada género (Gender), considerando su 
#raza (Race) y empresa (Publisher)?

#2) ¿Cuántos personajes villanos, neutrales y héroes (su bando, Aligment) 
#por cada empresa?
  
#3) ¿Cuántos individuos tenemos de cada género (Gender), considerando su 
#bando (Aligment) y empresa (Publisher)?

###--- Paso 7. Transformar en una sola columna los poderes usando `melt()` ----

# Reacomodar la tabla de acuerdo a las habilidades o poderes.

# La función `melt()` te permite acomodar la tabla, cambiando el formato
# de la misma de acuerdo a las habilidades o poderes.

marvelDc <- melt(fullMarvelDc, id = c("Name", "Gender", "Race", "Publisher", "Alignment", "Intelligence.x", 
                                        "Strength", "Speed", "Durability.x", "Power", "Combat", "Total"))
str(marvelDc)
head(marvelDc)

# Al usar melt()` se reduce el numero de columnas en 2
dim(marvelDc)

# Se redujeron de 179 columnas a 14 columnas. Creando 2 nuevas columnas:
  
# 1) `variable` :  Contiene el nombre de los poderes.
# 2) `value` : Contiene valores lógicos de acuerdo a cada poder de los personajes.

###--- Paso 8. Renombrar la columnas ----

head(marvelDc, 3)

# Vamos a renombrar la columna `variable` por `SuperPower`.

colnames(marvelDc)[colnames(marvelDc) == "variable"] <- "SuperPower" # Renombrar columna

# A veces el paquete `dplyr` cambia el nombre de algunas columnas solo 
# agregando `.x`, no es preocupante y podemos corregirlo de la siguiente 
# manera.

# Corregir nombres de columnas
colnames(marvelDc)[colnames(marvelDc) == "Intelligence.x"] <- "Intelligence"  # Renombrar columna
colnames(marvelDc)[colnames(marvelDc) == "Durability.x"] <- "Durability"  # Renombrar columna

###--- Paso 9. Verificar el formato de las columnas ----

# En caso de que las siguientes columnas no se encuentren convertidas.

marvelDc$Name <- as.factor(marvelDc$Name)
marvelDc$Gender <- as.factor(marvelDc$Gender)
marvelDc$Race <- as.factor(marvelDc$Race)
marvelDc$Publisher <- as.factor(marvelDc$Publisher)
marvelDc$Alignment <- as.factor(marvelDc$Alignment)
marvelDc$SuperPower <- as.factor(marvelDc$SuperPower)

# Verificamos que se cambiaran de formato:

class(marvelDc$Name)
class(marvelDc$Gender)
class(marvelDc$Race)
class(marvelDc$Publisher)
class(marvelDc$Alignment)
class(marvelDc$SuperPower)

###--- Paso 10. Selección de habilidades con TRUE ----
  
marvelDc <- marvelDc %>%
  filter(value == "True") %>%
  select(-value) #eliminar columna

head(marvelDc)


###--- Ejercicios - Repaso ----

# 1) ¿Quiénes son los personajes con más habilidades/poderes por cada empresa?
  
marvelDc %>% group_by(Name, Publisher) %>%
  distinct(SuperPower) %>%
  dplyr::count(Publisher) %>%
  select(Name, Publisher,  Count = n) %>%
  arrange(-Count) %>% # ordenar de max a min
  head(3)

# Spectre es el personaje con más habilidades a comparación de los 
# demás personajes.

# > NOTA:  Cuando usamos el simbolo `-` en la funcion `arrange()` 
# para ordenar de mayor a menor los valores.

# Sin embargo, ser el más habilidoso no implica el más poderoso...
# Si observamos sus stats todos son de 1 o menos.

marvelDc %>% filter(Name == "Spectre")

# Es el personaje con más habilidades, pero tiene sus stats muy bajos.

# 2) ¿Quiénes son los personajes con los stats más altos por cada empresa?

marvelDc %>% arrange(-Intelligence, -Strength, -Speed, -Durability, -Power, 
  -Combat) %>%
  select(-SuperPower) %>%
  distinct() %>% head(5)

# > NOTA:  Cuando usamos el simbolo `-` en la funcion `select()` estamos eliminando la columna SuperPower.

# 3) ¿Existe algún personaje que tenga todos sus stats en 100?
  
# Hay 6 columnas de stats evaluados que sumados nos da la columna Total, 
# osea que los valores maximos se encuentran cercanos a 600 (columnas 6:11).

marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Intelligence >= 100 & Strength >= 100 & Speed >= 100 & 
           Durability >= 100 & Power >= 100 & Combat >= 100)

# La salida da NINGUNO, ya que no existe un personaje que tenga los 6 Stats con valores de 100.

# Vamos a disminuir el filtro en valores cercanos o iguales a 90.

# Personaje con stats superiores a 90 en cada uno
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Intelligence >= 90 & Strength >= 90 & Speed >= 90 & Durability >= 90 & Power >= 90 & Combat >= 90)

# Y si filtramos por el valor total ... 
# Personajes con valores totales superiores a 570
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Total >= 570)

###--- Función `if_else()` ----

# Cuando usamos la función `if_else()` la empleamos para asignar
# valores de acuerdo a una conducional.

# - Usage: if_else(condición, TRUE, FALSE)
#- Condición: Selecciona una columna y verifica que debe cumplir la misma.
#- TRUE: En caso de que la condición sea VERDADERA, que acción debe hacer.
#- FALSE: En caso de que la condición sea FALSA, que acción debe hacer 

# Vamos agregar una nueva columna y vamos a cambiar los valores a usar
#el bando (Aligment)

marvelDc_edited <- marvelDc %>% mutate(Group = 
                                         if_else(Alignment == "good", "hero", # Primer if_else
                                                 if_else(Alignment == "bad","villain", "neutral"))) # Segundo if_else


# 1) ¿Quiénes son los hombres más poderosos y malvados?

marvelDc_edited %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Gender == "Male" & Group == "villain") %>%
  arrange(-Total)

###--- Ejercicios - Trabajo en equipo (Parte 2) ----
# 20 min para terminar todos los ejercicios por equipo
  
#  1) ¿Quiénes son los personajes más fuertes de cada empresa?
#  2) ¿Quiénes son los personajes más inteligentes de cada empresa?
#  3) ¿Quiénes son las mujeres más poderosas y malvadas?
# 4) ¿Quiénes son los hombres más poderosos y malvados?

###############################RESPUESTAS###################################

###--- Ejercicios - Trabajo en equipo (Parte 1) (RESPUESTAS) ----

# 1) ¿Cuántos individuos tenemos de cada género (Gender), considerando su
# raza (Race) y empresa (Publisher)?

fullMarvelDc %>% filter(!is.na(Race)) %>%
  group_by(Publisher, Gender) %>%
  dplyr::count(Race) %>%
  select(Publisher, Gender, Race,  Count = n) %>%
  arrange(-Count) # ordenar de max a min

# 2) ¿Cuántos personajes villanos, neutrales y héroes (su bando, Aligment) 
# por cada empresa?

marvelDcAlignment <- fullMarvelDc %>% filter(!is.na(Alignment)) %>%
  group_by(Publisher) %>%
  dplyr::count(Alignment) %>%
  select(Publisher, Alignment,  Count = n) %>%
  arrange(-Count) # ordenar de max a min

marvelDcAlignment

# 3) ¿Cuántos individuos tenemos de cada género (Gender), considerando su
# bando (Aligment) y empresa (Publisher)?

fullMarvelDc %>% filter(!is.na(Alignment) & !is.na(Gender)) %>%
  group_by(Publisher, Gender) %>%
  dplyr::count(Alignment) %>%
  select(Publisher, Gender, Alignment,  Count = n) %>%
  arrange(-Count) # ordenar de max a min

###--- Ejercicios - Trabajo en equipo (Parte 2) (RESPUESTAS) ----

# 1) ¿Quiénes son los personajes más fuertes de cada empresa?
  
marvelDc %>% filter(!is.na(Strength)) %>%  # filtrar NA
  group_by(Name, Publisher) %>%  # Agrupar por nombre del heroe y empresa
  distinct(Strength) %>% # Eliminar duplicados en la columna, para tener solo un valor por personaje
  select(Name, Publisher, Strength) %>% # seleccionar columnas
  arrange(-Strength) %>% # Ordenar de mayor a menor
  head(5)

# 2) ¿Quiénes son los personajes más inteligentes de cada empresa?
  
marvelDc %>% filter(!is.na(Intelligence)) %>%  # filtrar NA
  group_by(Name, Publisher) %>%
  distinct(Intelligence) %>% # eliminar duplicados
  select(Name, Publisher, Intelligence) %>%
  arrange(-Intelligence) %>% # Ordenar de mayor a menor
  head(5)

# 3) ¿Quiénes son las mujeres más poderosas y malvadas?
  
# con filtro
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
      filter(Total >= 500  & Gender == "Female" & Alignment == "bad") 
    
# sin filtro
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
      filter(Gender == "Female" & Alignment == "bad") %>%
      arrange(-Total)

# 4) ¿Quiénes son los hombres más poderosos y malvados?

# sin filtro
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
      filter(Gender == "Male" & Alignment == "bad") %>%
      arrange(-Total)
    
# Y bueno ?
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
      filter(Gender == "Male" & Alignment == "good") %>%
      arrange(-Total)
    
# Ambos ?
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
      filter(Gender == "Male" & Alignment == c("good", "bad")) %>%
      arrange(-Total)

  
## Deben practicar mucho cuando aprenden un lenguaje
