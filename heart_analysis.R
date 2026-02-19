# ============================================================
# Heart Disease Analysis — Script R Complet (version corrigée)
# Auteur  : Bipanda Franck Ulrich
# Formation: Mastère Data Engineering — DSP
# Date    : Février 2026
# Dataset : heart.xlsx (270 obs. x 8 variables)
# ============================================================

# ------------------------------------------------------------
# 1. INSTALLATION ET CHARGEMENT DES PACKAGES
# ------------------------------------------------------------
install.packages("openxlsx")
install.packages("sm")

library(openxlsx)   # Import fichier Excel
library(sm)         # Graphiques de densité comparée

# ------------------------------------------------------------
# 2. ENVIRONNEMENT DE TRAVAIL
# ------------------------------------------------------------
getwd()
setwd("/Users/macbook/Downloads")   # Adapter selon votre chemin

# ------------------------------------------------------------
# 3. IMPORT DU FICHIER
# ------------------------------------------------------------
DF.FULL <- read.xlsx("heart.xlsx", sheet = 1)

# Exploration initiale
head(DF.FULL)
dim(DF.FULL)       # 270 x 8
mode(DF.FULL)      # "list"
summary(DF.FULL)

# Afficher la variable cible
DF.FULL$coeur

# ------------------------------------------------------------
# 4. COPIE DE TRAVAIL
# ------------------------------------------------------------
matdone <- DF.FULL

# ------------------------------------------------------------
# 5. FILTRAGE ET STATISTIQUES DESCRIPTIVES
# ------------------------------------------------------------

# --- Comptage par sexe ---
# Nombre de femmes (méthode correcte)
length(matdone[matdone$sexe == "feminin", c("sexe")])  # → 87

# Vecteur de toutes les valeurs
matdone$sexe
matdone$sexe == "feminin"
length(matdone$sexe)   # → 270 (taille totale, pas le compte de femmes)

# --- Filtrage par âge ---
# Patients de 40 ans ou moins (15 individus)
matdone[matdone$age <= 40, ]

# Patients de 70 ans et plus (10 individus)
matdone[matdone$age >= 70, ]

# Patients entre 40 et 70 ans (255 individus)
matdone[matdone$age >= 40 & matdone$age <= 70, ]

# Hommes de 34 ans et plus
matdone[matdone$age >= 34 & matdone$sexe == "masculin", ]
length(matdone[matdone$age >= 34 & matdone$sexe == "masculin", ])   # → 8 colonnes

# --- Table de contingence : Angine vs Diagnostic cardiaque ---
tabCroi <- table(matdone$angine, matdone$coeur)
tabCroi

#          absence  presence
#  non       127       54
#  oui        23       66

# Probabilité d'avoir une maladie cardiaque si angine = oui
print(tabCroi[2, 2] / sum(tabCroi[2, ]))   # → 0.7416 (74.2%)

# --- Moyennes d'âge par groupe ---
# Par sexe
tapply(X = matdone$age, INDEX = matdone$sexe, mean)
# féminin  : 55.68 ans
# masculin : 53.84 ans

# Par sexe ET angine
b <- tapply(X = matdone$age, INDEX = list(matdone$sexe, matdone$angine), mean)
b
#              non      oui
# féminin   55.72    55.50
# masculin  52.63    55.76

# Écart (max - min) par sexe
Ecart <- tapply(X = matdone$age, INDEX = matdone$sexe, function(x) {max(x) - min(x)})
Ecart
# féminin : 42 ans | masculin : 48 ans

# ------------------------------------------------------------
# 6. VISUALISATIONS
# ------------------------------------------------------------

# Figure 1 — Histogramme de l'âge
hist(matdone$age, main = "Distribution de l'âge", xlab = "Âge", col = "steelblue")

# Figure 2 — Scatter plot âge par index
plot(matdone$age, main = "Âge des patients", ylab = "Âge", xlab = "Index")

# Estimation de la densité (affichage console uniquement)
density(matdone$age)

# Figure 3 — Boxplot du taux cardiaque maximum
boxplot(matdone$tauxmax,
        main = "Distribution du taux cardiaque maximum",
        ylab = "Taux max (bpm)",
        col = "lightblue")

# Figure 4 — Courbes de densité comparée (package sm)
# ⚠️ library(sm) doit être chargé AVANT cet appel
sm.density.compare(matdone$tauxmax, matdone$coeur,
                   xlab = "Taux cardiaque maximum (bpm)")
title("Densité : tauxmax selon diagnostic cardiaque")
legend("topright", c("absence", "presence"), fill = 2:3)

# Figure 5 — Boxplot croisé : tauxmax selon diagnostic
boxplot(matdone$tauxmax ~ matdone$coeur,
        main = "Taux cardiaque max selon diagnostic",
        xlab = "Diagnostic cardiaque",
        ylab = "Taux max (bpm)",
        col = c("lightgreen", "salmon"))

# Figure 6 — Nuage de points : âge vs tauxmax (sans couleur)
plot(matdone$age, matdone$tauxmax,
     main = "Âge vs Taux cardiaque maximum",
     xlab = "Âge", ylab = "Taux max (bpm)")

# Figure 7 — Nuage de points coloré par diagnostic
plot(matdone$age, matdone$tauxmax,
     pch = 21,
     bg  = c("green", "red")[as.factor(matdone$coeur)],
     main = "Âge vs Taux max (coloré par diagnostic)",
     xlab = "Âge", ylab = "Taux max (bpm)")
legend("topright", c("absence", "présence"), pch = 21, pt.bg = c("green", "red"))
