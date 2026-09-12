# =============================================================================
# FORMATION R - JOUR 2, MATINEE
# Automatiser ses traitements et comprendre les bases de donnees
# =============================================================================

library(dplyr)


# =============================================================================
# SEQUENCE 1 - Reactivation : trois erreurs a trouver           (20 minutes)
# =============================================================================
# Le script ci-dessous contient TROIS erreurs distinctes. Trouvez-les et
# corrigez-les. Ne l'executez pas tel quel : lisez-le d'abord.
#
#   library(dplyr)
#
#   annuaire <- read.csv2("data/structures.csv", fileEncoding = "UTF-8")
#
#   # Filtrer le departement 44
#   dep44 <- annuaire |>
#     filter(code_departemnt == "44")
#
#   # Compter les structures sans courriel
#   nb <- annuaire |>
#     filter(is.na(email)
#     summarise(n = n())
#
#   # Garder les colonnes utiles
#   resultat <- dep44 |>
#     select(nom_etablissement, ville, email)

# 1.1 Erreur 1 : laquelle, et quel message R affiche-t-il ?


# 1.2 Erreur 2 : laquelle, et quel symptome voyez-vous dans la console ?


# 1.3 Erreur 3 : la plus insidieuse. Elle ne produit AUCUN message d'erreur.
#     Laquelle, et pourquoi est-elle dangereuse ?


# 1.4 Reecrivez le script corrige ci-dessous.


# =============================================================================
# MICRO-TP 4 - Importer un annuaire                             (15 minutes)
# =============================================================================

# 4.1 Importez data/structures.csv. Le fichier utilise le point-virgule comme
#     separateur : choisissez la bonne fonction et precisez l'encodage.


# 4.2 Appliquez la check-list de controle apres import :
#     dimensions, noms de colonnes, types, NA, chaines vides, doublons.


# 4.3 Observez le type de code_postal et de code_insee. Que constatez-vous ?
#     Reimportez le fichier en forcant ces deux colonnes au type caractere.


# 4.4 Filtrez les structures du departement 44.


# 4.5 Exportez le resultat dans outputs/annuaire_dep44.csv, sans la colonne
#     de numeros de ligne.


# 4.6 ETAPE ESSENTIELLE : rouvrez le fichier exporte dans Excel ou LibreOffice.
#     Les accents sont-ils corrects ? Les codes postaux ont-ils garde leur
#     zero initial ? Un export mal parametre est inexploitable par vos collegues.


# -> Reponses attendues : 4.2 -> 1470 lignes, 13 colonnes, 788 courriels vides,
#    0 doublon sur id_structure | 4.4 -> 15 structures


# =============================================================================
# SEQUENCE 3 - Reorganiser un script                            (15 minutes)
# =============================================================================
# Ce script fonctionne, mais il est illisible et fragile. Reorganisez-le.
#
#   library(dplyr)
#   df <- read.csv2("data/structures.csv", fileEncoding = "UTF-8")
#   write.csv2(df2, "outputs/res.csv", row.names = FALSE)
#   x <- df |> filter(code_departement == "44")
#   df2 <- x |> select(nom_etablissement, ville, email)
#   df <- read.csv2("data/structures.csv",
#                   colClasses = c(code_postal = "character"))

# 3.1 Identifiez les quatre problemes.


# 3.2 Reecrivez le script avec un en-tete normalise et quatre sections :
#     import, controle, transformation, export.


# 3.3 Testez-le depuis une session propre : Ctrl+Shift+F10, puis executez
#     le script entier. S'il echoue, il n'etait pas autonome.


# =============================================================================
# TP 3 - Une fonction de synthese par departement               (25 minutes)
# =============================================================================

# 5.1 Ecrivez une fonction synthese_dep() qui recoit un tableau et un code
#     departement, et renvoie un data.frame d'une ligne contenant :
#     le code departement, le nombre total de structures, et le nombre de
#     structures disposant d'un courriel.


# 5.2 Securisez les entrees avec stopifnot() : le premier argument doit etre
#     un data.frame, le second une chaine de caracteres.


# 5.3 Testez : synthese_dep(annuaire, "44") doit fonctionner,
#     synthese_dep(annuaire, 44) doit echouer avec un message clair.


# 5.4 Appliquez la fonction aux cinq departements des Pays de la Loire
#     (44, 49, 53, 72, 85) avec une boucle for, puis assemblez les resultats.


# 5.5 Produisez le MEME resultat avec group_by() et summarise().
#     Comparez le nombre de lignes de code. Lequel utiliserez-vous a votre poste ?


# -> Reponses attendues : 5.3 -> dept 44 : 15 structures, 9 avec courriel
#    5.4 et 5.5 -> 5 lignes, totalisant 60 structures


# =============================================================================
# SEQUENCE 5 - Bases de donnees : ouvrir et fermer              (10 minutes)
# =============================================================================
# Cette sequence pose le vocabulaire. Aucune requete ce matin : les fonctions
# dplyr sur la base sont l'objet de l'apres-midi.

library(DBI)
library(RSQLite)

# 6.1 Ouvrez une connexion vers data/formation.sqlite.


# 6.2 Listez les tables disponibles. Combien y en a-t-il ?


# 6.3 Fermez la connexion.


# -> Reponse attendue : 3 tables (departements, structures, types_structure)


# =============================================================================
# FIN DE LA MATINEE
# =============================================================================
