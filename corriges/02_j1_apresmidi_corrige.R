# =============================================================================
# CORRIGE - JOUR 1, APRES-MIDI
# =============================================================================

library(dplyr)

# ---- TP 1 - Tableau de suivi de juridictions fictives -----------------------

juridictions <- data.frame(
  nom   = c("TJ Nantes", "TJ Rennes", "CA Angers", "CPH Nantes", "TJ Brest", "TCO Rennes"),
  dept  = c("44", "35", "49", "44", "29", "35"),
  recus = c(980, 740, 310, 220, 560, 190),
  clos  = c(870, 700, 290, 200, 510, 175),
  email = c("tj.nantes@justice.fr", "", "ca.angers@justice.fr", NA,
            "tj.brest@justice.fr", ""),
  stringsAsFactors = FALSE
)

# 1.1
str(juridictions)      # 6 obs. of 5 variables
dim(juridictions)      #> [1] 6 5

# 1.2
juridictions$taux_traitement <- round(juridictions$clos / juridictions$recus, 2)
juridictions$taux_traitement
#> [1] 0.89 0.95 0.94 0.91 0.91 0.92

# 1.3 Les DEUX formes d'absence. Un seul des deux tests ne suffit pas.
sans_email <- is.na(juridictions$email) | juridictions$email == ""
sum(sans_email)
#> [1] 3
juridictions[sans_email, c("nom", "email")]

# 1.4
juridictions[juridictions$nom == "TJ Nantes", ]

# 1.5 Metier : toutes les juridictions traitent entre 89 % et 95 % des dossiers
# recus. Aucune n'est en difficulte manifeste, mais la moitie d'entre elles
# n'a pas d'adresse electronique exploitable, ce qui bloquerait un envoi groupe.


# ---- TP 2 - Preparer une synthese territoriale ------------------------------

structures <- read.csv2("data/structures.csv", fileEncoding = "UTF-8")
dim(structures)
#> [1] 1470   13

# 2.1
structures |>
  select(nom_etablissement, type_code, ville, telephone, email) |>
  head(3)

# 2.2
structures |>
  filter(code_departement == "44") |>
  nrow()
#> [1] 15

# 2.3 / 2.6 - la chaine complete
annuaire_44 <- structures |>
  filter(code_departement == "44") |>
  select(nom_etablissement, type_code, ville, telephone, email) |>
  arrange(ville, nom_etablissement)

nrow(annuaire_44)
#> [1] 15

# 2.4 Le diagnostic AVANT la condition.
#     Combien de NA ? Combien de chaines vides ?
sum(is.na(structures$email))    #> [1] 0
sum(structures$email == "")     #> [1] 788
# Conclusion : dans CE fichier, l'absence est codee "" et jamais NA.
# On teste quand meme les deux : le fichier de l'an prochain peut differer.

structures_coord <- structures |>
  mutate(
    a_telephone = !is.na(telephone) & telephone != "",
    a_email     = !is.na(email)     & email     != ""
  )

sum(structures_coord$a_email)
#> [1] 682

# 2.5
structures |>
  count(type_code, sort = TRUE)
#> TBRTJ 272, CPH 216, TGI 168, TE 156, TPRX 125, TCO 122, CDAD 105,
#> CASS 104, CCD 102, TA 41, CA 37, TAE 12, CAA 9, CAS 1

# 2.7 BONUS
structures_coord |>
  group_by(type_code) |>
  summarise(
    nb              = n(),
    taux_coord_completes = mean(a_telephone & a_email)
  ) |>
  arrange(desc(nb))

# 2.8 "Partir des structures, puis ne garder que le departement 44, puis ne
# garder que les cinq colonnes d'annuaire, puis trier par ville et par nom."


# ---- SEQUENCE 7 - Traduire un besoin metier ---------------------------------

# 7.1 Decomposition, en francais, AVANT le code :
#   1. partir du fichier des structures
#   2. ne garder que les cinq departements des Pays de la Loire
#   3. ne garder que les tribunaux judiciaires
#   4. ne garder que les colonnes utiles
#   5. signaler les courriels manquants
#   6. trier par commune

# 7.2
tj_pdl <- structures |>
  filter(code_departement %in% c("44", "49", "53", "72", "85")) |>
  filter(type_code == "TGI") |>
  select(nom_etablissement, ville, code_departement, telephone, email) |>
  mutate(courriel_manquant = is.na(email) | email == "") |>
  arrange(ville)

nrow(tj_pdl)
#> [1] 8
sum(tj_pdl$courriel_manquant)
#> [1] 0
# Aucun courriel manquant : une absence de probleme est aussi un resultat,
# a condition de l'avoir verifiee plutot que supposee.
