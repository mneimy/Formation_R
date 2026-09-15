# Formation R — Ministère de la Justice

Support de la formation R de deux jours : consignes des travaux pratiques, jeu de données, démonstrations et ressources.

**Ce dépôt est le vôtre pendant la formation.** Vous écrivez vos réponses directement dans les scripts du dossier `R/`, et vous le gardez après.

---

## Démarrage — 3 minutes, à faire le matin du Jour 1

### 1. Récupérer le dépôt

Si Git est installé sur votre poste :

```bash
git clone <URL-DU-DÉPÔT>
```

Sinon, téléchargez l'archive ZIP depuis la page du dépôt et décompressez-la. **Décompressez-la vraiment** : ne travaillez pas à l'intérieur de l'archive, Windows le permet mais rien ne sera enregistré.

### 2. Ouvrir le projet

Double-cliquez sur **`formation-r-justice.Rproj`**.

Pas sur un script, pas sur le dossier : sur le fichier `.Rproj`. C'est lui qui place R au bon endroit et rend tous les chemins du dépôt valides. C'est la première cause d'erreur chez les débutants, et elle est évitable en un clic.

### 3. Vérifier que le poste est prêt

Dans la console R, tapez :

```r
source("R/00_verifier_installation.R")
```

Ce test dure 30 secondes. Il contrôle la version de R, les six packages nécessaires, la présence des données et le répertoire de travail. **S'il signale quelque chose, réglez-le avant de commencer** — signalez-le au formateur plutôt que d'attendre.

Résultat attendu :

```
Version de R : R version 4.5.x
  OK - le pipe natif |> est disponible.
Packages : tous presents.
  OK - vous etes bien a la racine du projet.
Donnees : les 4 fichiers sont presents.
```

---

## Ce que contient chaque fichier

### `R/` — les consignes, une par demi-journée

C'est ici que vous travaillez. Chaque script contient les énoncés sous forme de commentaires ; vous écrivez votre code directement en dessous de chaque question.

| Fichier | Quand | Contenu |
|---|---|---|
| `00_verifier_installation.R` | Avant tout | Test de 30 s du poste de travail. À lancer en premier. |
| `01_j1_matin.R` | Jour 1, matin | Micro-TP 1 à 3 — calculs, variables, types de données, vecteurs, conditions |
| `02_j1_apresmidi.R` | Jour 1, après-midi | TP 1 et 2 — data frames, puis `dplyr` sur le fichier réel |
| `03_j2_matin.R` | Jour 2, matin | Trois erreurs à corriger, micro-TP 4, réorganisation d'un script, TP 3 sur les fonctions |
| `04_j2_apresmidi.R` | Jour 2, après-midi | Étapes A à E — interroger la base SQLite avec `dbplyr`. L'après-midi s'ouvre par l'examen. |
| `99_regenerer_donnees.R` | Normalement jamais | Reconstruit `data/` à partir de `data/sources/`. Utile seulement si vous abîmez un fichier de données. Ne nécessite aucun accès internet. |

Les corrigés de ces quatre scripts se trouvent dans le dossier `corriges/`.

Chaque bloc de consignes se termine par une ligne de ce type :

```r
# -> Reponse attendue : 15 structures dans le departement 44
```

Elle sert à **vérifier votre résultat après avoir cherché**, pas à remplacer la recherche.

### `data/` — le jeu de données

**Dossier en lecture seule.** Aucun script ne doit jamais y écrire. C'est la règle la plus importante d'un projet de traitement de données : les sources restent intactes, quoi qu'il arrive.

| Fichier | Contenu |
|---|---|
| `structures.csv` | 1 470 structures judiciaires × 13 colonnes — le fichier principal du Jour 1 et du Jour 2 matin |
| `departements.csv` | 101 départements avec leur région |
| `types_structure.csv` | 13 libellés de types de structure |
| `formation.sqlite` | Les trois tables ci-dessus réunies dans une base de données — utilisée le Jour 2 après-midi |
| `sources/` | Les fichiers d'origine téléchargés depuis data.gouv.fr, conservés pour pouvoir tout reconstruire |

Les données sont **déjà construites et livrées avec le dépôt**. Vous n'avez rien à télécharger, rien à installer : aucun accès internet n'est nécessaire pendant la formation.

### `demos/` — les démonstrations du Jour 2 après-midi

Pendant la séance, **vous observez, vous ne reproduisez pas**. Ces dossiers restent à votre disposition ensuite, pour vous exercer à votre rythme.

| Fichier | Contenu |
|---|---|
| `ggplot2/01_grammaire_des_graphiques.R` | Un graphique construit couche par couche, du cadre vide au fichier PNG exporté |
| `ggplot2/02_choisir_la_bonne_forme.R` | Quatre questions métier, quatre formes : barres, histogramme, nuage de points, facettes |
| `ggplot2/03_finitions_institutionnelles.R` | Ce qui sépare un graphique correct d'un graphique diffusable : tri, titre, note de lecture, source, lisibilité en noir et blanc |
| `quarto/demo_pas_a_pas.qmd` | Un rapport Quarto qui explique Quarto en se servant de lui-même comme exemple |
| `quarto/rapport_modele.qmd` | Un squelette de note administrative à remplir : objet, périmètre, résultats, contrôles, limites |

Les scripts ggplot2 s'exécutent **bloc par bloc** (Ctrl+Entrée), pas d'un seul coup : l'intérêt est de voir le graphique se construire.

### `corriges/` — les corrigés des TP

Les corrigés commentés des quatre demi-journées, exécutables de bout en bout. Chaque valeur annoncée en commentaire a été vérifiée sur les données du dépôt.

Ils se lancent depuis la racine du projet : `source("corriges/01_j1_matin_corrige.R")`.

Le dossier a son propre [README](corriges/README.md), qui revient sur les trois moments où R produit un résultat faux sans afficher d'erreur. **Cherchez avant de les ouvrir** : les lignes `# -> Réponse attendue :` des consignes suffisent à vous contrôler.

### `ressources/`

| Fichier | Contenu |
|---|---|
| `script_modele.R` | Le modèle à reprendre pour vos propres traitements : en-tête normalisé et quatre sections — import, contrôle, transformation, export |
| `QCM_examen.md` · `.docx` · `.pdf` | Le sujet de l'examen du Jour 2 — 20 questions, 20 minutes. Le `.pdf` est prêt à imprimer. |

`script_modele.R` est le fichier le plus utile à emporter. C'est celui que vous copierez au bureau la semaine suivante.

Le corrigé de l'examen se trouve dans `corriges/`.

### `outputs/` — vos productions

Tous vos exports vont ici, **jamais dans `data/`**. Le contenu de ce dossier n'est pas suivi par git : tout ce qu'il contient peut être régénéré en relançant les scripts. C'est d'ailleurs le test d'un projet bien construit — pouvoir tout supprimer et tout retrouver.

### `utils/`

`panneau_connexion.R` fait apparaître la base SQLite dans le panneau **Connections** de RStudio, comme le font les connecteurs vers les bases de production. Vous n'avez pas à le modifier ni à le lire.

---

## Le jeu de données : les structures de la Justice

Référentiel SRJ publié sur data.gouv.fr sous Licence Ouverte. **1 470** tribunaux, cours et conseils, avec leur type, leur adresse, leur commune, leur département et leurs coordonnées. Aucune donnée nominative ni sensible.

Trois tables reliées entre elles :

```
structures (1 470 lignes)
  ├── type_code ────────────> types_structure (13 lignes)
  └── code_departement ────> departements (101 lignes)
```

Ce fichier n'a pas été nettoyé pour la formation. Il contient trois imperfections réelles, et c'est délibéré — ce sont elles qui donnent leur intérêt aux exercices de contrôle :

- **788 courriels sur 1 470** sont enregistrés comme du texte vide, et non comme une valeur manquante ;
- **12 structures** portent un code de type absent de la nomenclature officielle ;
- **34 structures** situées outre-mer n'ont pas de département, et disparaissent donc d'une jointure ordinaire.

Vous découvrirez chacune de ces trois situations à son moment. Elles ont toutes le même point commun, et c'est sans doute ce que vous retiendrez de plus utile pour votre poste : **R produit alors un résultat faux sans afficher le moindre message d'erreur.**

---

## Prérequis techniques

| Logiciel | Version | Remarque |
|---|---|---|
| R | **4.1 minimum** | Le pipe `\|>` enseigné le Jour 1 n'existe pas avant |
| RStudio Desktop | Récente | |
| Quarto | Récente | Uniquement pour la démonstration du Jour 2. **C'est un logiciel séparé, pas un package R.** |

Packages R nécessaires :

```r
install.packages(c("dplyr", "dbplyr", "DBI", "RSQLite", "readr", "ggplot2"))
```

`R/00_verifier_installation.R` contrôle tout cela pour vous.

---

## En cas de problème

| Symptôme | Cause probable | Solution |
|---|---|---|
| `could not find function "filter"` | Package non chargé | `library(dplyr)` en début de session |
| `object 'xxx' not found` | Faute de frappe, ou casse différente | R distingue les majuscules. Utilisez la touche **Tab** pour compléter les noms. |
| `cannot open file 'data/structures.csv'` | Projet non ouvert par le `.Rproj` | Fermez RStudio, rouvrez par `formation-r-justice.Rproj`. Vérifiez avec `getwd()`. |
| La console affiche `+` et ne répond plus | Parenthèse ou guillemet non fermé | Touche **Échap**, puis corrigez la ligne |
| Les accents s'affichent mal | Encodage | Ajoutez `fileEncoding = "UTF-8"` à votre `read.csv2()` |
| Un bouton **Render** absent | Quarto non installé | Voyez avec la DSI — cela ne bloque que la démonstration |

---

## Après la formation

Une demi-journée de retour d'expérience est prévue **quatre à six semaines** plus tard. D'ici là, repérez un traitement réel de votre poste et tentez de l'automatiser, même partiellement. Apportez-le : les blocages rencontrés en situation réelle sont le meilleur support de cette séance.

Ce dépôt reste accessible. Pour aller plus loin :

- [utilitR](https://book.utilitr.org) — documentation collaborative écrite par et pour les agents de l'État, la plus proche de vos usages
- [Introduction à R et au tidyverse](https://juba.github.io/tidyverse) — Julien Barnier, en français
- [R pour la science des données](https://r4ds.hadley.nz) — la référence, traduite en français

---

Licences des données et des supports : voir [LICENCE.md](LICENCE.md).
