# =============================================================================
# FORMATION R - JOUR 2, APRES-MIDI
# Interroger une base et restituer ses resultats
# -----------------------------------------------------------------------------
# Deroule de l'apres-midi :
#   1. Examen QCM                              30 min  (a faire en premier)
#   2. Base de donnees avec dbplyr, etapes A-C 55 min
#      PAUSE                                   15 min
#   3. Base de donnees avec dbplyr, etapes D-E 40 min
#   4. Demonstration ggplot2                   18 min  (vous observez)
#   5. Demonstration Quarto                    12 min  (vous observez)
#   6. Bilan                                   10 min
# =============================================================================


# =============================================================================
# 1. EXAMEN QCM                                                 (30 minutes)
# =============================================================================
# Le sujet est dans ressources/QCM_examen.pdf (ou .docx).
# 20 questions, 20 minutes, sans documentation ni ordinateur.
# La correction commentee suit immediatement la passation.
#
# Reprenez ce script apres la correction.


library(dplyr)
library(dbplyr)
source("utils/panneau_connexion.R")


# =============================================================================
# ETAPE A - Connexion et prise en main                          (15 minutes)
# =============================================================================

# A.1 Verifiez que vous etes bien a la racine du projet.


# A.2 Ouvrez la connexion avec ouvrir_connexion_formation().
#     Stockez-la dans un objet nomme con.


# A.3 Regardez le panneau Connections de RStudio (en haut a droite).
#     Depliez la base, puis une table. Cliquez sur l'icone de tableau a droite
#     du nom d'une table : vous previsualisez son contenu sans ecrire une
#     seule ligne de SQL.


# A.4 Creez les trois objets distants avec tbl() : structures,
#     types_structure et departements.


# A.5 Affichez l'objet structures. Regardez la premiere ligne de la sortie :
#     que signifie "?? rows" ?


# =============================================================================
# ETAPE B - Requetes simples et evaluation differee             (20 minutes)
# =============================================================================

# B.1 Sur la table distante structures, ecrivez une chaine qui filtre les
#     tribunaux judiciaires (type_code == "TGI"), conserve le nom, la ville
#     et le departement, et trie par departement.
#     Les fonctions dplyr d'hier s'appliquent a l'identique.


# B.2 Verifiez la classe de l'objet obtenu avec class().
#     Est-ce un data.frame ?


# B.3 Ajoutez show_query() a la fin de votre chaine. Lisez le SQL produit.
#     Reperez les mots-cles SELECT, FROM, WHERE et ORDER BY.


# B.4 Ajoutez collect() a la place de show_query(), et stockez le resultat
#     dans un objet tgi. Combien de lignes ?


# B.5 Comparez glimpse(structures) et str(structures).
#     Lequel est utilisable sur une table distante ?


# -> Reponses attendues : B.2 -> tbl_lazy, pas data.frame | B.4 -> 168 lignes


# =============================================================================
# ETAPE C - Agregations metier                                  (20 minutes)
# =============================================================================
# Regle a respecter dans les quatre questions : agreger PUIS collecter.
# Jamais l'inverse.

# C.1 Nombre de structures par type, tri decroissant.


# C.2 Nombre de structures par departement, tri decroissant.


# C.3 Taux de structures disposant d'un courriel.
#     Rappel du Jour 1 : l'absence est codee par une chaine vide.
#
#     ATTENTION, deuxieme piege, propre aux bases de donnees : ecrire
#     sum(email != "") / n() renvoie 0, et non 0.46. SQLite fait une
#     division ENTIERE. Utilisez show_query() pour voir pourquoi, puis
#     trouvez une ecriture qui donne le bon resultat.


# C.4 Les dix departements les mieux dotes.
#     Utilisez head(10) plutot que slice_max() : la traduction SQL de
#     slice_max() depend de la version de dbplyr installee.


# -> Reponses attendues :
#    C.1 -> TBRTJ 272, CPH 216, TGI 168, TE 156, TPRX 125, TCO 122, CDAD 105,
#           CASS 104, CCD 102, TA 41, CA 37, TAE 12, CAA 9, CAS 1 (total 1470)
#    C.3 -> 682 structures sur 1470, soit 46 %
#    C.4 -> le departement 59 (Nord) arrive en tete avec 46 structures


# ======================= PAUSE - 15 minutes ==================================


# =============================================================================
# ETAPE D - Jointures et qualite des referentiels               (25 minutes)
# =============================================================================

# D.1 Enrichissez structures avec le libelle de type (types_structure) et les
#     informations de departement (departements), par deux inner_join
#     successifs. Conservez le nom, le libelle de type, le departement
#     et la region.


# D.2 CONTROLE INDISPENSABLE : comptez les lignes avant et apres la jointure
#     avec departements seule. Le compte est-il identique ?


# D.3 Combien de structures ont ete perdues ? Utilisez anti_join() pour les
#     isoler, puis distinct() pour identifier les codes departement concernes.


# D.4 Faites le meme diagnostic sur types_structure. Quel code de type
#     n'existe pas dans le referentiel ? Combien de structures sont concernees ?


# D.5 Question d'interpretation, sans code. Classez vos deux constats :
#       - anomalie technique, a corriger dans la source ?
#       - absence attendue, a documenter ?
#       - regle metier ambigue, a faire trancher par la hierarchie ?


# -> Reponses attendues :
#    D.2 -> 1470 avant, 1436 apres | D.3 -> 34 perdues, codes 975, 978, 986, 987, 988
#    D.4 -> code TAE, 12 structures


# =============================================================================
# ETAPE E - Mini-cas de synthese                                (15 minutes)
# =============================================================================
# Demande de votre hierarchie :
#
#   "Produire un tableau regional indiquant, pour chaque region, le nombre
#    total de structures, le nombre de types distincts et le taux de courriels
#    renseignes. Ne garder que les regions comptant plus de 50 structures."

# E.1 Ecrivez la chaine complete et stockez le resultat dans tableau_regional.
#     n_distinct() compte les valeurs distinctes.
#     Le taux de courriels retombe sur le piege de la division entiere vu
#     en C.3 : appliquez la meme correction.


# E.2 Exportez le resultat dans outputs/tableau_regional.csv.


# E.3 Fermez la connexion avec fermer_connexion_formation(con).
#     Un script bien forme se termine toujours par la fermeture de connexion.


# -> Reponse attendue : 12 regions retenues sur 18. Auvergne-Rhone-Alpes en
#    tete avec 176 structures et 13 types distincts. Les taux de courriels
#    s'echelonnent de 42 % a 55 % : si vous lisez 0 partout, relisez C.3.


# =============================================================================
# 4 et 5. DEMONSTRATIONS - vous observez, vous ne reproduisez pas
# =============================================================================
# ggplot2 : demos/ggplot2/01_grammaire_des_graphiques.R
# Quarto  : demos/quarto/demo_pas_a_pas.qmd
#
# Les deux dossiers restent a votre disposition apres la formation.


# =============================================================================
# 6. BILAN
# =============================================================================
# Nommez un traitement de votre poste que vous pourriez reprendre en R
# des la semaine prochaine.
# =============================================================================
