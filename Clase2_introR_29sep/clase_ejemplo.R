######
# Script de clase "Intro a R"
# Sofia Salazar
# 29 de septiembre 2023
#######

indir = "/Users/sofiasalazar/Desktop/LAB/ViernesBioinfo/Clase2_introR_29sep/"
outdir = "/Users/sofiasalazar/Desktop/LAB/ViernesBioinfo/Clase2_introR_29sep/"

planets <- read.csv(paste0(indir,"planets.csv"))

save.image(file=paste0(outdir,"miAmbiente1.RData"))
