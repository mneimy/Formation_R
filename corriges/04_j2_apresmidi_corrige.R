# =============================================================================
# CORRIGE - JOUR 2, APRES-MIDI
# Interroger la base avec dbplyr
# =============================================================================

library(dplyr)
library(dbplyr)
source("utils/panneau_connexion.R")

# ---- ETAPE A - Connexion ----------------------------------------------------

getwd()
con <- ouvrir_connexion_formation()

structures      <- tbl(con, "structures")
types_structure <- tbl(con, "types_structure")
departements    <- tbl(con, "departements")

structures
# La sortie annonce "?? rows" : dbplyr n'a pas execute la requete, il ne sait
# donc pas combien de lignes elle renverra. Rien n'a ete rapatrie.


# ---- ETAPE B - Requetes simples et evaluation differee ----------------------

# B.1
requete_tgi <- structures %>%
  filter(type_code == "TGI") %>%
  select(nom_etablissement, ville, code_departement) %>%
  arrange(code_departement)

# B.2
class(requete_tgi)
#> [1] "tbl_SQLiteConnection" "tbl_dbi" "tbl_sql" "tbl_lazy" "tbl"
# Ce n'est PAS un data.frame : c'est une requete en attente.

# B.3
requete_tgi %>% show_query()
#> SELECT nom_etablissement, ville, code_departement
#> FROM structures
#> WHERE (type_code = 'TGI')
#> ORDER BY code_departement

# B.4
tgi <- requete_tgi %>% collect()
nrow(tgi)
#> [1] 168
class(tgi)   # maintenant c'est un tibble local

# B.5 glimpse() fonctionne sur une table distante, str() est illisible.
glimpse(structures)


# ---- ETAPE C - Agregations metier -------------------------------------------
# Regle : agreger PUIS collecter.

# C.1
structures %>%
  group_by(type_code) %>%
  summarise(nb = n()) %>%
  arrange(desc(nb)) %>%
  collect()
#> TBRTJ 272, CPH 216, TGI 168, TE 156, TPRX 125, TCO 122, CDAD 105,
#> CASS 104, CCD 102, TA 41, CA 37, TAE 12, CAA 9, CAS 1

# C.2
structures %>%
  group_by(code_departement) %>%
  summarise(nb = n()) %>%
  arrange(desc(nb)) %>%
  collect()

# C.3 Deux pieges se cumulent ici.
#
#   PIEGE 1 - l'absence est codee "" -> email != "", surtout pas is.na().
#
#   PIEGE 2 - SQLite fait une DIVISION ENTIERE. La chaine ci-dessous, qui
#   serait juste en R local, renvoie 0 sur une table distante :
#
#     summarise(avec = sum(email != "", na.rm = TRUE), total = n()) %>%
#       mutate(taux = avec / total)        # -> taux = 0
#
#   Le SQL produit est SUM(...) / COUNT(*), soit 682 / 1470 en entiers = 0.
#   Verifiez-le avec show_query() : c'est la meilleure demonstration de
#   l'interet de savoir lire le SQL genere.
#
#   Trois corrections possibles, de la plus lisible a la plus explicite :

# a) mean() sur une condition = proportion. La plus courte.
structures %>%
  summarise(taux = mean(email != "", na.rm = TRUE)) %>%
  collect()
#> taux = 0.464

# b) forcer le calcul en reel avec * 1.0
structures %>%
  summarise(avec_email = sum(email != "", na.rm = TRUE), total = n()) %>%
  mutate(taux = avec_email * 1.0 / total) %>%
  collect()
#> avec_email = 682, total = 1470, taux = 0.464

# c) collecter les comptages, puis calculer en local
structures %>%
  summarise(avec_email = sum(email != "", na.rm = TRUE), total = n()) %>%
  collect() %>%
  mutate(taux = avec_email / total)
#> taux = 0.464

# C.4 head(10) plutot que slice_max()
structures %>%
  group_by(code_departement) %>%
  summarise(nb = n()) %>%
  arrange(desc(nb)) %>%
  head(10) %>%
  collect()


# ---- ETAPE D - Jointures et qualite des referentiels ------------------------

# D.1
structures %>%
  inner_join(types_structure, by = "type_code") %>%
  inner_join(departements,    by = "code_departement") %>%
  select(nom_etablissement, libelle_type, nom_departement, nom_region) %>%
  head(5) %>%
  collect()

# D.2 LE CONTROLE INDISPENSABLE : compter avant et apres
avant <- structures %>% summarise(n = n()) %>% collect()
apres <- structures %>%
  inner_join(departements, by = "code_departement") %>%
  summarise(n = n()) %>%
  collect()
c(avant = avant$n, apres = apres$n)
#> avant 1470, apres 1436  -> 34 lignes ont disparu SANS aucun avertissement

# D.3
structures %>%
  anti_join(departements, by = "code_departement") %>%
  summarise(n = n()) %>%
  collect()
#> 34

structures %>%
  anti_join(departements, by = "code_departement") %>%
  distinct(code_departement) %>%
  collect()
#> 975, 978, 986, 987, 988

# D.4
structures %>%
  anti_join(types_structure, by = "type_code") %>%
  collect() %>%
  count(type_code)
#> TAE : 12

# D.5 Interpretation
#   - codes 975 a 988 : ABSENCE ATTENDUE. Saint-Pierre-et-Miquelon,
#     Saint-Martin, Wallis-et-Futuna, la Polynesie francaise et la
#     Nouvelle-Caledonie ne sont pas des departements. Rien a corriger :
#     a documenter dans la note de methode.
#   - code TAE : REGLE METIER AMBIGUE. Le code existe dans les donnees mais
#     pas dans la nomenclature publiee. Ni bug ni oubli de notre part :
#     a faire trancher par le producteur de la donnee.
#   - Aucune anomalie technique ici. Mais sans le controle D.2, les deux cas
#     seraient passes inapercus.


# ---- ETAPE E - Mini-cas de synthese -----------------------------------------

tableau_regional <- structures %>%
  inner_join(departements, by = "code_departement") %>%
  group_by(nom_region) %>%
  summarise(
    nb_structures = n(),
    nb_types      = n_distinct(type_code),
    # mean() sur une condition : evite la division entiere de SQLite
    taux_email    = mean(email != "", na.rm = TRUE)
  ) %>%
  filter(nb_structures > 50) %>%
  arrange(desc(nb_structures)) %>%
  collect()

tableau_regional
nrow(tableau_regional)

write.csv2(tableau_regional, "outputs/tableau_regional.csv", row.names = FALSE)

fermer_connexion_formation(con)
