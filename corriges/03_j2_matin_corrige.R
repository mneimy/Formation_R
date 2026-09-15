# =============================================================================
# CORRIGE - JOUR 2, MATINEE
# =============================================================================

library(dplyr)

# ---- SEQUENCE 1 - Les trois erreurs -----------------------------------------

# 1.1 ERREUR 1 : nom de colonne mal orthographie
#     filter(code_departemnt == "44")   ->  code_departement
#     Message : object 'code_departemnt' not found
#     Reflexe : la touche Tab complete les noms de colonnes.

# 1.2 ERREUR 2 : parenthese non fermee
#     filter(is.na(email)               ->  filter(is.na(email)) |>
#     Symptome : la console affiche + au lieu de >. R attend la suite.
#     Sortie : touche Echap, puis corriger dans l'editeur.

# 1.3 ERREUR 3 : la plus dangereuse, car SILENCIEUSE
#     filter(is.na(email)) renvoie 0 ligne sur ce fichier.
#     Aucun message d'erreur : le script "marche" et produit un resultat FAUX.
#     Le rapport conclurait que tous les courriels sont renseignes.
#     Correction : filter(is.na(email) | email == "")
#
#     A retenir : une erreur qui s'affiche est benigne, on la corrige.
#     Une erreur silencieuse se retrouve dans une note de synthese.

# 1.4 Script corrige
annuaire <- read.csv2("data/structures.csv", fileEncoding = "UTF-8")

dep44 <- annuaire |>
  filter(code_departement == "44")

nb_sans_courriel <- annuaire |>
  filter(is.na(email) | email == "") |>
  summarise(n = n())
nb_sans_courriel
#>     n
#> 1 788

resultat <- dep44 |>
  select(nom_etablissement, ville, email)


# ---- MICRO-TP 4 - Importer un annuaire --------------------------------------

# 4.1 Fichier a separateur ";" -> read.csv2()
annuaire <- read.csv2("data/structures.csv", fileEncoding = "UTF-8")

# 4.2 Check-list de controle
dim(annuaire)                                  #> [1] 1470   13
names(annuaire)
str(annuaire)
sum(is.na(annuaire))                           #> [1] 0
sum(annuaire$email == "", na.rm = TRUE)        #> [1] 788
sum(duplicated(annuaire$id_structure))         #> [1] 0

# 4.3 code_postal et code_insee sont lus comme des entiers : le zero de tete
#     saute. "01000" devient 1000, et c'est irreversible apres coup.
class(annuaire$code_postal)
#> [1] "integer"

annuaire <- read.csv2(
  "data/structures.csv",
  fileEncoding = "UTF-8",
  colClasses = c(code_postal = "character", code_insee = "character")
)
class(annuaire$code_postal)
#> [1] "character"

# 4.4
annuaire_dep44 <- annuaire |>
  filter(code_departement == "44")
nrow(annuaire_dep44)
#> [1] 15

# 4.5
write.csv2(annuaire_dep44, "outputs/annuaire_dep44.csv", row.names = FALSE)

# 4.6 Verification dans un tableur : accents corrects, codes postaux avec
#     leur zero initial. Sans cette etape, l'erreur n'est decouverte que par
#     le destinataire du fichier.


# ---- SEQUENCE 3 - Reorganiser un script -------------------------------------

# 3.1 Les quatre problemes :
#   a. l'export precede la transformation : impossible a suivre
#   b. le fichier source est lu deux fois, avec des parametres differents
#   c. les objets s'appellent df, df2, x : aucun ne dit ce qu'il contient
#   d. aucun commentaire : on ne sait pas pourquoi ce traitement existe

# 3.2 Version reorganisee -> voir ressources/script_modele.R du projet Formation_R

# 3.3 Test depuis une session propre : Ctrl+Shift+F10 puis Ctrl+Shift+Enter.
#     Un script qui ne tourne pas depuis une session vide n'est pas fini.


# ---- TP 3 - Une fonction de synthese par departement ------------------------

# 5.1 et 5.2
synthese_dep <- function(tableau, code_dep) {
  stopifnot(is.data.frame(tableau), is.character(code_dep))

  sous_tableau <- tableau |>
    filter(code_departement == code_dep)

  data.frame(
    departement   = code_dep,
    nb_structures = nrow(sous_tableau),
    nb_avec_email = sum(!is.na(sous_tableau$email) & sous_tableau$email != "")
  )
}

# 5.3
synthese_dep(annuaire, "44")
#>   departement nb_structures nb_avec_email
#> 1          44            15             9

# synthese_dep(annuaire, 44)
#> Error: is.character(code_dep) is not TRUE
# Mieux vaut une erreur franche qu'un resultat silencieusement faux.

# 5.4 Avec une boucle for
departements_cibles <- c("44", "49", "53", "72", "85")
resultats <- list()
for (dep in departements_cibles) {
  resultats[[dep]] <- synthese_dep(annuaire, dep)
}
tableau_boucle <- do.call(rbind, resultats)
tableau_boucle

# 5.5 Le meme resultat, en une seule chaine
tableau_vectorise <- annuaire |>
  filter(code_departement %in% departements_cibles) |>
  group_by(code_departement) |>
  summarise(
    nb_structures = n(),
    nb_avec_email = sum(!is.na(email) & email != "")
  )
tableau_vectorise
#> 5 lignes, 60 structures au total

sum(tableau_vectorise$nb_structures)
#> [1] 60

# Conclusion : 10 lignes de boucle contre 6 lignes de dplyr, pour un resultat
# identique. La boucle doit etre COMPRISE pour lire le code des collegues ;
# l'approche vectorisee est celle du quotidien.


# ---- SEQUENCE 5 - Ouvrir et fermer une connexion ----------------------------

library(DBI)
library(RSQLite)

con <- dbConnect(RSQLite::SQLite(), "data/formation.sqlite")
dbListTables(con)
#> [1] "departements" "structures" "types_structure"
dbDisconnect(con)
