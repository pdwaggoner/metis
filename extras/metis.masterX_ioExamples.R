
#----------------------------
# Install necessary packages
#----------------------------
if("devtools" %in% rownames(installed.packages()) == F){install.packages("devtools")}
library(devtools)
if("metis" %in% rownames(installed.packages()) == F){install_github(repo="JGCRI/metis")}
library(metis)
if("rgcam" %in% rownames(installed.packages()) == F){install_github(repo="JGCRI/rgcam")}
library(rgcam)
if("tibble" %in% rownames(installed.packages()) == F){install.packages("tibble")}
library(tibble)
if("dplyr" %in% rownames(installed.packages()) == F){install.packages("dlpyr")}
library(dplyr)
if("rgdal" %in% rownames(installed.packages()) == F){install.packages("rgdal")}
library(rgdal)
if("tmap" %in% rownames(installed.packages()) == F){install.packages("tmap")}
library(tmap)
if("rgeos" %in% rownames(installed.packages()) == F){install.packages("rgeos")}
library(rgeos)


#----------------------------
# Read GCAM Data
#---------------------------

# Blair and Miller Problems Chapter 2 - Simple I/O

# Problem 2.1
# Dollar values of last year’s interindustry transactions and total outputs for a
# two-sector economy (agriculture and manufacturing) are as shown below:
#  Z = 500 350
#      320 360
#  x = 1000
#      800
#  a. What are the two elements in the final-demand vector f = (f1, f2) ?
#  b. Suppose that f1 increases by $50 and f2 decreases by $20. What new gross outputs
#     would be necessary to satisfy the new final demands?

# Solution:
# a. f = x - Zi = (150, 120)
# b. x = (1138.90, 844.40)

# Construct the IO Table
ioTable0a=tibble::tribble(
 ~supplySector,    ~ag,         ~manufact, ~total,
          "ag",    500,          350,   1000,
         "manufact",    320,          360,    800  );ioTable0a

# Enter into metis.io
io_a<-metis.io(ioTable0 = ioTable0a, plotSankeys = T, folderName = "2.1a")
# Explore solution
io_a$ioTbl
io_a$A
io_a$L

# Final-demand is calultaed in metis.io as a column vector called adjustedDemands

ioTable0b=tibble::tribble(
  ~supplySector,    ~ag,         ~manufact, ~adjustedDemandsNew,
           "ag",    500,          350,   200,
          "manufact",    320,          360,   100);ioTable0b

io_b<-metis.io(ioTable0 = ioTable0b, useIntensity=1, A0=io_a$A ,plotSankeys = T, folderName = "2.1b")
io_b$ioTbl
io_b$A
io_b$L

# Can Combine the tables and add more details for comparative plots
io_comb <- io_a$ioTbl %>%
  filter(!grepl("_all",supplySubSector)) %>%
  select("supplySubSector",unique(ioTable0a$supplySector), "total") %>%
  mutate(subRegion = "p2.1a") %>%
  bind_rows(io_b$ioTbl %>%
              filter(!grepl("_all",supplySubSector)) %>%
              select("supplySubSector",unique(ioTable0a$supplySector), "total") %>%
              mutate(subRegion = "p2.1b"));io_comb

io_c<-metis.io(ioTable0 = io_comb, plotSankeys = T, folderName = "2.1comb")


#Problem 2.1b
#(diag(nrow(io$ioTbl)) + io$A + io$A%*%io$A + io$A%*%io$A%*%io$A + io$A%*%io$A%*%io$A%*%io$A)%*%as.matrix(io$D)
#i. [794.9863,613.7669]
#ii. [1139,844]

#Problem 2.2
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~S1,         ~S2, ~S3,
  "S1"     ,    350,         0, 0,
  "S2"     ,    50,        250, 150,
  "S3"     ,    200,       150, 550);Z0


X0=tibble::tribble( # Initial total demand
  ~total,
  1000,
  500,
  1000
);X0


io<-metis.io(Z0=Z0,X0=X0,D=c(1300,100,200))
io$A
io$L


#Problem 2.3
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~ag,         ~man, ~hhc,
  "ag"     ,    500,         350, 90,
  "man"     ,    320,        360, 50,
  "hhc"    ,     100,         60, 40);Z0


X0=tibble::tribble( # Initial total demand
  ~total,
  1000,
  800,
  300
);X0


io<-metis.io(Z0=Z0,X0=X0,D=c(110,50,100))
io$A
io$L

# Problem 2.4
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~lum,         ~pap, ~mach,
  "lum"     ,    50*0.05,     50*0.2, 50*0.05,
  "pap"     ,    50*0.05,        50*0.1, 50*0.05,
  "mach"    ,     100*0.3,         100*0.3, 100*0.15);Z0


X0=tibble::tribble( # Initial total demand
  ~total,
  50,
  50,
  100
);X0


io<-metis.io(Z0=Z0,X0=X0,D=c(35*0.75,40*0.9,25*0.95))
io$A
io$L

# Problem 2.5
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~A,         ~B,
  "A"     ,    2,         8,
  "B"     ,    6,        4);Z0


D0=tibble::tribble( # Initial total demand
  ~external,
  20,
  20
);D0


io<-metis.io(Z0=Z0,D0=D0,D=c(15,18))
io$A
io$L

# Problem 2.6
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~A,         ~B,
  "A"     ,    6,         2,
  "B"     ,    4,        2);Z0


X0=tibble::tribble( # Initial total demand
  ~total,
  20,
  15
);X0


io<-metis.io(Z0=Z0,X0=X0)
io$A
io$L

# Problem 2.11
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~ag,         ~sv, ~comp,
  "ag"     ,    2,         2, 1,
  "sv"     ,    1,         0, 0,
  "comp"   ,    2,         0, 1);Z0


X0=tibble::tribble( # Initial total demand
  ~total,
  5,
  2,
  2
);X0


io<-metis.io(Z0=Z0,X0=X0)
io$A
io$L


#----------------------------
# Inter-regional irio
# Blair and Miller Problems Chapter 3 - Simple I/O
#---------------------------


# Example
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~r1,         ~r2, ~r3, ~s1, ~s2,
  "r1",    150,        500, 50, 25, 75,
  "r2",    200,        100, 400, 200, 100,
  "r3",   300, 500, 50, 60, 40,
  "s1",  75, 100, 60, 200, 250,
  "s2", 50, 25, 25, 150, 100
  );Z0

X0=tibble::tribble( # Initial total demand
  ~total,
  1000,
  2000,
  1000,
  1200,
  800
);X0

irio<-metis.irio(Z0=Z0,X0=X0, D=c(100,0,0,0,0))

# Problem 3.2
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~r1,  ~r2,  ~s1, ~s2,
  "r1",    40,50,  30, 45,
  "r2",    60,10,  70, 45,
  "s1",  50, 60, 50, 80,
  "s2", 70, 70, 50, 50
);Z0


D0=tibble::tribble( # Initial total demand
  ~total,
  200,
  200,
  300,
  400
);D0

irio<-metis.irio(Z0=Z0,D0=D0, D=c(280,360,0,0))

# Problem 3.3
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~r1,  ~r2,  ~s1, ~s2,
  "r1",    40,50,  0, 0,
  "r2",    60,10,  0, 0,
  "s1",  0, 0, 30, 45,
  "s2", 0, 0, 70, 45
);Z0

Q0=tibble::tribble( # Initial Flows
  ~sector ,    ~r1,  ~r2,  ~s1, ~s2,
  "r1",    50,0,  60, 0,
  "r2",    0,50,  0, 80,
  "s1",  70, 0, 70, 0,
  "s2", 0, 50, 0, 50
);Q0

D0=tibble::tribble( # Initial total demand
  ~total,
  200,
  200,
  300,
  400
);D0

irio<-metis.irio(Z0=Z0,D0=D0, D=c(280,360,0,0))



#-------------
# Workflow for Metis I/O Analysis

# Small Example

# Problem 2.1
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~W,         ~E,
  "W"     ,    0,           0.5,
  "E"     ,    0.3,         0);A0


D0=tibble::tribble( # Initial total demand
  ~total,
  1,
  1
);D0


io<-metis.io(Z0=Z0,D0=D0,D=c(0,1))
io$A
io$L

# Problem 2.1
Z0=tibble::tribble( # Initial Flows
  ~sector ,    ~Wgw,      ~Ws, ~ W,   ~Ebio, ~ Esol, ~ E,
  "Wgw"   ,    0,         0,    0.5,  0,         0,    0,
  "Ws"    ,    0,         0,    0.5,  0,         0,    0,
  "W"     ,    0,         0,    0,    0.5,       0.5,   0,
  "Ebio"  ,    0,         0,    0,    0,         0,    0.3,
  "Esol"  ,    0,         0,    0,    0,         0,    0.7,
  "E"     ,    0,         0,    0.1,    0,         0,    0);Z0

A0=tibble::tribble( # Initial Flows
  ~sector ,    ~Wgw,      ~Ws, ~ W,   ~Ebio, ~ Esol, ~ E,
  "Wgw"   ,    0,         0,    0.5,  0,         0,    0,
  "Ws"    ,    0,         0,    0.5,  0,         0,    0,
  "W"     ,    0,         0,    0,    1,         1,    0,
  "Ebio"  ,    0,         0,    0,    0,         0,    1,
  "Esol"  ,    0,         0,    0,    0,         0,    0,
  "E"     ,    0,         0,    10,   0,         0,    0);A0

D0=tibble::tribble( # Initial total demand
  ~total,
  0,
  0,
  1,
  0,
  0,
  1
);D0


io<-metis.io(Z0=Z0,D0=D0,D=c(0,0,1,0,0,0))
io$A
io$L

# Commodities
# 1. Water demands
# 2. Agricultural production by Crop
# 3. Electricity Production by Type

# Downscaled Outputs:
# 1. Ag production by crop
# 2. Elec production by fuel
# 3. Water demands by ag, elec, other

# Initial Coefficient Assumptions
# A0

# Steps
# 1. Use A0 and D0 (Demand other) to find Intermediate flows and total production
# 2. Compare Aggregated demands to initial assumption
# 3. Adjust A to reflect actual data
# 4.


A0=tibble::tribble( # Initial Flows
  ~sector     ,    ~W,   ~Ag_corn,  ~Ag_rice, ~E_coal, ~E_solar, ~E,
  "W"         ,    0,       0.1,     2,     0.5,    0.01,   0,
  "Ag_corn"     ,    0,        0,      0,     0,      0,      0,
  "Ag_rice"     ,    0,        0,      0,     0,      0,      0,
  "E_coal"     ,    0,        0,      0,     0,      0,      0,
  "E_solar"    ,    0,        0,      0,     0,      0,      0,
  "E"         ,    1,      0.3,    0.4,   0,      0,      0);A0

Dreal = tibble::tribble( # From tethys
  ~sector, ~W,
  "Ag"   ,  1000,
  "E"    ,    20);Dreal



D0=tibble::tribble( # Other demands (Not internal flows)
  ~other,
  1000, # W
  10,  # Acorn
  10,  # Arice
  50, # Ecoal
  50,   # Esolar
  100 # E
);D0


io<-metis.io(D0=D0,A0=A0, D=c(10,0,0,0,1,1))
io$A
io$L

install.packages("corrplot")
library(corrplot)
M<-as.matrix(A0%>%dplyr::select(-sector))
rownames(M)<-colnames(M);M
col<- colorRampPalette(metis.colors()$pal_div_wet)(20)
corrplot(M, method="circle", is.corr=F, type="upper",addCoef.col="red", col=col, add=F, cl.length=20, cl.lim=c(0,2))

