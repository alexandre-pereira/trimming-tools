// ============================================================
//  Banc de calage parapente compact et plat, à poser sur un chant de table
//  (même principe que l'EasyTrim) — laser + poche à eau de 5 kg.
//
//  Un socle s'accroche au bord de la table et porte la poulie de renvoi, logée dans le bloc
//  des crochets, sous le passage du coulisseau ; la cordelette rejoint le coulisseau par un canal
//  creusé dans le dessus du socle. Un coulisseau roule dessus sur 4 roues en V montées sur vis M5 ; il porte
//  à l'avant un plot central et deux bobines où s'accrochent les deux élévateurs posés à plat
//  et, juste derrière, la cible articulée ; à l'arrière, la cordelette de la poche à eau.
//  La cible se rabat vers l'arrière, à plat sur le coulisseau, pour le transport.
//
//  Repère : x = axe de traction, +x vers la voile ; chant de la table en x = 0 ;
//  dessus de la table en z = 0. La poche à eau pend en x < 0.
// ============================================================

part = "assemblage";   // socle | coulisseau | poulie | cible | bobine_tete | bobine_ecrou | entretoises_grappe | assemblage
plie = false;          // assemblage : true = cible rabattue, coulisseau en butée arrière (transport)
alleg = true;          // socle et coulisseau évidés : un cinquième de matière en moins, donc moins cher chez un imprimeur

// --- Socle ---
T        = 17;     // épaisseur
wheel_z  = 9.8;    // plan de roulement des roues (1,5 mm entre les têtes de vis et la table)
base_w   = 50;     // largeur entre les deux rainures en V
travel   = 100;    // course du coulisseau (chaque mm de course allonge le socle d'autant)
stop_t   = 5;      // épaisseur des butées de fin de course
stop_w   = 80;     // largeur des butées
lug_drop = 14;     // hauteur du crochet sous le dessus de la table (il dépasse la poulie pour la protéger)
lug_len  = 34;     // avancée des joues devant le chant ; le socle (et ses rainures) commence au bout des joues
chan_w   = 6;      // canal de la cordelette dans le dessus du socle, sous le coulisseau

// --- Roues V Ø24 pour profilé V-slot (2 roulements 625) ---
wheel_od   = 23.9;
wheel_w    = 10.23;
wheel_stack = 11;    // largeur sur les deux roulements 625 et leur cale de 1 mm : ils dépassent la roue de 0,4 mm par face.
                     // C'est cette cote, et non wheel_w, qui compte le long de la vis.
wheel_flat = 5.9;    // largeur du méplat de la bande de roulement
wheel_px   = 30;     // entraxe longitudinal des roues. Chaque mm d'entraxe en moins raccourcit le socle d'autant
                     // (ou rend 1 mm de course) ; en dessous de 28 mm les roues se toucheraient.
spacer_h   = 2.7;    // entretoise imprimée entre la roue et le coulisseau.
                     // Vis M5×25 : 11 (roue) + 2,7 (entretoise) + 5,3 (matière sous l'écrou) = 19 ; l'écrou frein (5 mm)
                     // va de 19 à 24, la vis le dépasse de 1 mm (bague nylon en prise) et reste sous le dessus du coulisseau.
n_spacer   = 8;      // entretoises dans la grappe (4 pour les roues, 2 pour la poulie, 2 de rechange)
groove_flat  = 5.0;  // fond de la rainure du socle, plus étroit que le méplat :
groove_depth = 3.0;  // la roue porte sur ses chanfreins, pas sur le fond

// --- Coulisseau ---
sl_t     = 11.5;   // épaisseur : elle loge un écrou frein M5 (5 mm) au bout de la vis M5×25 des roues
sl_rear  = 28;     // débord arrière (côté poulie) depuis le milieu des roues
sl_front = 48;     // débord avant (côté voile)
pit_x    = 27;     // puits du nœud de la cordelette : le plus en avant possible, pour que le brin reste presque horizontal
edge     = 8;      // matière entre l'axe d'une roue et le bord
nut_h    = 6.2;    // logement des écrous frein M5 des roues : écrou noyé, 5,3 mm de matière dessous (voir spacer_h)
adj      = 1;      // côté -y : trous oblongs de ±1 mm pour régler le jeu des roues

// --- Accrochage des 2 élévateurs : nervure centrale traversée par une vis M5, une bobine de chaque côté ---
// Les élévateurs sont posés à plat. Leur boucle de base se passe par-dessus le chapeau de la bobine,
// sans rien dévisser ; la sangle se couche ensuite dans son couloir, entre la nervure centrale et une joue.
// La vis est montée une fois pour toutes ; sa tête et son écrou sont noyés dans les chapeaux :
// la sangle ne touche que du plastique lisse, et aucune pièce ne se démonte à l'usage.
elev_w   = 26;     // longueur utile d'une bobine = largeur de la sangle de l'élévateur (25) + 1 mm
elev_t   = 5;      // épaisseur de la sangle à l'endroit de la boucle
post_w   = 16;     // largeur de la nervure centrale
pin_d    = 5.3;    // passage de la vis M5
pin_x    = 24;     // position de l'axe des bobines devant la face avant
pin_z    = 0.5;    // hauteur de l'axe au-dessus du dessus du coulisseau. Il reste sl_t + pin_z - bob_d/2 - floor_t
                   // (5,7 mm) entre la bobine et le plancher : la boucle de l'élévateur (elev_t = 5) y passe avec 0,7 mm de jeu.
                   // Chaque mm ajouté ici donne 1 mm de plus à la sangle et épaissit le banc plié d'autant.
boss_r   = 7;      // bossage de la nervure autour de l'axe
bob_d    = 9;      // diamètre des bobines, sur lesquelles porte la sangle
bob_fl   = 14;     // diamètre du chapeau
screw_l  = 80;     // vis CHC M5×80 (tête cylindrique à six pans creux)
pocket   = 6;      // logement de la tête (Ø8,5 × 5) dans un chapeau ; celui de l'écrou frein (5 mm) a 1 mm de plus,
                   // pour que la vis M5×80 dépasse l'écrou de 1,5 mm (bague nylon en prise) sans sortir du chapeau
cap_l    = (screw_l - 5.5 - 2*elev_w - post_w)/2 + pocket;   // longueur d'un chapeau (≈ 9,25)
cone_l   = (bob_fl - bob_d)/2;                               // raccord conique à 45° entre bobine et chapeau

// --- Plateau avant : plancher sous les bobines, puis deux couloirs qui tiennent les élévateurs à plat ---
tray_l   = 54;     // longueur du plateau devant la face avant
floor_t  = 1.8;    // plancher sous les bobines (la boucle passe entre la bobine et lui)
tray_t   = 3;      // fond des couloirs
ch_x0    = pin_x + bob_fl/2 + 3;   // début des couloirs, juste devant les chapeaux
fence_t  = 3;      // épaisseur des joues
fence_z  = 3.5;    // hauteur des joues au-dessus du dessus du coulisseau : elles montent jusqu'au dessus de la sangle tendue
fence_y  = post_w/2 + elev_w + 0.5;   // face intérieure des joues extérieures

// --- Poulie Ø25 sur un roulement 625ZZ, axe = vis CHC M5×40 et écrou frein, noyés dans les joues ---
// Elle est logée dans le bloc des crochets, sous le passage du coulisseau : rien ne dépasse du socle.
// Le roulement supprime le frottement de l'axe, qui fausserait la tension de la suspente.
pul_r    = 12.5;
pul_w    = 9.4;
slot_w   = 5 + 2*spacer_h + 0.2;   // fente de la poulie entre les joues (roulement 5 + une entretoise de chaque côté + jeu)
cord_d   = 2;      // cordelette 2 mm
axle_d   = 5.3;    // passage de la vis M5 dans les joues
axle_l   = 40;     // vis CHC M5×40 (DIN 912, tête Ø8,5 × 5) et écrou frein M5 (5 mm)
axle_hd  = 9.5;    // profondeur du logement de la tête (Ø9), côté -y : la tige lisse de la vis (18 mm) arrive ainsi
                   // jusque sous le roulement, et le bout fileté s'arrête 0,5 mm sous le flanc d'en face
axle_nd  = 6.5;    // profondeur du logement à six pans de l'écrou frein, côté +y : la vis le dépasse de 1 mm (bague nylon
                   // en prise). Tête et écrou restent sous les flancs, hors du passage des roues.

// --- Cible articulée à l'avant du coulisseau, verrouillée d'équerre quand elle est relevée ---
// Relevée et poussée vers le bas, sa languette se coince entre la face avant du coulisseau et une
// lèvre inclinée : elle ne peut basculer ni en avant ni en arrière. Pour la rabattre, on la soulève
// de `lift` (les charnons ont une lumière), puis on la couche sur le coulisseau.
tg_t      = 3;     // épaisseur de la plaque
tg_w      = 84;    // largeur de la partie haute
tg_up     = 88;    // hauteur au-dessus de l'axe de charnière (rabattue, la cible ne dépasse pas du socle)
tg_wide_z = 11;    // la plaque s'élargit au-dessus des oreilles
hinge_x   = 3.5;   // axe de charnière : en avant de la face avant du coulisseau…
hinge_z   = 4;     // …et au-dessus de son dessus. hinge_z - hinge_x = jeu de la cible rabattue (0,5)
ear_t     = 6;     // oreilles du coulisseau
ear_r     = 5;     // rayon des oreilles autour de l'axe ; leur dessus est arasé à ear_h pour ne pas épaissir le banc plié
ear_h     = 4.5;   // dessus des oreilles, au-dessus de l'axe de charnière : 1,6 mm de matière au-dessus du logement de l'écrou
knuckle_w = 7;     // charnons de la cible
knuckle_r = 3.5;
hinge_d   = 3.4;   // lumière des charnons, où entre le bout de la vis M3
ear_d     = 3.3;   // passage de la vis M3 dans les oreilles. Chaque charnière est une vis M3×12 à tête bombée : sa tête porte
                   // sur le flanc de l'oreille, un écrou frein M3 la serre de l'autre côté, et les 5,6 mm qui dépassent
                   // servent d'axe à la cible. La vis est donc bloquée sur l'oreille, vis et écrou, sans rien d'ajusté.
ear_nut   = 4;     // profondeur du logement à six pans de l'écrou frein M3 (5,5 sur plats, 4 mm), sur la face intérieure
                   // de l'oreille : il reste 2 mm de matière sous la tête de vis, et le charnon voisin, à 0,4 mm,
                   // empêche l'écrou de ressortir.
lift      = 5.5;   // course de soulèvement pour déverrouiller
lip_z     = 6.5;   // sommet de la lèvre, au-dessus du dessous du coulisseau
flap_h    = sl_t - 2.5;   // languette de verrouillage : elle descend jusqu'à 2,5 mm du dessous du coulisseau,
                   // là où la lèvre inclinée la coince (même géométrie quelle que soit l'épaisseur du coulisseau)
lip_y0    = post_w/2 + 1;    // la lèvre court de la nervure centrale…
lip_y1    = 28;              // …jusqu'avant les charnons
mire_z    = 45;    // hauteur de la mire gravée : viser toujours le trait horizontal

// --- Valeurs dérivées ---
wheel_ch = (wheel_w - wheel_flat) / 2;                    // chanfrein de la roue
wheel_y  = base_w/2 + wheel_od/2 + wheel_flat/2
           - groove_flat/2 - groove_depth;                // axe des roues (≈ 34,4)
base_l   = 2*stop_t + travel + wheel_px + wheel_od;       // longueur du socle, du bout des joues à la butée avant (≈ 164)
x_end    = -lug_len + base_l;                             // butée avant
sl_w     = 2 * (wheel_y + edge);                          // largeur du coulisseau (≈ 85)
z_sb     = wheel_z + wheel_stack/2 + spacer_h;            // dessous du coulisseau (1 mm au-dessus du socle)
axle_x   = -lug_len/2;                                    // axe de poulie, au milieu des joues…
axle_z   = -1;                                            // …sous les rainures : le logement de la tête de vis (Ø9) laisse
                                                          // ainsi 0,8 à 3 mm de matière sous le chanfrein où roule la roue
groove_r = 10;                                            // fond de gorge (2 mm de matière autour du roulement)
z_cord   = axle_z + groove_r + cord_d/2;                  // brin au départ de la poulie (≈ 10), 7 mm sous son arrivée au coulisseau
wheel_x0 = -sl_rear + edge;                               // roues arrière (repère du coulisseau) ; roues avant à wheel_x0 + wheel_px
xs_min   = -lug_len + stop_t + wheel_od/2 - wheel_x0;     // coulisseau en butée arrière
knot_x   = pit_x + 1;                                     // fente par où la cordelette sort du coulisseau (repère du coulisseau)
yk       = sl_w/2 - ear_t - 0.4;                          // bord extérieur des charnons de la cible

$fn = 72;

// prismes : profil (y, z) extrudé le long de x, et profil (x, z) extrudé le long de y
module prism_x(len, pts)   { rotate([90, 0, 90]) linear_extrude(len) polygon(pts); }
module prism_y(y0, w, pts) { translate([0, y0 + w, 0]) rotate([90, 0, 0]) linear_extrude(w) polygon(pts); }

module socle() {
    b = base_w/2; zc = wheel_z; gf = groove_flat/2; gd = groove_depth;
    lug_w = (base_w - slot_w)/2;
    x0 = -lug_len;
    n_cell = floor((x_end - stop_t - 14) / 44);               // allègements séparés par des nervures de 4 mm
    cell   = (x_end - stop_t - 14 - 4*(n_cell - 1)) / n_cell;
    difference() {
        union() {
            translate([x0, -b, 0]) cube([base_l, base_w, T]);                   // plateau, du bout des joues à la butée avant
            for (x = [x0, x_end - stop_t])
                translate([x, -stop_w/2, 0]) cube([stop_t, stop_w, T]);         // butées : les roues s'y arrêtent
            for (y0 = [slot_w/2, -b])                                           // joues de poulie + crochets de table
                prism_y(y0, lug_w, [[1, T], [x0, T], [x0, -4], [x0 + 8, -lug_drop],
                                    [0, -lug_drop], [0, 0], [1, 0]]);
        }
        // rainures en V sur les deux flancs, entre les butées
        for (s = [-1, 1]) translate([x0 + stop_t, 0, 0]) scale([1, s, 1])
            prism_x(base_l - 2*stop_t, [[b + 1, zc + gf + gd + 1], [b - gd, zc + gf],
                                        [b - gd, zc - gf], [b + 1, zc - gf - gd - 1]]);
        // fente de la poulie, débouchante en haut et en bas : la poulie se pose par le dessus
        translate([axle_x - pul_r - 1, -slot_w/2, -lug_drop - 1]) cube([2*pul_r + 2, slot_w, lug_drop + T + 2]);
        // vis M5 de la poulie, à travers les deux joues : logement rond de la tête d'un côté, logement à six pans de
        // l'écrou frein de l'autre (deux pans horizontaux : il s'imprime sans support)
        translate([axle_x, -b - 1, axle_z]) rotate([-90, 0, 0]) cylinder(d = axle_d, h = base_w + 2);
        translate([axle_x, -b - 1, axle_z]) rotate([-90, 0, 0]) cylinder(d = 9, h = axle_hd + 1);
        translate([axle_x, b - axle_nd, axle_z]) rotate([-90, 0, 0]) cylinder(d = 8.3 / cos(30), h = axle_nd + 1, $fn = 6);
        // canal de la cordelette, ouvert vers le haut, de la poulie jusqu'au bout du socle (il traverse la butée avant :
        // en fin de course, le nœud est au-dessus du bout du socle)
        translate([axle_x, -chan_w/2, z_cord - cord_d/2 - 1]) cube([x_end - axle_x + 1, chan_w, T]);
        // allègements ouverts côté table (donc vers le haut à l'impression, sans pontage), de part et d'autre du canal :
        // il reste 3 mm de dessus, 4 mm de flanc derrière les rainures et 3 mm de paroi le long du canal
        for (i = [0 : n_cell - 1], y0 = alleg ? [-18, 6] : [-16, 6])
            translate([10 + i*(cell + 4), y0, -1]) cube([cell, alleg ? 12 : 10, T - (alleg ? 2 : 3)]);
        // les deux crochets sont creusés par-dessous : 3 mm de paroi, et 2 mm de matière sous les logements de la tête
        // et de l'écrou de la vis de poulie
        if (alleg) for (y0 = [slot_w/2 + 3, -b + 3])
            translate([x0 + 10, y0, -lug_drop - 1]) cube([lug_len - 13.5, lug_w - 6, lug_drop - 6.5]);
    }
}

// logement d'écrou M5 (8 sur plats), méplats parallèles à y pour pouvoir coulisser dans un trou oblong
module nut_m5(h) { rotate([0, 0, 30]) cylinder(d = 8.3 / cos(30), h = h, $fn = 6); }

// origine : 20 mm devant les roues arrière, z = 0 au-dessous de la plaque
module coulisseau() {
    hx = sl_front + hinge_x;      // axe de charnière
    px = sl_front + pin_x;        // axe des bobines
    cx = sl_front + ch_x0;        // début des couloirs
    cl = tray_l - ch_x0;          // leur longueur
    lip = [[sl_front + tg_t - 0.1, floor_t - 0.1], [sl_front + tg_t + 0.6, lip_z],
           [sl_front + tg_t + 2.8, lip_z], [sl_front + tg_t + 2.8, floor_t - 0.1]];
    difference() {
        union() {
            translate([-sl_rear, -sl_w/2, 0]) cube([sl_rear + sl_front, sl_w, sl_t]);          // plaque
            translate([sl_front - 1, -sl_w/2, 0]) cube([tray_l + 1, sl_w, floor_t]);           // plancher avant
            translate([cx, -sl_w/2, 0]) cube([cl, sl_w, tray_t]);                              // fond des couloirs
            translate([sl_front - 2, -post_w/2, 0]) cube([2 + tray_l, post_w, sl_t]);          // nervure centrale
            hull() {                                                                           // son bossage autour de l'axe
                translate([px - boss_r, -post_w/2, 0]) cube([2*boss_r, post_w, sl_t]);
                translate([px, -post_w/2, sl_t + pin_z]) rotate([-90, 0, 0]) cylinder(r = boss_r, h = post_w);
            }
            translate([cx, -post_w/2, 0]) cube([cl, post_w, sl_t + fence_z]);                  // séparateur des deux couloirs
            for (y0 = [fence_y, -fence_y - fence_t])
                translate([cx, y0, 0]) cube([cl, fence_t, sl_t + fence_z]);                    // joues extérieures
            prism_y(lip_y0, lip_y1 - lip_y0, lip);                                             // lèvres de verrouillage de la cible
            prism_y(-lip_y1, lip_y1 - lip_y0, lip);
            for (y0 = [sl_w/2 - ear_t, -sl_w/2]) intersection() {                              // oreilles de charnière
                union() {
                    translate([sl_front - 2, y0, 0]) cube([2 + hinge_x + ear_r, ear_t, sl_t + hinge_z]);
                    translate([hx, y0, sl_t + hinge_z]) rotate([-90, 0, 0]) cylinder(r = ear_r, h = ear_t);
                }
                translate([sl_front - 3, y0 - 1, -1]) cube([hinge_x + ear_r + 5, ear_t + 2, sl_t + hinge_z + ear_h + 1]);   // dessus arasé
            }
        }
        for (x = [wheel_x0, wheel_x0 + wheel_px]) {
            // côté +y : position fixe
            translate([x, wheel_y, -1]) cylinder(d = 5.3, h = sl_t + 2);
            translate([x, wheel_y, sl_t - nut_h]) nut_m5(nut_h + 1);
            // côté -y : trous oblongs, pour plaquer les roues dans la rainure avant de serrer
            hull() for (dy = [-adj, adj]) translate([x, -wheel_y + dy, -1]) cylinder(d = 5.3, h = sl_t + 2);
            hull() for (dy = [-adj, adj]) translate([x, -wheel_y + dy, sl_t - nut_h]) nut_m5(nut_h + 1);
        }
        // axe de charnière : passage des vis M3 dans les oreilles, et logement à six pans de leur écrou frein sur la face
        // intérieure (deux pans horizontaux : il s'imprime sans support)
        translate([hx, -sl_w, sl_t + hinge_z]) rotate([-90, 0, 0]) cylinder(d = ear_d, h = 2*sl_w);
        for (s = [-1, 1]) translate([hx, s*(sl_w/2 - ear_t - 1), sl_t + hinge_z]) rotate([-90*s, 0, 0])
            cylinder(d = 5.8 / cos(30), h = ear_nut + 1, $fn = 6);
        // axe des bobines : vis M5 à travers la nervure
        translate([px, -post_w, sl_t + pin_z]) rotate([-90, 0, 0]) cylinder(d = pin_d, h = 2*post_w);
        // plancher échancré sous les chapeaux : c'est par là que la boucle de l'élévateur passe sous le chapeau
        // quand on l'enfile (sans échancrure, il ne resterait que 0,2 mm entre le chapeau et le plancher)
        for (s = [-1, 1]) translate([px - bob_fl/2 - 2, s > 0 ? post_w/2 + elev_w : -sl_w/2 - 1, -1])
            cube([bob_fl + 4, sl_w/2 + 1 - post_w/2 - elev_w, floor_t + 2]);
        // cordelette : puits du nœud, ouvert dessus pour nouer, fermé dessous sauf une fente de 3 mm
        // par où le brin descend dans le canal du socle (le nœud en huit ne passe pas par la fente)
        translate([pit_x, -6, 2]) cube([10, 12, sl_t]);
        translate([knot_x - 2, -1.5, -1]) cube([4, 3, 4]);
        // allègement : la plaque est creusée par le dessus (rien à ponter à l'impression, dessous resté plan). Il reste
        // un fond de 2,4 mm, un cadre, un bossage plein sous chaque écrou, deux traverses entre les roues, un longeron
        // et le bloc du puits de la cordelette, relié à la face avant où s'appuie la cible.
        if (alleg) difference() {
            translate([-sl_rear + 3, -sl_w/2 + 3, 2.4]) cube([sl_rear + sl_front - 7, sl_w - 6, sl_t]);
            for (x = [wheel_x0, wheel_x0 + wheel_px]) {
                translate([x, wheel_y, 0]) cylinder(r = 8, h = sl_t + 2);
                hull() for (dy = [-adj, adj]) translate([x, -wheel_y + dy, 0]) cylinder(r = 8, h = sl_t + 2);
                translate([x - 1.5, -sl_w/2, 0]) cube([3, sl_w, sl_t + 2]);
            }
            translate([-sl_rear, -2, 0]) cube([sl_rear + pit_x, 4, sl_t + 2]);
            translate([pit_x - 3, -9, 0]) cube([sl_front - pit_x + 3, 18, sl_t + 2]);
        }
    }
}

// Bobine d'un élévateur : tube lisse sur lequel porte la sangle, raccord conique, puis chapeau
// qui retient la sangle et cache la tête de vis (ecrou = false) ou l'écrou frein (ecrou = true).
// S'imprime debout, le tube sur le plateau, sans support ni pontage.
module bobine(ecrou = false) {
    h = elev_w + cap_l;
    difference() {
        union() {
            cylinder(d = bob_d, h = h);
            translate([0, 0, elev_w]) cylinder(d1 = bob_d, d2 = bob_fl, h = cone_l);
            translate([0, 0, elev_w + cone_l]) cylinder(d = bob_fl, h = cap_l - cone_l - 1.5);
            translate([0, 0, h - 1.5]) cylinder(d1 = bob_fl, d2 = bob_fl - 3, h = 1.5);     // bout arrondi
        }
        translate([0, 0, -1]) cylinder(d = pin_d, h = h + 2);
        if (ecrou) translate([0, 0, h - pocket - 1]) cylinder(d = 8.3 / cos(30), h = pocket + 2, $fn = 6);
        else       translate([0, 0, h - pocket]) cylinder(d = 9.2, h = pocket + 1);
    }
}

// Entretoise imprimée : une entre chaque roue et le coulisseau, une de chaque côté du roulement de poulie.
// Elle ne porte que sur la bague intérieure du roulement et remplace 3 rondelles M5.
module entretoise() {
    difference() {
        cylinder(d = 8, h = spacer_h);
        translate([0, 0, -1]) cylinder(d = 5.3, h = spacer_h + 2);
    }
}

// Poulie : le roulement 625 (5 × 16 × 5) s'emmanche par le dessus et bute sur une lèvre ; il est centré dans la largeur.
module poulie() {
    gw = cord_d + 0.6;
    difference() {
        cylinder(r = pul_r, h = pul_w);
        translate([0, 0, pul_w/2]) rotate_extrude()                             // gorge en V à 45° (imprimable sans support)
            polygon([[groove_r, -gw/2], [pul_r + 1, -gw/2 - (pul_r + 1 - groove_r)],
                     [pul_r + 1,  gw/2 + (pul_r + 1 - groove_r)], [groove_r, gw/2]]);
        translate([0, 0, (pul_w - 5)/2]) cylinder(d = 16.15, h = pul_w);        // logement du 625, emmanché, centré
        translate([0, 0, -1])  cylinder(d = 13.5, h = 5);                       // lèvre de retenue de 2,2 mm
    }
}

// Cible relevée et verrouillée. Origine : face avant du coulisseau en x = 0, dessus du coulisseau en z = 0.
module cible() {
    difference() {
        union() {
            translate([0, -yk, -flap_h]) cube([tg_t, 2*yk, flap_h + tg_wide_z + 1]);        // languette + bas, entre les oreilles
            translate([0, -tg_w/2, tg_wide_z])
                cube([tg_t, tg_w, hinge_z + tg_up - tg_wide_z]);                            // partie visée
            for (y0 = [yk - knuckle_w, -yk]) intersection() {                               // charnons oblongs
                translate([0, y0, -20]) cube([hinge_x + knuckle_r + 1, knuckle_w, 40]);
                hull() for (dz = [0.6, -lift]) {
                    translate([tg_t - 1, y0, hinge_z + dz - knuckle_r])
                        cube([hinge_x - tg_t + 1, knuckle_w, 2*knuckle_r]);
                    translate([hinge_x, y0, hinge_z + dz]) rotate([-90, 0, 0])
                        cylinder(r = knuckle_r, h = knuckle_w);
                }
            }
        }
        for (s = [-1, 1])                                                                   // lumières des charnons, borgnes côté intérieur
            hull() for (dz = [0.6, -lift]) translate([hinge_x, s > 0 ? yk - knuckle_w + 1 : -yk - 0.5, hinge_z + dz])
                rotate([-90, 0, 0]) cylinder(d = hinge_d, h = knuckle_w - 0.5);
        translate([-1, -post_w/2 - 0.5, -flap_h - 1]) cube([tg_t + 2, post_w + 1, flap_h + 1.5]);   // passage de la nervure centrale
        // mire gravée sur la face visée : un trait horizontal, deux verticaux
        translate([tg_t - 0.4, -32, mire_z - 0.4]) cube([1, 64, 0.8]);
        for (y = [-16, 16]) translate([tg_t - 0.4, y - 0.4, mire_z - 16]) cube([1, 0.8, 32]);
    }
}

// ---------- assemblage (visualisation) ----------
pos = -1;              // position imposée du coulisseau, de 0 (butée arrière) à 1 (butée avant) ; -1 = selon `plie`
xs = pos >= 0 ? xs_min + pos*travel : plie ? xs_min : xs_min + travel/2;

module roue() {
    r = wheel_od/2;
    rotate_extrude() polygon([[2.5, -wheel_w/2], [r - wheel_ch, -wheel_w/2], [r, -wheel_flat/2],
                              [r, wheel_flat/2], [r - wheel_ch, wheel_w/2], [2.5, wheel_w/2]]);
}
module asm_coulisseau() { translate([xs, 0, z_sb]) coulisseau(); }
module asm_cible() {
    translate([xs + sl_front, 0, z_sb + sl_t])
        if (plie) translate([hinge_x, 0, hinge_z]) rotate([0, -90, 0]) translate([-hinge_x, 0, -hinge_z]) cible();
        else cible();
}
module asm_poulie()     { translate([axle_x, pul_w/2, axle_z]) rotate([90, 0, 0]) poulie(); }
module asm_roues()      { for (x = [wheel_x0, wheel_x0 + wheel_px], s = [-1, 1])
                              translate([xs + x, s*wheel_y, wheel_z]) roue(); }
bob_y = post_w/2 + elev_w + cap_l;         // bout extérieur des chapeaux
module sur_axe() { translate([xs + sl_front + pin_x, 0, z_sb + sl_t + pin_z]) children(); }
module asm_bobines() {
    sur_axe() {
        translate([0,  post_w/2, 0]) rotate([-90, 0, 0]) bobine(ecrou = true);
        translate([0, -post_w/2, 0]) rotate([ 90, 0, 0]) bobine(ecrou = false);
    }
}
module asm_axe() {       // vis CHC M5×80 : tête noyée dans un chapeau, écrou frein noyé dans l'autre
    sur_axe() rotate([-90, 0, 0]) {
        translate([0, 0, -bob_y + 0.5]) cylinder(d = 8.5, h = 5, $fn = 24);
        translate([0, 0, -bob_y + 5.5]) cylinder(d = 5, h = screw_l, $fn = 24);
        translate([0, 0, bob_y - pocket - 1 + 0.2]) cylinder(d = 9, h = 5, $fn = 6);
    }
}
module asm_axe_poulie() {       // vis CHC M5×40, écrou frein, roulement 625 et ses deux entretoises
    translate([axle_x, 0, axle_z]) rotate([-90, 0, 0]) {
        translate([0, 0, -base_w/2 + axle_hd - 5]) cylinder(d = 8.5, h = 5, $fn = 24);
        translate([0, 0, -base_w/2 + axle_hd]) cylinder(d = 5, h = axle_l, $fn = 24);
        translate([0, 0, base_w/2 - axle_nd]) cylinder(d = 9, h = 5, $fn = 6);
        translate([0, 0, -2.5]) difference() { cylinder(d = 16, h = 5, $fn = 48); translate([0, 0, -1]) cylinder(d = 8.4, h = 7, $fn = 24); }
        for (s = [-1, 1]) translate([0, 0, s*(2.5 + spacer_h/2) - spacer_h/2]) cylinder(d = 8, h = spacer_h, $fn = 24);
    }
}
module asm_vis_charnieres() {   // vis M3×12 à tête bombée : tête sur le flanc de l'oreille, écrou frein sur sa face intérieure
    translate([xs + sl_front + hinge_x, 0, z_sb + sl_t + hinge_z]) for (s = [-1, 1]) rotate([90*s, 0, 0]) {
        translate([0, 0, -sl_w/2 - 1.65]) cylinder(d = 5.7, h = 1.65, $fn = 24);
        translate([0, 0, -sl_w/2]) cylinder(d = 3, h = 12, $fn = 16);
        translate([0, 0, -sl_w/2 + ear_t - ear_nut]) cylinder(d = 6.3, h = ear_nut, $fn = 6);
    }
}
module asm_divers() {
    asm_axe();
    asm_axe_poulie();
    asm_vis_charnieres();
    if (!plie) {   // cordelette : du haut de la poulie à la fente du coulisseau, dans le canal, puis brin vertical vers la poche
        dx = xs + knot_x - axle_x; dz = z_sb + 1 - z_cord;
        translate([axle_x, 0, z_cord]) rotate([0, atan2(dx, dz), 0]) cylinder(d = cord_d, h = norm([dx, dz]), $fn = 12);
        translate([axle_x - groove_r - cord_d/2, 0, axle_z - 120]) cylinder(d = cord_d, h = 120, $fn = 12);
    }
}
// Illustration de l'accrochage (rien à imprimer) : les deux élévateurs posés à plat,
// leur boucle de base sur une bobine, entre la joue et le plot, la sangle partant vers la voile.
module asm_elevateurs() {
    sur_axe() for (s = [-1, 1]) translate([0, s*(post_w/2 + elev_w/2), 0]) {
        rotate([-90, 0, 0]) translate([0, 0, -12.5]) difference() {      // boucle autour de la bobine
            cylinder(d = bob_d + 2*elev_t, h = 25, $fn = 32);
            translate([0, 0, -1]) cylinder(d = bob_d + 0.6, h = 27, $fn = 32);
        }
        translate([4, -12.5, -elev_t/2]) cube([150, 25, elev_t]);        // sangle à plat, vers la voile
    }
}
module asm_table() { translate([0, -110, -45]) cube([300, 220, 45]); }

module assemblage() {
    color("DodgerBlue") socle();
    color("DeepSkyBlue") asm_coulisseau();
    color("White") asm_cible();
    color("Gainsboro") asm_poulie();
    color("DimGray") asm_roues();
    color("White") asm_bobines();
    color("OrangeRed") asm_divers();
    if (!plie) %asm_table();
}

// Les pièces sortent orientées pour l'impression, sans support.
if (part == "socle")            translate([0, 0, T]) rotate([180, 0, 0]) socle();   // dessus sur le plateau
else if (part == "coulisseau")  coulisseau();                                       // dessous sur le plateau
else if (part == "poulie")      poulie();
else if (part == "cible")       rotate([0, -90, 0]) cible();                        // dos sur le plateau
// Une pièce par fichier : les deux bobines séparées, et les 8 entretoises réunies en grappe par une barrette
// à couper au cutter (un service d'impression refuse les pièces minuscules).
else if (part == "bobine_tete")   bobine(ecrou = false);
else if (part == "bobine_ecrou")  bobine(ecrou = true);
else if (part == "entretoises_grappe") {
    for (i = [0 : n_spacer - 1]) translate([i*10, 0, 0]) entretoise();
    translate([-4, 3.6, 0]) cube([(n_spacer - 1)*10 + 8, 2, 1.5]);
}
else if (part == "asm_socle")      socle();
else if (part == "asm_coulisseau") asm_coulisseau();
else if (part == "asm_cible")      asm_cible();
else if (part == "asm_poulie")     asm_poulie();
else if (part == "asm_roues")      asm_roues();
else if (part == "asm_divers")     asm_divers();
else if (part == "asm_table")      asm_table();
else if (part == "asm_elevateurs") asm_elevateurs();
else if (part == "asm_bobines")    asm_bobines();
else if (part == "x_socle_coulisseau") intersection() { socle(); asm_coulisseau(); }
else if (part == "x_socle_poulie")     intersection() { socle(); asm_poulie(); }
else if (part == "x_socle_roues")      intersection() { socle(); asm_roues(); }
else if (part == "x_coulisseau_cible") intersection() { asm_coulisseau(); asm_cible(); }
else if (part == "x_coulisseau_bobines")    intersection() { asm_coulisseau(); asm_bobines(); }
else if (part == "x_coulisseau_elevateurs") intersection() { asm_coulisseau(); asm_elevateurs(); }
else if (part == "x_cible_vis")        intersection() { asm_cible(); asm_vis_charnieres(); }
else if (part == "x_cible_reste")      intersection() { asm_cible(); union() { socle(); asm_poulie(); asm_roues(); asm_axe(); asm_bobines(); } }
else assemblage();
