# =============================================================================
# DEMONSTRATION ggplot2 - 3/3
# Ce qui separe un graphique correct d'un graphique publiable
# -----------------------------------------------------------------------------
# Les donnees sont les memes qu'au script 01. Seul l'habillage change.
# Comparez la premiere et la derniere version : c'est le meme jeu de donnees.
# =============================================================================

library(dplyr)
library(ggplot2)

structures   <- read.csv2("data/structures.csv",   fileEncoding = "UTF-8")
departements <- read.csv2("data/departements.csv", fileEncoding = "UTF-8")

regional <- structures |>
  inner_join(departements, by = "code_departement") |>
  group_by(nom_region) |>
  summarise(nb = n(), taux_email = mean(email != "")) |>
  arrange(desc(nb))


# ---- 1. Un theme maison, defini une fois pour toutes ------------------------
# Plutot que de repeter les memes reglages sur chaque graphique, on definit un
# theme une fois et on l'applique partout. C'est ce qui donne a une serie de
# graphiques l'air d'appartenir au meme document.

theme_justice <- function(base_size = 11) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.title      = element_text(face = "bold", size = base_size + 3),
      plot.subtitle   = element_text(colour = "grey30", margin = margin(b = 10)),
      plot.caption    = element_text(colour = "grey45", size = base_size - 2, hjust = 0),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_blank(),   # inutile sur des barres horizontales
      axis.ticks      = element_blank()
    )
}

# On peut meme en faire le theme par defaut de toute la session :
# theme_set(theme_justice())


# ---- 2. Mettre en evidence UNE information ----------------------------------
# Colorer toutes les barres de la meme couleur n'apporte rien. Colorer
# differemment ce dont on parle transforme le graphique en argument.
# Ici : les regions sous la moyenne nationale de renseignement des courriels.

moyenne_nationale <- mean(structures$email != "")

regional <- regional |>
  mutate(sous_la_moyenne = taux_email < moyenne_nationale)

g <- ggplot(regional, aes(x = reorder(nom_region, taux_email), y = taux_email,
                          fill = sous_la_moyenne)) +
  geom_col() +
  geom_hline(yintercept = moyenne_nationale, linetype = "dashed", colour = "grey40") +
  annotate("text",
           x = 1.5, y = moyenne_nationale,
           label = paste0("Moyenne nationale : ", round(moyenne_nationale * 100), " %"),
           hjust = -0.05, size = 3, colour = "grey30") +
  scale_fill_manual(values = c("TRUE" = "#c05621", "FALSE" = "#a0aec0"), guide = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.7)) +
  coord_flip() +
  labs(
    # Le titre se calcule a partir des donnees : un nombre ecrit en dur dans
    # un titre devient faux des la prochaine extraction, sans prevenir.
    title    = paste0(sum(regional$sous_la_moyenne),
                      " regions sous la moyenne de renseignement des courriels"),
    subtitle = "Part des structures judiciaires disposant d'une adresse electronique",
    x = NULL, y = NULL,
    caption  = "Source : referentiel SRJ, data.gouv.fr - extraction 2026\nLecture : en Martinique, 33 % des structures disposent d'un courriel."
  ) +
  theme_justice()
g

ggsave("outputs/03_graphique_publiable.png", g,
       width = 22, height = 14, units = "cm", dpi = 200)


# ---- 3. Les six regles de finition ------------------------------------------
#
#   1. TRIER par valeur, jamais par ordre alphabetique.
#      Un graphique non trie oblige le lecteur a faire le tri lui-meme.
#
#   2. TITRER par le message, pas par le sujet.
#      "Neuf regions sous la moyenne" vaut mieux que "Taux par region".
#      Si vous ne savez pas quoi ecrire, le graphique n'a peut-etre rien a dire.
#
#   3. AJOUTER UNE NOTE DE LECTURE pour tout graphique de pourcentage.
#      "Lecture : en Martinique, 33 % des structures..." evite les contresens.
#
#   4. CITER LA SOURCE ET LA DATE D'EXTRACTION, systematiquement.
#      Un graphique sans source n'est pas opposable.
#
#   5. VERIFIER LA LISIBILITE EN NOIR ET BLANC.
#      Beaucoup de documents administratifs sont imprimes en monochrome.
#      Test : convertissez le PNG en niveaux de gris. Distinguez-vous encore
#      les deux groupes ? Ici oui, les teintes ont des clartes differentes.
#
#   6. AUCUNE DONNEE NOMINATIVE OU SENSIBLE dans un graphique destine
#      a etre diffuse.
#
# ---- 4. Formats d'export ----------------------------------------------------
#
#   PNG  : pour un rapport, une presentation, un courriel. dpi = 200 minimum.
#   PDF  : pour l'impression - format vectoriel, aucune perte au zoom.
#   SVG  : pour le web ou pour retoucher ensuite le graphique.

ggsave("outputs/03_graphique_publiable.pdf", g, width = 22, height = 14, units = "cm")

cat("Graphiques enregistres en PNG et PDF dans outputs/\n")
