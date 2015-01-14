#LOAD IN DATA-
#Water Supply Reliability
load("Colorado_demand_reliability.RData",verbose=FALSE) #dem_rel_matrix
Colorado_Rel <- dem_rel_matrix

#KDMI 
Data_Benning <- read.table("KDMI_FORT_BENNING.txt",header=FALSE)
Data_Hood <- read.table("KDMI_FORT_HOOD.txt",header=FALSE)
Data_Colorado <- read.table("KDMI_AIR_FORCE_ACADEMY.txt",header=FALSE)
Data_Edwards <- read.table("KDMI_EDWARDS.txt",header=FALSE)
rows <- nrow(Data_Benning)
cols <- ncol(Data_Benning)
Prcp_Change <- Data_Benning[2:rows,1]
Temp_Change <- as.vector(data.matrix(Data_Benning[1,2:cols]))
FortBenning_KDMI <- Data_Benning[2:rows,2:cols]
FortHood_KDMI <- Data_Hood[2:rows,2:cols]
Colorado_KDMI <- Data_Colorado[2:rows,2:cols]
Edwards_KDMI <- Data_Edwards[2:rows,2:cols]

#Heat
Data_Benning <- read.table("HEAT_DAYS_FORT_BENNING.txt",header=FALSE)
Data_Hood <- read.table("HEAT_DAYS_FORT_HOOD.txt",header=FALSE)
Data_Colorado <- read.table("HEAT_DAYS_AIR_FORCE_ACADEMY.txt",header=FALSE)
Data_Edwards <- read.table("HEAT_DAYS_EDWARDS.txt",header=FALSE)
rows <- nrow(Data_Benning)
cols <- ncol(Data_Benning)
RH_Change <- Data_Benning[2:rows,1]
Temp_Change <- as.vector(data.matrix(Data_Benning[1,2:cols]))
FortBenning_Heat <- Data_Benning[2:rows,2:cols]
FortHood_Heat <- Data_Hood[2:rows,2:cols]
Colorado_Heat <- Data_Colorado[2:rows,2:cols]
Edwards_Heat <- Data_Edwards[2:rows,2:cols]

#Climate data
load("Colorado_PRCP_Projections.RData") #DELTA_PRCP
load("Colorado_TEMP_Projections.RData") #DELTA_TEMP

CMIP3_Projections <- read.table("CMIP3_Projections_Benning.txt",header=TRUE)
Prcp_Temp_Projections3_Benning_2050 <- cbind(CMIP3_Projections[,1],CMIP3_Projections[,2])
Prcp_Temp_Projections3_Benning_2080 <- cbind(CMIP3_Projections[,3],CMIP3_Projections[,4])

CMIP3_Projections1 <- read.table("Hood_CMIP3_2050.txt",header=TRUE)
CMIP3_Projections2 <- read.table("Hood_CMIP3_2080.txt",header=TRUE)
Prcp_Temp_Projections3_Hood_2050 <- cbind(CMIP3_Projections1[,1]*100,CMIP3_Projections1[,2])
Prcp_Temp_Projections3_Hood_2080 <- cbind(CMIP3_Projections2[,1]*100,CMIP3_Projections2[,2])

CMIP3_Projections1 <- read.table("USAFA_CMIP3_2050.txt",header=TRUE)
CMIP3_Projections2 <- read.table("USAFA_CMIP3_2080.txt",header=TRUE)
Prcp_Temp_Projections3_Colorado_2050 <- cbind(CMIP3_Projections1[,1]*100,CMIP3_Projections1[,2])
Prcp_Temp_Projections3_Colorado_2080 <- cbind(CMIP3_Projections2[,1]*100,CMIP3_Projections2[,2])

CMIP3_Projections1 <- read.table("Edwards_CMIP3_2050.txt",header=TRUE)
CMIP3_Projections2 <- read.table("Edwards_CMIP3_2080.txt",header=TRUE)
Prcp_Temp_Projections3_Edwards_2050 <- cbind(CMIP3_Projections1[,1]*100,CMIP3_Projections1[,2])
Prcp_Temp_Projections3_Edwards_2080 <- cbind(CMIP3_Projections2[,1]*100,CMIP3_Projections2[,2])

