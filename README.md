# Banc de calage parapente

Pour vérifier le calage de sa voile, il faut mesurer chaque suspente sous la même tension.
Ici, deux pièces imprimées en 3D font le travail avec un télémètre laser et une poche à eau
de 5 L : un **banc** qui se pose sur le bord d'une table et tend la suspente à 5 kg, et un
**support de laser** qui coince la patte de la suspente côté voile. Quincaillerie : 27 €.

| Le banc, suspente tendue | Plié : 164 × 93 × 52 mm | Le support du laser et son encoche |
|---|---|---|
| ![banc ouvert](apercu/banc_ouvert_avant.png) | ![banc plié](apercu/banc_plie.png) | ![support laser](apercu/support_laser_encoche.png) |

## Comment ça marche

- Le banc s'accroche au bord de la table. Les deux **élévateurs** se posent à plat dessus,
  chacun sur une bobine ; on passe simplement la boucle du maillon par-dessus.
- Un chariot à roulettes relie les élévateurs, par une cordelette et une poulie, à la **poche
  à eau** qui pend sous la table. Tant que le chariot flotte entre ses butées, la suspente est
  tendue à exactement 5 kg.
- Devant les élévateurs, une **cible blanche** se relève et se verrouille d'équerre.
- Côté voile, on glisse la suspente dans l'**encoche du support**, la patte vient en butée,
  et le laser couché dans le support vise la cible. **Longueur de la suspente = lecture +
  constante**, la constante se mesure une fois au mètre ruban.
- Pour voyager : cible rabattue, un velcro autour.

## Fichiers à imprimer

Huit fichiers, un par pièce, déjà orientés pour l'impression, sans support.

| Fichier | Pièce |
|---|---|
| `socle.stl` | le socle qui s'accroche à la table ([image](apercu/socle.png)) |
| `coulisseau.stl` | le chariot qui porte les élévateurs et la cible ([image](apercu/coulisseau.png)) |
| `cible.stl` | la cible, à imprimer en blanc ([image](apercu/cible.png)) |
| `poulie.stl` | la poulie de la cordelette ([image](apercu/poulie.png)) |
| `bobine_tete.stl`, `bobine_ecrou.stl` | les deux bobines des élévateurs ([image](apercu/bobine_tete.png)) |
| `entretoises_grappe.stl` | 8 petites entretoises sur une barrette, à détacher au cutter ([image](apercu/entretoises_grappe.png)) |
| `support_laser.stl` | le support du laser ([image](apercu/support_laser.png), [l'encoche](apercu/support_laser_encoche.png)) |

**Le support est à la taille de votre laser.** Mesurez-le (largeur, longueur, épaisseur),
reportez les trois cotes dans `scad/support_laser.scad` et regénérez le STL. S'il a des
boutons sur le côté, `btn_cote` ouvre la paroi en face. Le support est un peu moins haut
que le laser, pour le saisir facilement.

## Quelle matière

**PETG**, 4 périmètres, 25 % de remplissage, cible en blanc mat. Pas de PLA : il se déforme
dans une voiture au soleil.

Si vous faites imprimer chez [JLC3DP](https://jlc3dp.com/3d-printing-quote) : socle et cible
en **résine SLA 9000HE** blanche, tout le reste en **nylon SLS 3201PA-F**. Comptez ≈ 30 $ de
pièces et ≈ 10 $ de port. Les pièces qui serrent des goupilles ou tirent sur une suspente
(chariot, support du laser) ne doivent pas être en résine.

## Ce qu'il faut acheter

Tout sur AliExpress, chez des vendeurs notés. Prix lus le 5 octobre 2026 ; vérifiez la
variante cochée avant de payer.

| Pièce | Variante à cocher | Il en faut | Prix | Lien |
|---|---|---|---|---|
| Roues V noires Ø 24, roulements montés | « 10PC BigBlack Wheel » | 5 sur 10 | 6,69 € | [annonce](https://fr.aliexpress.com/item/1005003090749056.html) |
| Vis M5 × 25 tête bombée | « 10Pcs M5x25 » | 4 sur 10 | 4,29 € | [annonce](https://fr.aliexpress.com/item/32850409234.html) |
| Écrous frein M5 (bague nylon) | « M5 X 50pcs » | 5 sur 50 | 3,39 € | [annonce](https://fr.aliexpress.com/item/1005002375633274.html) |
| Vis M5 × 80 tête cylindrique | « M5 10 pièces », puis « 80 mm » | 1 sur 10 | 5,09 € | [annonce](https://fr.aliexpress.com/item/32968483467.html) |
| Goupille Ø 5 × 40 (axe de la poulie) | « M5 10pcs », puis « 40mm » | 1 sur 10 | ≈ 1,50 € | [annonce](https://fr.aliexpress.com/item/1005004143852668.html) |
| Goupilles Ø 3 × 12 (charnière de la cible) | « M3 25pcs », puis « 12mm » | 2 sur 25 | ≈ 1,50 € | [même annonce](https://fr.aliexpress.com/item/1005004143852668.html) |
| Cordelette 2 mm | « 10 meters » | 1,5 m | 1,62 € | [annonce](https://fr.aliexpress.com/item/1005011930498059.html) |

**≈ 27 € port compris.** Le roulement de la poulie se récupère sur la cinquième roue, le lest
est votre poche à eau, et il n'y a ni colle ni frein-filet. Le laser n'est pas compté : un
télémètre Bluetooth de 30 m (HOTO QWCJY001 ou équivalent) vaut 30 à 40 €.

## Montage

Le schéma complet, avec la visserie : [schema_montage.png](apercu/schema_montage.png).

1. **Poulie** : sortez un roulement d'une roue en trop, emmanchez-le dans la poulie. Posez la
   poulie dans sa fente avec une entretoise de chaque côté et enfoncez la goupille Ø 5 à
   travers les deux crochets, jusqu'à ce qu'elle soit en retrait des flancs.
2. **Roues** : un écrou frein dans chacun des 4 logements du chariot, puis pour chaque roue
   une vis M5 × 25 par le dessous, à travers la roue et une entretoise.
3. **Jeu** : serrez le côté fixe, poussez les deux autres roues au fond de leur rainure (trous
   oblongs), serrez. Le chariot doit rouler tout seul quand on incline le socle.
4. **Bobines** : sur la vis M5 × 80, une bobine, la nervure du chariot, l'autre bobine, l'écrou
   frein dans le chapeau. On n'y touche plus.
5. **Cible** : entre les oreilles du chariot, une goupille Ø 3 de chaque côté, enfoncée à ras.
6. **Cordelette** : nœud en huit dans le puits derrière la cible ; le brin file dans le canal
   du socle, passe sur la poulie et se noue à la poignée de la poche. Pesez la poche pleine à
   **5,00 kg**.

Réglez la cordelette pour que la poche touche le sol quand la suspente est molle, et décolle
dès qu'on tire.

## Régler l'offset dans l'outil de calage

Le laser réglé pour mesurer **depuis sa face avant**, la lecture est la distance entre le
laser et la cible. Sur le banc, le centre de la boucle d'élévateur (l'axe de la bobine) est
21 mm derrière la cible, et la boucle de la suspente bute 8,5 mm derrière la face avant du
laser. Donc :

**longueur de la suspente, élévateur compris = lecture + 30 mm + boucle d'attache**

La « boucle d'attache », c'est la partie de la suspente qui dépasse du bec, jusqu'au bout de
la boucle : 10 à 20 mm selon la voile, à mesurer une fois au réglet. Offset à saisir dans
l'outil, typiquement **40 à 50 mm**.

- Les constructeurs donnent le plus souvent les longueurs élévateur compris, du centre de la
  boucle de mousqueton à la patte d'attache sur la voile, sous 5 kg : c'est ce que mesure le
  banc, la bobine jouant le rôle du mousqueton. Si vos valeurs de référence sont données sans
  élévateurs (depuis les maillons), retirez la longueur de l'élévateur, indiquée dessus.
  Vérifiez la convention dans la fiche de contrôle de votre voile.
- Pour contrôler l'offset : mesurez une suspente au mètre ruban acier selon la méthode du
  constructeur, et comparez à la lecture du laser au même moment.
- Si le laser mesure depuis sa face arrière, retirez la longueur du laser de l'offset.

## Pour aller plus loin

- [NOTES.md](https://github.com/alexandre-pereira/trimming-tools/blob/main/NOTES.md) : les
  choix de conception, les cotes, les prix relevés, les variantes écartées et ce qui a été
  vérifié.
- Les modèles OpenSCAD sont dans `scad/`, les scripts qui regénèrent STL, images et ce site
  dans `outils/`. Dépôt : <https://github.com/alexandre-pereira/trimming-tools>.
- Rien n'a encore été imprimé ni essayé sous charge : c'est un modèle, pas un produit testé.
