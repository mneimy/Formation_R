# =============================================================================
# Preparation des donnees de la formation R
# -----------------------------------------------------------------------------
# Produit, a partir des fichiers de data/sources/ :
#   - data/structures.csv     : le referentiel a plat, utilise Jour 1 et Jour 2 matin
#   - data/departements.csv   : referentiel geographique
#   - data/types_structure.csv: referentiel des types
#   - data/formation.sqlite   : la base 3 tables, utilisee Jour 2 apres-midi
#
# Aucun acces reseau necessaire : les sources sont deja dans data/sources/.
# Dependances : DBI + RSQLite uniquement.
#
# Usage : source("R/99_regenerer_donnees.R")  -- depuis la racine du projet
# =============================================================================

library(DBI)
library(RSQLite)

# ---- 1. Lecture des sources -------------------------------------------------

structures_brut <- read.csv2(
  "data/sources/structures_justice.csv",
  fileEncoding = "UTF-8", stringsAsFactors = FALSE, colClasses = "character"
)

departements <- read.csv(
  "data/sources/departements_regions.csv",
  fileEncoding = "UTF-8", stringsAsFactors = FALSE, colClasses = "character"
)
names(departements) <- c("code_departement", "nom_departement", "nom_region")

types_structure <- read.csv(
  "data/sources/types_structure.csv",
  fileEncoding = "UTF-8", stringsAsFactors = FALSE, colClasses = "character"
)

# ---- 2. Mise en forme de la table structures --------------------------------
# Code departement deduit du code INSEE : 3 caracteres pour les DOM/COM (97x/98x),
# 2 sinon (dont "2A" / "2B" pour la Corse).

code_insee <- structures_brut$CODE_INSEE
est_dom_com <- substr(code_insee, 1, 2) %in% c("97", "98")
code_departement <- ifelse(est_dom_com, substr(code_insee, 1, 3), substr(code_insee, 1, 2))

# Les noms de colonnes de la source contiennent des accents, dont le decodage
# depend du parametrage regional de Windows -> on selectionne par position pour
# rendre ce script insensible au poste sur lequel il tourne.
col <- function(motif) {
  i <- grep(motif, names(structures_brut))
  if (length(i) != 1) stop("Colonne introuvable ou ambigue : ", motif)
  structures_brut[[i]]
}

structures <- data.frame(
  id_structure           = paste0(structures_brut$CODE_ORIG, "-", structures_brut$NUM),
  type_code              = structures_brut$TYPE,
  code_insee             = code_insee,
  code_departement       = code_departement,
  nom_etablissement      = structures_brut$NOM_ETABLISSEMENT,
  adresse                = col("^NUM.*VOIE$"),
  code_postal            = structures_brut$CODE_POSTAL,
  ville                  = structures_brut$LIGNE_D_ACHEMINEMENT,
  collectivite_outre_mer = col("^PAYS_OU_D"),
  coord_x                = as.numeric(col("^COORDONN.*X$")),
  coord_y                = as.numeric(col("^COORDONN.*Y$")),
  telephone              = structures_brut$NU_TEL,
  email                  = structures_brut$ADRESSE_MAIL,
  stringsAsFactors       = FALSE
)

# ---- 3. Ecriture des CSV de travail -----------------------------------------
# write.csv2 : separateur ";" et decimale "," -> c'est read.csv2() qui les relit,
# conformement a ce qui est enseigne le Jour 2 au matin.

dir.create("data", showWarnings = FALSE)
write.csv2(structures,      "data/structures.csv",      row.names = FALSE, fileEncoding = "UTF-8")
write.csv2(departements,    "data/departements.csv",    row.names = FALSE, fileEncoding = "UTF-8")
write.csv2(types_structure, "data/types_structure.csv", row.names = FALSE, fileEncoding = "UTF-8")

# ---- 4. Construction de la base SQLite --------------------------------------

chemin_base <- "data/formation.sqlite"
if (file.exists(chemin_base)) invisible(file.remove(chemin_base))

con <- dbConnect(RSQLite::SQLite(), chemin_base)
dbWriteTable(con, "structures",      structures)
dbWriteTable(con, "types_structure", types_structure)
dbWriteTable(con, "departements",    departements)
dbDisconnect(con)

# ---- 5. Recapitulatif -------------------------------------------------------

cat("Donnees preparees.\n")
cat(" - data/structures.csv      :", nrow(structures), "lignes,", ncol(structures), "colonnes\n")
cat(" - data/departements.csv    :", nrow(departements), "lignes\n")
cat(" - data/types_structure.csv :", nrow(types_structure), "lignes\n")
cat(" - data/formation.sqlite    : 3 tables\n")
cat("\nValeurs de controle attendues :\n")
cat("  structures sans courriel  :", sum(structures$email == ""), "/", nrow(structures), "\n")
cat("  structures de code TAE    :", sum(structures$type_code == "TAE"), "\n")
cat("  codes departement orphelins:",
    paste(setdiff(unique(structures$code_departement), departements$code_departement), collapse = ", "), "\n")
