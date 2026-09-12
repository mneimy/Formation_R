# =============================================================================
# FORMATION R - JOUR 1, MATINEE
# Decouvrir R et RStudio
# -----------------------------------------------------------------------------
# Ce fichier contient les CONSIGNES. Vous ecrivez vos reponses directement
# en dessous de chaque consigne.
# Le corrige se trouve dans le projet TP_Corriges (ne l'ouvrez pas maintenant).
#
# Pour executer une ligne : placez le curseur dessus, puis Ctrl + Entree.
# =============================================================================


# =============================================================================
# MICRO-TP 1 - Premiere fiche de cadrage                        (8 minutes)
# =============================================================================
# Contexte : vous preparez une note de cadrage sur l'activite d'une juridiction.

# 1.1 Ce fichier est deja votre script. Verifiez qu'il est bien enregistre.
#     Verifiez ou vous vous trouvez :
getwd()

# 1.2 Declarez deux objets : 1250 dossiers recus, 975 dossiers clos.
#     Utilisez l'operateur <- et des noms explicites.


# 1.3 Calculez le taux de cloture en pourcentage, arrondi a une decimale.
#     Affichez-le.


# 1.4 Provoquez volontairement une faute de frappe sur un nom d'objet
#     (par exemple en oubliant le "s" final). Lisez le message d'erreur
#     et reformulez-le avec vos propres mots dans un commentaire.


# -> Reponse attendue pour 1.3 : 78


# =============================================================================
# MICRO-TP 2 - Indicateurs d'activite                          (12 minutes)
# =============================================================================
# Contexte : volumes mensuels de dossiers sur 6 mois. Le NA du mois 4 est une
# donnee reellement manquante : le service n'a pas transmis son chiffre.

entrants <- c(120, 95, 110, NA, 130, 105)
sortants <- c(100, 90, 115, 80, 125, 100)

# 2.1 Calculez le total des entrants. Que se passe-t-il ? Pourquoi ?


# 2.2 Corrigez le calcul precedent avec l'argument na.rm = TRUE.
#     Faites de meme pour le total des sortants et la moyenne mensuelle
#     des entrants.


# 2.3 Calculez le solde (total entrants - total sortants).
#     Commentez le resultat en langage metier : le stock augmente-t-il ?


# 2.4 Calculez le taux de traitement (sortants / entrants * 100),
#     arrondi a une decimale.


# 2.5 Le point cle de la matinee. Executez les deux lignes ci-dessous
#     et expliquez en commentaire pourquoi les resultats different.
ref <- c("TJ44", NA, "", "CA49")
is.na(ref)
ref == ""


# -> Reponses attendues : 2.2 -> 560, 610, 112 | 2.3 -> -50 | 2.4 -> 108.9


# =============================================================================
# MICRO-TP 3 - Reperer les mois sous tension                   (15 minutes)
# =============================================================================

recus   <- c(120, 95, 110, 140, 130, 105)
traites <- c(100, 90, 115,  80, 125, 100)

# 3.1 Avant tout calcul : verifiez que les deux vecteurs ont la meme longueur.
#     Le resultat doit etre TRUE.


# 3.2 Calculez le solde mensuel (recus - traites). Observez : R fait le calcul
#     mois par mois, sans boucle.


# 3.3 Selectionnez les mois ou les entrees depassent les sorties,
#     avec une indexation par condition.


# 3.4 Declarez seuil <- 30. Selectionnez les mois dont le solde depasse ce
#     seuil, puis comptez-les avec length().


# 3.5 Redigez en commentaire une phrase en langage metier decrivant
#     ce que vous venez de mesurer.


# -> Reponses attendues : 3.2 -> 20 5 -5 60 5 5 | 3.4 -> 1 mois (solde de 60)


# =============================================================================
# FIN DE LA MATINEE
# Cet apres-midi : les memes raisonnements, mais sur un vrai fichier de
# 1 470 structures judiciaires.
# =============================================================================
