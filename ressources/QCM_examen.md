# Examen QCM — Formation R

**Durée : 20 minutes · 20 questions · Sans documentation ni ordinateur**

Une seule réponse est correcte par question. Entourez la lettre choisie.
Une réponse fausse ne retire pas de point : répondez à tout.

Nom : ............................................  Date : ....................

---

## Partie 1 — Bases du langage (questions 1 à 7)

**1.** Quel opérateur affecte une valeur à un objet en R ?

- A. `==`
- B. `<-`
- C. `=>`
- D. `::`

**2.** Que renvoie `class("44")` ?

- A. `"numeric"`
- B. `"integer"`
- C. `"character"`
- D. `"logical"`

**3.** Le vecteur `v <- c(120, 95, NA, 130)`. Que renvoie `sum(v)` ?

- A. `345`
- B. `NA`
- C. `0`
- D. Un message d'erreur

**4.** Comment corriger le calcul de la question 3 pour obtenir 345 ?

- A. `sum(v, ignore = TRUE)`
- B. `sum(v, na = FALSE)`
- C. `sum(v, na.rm = TRUE)`
- D. `sum(na.omit = v)`

**5.** Soit `ref <- c("TJ44", NA, "", "CA49")`. Combien d'éléments `is.na(ref)` détecte-t-il ?

- A. 0
- B. 1
- C. 2
- D. 4

**6.** Soit `x <- c(80, 110, 140, 95)`. Que renvoie `x[x > 100]` ?

- A. `TRUE FALSE TRUE FALSE`
- B. `110 140`
- C. `2 3`
- D. `140`

**7.** Vous tapez une instruction et la console affiche `+` au lieu de `>`. Que s'est-il passé ?

- A. R a détecté une erreur de syntaxe
- B. R attend la suite d'une instruction incomplète
- C. R est en train de calculer
- D. R a besoin d'une mise à jour

---

## Partie 2 — Manipulation avec dplyr (questions 8 à 13)

**8.** Quelle est la différence entre `install.packages()` et `library()` ?

- A. Aucune, ce sont deux écritures du même besoin
- B. `install.packages()` une fois par poste, `library()` à chaque session
- C. `library()` une fois par poste, `install.packages()` à chaque session
- D. `install.packages()` sert aux packages, `library()` aux fichiers

**9.** Quelle fonction dplyr sélectionne des **lignes** selon une condition ?

- A. `select()`
- B. `filter()`
- C. `arrange()`
- D. `mutate()`

**10.** Quelle fonction dplyr crée ou modifie une **colonne** ?

- A. `summarise()`
- B. `rename()`
- C. `mutate()`
- D. `count()`

**11.** À quoi sert le pipe `|>` ?

- A. À additionner deux tableaux
- B. À enchaîner des opérations dans l'ordre de lecture
- C. À commenter une ligne de code
- D. À comparer deux valeurs

**12.** Dans un fichier, les courriels absents sont stockés en chaîne vide `""`.
Que renvoie `filter(structures, is.na(email))` ?

- A. Toutes les structures sans courriel
- B. 0 ligne
- C. Un message d'erreur
- D. Toutes les structures

**13.** Quelle paire de fonctions produit un comptage par catégorie ?

- A. `select()` + `arrange()`
- B. `mutate()` + `rename()`
- C. `group_by()` + `summarise()`
- D. `filter()` + `head()`

---

## Partie 3 — Import, scripts et fonctions (questions 14 à 17)

**14.** Un fichier CSV français utilise le point-virgule comme séparateur.
Quelle fonction faut-il utiliser ?

- A. `read.csv()`
- B. `read.csv2()`
- C. `read.table()`
- D. `read.delim()`

**15.** Vous importez un fichier avec la mauvaise fonction de lecture. Que se passe-t-il ?

- A. R affiche un message d'erreur explicite
- B. R refuse d'ouvrir le fichier
- C. R importe un tableau à une seule colonne, sans avertissement
- D. R corrige automatiquement le séparateur

**16.** Un code postal `01000` s'affiche `1000` après import. Comment l'éviter ?

- A. En ajoutant `round = FALSE`
- B. En forçant le type avec `colClasses = "character"`
- C. En renommant la colonne
- D. C'est impossible à éviter

**17.** À quoi sert `stopifnot()` dans une fonction ?

- A. À arrêter le script à la fin du traitement
- B. À interrompre la fonction si une condition d'entrée n'est pas vérifiée
- C. À ignorer les valeurs manquantes
- D. À mettre le script en pause

---

## Partie 4 — Bases de données (questions 18 à 20)

**18.** Dans la chaîne `tbl(con, "structures") |> filter(...)`, à quel moment
la requête est-elle réellement exécutée sur la base ?

- A. Dès l'appel à `tbl()`
- B. Dès l'appel à `filter()`
- C. Seulement à l'appel de `collect()`
- D. À la fermeture de la connexion

**19.** `inner_join(structures, departements)` renvoie 1 436 lignes alors que
`structures` en compte 1 470. Que s'est-il passé ?

- A. Les 34 lignes en trop ont été fusionnées
- B. 34 lignes n'ont pas de correspondance dans le référentiel et ont été exclues
- C. La jointure a échoué
- D. 34 lignes étaient des doublons

**20.** Quel est le bon ordre des opérations sur une table distante ?

- A. `collect()` d'abord, puis filtrer et agréger en local
- B. Filtrer et agréger sur la base, puis `collect()`
- C. L'ordre n'a aucune importance
- D. Il ne faut jamais utiliser `collect()`

---

**Fin de l'épreuve.** Rendez votre feuille au formateur.
