# =============================================================================
# A EXECUTER EN TOUT PREMIER, LE MATIN DU JOUR 1
# Verifie que le poste est correctement equipe. Duree : 30 secondes.
# =============================================================================

cat("Version de R :", R.version.string, "\n")
if (getRversion() < "4.1.0") {
  cat("  ATTENTION : le pipe natif |> demande R 4.1 minimum.\n")
} else {
  cat("  OK - le pipe natif |> est disponible.\n")
}

requis <- c("dplyr", "dbplyr", "DBI", "RSQLite", "readr", "ggplot2")
manquants <- setdiff(requis, rownames(installed.packages()))

if (length(manquants) == 0) {
  cat("Packages : tous presents.\n")
} else {
  cat("Packages MANQUANTS :", paste(manquants, collapse = ", "), "\n")
  cat("  -> install.packages(c(\"", paste(manquants, collapse = "\", \""), "\"))\n", sep = "")
}

cat("Repertoire de travail :", getwd(), "\n")
if (file.exists("formation-r-justice.Rproj")) {
  cat("  OK - vous etes bien a la racine du projet.\n")
} else {
  cat("  ATTENTION : ouvrez formation-r-justice.Rproj avant de continuer.\n")
}

fichiers <- c("data/structures.csv", "data/departements.csv",
              "data/types_structure.csv", "data/formation.sqlite")
absents <- fichiers[!file.exists(fichiers)]
if (length(absents) == 0) {
  cat("Donnees : les 4 fichiers sont presents.\n")
} else {
  cat("Donnees MANQUANTES :", paste(absents, collapse = ", "), "\n")
  cat("  -> source(\"R/99_regenerer_donnees.R\")\n")
}

if (requireNamespace("quarto", quietly = TRUE)) {
  v <- try(quarto::quarto_version(), silent = TRUE)
  cat("Quarto :", if (inherits(v, "try-error")) "absent du poste" else as.character(v), "\n")
} else {
  cat("Quarto : package R 'quarto' absent (verifier avec : quarto --version au Terminal)\n")
}
