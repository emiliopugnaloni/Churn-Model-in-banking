library(data.table)

gc() #free unused memory

data = fread("~/buckets/b1/datasets/competencia_02_fe02.csv.gz")
setorder(data, foto_mes, numero_de_cliente)

# ------------
# FE Historico
# ------------


## A todas Lags (1,3,6,9), Moving Average (3,6,9) y Tendencia (3,6,9)

cols <- setdiff(names(dataset), c("numero_de_cliente", "foto_mes", "clase_ternaria"))


for (i in c(1,3,6,9))
{
  lag_names <- paste(cols, "_lag", i, sep = "")
  ma_names <- paste(cols, "_ma", i, sep = "")
  tend_ma_names <- paste(cols, "_tend_ma", i, sep = "")

  
  data[, (lag_names) := shift(.SD, i), by=numero_de_cliente, .SDcols = cols]

  if (i!= 1){

    data[, (ma_names) := round(frollmean(.SD, n = i, align = "right"),2), by = numero_de_cliente, .SDcols = cols]
    data[, (tend_ma_names) := round(.SD / get(ma_names), 2), .SDcols = c(cols, ma_names)]
    
    
    
    }  #solo calculamos medias moviles para 3,6 y 9 meses
  
}



fwrite(data, "~/buckets/b1/datasets/competencia_03_v2_FE.csv.gz")

