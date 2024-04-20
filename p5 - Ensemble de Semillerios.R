library(data.table)

#working directory
setwd("C:/Users/epugnalo/OneDrive - Telefonica/Documents/Data Mining UBA/2C - DM en Economica y Finanzas/dmeyf2023/EntregaTerceraCompetencia/")
data_semillas <- fread("exp_C3_Modelo_Final_Semillerios_tabla_predicciones_semillas.csv")

head(data_semillas)

#compute mean "semillas" of each row and sort
data_semillas[, mean_semillas := rowMeans(.SD), .SDcols = colnames(data_semillas)[2:10]]
setorder(data_semillas, -mean_semillas)  #ordenamos de forma descendente


#compute ranking of each row for each columns
data_semillas_rank <- copy(data_semillas)
data_semillas_rank[, (colnames(data_semillas_rank)[2:10]) := lapply(.SD, rank), .SDcols = colnames(data_semillas_rank)[2:10]]
data_semillas_rank[, mean_semillas := rowMeans(.SD), .SDcols = colnames(data_semillas_rank)[2:10]]
setorder(data_semillas_rank, -mean_semillas) #ordenamos de forma descendente


## Generamos archivos para kaggle 

#create folder
dir.create("Entregas", showWarnings = FALSE)

cortes <- seq(8000, 16000, by = 500)

for (envios in cortes) {
  data_semillas[, Predicted := 0L]
  data_semillas[1:envios, Predicted := 1L]

  fwrite(data_semillas[, list(numero_de_cliente, Predicted)],
    file = paste0("Entregas/EnsembleSemillerios", "_", envios, ".csv"),
    sep = ","
  )
}

for (envios in cortes) {
  data_semillas_rank[, Predicted := 0L]
  data_semillas_rank[1:envios, Predicted := 1L]

  fwrite(data_semillas_rank[, list(numero_de_cliente, Predicted)],
    file = paste0("Entregas/EnsembleRankSemillerios", "_", envios, ".csv"),
    sep = ","
  )
}
