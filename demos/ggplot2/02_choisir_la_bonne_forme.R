# =============================================================================
# DEMONSTRATION ggplot2 - 2/3
# Choisir la bonne forme selon la question posee
# -----------------------------------------------------------------------------
# Le choix du graphique ne depend pas du gout : il depend de la QUESTION.
# Quatre questions courantes, quatre formes.
# =============================================================================

library(dplyr)
library(ggplot2)

structures   <- read.csv2("data/structures.csv",   fileEncoding = "UTF-8")
departements <- read.csv2("data/departements.csv", fileEncoding = "UTF-8")
types        <- read.csv2("data/types_structure.csv", fileEncoding = "UTF-8")

base <- structures |>
  inner_join(departements, by = "code_departement") |>
  left_join(types, by = "type_code")


# =============================================================================
# QUESTION 1 : "Combien, par categorie ?"        -> BARRES  geom_col()
# =============================================================================
# La forme la plus utile de toutes, et la plus sous-employee dans
# l'administration au profit du camembert.
# Regle : barres horizontales des que les etiquettes sont des mots.

par_type <- base |>
  filter(!is.na(libelle_type)) |>
  count(libelle_type, sort = TRUE)

g1 <- ggplot(par_type, aes(x = reorder(libelle_type, n), y = n)) +
  geom_col(fill = "#2c5282") +
  geom_text(aes(label = n), hjust = -0.2, size = 3) +   # la valeur en bout de barre
  coord_flip() +
  labs(title = "Nombre de structures par type", x = NULL, y = NULL,
       caption = "Source : referentiel SRJ, data.gouv.fr") +
  theme_minimal(base_size = 11)
g1
ggsave("outputs/02a_barres_par_type.png", g1, width = 20, height = 12, units = "cm", dpi = 150)

# POURQUOI PAS UN CAMEMBERT ?
# L'oeil humain compare mal des angles, et bien des longueurs. Avec 14
# categories, un camembert devient illisible la ou les barres restent claires.
# ggplot2 ne propose d'ailleurs pas de geom_pie() : ce n'est pas un oubli.


# =============================================================================
# QUESTION 2 : "Comment se repartit une valeur ?"  -> HISTOGRAMME  geom_histogram()
# =============================================================================
# Une moyenne cache la forme de la distribution. L'histogramme la montre.

par_dept <- base |> count(code_departement)

g2 <- ggplot(par_dept, aes(x = n)) +
  geom_histogram(binwidth = 3, fill = "#2c5282", colour = "white") +
  labs(title = "Combien de structures par departement ?",
       subtitle = paste0("Moyenne : ", round(mean(par_dept$n), 1),
                         " structures - mais la moyenne ne dit pas tout"),
       x = "Nombre de structures dans le departement",
       y = "Nombre de departements",
       caption = "Source : referentiel SRJ, data.gouv.fr") +
  theme_minimal(base_size = 11)
g2
ggsave("outputs/02b_histogramme.png", g2, width = 20, height = 12, units = "cm", dpi = 150)

# A COMMENTER EN SEANCE : la distribution est asymetrique. La plupart des
# departements comptent une dizaine de structures, quelques-uns beaucoup plus.
# La moyenne seule suggererait a tort une repartition homogene.


# =============================================================================
# QUESTION 3 : "Deux mesures varient-elles ensemble ?" -> NUAGE  geom_point()
# =============================================================================

comparaison <- base |>
  group_by(nom_region) |>
  summarise(nb = n(), taux_email = mean(email != ""))

g3 <- ggplot(comparaison, aes(x = nb, y = taux_email)) +
  geom_point(size = 3, colour = "#2c5282") +
  geom_text(aes(label = nom_region), vjust = -0.9, size = 2.8) +
  scale_y_continuous(labels = scales::percent) +   # 0.46 s'affiche "46 %"
  expand_limits(x = 200) +
  labs(title = "Les grandes regions renseignent-elles mieux leurs courriels ?",
       subtitle = "Aucune relation nette : la taille n'explique pas la qualite du referentiel",
       x = "Nombre de structures", y = "Part avec courriel",
       caption = "Source : referentiel SRJ, data.gouv.fr") +
  theme_minimal(base_size = 11)
g3
ggsave("outputs/02c_nuage.png", g3, width = 20, height = 13, units = "cm", dpi = 150)

# Le titre pose une QUESTION et le sous-titre donne la REPONSE.
# C'est la difference entre un graphique qui informe et un graphique qui decore.


# =============================================================================
# QUESTION 4 : "Comparer plusieurs groupes d'un coup ?" -> facet_wrap()
# =============================================================================
# facet_wrap() repete le MEME graphique pour chaque groupe, avec des axes
# communs. C'est la fonction qui remplace dix diapositives par une seule.

top6 <- base |>
  filter(!is.na(libelle_type)) |>
  count(nom_region, libelle_type) |>
  # ATTENTION : "Île-de-France" prend un I accentue dans le referentiel.
  # Ecrire "Ile-de-France" ne provoque aucune erreur : la region disparait
  # simplement du graphique, sans un mot. Verifiez toujours vos libelles avec
  # unique(base$nom_region) avant de filtrer sur du texte.
  filter(nom_region %in% c("Île-de-France", "Auvergne-Rhône-Alpes",
                           "Occitanie", "Grand Est", "Nouvelle-Aquitaine",
                           "Hauts-de-France")) |>
  group_by(libelle_type) |>
  filter(sum(n) > 80) |>
  ungroup()

g4 <- ggplot(top6, aes(x = reorder(libelle_type, n), y = n)) +
  geom_col(fill = "#2c5282") +
  coord_flip() +
  facet_wrap(~ nom_region) +
  labs(title = "Repartition des principaux types de structure, par region",
       x = NULL, y = "Nombre de structures",
       caption = "Source : referentiel SRJ, data.gouv.fr") +
  theme_minimal(base_size = 9)
g4
ggsave("outputs/02d_facettes.png", g4, width = 24, height = 15, units = "cm", dpi = 150)

cat("Quatre graphiques enregistres dans outputs/\n")
