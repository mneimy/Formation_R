# =============================================================================
# CORRIGE - JOUR 1, MATINEE
# A ne pas distribuer avant la correction collective.
# =============================================================================

# ---- MICRO-TP 1 - Premiere fiche de cadrage ---------------------------------

nb_dossiers_recus <- 1250
nb_dossiers_clos  <- 975

taux_cloture <- nb_dossiers_clos / nb_dossiers_recus * 100
round(taux_cloture, 1)
#> [1] 78

# Erreur volontaire :
# nb_dossier_clos
#> Error: object 'nb_dossier_clos' not found
# Traduction : R ne connait aucun objet portant EXACTEMENT ce nom.
# R distingue les majuscules et compte chaque caractere.


# ---- MICRO-TP 2 - Indicateurs d'activite ------------------------------------

entrants <- c(120, 95, 110, NA, 130, 105)
sortants <- c(100, 90, 115, 80, 125, 100)

# 2.1 Le NA contamine tout le calcul : R refuse de deviner.
sum(entrants)
#> [1] NA

# 2.2
sum(entrants, na.rm = TRUE)   #> 560
sum(sortants, na.rm = TRUE)   #> 610
mean(entrants, na.rm = TRUE)  #> 112

# 2.3
solde <- sum(entrants, na.rm = TRUE) - sum(sortants, na.rm = TRUE)
solde
#> [1] -50
# Metier : plus de dossiers sortis qu'entres -> le stock se resorbe.

# 2.4
taux <- sum(sortants, na.rm = TRUE) / sum(entrants, na.rm = TRUE) * 100
round(taux, 1)
#> [1] 108.9

# 2.5 LE POINT CLE DE LA MATINEE
ref <- c("TJ44", NA, "", "CA49")
is.na(ref)
#> [1] FALSE  TRUE FALSE FALSE   <- seul NA est detecte
ref == ""
#> [1] FALSE    NA  TRUE FALSE   <- seule "" est detectee
# Deux formes d'absence differentes, deux tests differents.
# Noter aussi que NA == "" renvoie NA, pas FALSE : on ne peut pas comparer
# a une valeur inconnue.


# ---- MICRO-TP 3 - Reperer les mois sous tension -----------------------------

recus   <- c(120, 95, 110, 140, 130, 105)
traites <- c(100, 90, 115,  80, 125, 100)

# 3.1 Controle prealable, toujours
length(recus) == length(traites)
#> [1] TRUE

# 3.2 Calcul vectorise : mois par mois, sans boucle
solde_mensuel <- recus - traites
solde_mensuel
#> [1] 20  5 -5 60  5  5

# 3.3
solde_mensuel[solde_mensuel > 0]
#> [1] 20  5 60  5  5

# 3.4
seuil <- 30
mois_tension <- solde_mensuel[solde_mensuel > seuil]
mois_tension          #> [1] 60
length(mois_tension)  #> [1] 1

# 3.5 Metier : un seul mois presente un stock residuel superieur au seuil
# d'alerte de 30 dossiers. Les cinq autres restent sous controle.
