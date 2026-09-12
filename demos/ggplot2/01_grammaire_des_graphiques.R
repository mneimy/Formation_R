# =============================================================================
# DEMONSTRATION ggplot2 - 1/3
# La grammaire des graphiques : construire couche par couche
# -----------------------------------------------------------------------------
# A projeter en seance. Executez UN BLOC A LA FOIS et laissez le graphique
# s'afficher avant de passer au suivant : l'interet de la demonstration est
# de voir le graphique se construire.
# =============================================================================

library(dplyr)
library(ggplot2)

# ---- Les donnees : le tableau regional produit en fin de Jour 2 -------------

structures   <- read.csv2("data/structures.csv",   fileEncoding = "UTF-8")
departements <- read.csv2("data/departements.csv", fileEncoding = "UTF-8")

tableau_regional <- structures |>
  inner_join(departements, by = "code_departement") |>
  group_by(nom_region) |>
  summarise(
    nb_structures = n(),
    taux_email    = mean(email != "")
  ) |>
  arrange(desc(nb_structures))

tableau_regional


# =============================================================================
# L'IDEE CENTRALE
# -----------------------------------------------------------------------------
# Un graphique ggplot2 repond toujours a trois questions, dans cet ordre :
#
#   1. QUELLES DONNEES ?          -> ggplot(donnees)
#   2. QUELLE COLONNE SUR QUEL AXE ? -> aes(x = ..., y = ...)
#   3. QUELLE FORME ?             -> geom_col(), geom_point(), geom_line()...
#
# On assemble ces reponses avec le signe +, une couche a la fois.
# Le + de ggplot2 joue le meme role que le |> de dplyr : enchainer.
# Piege classique : ecrire |> au lieu de + dans un ggplot. R renvoie une erreur.
# =============================================================================


# ---- COUCHE 1 : les donnees et les axes, sans forme -------------------------
# Resultat : un cadre vide, mais les axes sont deja places.
# C'est normal : on n'a pas encore dit QUELLE FORME dessiner.

ggplot(
  tableau_regional,
  aes(x = nom_region, y = nb_structures)
)


# ---- COUCHE 2 : ajouter les barres ------------------------------------------
# geom_col() dessine une barre dont la hauteur est la valeur de y.
# Probleme immediat et visible : les noms de regions se chevauchent,
# et les barres sont dans l'ordre alphabetique, qui n'a aucun sens ici.

ggplot(tableau_regional, aes(x = nom_region, y = nb_structures)) +
  geom_col()


# ---- COUCHE 3 : ordonner les barres par valeur ------------------------------
# reorder(A, B) reordonne les categories de A selon les valeurs de B.
# Un graphique de categories doit presque toujours etre trie par valeur :
# c'est ce qui permet de lire un classement d'un seul coup d'oeil.

ggplot(tableau_regional, aes(x = reorder(nom_region, nb_structures), y = nb_structures)) +
  geom_col()


# ---- COUCHE 4 : basculer a l'horizontale ------------------------------------
# coord_flip() permute les deux axes. Des que les etiquettes sont des noms
# longs - regions, juridictions, services - l'horizontale est le bon choix :
# les noms se lisent normalement, sans incliner la tete ni le texte.

ggplot(tableau_regional, aes(x = reorder(nom_region, nb_structures), y = nb_structures)) +
  geom_col() +
  coord_flip()


# ---- COUCHE 5 : titrer et citer la source -----------------------------------
# Un graphique destine a sortir du service doit porter son titre, l'unite de
# lecture et sa source. x = NULL retire le titre d'axe "nom_region", qui
# n'apprend rien : les noms de regions parlent d'eux-memes.

ggplot(tableau_regional, aes(x = reorder(nom_region, nb_structures), y = nb_structures)) +
  geom_col() +
  coord_flip() +
  labs(
    title    = "Structures judiciaires par region",
    subtitle = "France entiere, hors collectivites d'outre-mer",
    x        = NULL,
    y        = "Nombre de structures",
    caption  = "Source : referentiel SRJ, data.gouv.fr - extraction 2026"
  )


# ---- COUCHE 6 : le theme ----------------------------------------------------
# Le theme ne change aucune donnee : il ne regle que l'habillage.
# theme_minimal() retire le fond gris et allege les quadrillages.

ggplot(tableau_regional, aes(x = reorder(nom_region, nb_structures), y = nb_structures)) +
  geom_col(fill = "#2c5282") +
  coord_flip() +
  labs(
    title    = "Structures judiciaires par region",
    subtitle = "France entiere, hors collectivites d'outre-mer",
    x        = NULL,
    y        = "Nombre de structures",
    caption  = "Source : referentiel SRJ, data.gouv.fr - extraction 2026"
  ) +
  theme_minimal(base_size = 12)


# ---- EXPORTER ---------------------------------------------------------------
# ggsave() enregistre le DERNIER graphique affiche.
# Toujours preciser width, height et dpi : sans cela, la taille depend de la
# fenetre RStudio au moment de l'export, et le resultat n'est pas reproductible.

ggsave(
  "outputs/01_structures_par_region.png",
  width = 20, height = 12, units = "cm", dpi = 150
)

cat("Graphique enregistre dans outputs/01_structures_par_region.png\n")
