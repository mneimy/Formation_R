# =============================================================================
# FORMATION R - JOUR 1, APRES-MIDI
# Manipuler des donnees avec dplyr
# -----------------------------------------------------------------------------
# Prerequis : avoir execute R/00_preparer_donnees.R une fois (ou disposer du
# fichier data/structures.csv fourni).
# =============================================================================

library(dplyr)


# =============================================================================
# TP 1 - Tableau de suivi de juridictions fictives              (15 minutes)
# =============================================================================
# Le tableau ci-dessous est volontairement imparfait : la colonne email
# contient une chaine vide "" ET un NA. Les deux formes d'absence coexistent,
# exactement comme dans les fichiers reels.

juridictions <- data.frame(
  nom   = c("TJ Nantes", "TJ Rennes", "CA Angers", "CPH Nantes", "TJ Brest", "TCO Rennes"),
  dept  = c("44", "35", "49", "44", "29", "35"),
  recus = c(980, 740, 310, 220, 560, 190),
  clos  = c(870, 700, 290, 200, 510, 175),
  email = c("tj.nantes@justice.fr", "", "ca.angers@justice.fr", NA,
            "tj.brest@justice.fr", ""),
  stringsAsFactors = FALSE
)

# 1.1 Examinez la structure du tableau. Combien de lignes ? De colonnes ?
#     De quel type est chaque colonne ?


# 1.2 Ajoutez une colonne taux_traitement = clos / recus, arrondie a 2 decimales.
#     Utilisez l'operateur $.


# 1.3 Reperez les lignes sans adresse electronique exploitable.
#     Attention : il y a DEUX formes d'absence a detecter.


# 1.4 Affichez la ligne correspondant au TJ Nantes.


# 1.5 En commentaire, une phrase en langage metier sur le taux de traitement
#     de l'ensemble des juridictions.


# -> Reponses attendues : 1.1 -> 6 lignes, 5 colonnes | 1.3 -> 3 lignes


# =============================================================================
# TP 2 - Preparer une synthese territoriale                     (25 minutes)
# =============================================================================
# L'import sera detaille demain matin. Pour aujourd'hui, executez simplement
# la ligne ci-dessous.

structures <- read.csv2("data/structures.csv", fileEncoding = "UTF-8")

# Verification rapide : 1470 lignes, 13 colonnes.
dim(structures)

# ---- SOCLE OBLIGATOIRE - questions 1 a 5 ------------------------------------

# 2.1 Conservez uniquement les colonnes utiles a un annuaire :
#     nom d'etablissement, type, ville, telephone, courriel.


# 2.2 Filtrez les structures du departement 44.


# 2.3 Triez le resultat par ville, puis par nom d'etablissement.


# 2.4 Creez deux colonnes logiques : a_telephone et a_email, indiquant si la
#     coordonnee est reellement disponible.
#     ATTENTION : avant d'ecrire votre condition, posez-vous la question
#     "comment l'absence est-elle codee dans ce fichier ?" et verifiez-le.


# 2.5 Comptez les structures par type (sur le fichier complet, pas seulement
#     le departement 44).


# 2.6 Assemblez 2.1 a 2.3 en UNE SEULE chaine avec le pipe |>, et stockez le
#     resultat dans un objet nomme annuaire_44. Combien de lignes ?


# ---- BONUS - pour ceux qui ont termine --------------------------------------

# 2.7 Calculez, par type de structure, la part de structures disposant a la
#     fois d'un telephone et d'un courriel. Triez par effectif decroissant.


# 2.8 Reformulez oralement la chaine de la question 2.6 :
#     "Partir de..., puis..., puis..."


# -> Reponses attendues : 2.5 -> TBRTJ 272, CPH 216, TGI 168, TE 156, TPRX 125,
#    TCO 122, CDAD 105, CASS 104, CCD 102, TA 41, CA 37, TAE 12, CAA 9, CAS 1
#    2.6 -> 15 structures dans le departement 44


# =============================================================================
# SEQUENCE 7 - Traduire un besoin metier                        (20 minutes)
# =============================================================================
# Votre chef de service vous ecrit :
#
#   "Produire la liste des tribunaux judiciaires des Pays de la Loire, avec
#    leurs coordonnees utiles, en signalant ceux dont le courriel manque,
#    classee par commune."
#
# Les cinq departements de la region : 44, 49, 53, 72, 85.
#
# 7.1 Decomposez ce besoin en etapes, en francais, avant d'ecrire du code.
#     Une etape par ligne, en commentaire.


# 7.2 Traduisez chaque etape en une fonction dplyr, puis assemblez la chaine.
#     Le code du type "tribunal judiciaire" est "TGI".
#     Pour filtrer sur plusieurs departements, l'operateur %in% est plus lisible
#     qu'une suite de | : code_departement %in% c("44", "49", ...)


# -> Reponse attendue : 8 tribunaux judiciaires, aucun sans courriel
#    (le controle renvoie 0 ligne : une absence de probleme est aussi un
#     resultat, a condition de l'avoir verifiee)


# =============================================================================
# FIN DE LA JOURNEE 1
# =============================================================================
