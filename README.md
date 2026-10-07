# Banc de calage parapente

[English version](README.en.md)

Pour vérifier le calage de sa voile, il faut mesurer chaque suspente sous la même tension.
Ici, deux pièces imprimées en 3D font le travail avec un télémètre laser et une poche à eau
de 5 L : un **banc** qui se pose sur le bord d'une table et tend la suspente à 5 kg, et un
**support de laser** qui coince la patte de la suspente côté voile. Quincaillerie : 27 €.

| Le banc, suspente tendue | Plié : 164 × 93 × 52 mm | Le support du laser et son encoche |
|---|---|---|
| ![Le banc en service, vu du côté de la voile](apercu/banc_ouvert_avant.png) | ![Le banc plié pour le transport](apercu/banc_plie.png) | ![Le support du télémètre laser, avec l'encoche de la suspente sous l'avant](apercu/support_laser_encoche.png) |

## Comment ça marche

- Le banc s'accroche au bord de la table. Les deux **élévateurs** se posent à plat dessus,
  chacun sur une bobine ; on passe simplement la boucle du maillon par-dessus.
- Un chariot à roulettes relie les élévateurs, par une cordelette et une poulie, à la **poche
  à eau** qui pend sous la table. Tant que le chariot flotte entre ses butées, la suspente est
  tendue à exactement 5 kg.
- Devant les élévateurs, une **cible blanche** se relève et se verrouille d'équerre.
- Côté voile, on glisse la suspente dans l'**encoche du support**, la patte vient en butée,
  et le laser couché dans le support vise la cible. L'outil de calage en ligne fait le reste,
  avec l'offset indiqué plus bas.
- Pour voyager : cible rabattue, un velcro autour.

## Fichiers à imprimer

Sept fichiers pour le banc, un par pièce, déjà orientés pour l'impression, sans support ;
puis le support du laser, dans la version de votre télémètre.

| Fichier | Pièce |
|---|---|
| `socle.stl` | le socle qui s'accroche à la table ([image](apercu/socle.png)) |
| `coulisseau.stl` | le chariot qui porte les élévateurs et la cible ([image](apercu/coulisseau.png)) |
| `cible.stl` | la cible, à imprimer en blanc ([image](apercu/cible.png)) |
| `poulie.stl` | la poulie de la cordelette ([image](apercu/poulie.png)) |
| `bobine_tete.stl`, `bobine_ecrou.stl` | les deux bobines des élévateurs ([image](apercu/bobine_tete.png)) |
| `entretoises_grappe.stl` | 8 petites entretoises sur une barrette, à détacher au cutter ([image](apercu/entretoises_grappe.png)) |

### À imprimer d'abord : le calibre des goupilles

Les goupilles tiennent par serrage dans des trous à six pans, et ce serrage se joue à quelques
centièmes de millimètre, moins que la précision d'une imprimante. `calibre_goupilles.stl`
([image](apercu/calibre_goupilles.png)) porte les mêmes trous en huit cotes, de 4,85 à 5,20 mm
et de 2,85 à 3,20 mm ; le nombre gravé au-dessus de chacun est sa cote en centièmes
(295 = 2,95 mm).

Imprimez-le sur la même imprimante et dans la même matière que le banc, puis enfoncez-y vos
goupilles à fond, le bout lisse en premier. Repérez le plus grand trou d'où la goupille ne
ressort pas à la main, et retenez la cote juste en dessous. Le modèle est tracé pour 4,95 et 2,95 :
si vous trouvez autre chose, reportez vos deux cotes dans `axle_d` et `ear_d` de
`scad/banc.scad` et regénérez le socle et le chariot.

### Le support du laser, à la taille de votre télémètre

Même pièce ([l'encoche](apercu/support_laser_encoche.png), [vue de dessous](apercu/support_laser_bec.png)),
une version par télémètre : les Leica DISTO et les Bosch à moins de 500 €, aux cotes du
constructeur plus 0,5 mm de jeu. Le support est 3 mm moins haut que le télémètre, pour le
saisir et atteindre ses boutons. Certains télémètres ne mesurent que depuis leur face
arrière : leur lecture est plus longue de leur propre longueur, le tableau dit combien
retrancher. GLM 100, 120 et 150 : pointe arrière rentrée.

<!-- supports:debut -->
| Télémètre | Cotes constructeur (mm) | Repère de mesure | Fichier |
|---|---|---|---|
| Leica DISTO D1 | 115 × 43.5 × 23.5 | arrière seulement : retranchez 115 mm de la lecture | `support_laser_leica_d1.stl` ([image](apercu/support_laser_leica_d1.png)) |
| Leica DISTO D110 / E7100i | 120 × 37 × 23 | arrière seulement : retranchez 120 mm de la lecture | `support_laser_leica_d110.stl` ([image](apercu/support_laser_leica_d110.png)) |
| Leica DISTO D2 (v1, 100 m) | 116 × 44 × 26 | avant ou arrière | `support_laser_leica_d2_v1.stl` ([image](apercu/support_laser_leica_d2_v1.png)) |
| Leica DISTO D2 (2025, 150 m) / D2G | 127 × 50.5 × 24.5 | avant ou arrière | `support_laser_leica_d2_2025.stl` ([image](apercu/support_laser_leica_d2_2025.png)) |
| Leica DISTO X1 | 125 × 53.5 × 25.5 | arrière seulement : retranchez 125 mm de la lecture | `support_laser_leica_x1.stl` ([image](apercu/support_laser_leica_x1.png)) |
| Leica DISTO X3 / X4 | 132 × 56 × 29 | avant ou arrière | `support_laser_leica_x3_x4.stl` ([image](apercu/support_laser_leica_x3_x4.png)) |
| Bosch GLM 40 / GLM 30 | 105 × 41 × 24 | avant ou arrière | `support_laser_bosch_glm40.stl` ([image](apercu/support_laser_bosch_glm40.png)) |
| Bosch GLM 50-22 / 50-25 G / 50-27 C / 50-27 CG / 40-31 | 119 × 53 × 29 | avant ou arrière | `support_laser_bosch_glm50.stl` ([image](apercu/support_laser_bosch_glm50.png)) |
| Bosch GLM 80 | 111 × 51 × 30 | avant ou arrière | `support_laser_bosch_glm80.stl` ([image](apercu/support_laser_bosch_glm80.png)) |
| Bosch GLM 100-25 C / 150-27 C / 120 C | 142 × 64 × 28 | avant ou arrière | `support_laser_bosch_glm100_150.stl` ([image](apercu/support_laser_bosch_glm100_150.png)) |
| Bosch Zamo (IV, 2025) | 104 × 38 × 23 | arrière seulement : retranchez 104 mm de la lecture | `support_laser_bosch_zamo.stl` ([image](apercu/support_laser_bosch_zamo.png)) |
| Bosch PLM30-21 / EasyDistance 20 | 94 × 36 × 23 | arrière seulement : retranchez 94 mm de la lecture | `support_laser_bosch_plm30.stl` ([image](apercu/support_laser_bosch_plm30.png)) |
| Bosch PLM40-23 / 50-23 / 60-23C / 70-23C, UniversalDistance 30 / 40C / 50 / 50C, PLR 30 C / 40 C | 100 × 42 × 22 | avant ou arrière | `support_laser_bosch_plm40_70.stl` ([image](apercu/support_laser_bosch_plm40_70.png)) |
| Bosch PLM70-27 / AdvancedDistance 50C / PLR 50 C | 115 × 50 × 23 | avant ou arrière | `support_laser_bosch_plm70_27.stl` ([image](apercu/support_laser_bosch_plm70_27.png)) |
<!-- supports:fin -->

Autre télémètre : mesurez-le (largeur, longueur, épaisseur), reportez les trois cotes dans
`scad/support_laser.scad` et regénérez le STL ; `btn_cote` ouvre une paroi en face de boutons
latéraux.

## Quelle matière

**PETG**, 4 périmètres, 25 % de remplissage, cible en blanc mat. Pas de PLA : il se déforme
dans une voiture au soleil.

Si vous faites imprimer chez [JLC3DP](https://jlc3dp.com/3d-printing-quote) : tout en
**nylon SLS 3201PA-F**, sauf la cible en **résine SLA 9000HE** blanche. Comptez ≈ 44 $ de
pièces pour le banc et ≈ 10 $ de port. Les pièces qui serrent des goupilles ou tirent sur
une suspente (socle, chariot, support du laser) ne doivent pas être en résine : elle casse
au lieu de plier.

## Ce qu'il faut acheter

Tout sur AliExpress, chez des vendeurs notés. Prix lus le 5 octobre 2026 (goupilles : le 8) ;
vérifiez la variante cochée avant de payer.

| Pièce | Variante à cocher | Il en faut | Prix | Lien |
|---|---|---|---|---|
| Roues V noires Ø 24, roulements montés | « 10PC BigBlack Wheel » | 5 sur 10 | 6,69 € | [annonce](https://fr.aliexpress.com/item/1005003090749056.html) |
| Vis M5 × 25 tête bombée | « 10Pcs M5x25 » | 4 sur 10 | 4,29 € | [annonce](https://fr.aliexpress.com/item/32850409234.html) |
| Écrous frein M5 (bague nylon) | « M5 X 50pcs » | 5 sur 50 | 3,39 € | [annonce](https://fr.aliexpress.com/item/1005002375633274.html) |
| Vis M5 × 80 tête cylindrique | « M5 10 pièces », puis « 80 mm » | 1 sur 10 | 5,09 € | [annonce](https://fr.aliexpress.com/item/32968483467.html) |
| Goupille moletée Ø 5 × 40 (axe de la poulie) | « M5-5pcs », puis « 40mm » | 1 sur 5 | 2,11 € | [annonce](https://fr.aliexpress.com/item/1005007894767899.html) |
| Goupilles moletées Ø 3 × 12 (charnière de la cible) | « M3-10pcs », puis « 12 mm » | 2 sur 10 | 1,02 € | [même annonce](https://fr.aliexpress.com/item/1005007894767899.html) |
| Cordelette 2 mm | « 10 meters » | 1,5 m | 1,62 € | [annonce](https://fr.aliexpress.com/item/1005011930498059.html) |

**≈ 27 € port compris.** Le roulement de la poulie se récupère sur la cinquième roue, le lest
est votre poche à eau, et il n'y a ni colle ni frein-filet. Le laser n'est pas compté : un
télémètre Bluetooth de 30 m (HOTO QWCJY001 ou équivalent) vaut 30 à 40 €.

Les goupilles sont lisses, sauf un bout moleté de 3,5 mm, plus gros de 0,1 mm : c'est lui qui
mord dans le plastique et retient la goupille. Une goupille entièrement lisse ne tiendrait
que si le trou sort de l'imprimante à quelques centièmes près.

### La même chose en Europe

Toute la visserie se trouve à l'unité chez visseriefixations.fr (France). Aucun des sites
européens examinés n'a aussi les roues : elles viennent d'une boutique d'impression 3D. Prix
lus le 8 octobre 2026, port non compris (il ne s'affiche que dans le panier).

| Pièce | Référence du site | Il en faut | Prix | Lien |
|---|---|---|---|---|
| Roues V Ø 24 × 10 en POM, alésage 5, roulements 625ZZ montés | lot de 6 | 5 sur 6 | 12,90 € | [3delectroshop.fr](https://3delectroshop.fr/roulements-et-rotules/504-roulettes-v-slot-en-pom-avec-roulements-625zz.html) |
| Vis M5 × 25 tête bombée, ISO 7380, inox A2 | TBHC05/025A2 | 4 | 0,08 € pièce | [visseriefixations.fr](https://www.visseriefixations.fr/vis-a-six-pans-creux/tete-bombee-hexagonale-creuse/tbhc-inox-a2-iso-7380/tbhc-m5x25-inox-a2-iso-7380.html) |
| Écrous frein M5 à bague nylon, DIN 985, inox A2 | ECRNYL05A2 | 5 | 0,04 € pièce | [visseriefixations.fr](https://www.visseriefixations.fr/ecrous/ecrous-autofreines/ecrou-hexagonal-autofreine-nylstop/ecrou-nylstop-inox-a2-din-985/ecrou-nylstop-m5-inox-a2-din-985-99867-99867.html) |
| Vis M5 × 80 tête cylindrique, DIN 912, inox A2, filetage partiel | TCHC05/080A2PF | 1 | 0,59 € | [visseriefixations.fr](https://www.visseriefixations.fr/vis-a-six-pans-creux/tete-cylindrique-hexagonale-creuse/inox-a2/tchc-inox-a2-filetage-partiel-din-912/tchc-m5x80-inox-a2-pf-din-912.html) |
| Goupille lisse Ø 5 × 40, ISO 2338 h8, inox A1 (axe de la poulie) | GOUCYL05/040A2ISO | 1 | 0,80 € | [visseriefixations.fr](https://www.visseriefixations.fr/goupilles/goupille-cylindrique-decolletee/iso-2338b-h8-inox-a1/goupille-cylindrique-rectifiee-h8-5x40-inox-a1-iso-2338b.html) |
| Goupilles cannelées Ø 3 × 12, DIN 1474, inox A1 (charnière de la cible) | GOUCANG0503/012IDI | 2 | 0,24 € pièce | [visseriefixations.fr](https://www.visseriefixations.fr/goupilles/goupilles-cannelees-embrochables-din-1474-g05-iso-8741/inox/goupille-cannelee-g05-3x12-inox-a1-din-1474-13489-13489.html) |

**Visserie : 2,39 €, plus le port ; roues : 12,90 €, plus le port.** La cordelette est
n'importe quelle cordelette de 2 mm.

La goupille Ø 5 est ici lisse d'un bout à l'autre, ce marchand n'ayant pas de cannelée en
5 × 40 : elle ne tient que par le serrage de son trou, donc réglez `axle_d` au calibre. Sa tolérance doit être h8 :
une goupille m6, plus courante, ne passe pas dans le roulement.

## Montage

Le schéma complet, avec la visserie : [schema_montage.png](apercu/schema_montage.png).

1. **Poulie** : sortez un roulement d'une roue en trop, emmanchez-le dans la poulie. Posez la
   poulie dans sa fente avec une entretoise de chaque côté et enfoncez la goupille Ø 5, le
   bout lisse en premier, à travers les deux crochets, jusqu'à ce qu'elle soit en retrait des
   flancs.
2. **Roues** : un écrou frein dans chacun des 4 logements du chariot, puis pour chaque roue
   une vis M5 × 25 par le dessous, à travers la roue et une entretoise.
3. **Jeu** : serrez le côté fixe, poussez les deux autres roues au fond de leur rainure (trous
   oblongs), serrez. Le chariot doit rouler tout seul quand on incline le socle.
4. **Bobines** : sur la vis M5 × 80, une bobine, la nervure du chariot, l'autre bobine, l'écrou
   frein dans le chapeau. On n'y touche plus.
5. **Cible** : entre les oreilles du chariot, une goupille Ø 3 de chaque côté, le bout lisse
   en premier, enfoncée à ras : le bout moleté reste dans l'oreille.
6. **Cordelette** : nœud en huit dans le puits derrière la cible ; le brin file dans le canal
   du socle, passe sur la poulie et se noue à la poignée de la poche. Pesez la poche pleine à
   **5,00 kg**.

Réglez la cordelette pour que la poche touche le sol quand la suspente est molle, et décolle
dès qu'on tire.

## Régler l'offset dans l'outil de calage

L'outil demande la distance entre le point d'accrochage de l'élévateur et la cible. Sur le
banc, l'élévateur entier est pris sur la bobine : l'axe de sa vis est à **21 mm** de la face
de la cible, du côté du laser.

**Offset à saisir : 21 mm.**

Réglez le télémètre pour mesurer **depuis sa face avant** : elle affleure le bec du support.

## Pour aller plus loin

- [NOTES.md](https://github.com/alexandre-pereira/trimming-tools/blob/main/NOTES.md) : les
  choix de conception, les cotes, les prix relevés, les variantes écartées et ce qui a été
  vérifié.
- Les modèles OpenSCAD sont dans `scad/`, les scripts qui regénèrent STL, images et ce site
  dans `outils/`. Dépôt : <https://github.com/alexandre-pereira/trimming-tools>, site : <https://trimming-tools.weflare.fr>.
- Rien n'a encore été imprimé ni essayé sous charge : c'est un modèle, pas un produit testé.
