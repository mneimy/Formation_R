# Corrigé commenté — Examen QCM

**Barème : 1 point par question, 20 points. Aucun point négatif.**

| Q | Réponse | Ce que la question vérifie | Commentaire de correction |
|---|---|---|---|
| 1 | **B** `<-` | Affectation | `=` fonctionne aussi mais la convention R réserve `=` aux arguments de fonctions. `==` compare, il n'affecte pas. |
| 2 | **C** `"character"` | Types | Les guillemets font le type. Un code département est du texte, pas un nombre — c'est ce qui préserve le `0` de `"01"`. |
| 3 | **B** `NA` | Propagation du `NA` | R refuse de deviner : si une valeur est inconnue, la somme est inconnue. Ce comportement est une protection, pas un défaut. |
| 4 | **C** `na.rm = TRUE` | Argument nommé | `na.rm` = *NA remove*. À n'utiliser qu'en sachant ce qu'on retire. |
| 5 | **B** 1 | `NA` ≠ `""` | Seul le `NA` est détecté. La chaîne vide `""` ne l'est pas — c'est le piège central de la formation. |
| 6 | **B** `110 140` | Indexation par condition | `x > 100` produit des `TRUE/FALSE` ; les crochets renvoient les **valeurs**, pas les positions. La réponse A est le résultat de la condition seule. |
| 7 | **B** instruction incomplète | Lecture de la console | Le `+` n'est pas une erreur : R attend une parenthèse fermante. Touche **Échap** pour sortir. |
| 8 | **B** | Packages | Installer = une fois par poste. Charger = à chaque session. `install.packages()` ne figure jamais dans un script partagé. |
| 9 | **B** `filter()` | Verbes de base | `filter` agit sur les **lignes** (hauteur), `select` sur les **colonnes** (largeur). |
| 10 | **C** `mutate()` | Verbes de base | `rename()` renomme sans calculer ; `summarise()` réduit plusieurs lignes à une. |
| 11 | **B** | Pipe | Le pipe change la lisibilité, pas le résultat. On lit de gauche à droite au lieu de l'intérieur vers l'extérieur. |
| 12 | **B** 0 ligne | **Question la plus importante** | Aucune erreur, aucun avertissement, un résultat faux. Un participant qui répond A doit refaire le diagnostic : `count(email == "")`. |
| 13 | **C** | Agrégation | `count()` est le raccourci de cette paire pour un simple dénombrement. |
| 14 | **B** `read.csv2()` | Import | Le `2` signale la convention française : séparateur `;`, décimale `,`. |
| 15 | **C** silencieusement | Contrôle après import | Aucun message. Seul `dim()` révèle le problème : 1 470 × 1 au lieu de 1 470 × 13. D'où la check-list systématique. |
| 16 | **B** `colClasses` | Typage à l'import | Et il faut le faire **dès la lecture** : le zéro perdu est irrécupérable après coup. |
| 17 | **B** | Robustesse | Mieux vaut une erreur franche qu'un résultat silencieusement faux — même logique qu'à la question 12. |
| 18 | **C** `collect()` | Évaluation différée | `tbl()` et `filter()` ne font que construire la requête. Rien ne circule tant que `collect()` n'est pas appelé. |
| 19 | **B** | Jointures | Exclusion silencieuse. D'où la règle : compter les lignes avant et après chaque jointure. |
| 20 | **B** | Réflexe de production | Ici 1 470 lignes, sans conséquence. Sur une base de production, l'ordre A rapatrie des millions de lignes sur le poste. |

---

## Lecture des résultats

| Score | Interprétation | Suite à donner |
|---|---|---|
| 16–20 | Objectifs atteints | Peut travailler en autonomie sur un script guidé |
| 12–15 | Acquis en cours | Revoir la fiche mémo ; refaire le TP 2 du Jour 1 |
| 8–11 | Fragile | Reprendre les séquences 3 et 6 du Jour 1 avant tout usage réel |
| < 8 | Non acquis | Proposer un accompagnement individuel avant la session de retour d'expérience |

## Questions à commenter en priorité à l'oral

Trois questions méritent un commentaire collectif, quelle que soit la réussite du groupe :

- **Q12** — le piège `is.na()` / `""`. C'est le fil rouge des deux jours.
- **Q15** et **Q19** — les deux cas où R produit un résultat faux **sans rien signaler**. Le point commun à faire ressortir : une erreur qui s'affiche est bénigne, une erreur silencieuse finit dans une note de synthèse.
- **Q20** — le seul réflexe de la formation qui protège autre chose que le participant lui-même : le serveur de production.
