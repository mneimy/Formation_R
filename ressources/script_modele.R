# =============================================================================
# Projet   : [Objet du traitement]
# Auteur   : [Prenom Nom] - [Service]
# Date     : [JJ/MM/AAAA]
# Entree   : data/structures.csv
# Sortie   : outputs/[nom_du_fichier].csv
# Objet    : [Une phrase : a quoi sert ce script et pour qui]
# =============================================================================
# Ce script est le modele a reprendre pour tout traitement. Les quatre sections
# sont dans un ordre qui ne s'inverse pas : on ne peut pas exporter avant
# d'avoir transforme, ni transformer avant d'avoir controle.
# =============================================================================

library(dplyr)

# ---- 1. Import --------------------------------------------------------------
# colClasses force le type des codes : sans cela "01000" devient 1000.

annuaire <- read.csv2(
  "data/structures.csv",
  fileEncoding = "UTF-8",
  colClasses = c(code_postal = "character", code_insee = "character")
)

# ---- 2. Controle ------------------------------------------------------------
# Ce bloc ne se discute pas : il s'execute a chaque fois.

stopifnot(nrow(annuaire) > 0)
dim(annuaire)
sum(duplicated(annuaire$id_structure))   # doublons sur la cle
sum(annuaire$email == "", na.rm = TRUE)  # chaines vides, pas des NA

# ---- 3. Transformation ------------------------------------------------------
# On isole le departement 44 pour l'export destine a [destinataire].

annuaire_dep44 <- annuaire |>
  filter(code_departement == "44") |>
  mutate(courriel_manquant = is.na(email) | email == "") |>
  select(nom_etablissement, ville, telephone, email, courriel_manquant) |>
  arrange(ville, nom_etablissement)

# ---- 4. Export --------------------------------------------------------------
# Toujours dans outputs/, jamais dans data/. row.names = FALSE evite une
# colonne de numeros inutile a l'ouverture dans un tableur.

write.csv2(annuaire_dep44, "outputs/annuaire_dep44.csv", row.names = FALSE)

cat("Export realise :", nrow(annuaire_dep44), "lignes\n")

# =============================================================================
# Avant de livrer ce script : Ctrl+Shift+F10 (session propre), puis
# Ctrl+Shift+Enter (executer tout). S'il echoue, il n'etait pas autonome.
# =============================================================================
