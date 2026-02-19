# ============================================================
# Heart Disease Analysis — Documentation des erreurs de saisie
# Auteur  : Bipanda Franck Ulrich
# Formation: Mastère Data Engineering — DSP
# Date    : Février 2026
# ============================================================
# Ce fichier documente toutes les erreurs commises dans les
# deux environnements (R Console macOS et RStudio) avec leurs
# messages d'erreur exacts et les corrections apportées.
# ============================================================


# ============================================================
# SECTION 1 — ERREURS D'INSTALLATION
# ============================================================

# ❌ Erreur 1 : package sans guillemets
install.packages(sm)
# Error: object 'sm' not found
# ✅ Correction :
install.packages("sm")

# ❌ Erreur 2 : deux packages en un seul appel (mauvaise syntaxe)
install.packages("xlsx", "openxlsx")
# Warning: 'lib = "openxlsx"' is not writable
# ✅ Correction : deux appels séparés
install.packages("xlsx")
install.packages("openxlsx")

# ❌ Erreur 3 : faute de frappe dans library()
libray(sm)
# Error in libray(sm) : could not find function "libray"
# ✅ Correction :
library(sm)

# ❌ Erreur 4 : appel sans chargement préalable de library(sm)
sm.density.compare(matdone$tauxmax, matdone$coeur)
# Error: could not find function "sm.density.compare"
# ✅ Correction : toujours charger la librairie AVANT l'appel
library(sm)
sm.density.compare(matdone$tauxmax, matdone$coeur)

# ❌ Erreur 5 : faute de frappe dans le nom de la fonction
sm.density.comparte(matdone$tauxmax, matdone$coeur)
# Error: could not find function "sm.density.comparte"
# ✅ Correction :
sm.density.compare(matdone$tauxmax, matdone$coeur)


# ============================================================
# SECTION 2 — ERREURS D'IMPORT DU FICHIER
# ============================================================

# ❌ Erreur 1 : setwd sans guillemets
setwd(/Users/macbook/Downloads/heart.xlsx)
# Error: unexpected '/' in "setwd(/"
# ✅ Correction :
setwd("/Users/macbook/Downloads")

# ❌ Erreur 2 : setwd pointe vers le fichier, pas le dossier
setwd("/Users/macbook/Downloads/heart.xlsx")
# Error in setwd(...) : cannot change working directory
# ✅ Correction : pointer vers le DOSSIER
setwd("/Users/macbook/Downloads")

# ❌ Erreur 3 : arguments incorrects + library non chargée
DF.FULL <- read.xlsx(file = "heart.xlsx", sheetubdex = 1, header = T)
# Error: could not find function "read.xlsx"  (library non chargée)
# ✅ Correction : charger la lib puis utiliser les bons arguments
library(openxlsx)
DF.FULL <- read.xlsx("heart.xlsx", sheet = 1)

# ❌ Erreur 4 : argument "file=" non reconnu par openxlsx
DF.FULL <- read.xlsx(file = "heart.xlsx", sheet = 1)
# Error: unused argument (file = "heart.xlsx")
# ✅ Correction : le 1er argument positionnel suffit
DF.FULL <- read.xlsx("heart.xlsx", sheet = 1)

# ❌ Erreur 5 : tentative d'appeler coeur() comme une fonction
print(coeur(DF.FULL))
# Error in coeur(DF.FULL) : could not find function "coeur"
# ✅ Correction : utiliser l'opérateur $
DF.FULL$coeur

# ❌ Erreur 6 : caractère § invalide en R
DF.FULL§coeur
# Error: unexpected input in "DF.FULL§"
# ✅ Correction :
DF.FULL$coeur


# ============================================================
# SECTION 3 — ERREURS DE FILTRAGE PAR SEXE
# ============================================================

# ❌ Erreur 1 : = au lieu de == dans la condition
length(DF.FULL$sex = "feminin")
# Error: unexpected '=' in "length(DF.FULL$sex="
# ✅ Correction : double égal pour comparaison
length(DF.FULL$sex == "feminin")   # Retourne 270 (taille du vecteur entier !)

# ⚠️ Attention : length() sur un vecteur logique retourne sa taille totale
# Pour compter les femmes, utiliser :
length(matdone[matdone$sexe == "feminin", c("sexe")])   # → 87

# ❌ Erreur 2 : utiliser matdone avant de le créer
length(matdone[matdone$sexe == "feminin", c("sexe")])
# Error: object 'matdone' not found
# ✅ Correction : créer matdone d'abord
matdone <- DF.FULL
length(matdone[matdone$sexe == "feminin", c("sexe")])   # → 87


# ============================================================
# SECTION 4 — ERREURS DE FILTRAGE PAR AGE
# (Section avec le plus de différences entre les deux environnements)
# ============================================================

# ❌ Erreur 1 : guillemets autour d'un nombre (comparaison chaîne)
matdone$age <= "40"
# Retourne un vecteur booléen mais la comparaison est incorrecte (chaîne vs numérique)
# ✅ Correction :
matdone$age <= 40

# ❌ Erreur 2 (RStudio) : parenthèses au lieu de crochets
matdone(matdone$age <= "40")
# Error: could not find function "matdone"
# ✅ Correction :
matdone[matdone$age <= 40, ]

# ❌ Erreur 3 : crochet sans virgule (colonnes non spécifiées)
matdone[matdone$age <= 40]
# Error: undefined columns selected
# ✅ Correction : ajouter la virgule pour sélectionner toutes les colonnes
matdone[matdone$age <= 40, ]

# ❌ Erreur 4 : condition logiquement impossible
# (un patient NE PEUT PAS avoir age <= 40 ET age >= 70 simultanément)
matdone[matdone$age <= 40 & matdone$age >= 70, ]
# Retourne 0 lignes — pas d'erreur mais résultat vide et logique incorrecte
# ✅ Correction : inverser les bornes
matdone[matdone$age >= 40 & matdone$age <= 70, ]   # 255 individus

# ❌ Erreur 5 : condition avec guillemets ET logique impossible
matdone[matdone$age <= "40" & matdone$age >= "70"]
# Double erreur : guillemets + condition impossible + virgule manquante
# Retourne : data frame with 0 columns and 270 rows
# ✅ Correction :
matdone[matdone$age >= 40 & matdone$age <= 70, ]

# ✅ Syntaxes correctes pour le filtrage par âge :
matdone[matdone$age <= 40, ]                                        # 15 individus
matdone[matdone$age >= 70, ]                                        # 10 individus
matdone[matdone$age >= 40 & matdone$age <= 70, ]                    # 255 individus
matdone[matdone$age >= 34 & matdone$sexe == "masculin", ]           # Hommes >= 34 ans


# ============================================================
# SECTION 5 — ERREURS SUR TAPPLY ET AUTRES FONCTIONS
# ============================================================

# ❌ Erreur 1 : INDEX en minuscule (sensible à la casse)
tapply(X = matdone$age, index = matdone$sexe, mean)
# Error in unique.default(x, nmax = nmax) : unique() applies only to vectors
# ✅ Correction : INDEX en MAJUSCULES
tapply(X = matdone$age, INDEX = matdone$sexe, mean)

# ❌ Erreur 2 : oubli de tapply() au début
(X = matdone$age, INDEX = matdone$sexe, function(x){max(x) - min(x)})
# Error: unexpected ',' in "(X=matdone$age,"
# ✅ Correction :
Ecart <- tapply(X = matdone$age, INDEX = matdone$sexe, function(x){max(x) - min(x)})

# ❌ Erreur 3 : faute de frappe dans length
legnth(matdone[matdone$age >= 34 & matdone$sexe == "masculin", ])
# Error: could not find function "legnth"
# ✅ Correction :
length(matdone[matdone$age >= 34 & matdone$sexe == "masculin", ])   # → 8

# ❌ Erreur 4 : histogram() n'existe pas en R de base
histogram(matdone$age)
# Error: could not find function "histogram"
# ✅ Correction : utiliser hist()
hist(matdone$age)

# ❌ Erreur 5 : oubli de plot() au début
(matdone$age, matdone$tauxmax, pch = 21, bg = c("green", "red"))
# Error: unexpected ',' in "(matdone$age,"
# ✅ Correction :
plot(matdone$age, matdone$tauxmax, pch = 21, bg = c("green", "red"))
