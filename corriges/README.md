# Corrigés des travaux pratiques

Corrigés commentés des quatre demi-journées. Chaque script est exécutable de bout en bout et a été vérifié sur les données réelles du dépôt : les valeurs annoncées en commentaire `#>` sont celles que R produit, pas des valeurs approchées.

> **Cherchez avant de regarder.** Un corrigé lu avant d'avoir essayé n'apprend rien. Les consignes du dossier `R/` portent toutes une ligne `# -> Réponse attendue :` qui vous permet de vous contrôler sans ouvrir ces fichiers.

## Contenu

| Fichier | Correspond à |
|---|---|
| `01_j1_matin_corrige.R` | Micro-TP 1 à 3 — calculs, types, vecteurs, conditions |
| `02_j1_apresmidi_corrige.R` | TP 1 et 2, puis la traduction du besoin métier |
| `03_j2_matin_corrige.R` | Les trois erreurs, micro-TP 4, réorganisation de script, TP 3 |
| `04_j2_apresmidi_corrige.R` | Étapes A à E — la base SQLite avec `dbplyr` |

## Comment les exécuter

Depuis la **racine du projet** (ouvrez `formation-r-justice.Rproj` d'abord), pas depuis ce dossier :

```r
source("corriges/01_j1_matin_corrige.R")
```

Les chemins vers `data/`, `utils/` et `outputs/` sont relatifs à la racine. Lancer le script depuis le dossier `corriges/` échouerait.

## Les trois pièges de la formation

Ces corrigés valent surtout pour trois moments où **R produit un résultat faux sans afficher le moindre message d'erreur**. Si vous ne relisez que trois passages, relisez ceux-là.

**1. `is.na()` sur une colonne codée en chaîne vide** — script 02.
`filter(is.na(email))` renvoie 0 ligne. Aucune erreur. On en conclut que l'annuaire est complet, alors que 788 courriels manquent sur 1 470. Le diagnostic tient en une ligne : `count(email == "")`.

**2. La division entière de SQLite** — script 04, étape C.
`sum(email != "") / n()` sur une table distante renvoie **0**, pas 0,46. Le SQL produit est `SUM(...) / COUNT(*)`, et SQLite divise deux entiers en entier. `show_query()` le montre immédiatement — c'est la meilleure raison de savoir lire le SQL généré. Le corrigé donne trois écritures correctes ; `mean(email != "")` est la plus lisible.

**3. L'exclusion silencieuse d'une jointure** — script 04, étape D.
1 470 lignes avant l'`inner_join`, 1 436 après. Aucun avertissement. D'où la règle : compter les lignes avant et après chaque jointure, systématiquement.

Le point commun, et sans doute ce qu'il faut retenir de ces deux jours :

> Une erreur qui s'affiche est bénigne : vous la corrigez.
> Une erreur silencieuse finit dans une note de synthèse.
