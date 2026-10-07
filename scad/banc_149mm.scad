// ============================================================
//  Banc de calage parapente compact et court, à poser sur un chant de table
//  (même principe que l'EasyTrim) — laser + poche à eau de 5 kg.
//
//  Version « glissière inversée » : 100 mm de course pour 149 mm de long.
//  Les 4 roues en V sont fixées sur le socle, court, accroché au bord de la table.
//  Le coulisseau est un rail en U (la glissière) qui roule sur ces roues et peut
//  dépasser du socle des deux côtés, comme un tiroir. Il porte le plateau :
//  bobines des élévateurs, couloirs, cible articulée et verrouillée.
//  La version précédente (roues sur le coulisseau, 210 mm) est dans banc_210mm.scad.
//
//  Repère : x = axe de traction, +x vers la voile ; chant de la table en x = 0 ;
//  dessus de la table en z = 0. La poche à eau pend en x < 0.
// ============================================================

part = "assemblage";   // socle | glissiere | plateau | poulie | cible | petites_pieces | assemblage
plie = false;          // assemblage : true = cible rabattue, coulisseau rentré (transport)
xs_o = -999;           // assemblage : position imposée du coulisseau (sinon mi-course, ou rentré si plie)

// --- Socle ---
T        = 10;     // épaisseur ; le dessus est plat, il s'imprime retourné
base_w   = 50;     // largeur
travel   = 100;    // course du coulisseau
lug_drop = 12;     // hauteur du crochet sous le dessus de la table
lug_len  = 30;     // avancée des joues devant le chant (elles dépassent la poulie pour la protéger)
slot_w   = 11.8;   // fente de la poulie entre les joues (roulement 5 + une entretoise de chaque côté + jeu)

// --- Roues V Ø24 pour profilé V-slot (2 roulements 625), fixées debout sur le socle ---
wheel_od   = 23.9;
wheel_w    = 10.23;
wheel_flat = 5.9;    // largeur du méplat de la bande de roulement
wheel_px   = 32;     // entraxe longitudinal. Longueur du coulisseau = course + entraxe + 17 mm
wheel_x1   = 14;     // roues arrière, depuis le chant de la table
wheel_yb   = 18;     // demi-écartement des axes
adj        = 1;      // côté -y : trous oblongs de ±1 mm pour régler le jeu des roues
nut_p      = 4.2;    // logement des écrous M5 sous le socle
spacer_h   = 3.3;    // entretoises imprimées de la poulie
groove_flat  = 5.0;  // fond de la rainure des rails, plus étroit que le méplat :
groove_depth = 3.0;  // la roue porte sur ses chanfreins, pas sur le fond
chan_w   = 10;     // canal du socle où circule le taquet de butée de la glissière
chan_z   = 5;      // fond de ce canal

// --- Glissière : rail en U (âme + 2 rails) qui roule sur les roues ---
web_t    = 2.4;    // âme, sur laquelle se visse le plateau
rail_t   = 7;      // épaisseur des rails
rail_z0  = 3;      // bas des rails au-dessus de la table
end_t    = 3;      // cloison arrière : butée de fin de course côté voile
blk_w    = 8;      // taquet avant : attache de la cordelette et butée côté poche
blk_l    = 12;
acc_d    = 12;     // trous d'accès aux vis des roues, dans l'âme
xs_acc   = 34;     // position du coulisseau où ces trous sont au-dessus des roues

// --- Plateau (vissé sur la glissière) ---
sl_t     = 8;      // épaisseur
sl_w     = 84.8;   // largeur
sl_front = 48;     // face avant, dans le repère du coulisseau
fix_x    = [-35, 30];   // vis M3 fraisées qui tiennent le plateau sur les rails

// --- Accrochage des 2 élévateurs : nervure centrale traversée par une vis M5, une bobine de chaque côté ---
// Les élévateurs sont posés à plat. Leur boucle de base se passe par-dessus le chapeau de la bobine,
// sans rien dévisser ; la sangle se couche ensuite dans son couloir, entre la nervure centrale et une joue.
// La vis est montée une fois pour toutes ; sa tête et son écrou sont noyés dans les chapeaux :
// la sangle ne touche que du plastique lisse, et aucune pièce ne se démonte à l'usage.
elev_w   = 26;     // longueur utile d'une bobine = largeur de la sangle de l'élévateur + 1 mm
post_w   = 16;     // largeur de la nervure centrale
pin_d    = 5.3;    // passage de la vis M5
pin_x    = 24;     // position de l'axe des bobines devant la face avant
pin_z    = 1;      // hauteur de l'axe au-dessus du dessus du plateau
boss_r   = 7;      // bossage de la nervure autour de l'axe
bob_d    = 9;      // diamètre des bobines, sur lesquelles porte la sangle
bob_fl   = 14;     // diamètre du chapeau
screw_l  = 80;     // vis CHC M5×80 (tête cylindrique à six pans creux)
pocket   = 6;      // logement de la tête (Ø8,5 × 5) ou de l'écrou frein (5 mm) dans le chapeau
cap_l    = (screw_l - 5.5 - 2*elev_w - post_w)/2 + pocket;   // longueur d'un chapeau (≈ 9,25)
cone_l   = (bob_fl - bob_d)/2;                               // raccord conique à 45° entre bobine et chapeau

// --- Avant du plateau : plancher sous les bobines, puis deux couloirs qui tiennent les élévateurs à plat ---
tray_l   = 54;     // longueur devant la face avant
floor_t  = 1.8;    // plancher sous les bobines (la boucle passe entre la bobine et lui)
tray_t   = 3;      // fond des couloirs
ch_x0    = pin_x + bob_fl/2 + 3;   // début des couloirs, juste devant les chapeaux
fence_t  = 3;      // épaisseur des joues
fence_z  = 5;      // hauteur des joues au-dessus du dessus du plateau
fence_y  = post_w/2 + elev_w + 0.5;   // face intérieure des joues extérieures

// --- Poulie (1 roulement 625ZZ, axe M5) ---
pul_r   = 13;
pul_w   = 10;
cord_d  = 2;       // cordelette de 2 mm
axle_d  = 5.3;     // passage de la vis M5 (CHC M5×60 à tige partiellement filetée : le roulement porte sur la partie lisse)

// --- Cible articulée à l'avant du plateau, verrouillée d'équerre quand elle est relevée ---
// Relevée et poussée vers le bas, sa languette se coince entre la face avant du plateau et une
// lèvre inclinée : elle ne peut basculer ni en avant ni en arrière. Pour la rabattre, on la soulève
// de `lift` (les charnons ont une lumière), puis on la couche sur le plateau.
tg_t      = 3;     // épaisseur de la plaque
tg_w      = 84;    // largeur de la partie haute
tg_up     = 90;    // hauteur au-dessus de l'axe de charnière
tg_wide_z = 11;    // la plaque s'élargit au-dessus des oreilles
hinge_x   = 3.5;   // axe de charnière : en avant de la face avant du plateau…
hinge_z   = 4;     // …et au-dessus de son dessus. hinge_z - hinge_x = jeu de la cible rabattue (0,5)
ear_t     = 6;     // oreilles du plateau
ear_r     = 4;
knuckle_w = 7;     // charnons de la cible
knuckle_r = 3.5;
hinge_d   = 3.4;   // lumière des charnons, pour la moitié lisse de la goupille Ø3
ear_d     = 3.0;   // trou des oreilles, pour une goupille cannelée Ø3 × 12 (DIN 1474) : sa moitié cannelée
                   // mord dans l'oreille et ne ressort pas ; sa moitié lisse sert d'axe à la cible.
                   // Les lumières des charnons sont borgnes côté intérieur : la goupille ne peut pas non plus rentrer.
lift      = 5.5;   // course de soulèvement pour déverrouiller
flap_h    = 5.5;   // languette de verrouillage, sous le dessus du plateau
lip_top   = 1.5;   // sommet de la lèvre, sous le dessus du plateau
lip_y0    = post_w/2 + 1;    // la lèvre court de la nervure centrale…
lip_y1    = 28;              // …jusqu'avant les charnons
mire_z    = 45;    // hauteur de la mire gravée : viser toujours le trait horizontal

// --- Valeurs dérivées ---
wheel_ch = (wheel_w - wheel_flat) / 2;                    // chanfrein de la roue
wheel_x2 = wheel_x1 + wheel_px;                           // roues avant
wheel_z  = T + wheel_w/2;                                 // plan de roulement : les roues sont posées sur le socle
rail_y   = wheel_yb + wheel_od/2 + wheel_flat/2
           - groove_flat/2 - groove_depth;                // face intérieure des rails (≈ 26,4)
base_l   = wheel_x2 + wheel_od/2 + 4;                     // longueur du socle sur la table (≈ 62)
z_web    = T + wheel_w + 3.6;                             // dessous de l'âme : passe au-dessus des têtes de vis des roues
z_sb     = z_web + web_t;                                 // dessous du plateau
sl_len   = wheel_px + travel + wheel_od/2 + end_t + 2;    // longueur du coulisseau (≈ 149)
sl_rear  = sl_len - sl_front - tray_l;                    // arrière du coulisseau, dans son repère
xs_max   = wheel_x1 - wheel_od/2 + sl_rear - end_t;       // butée côté voile : la cloison arrière touche les roues arrière
xs_min   = xs_max - travel;                               // butée côté poche : le taquet touche le bout du canal
xs_plie  = sl_rear - lug_len;                             // rentré : l'arrière du coulisseau à l'aplomb des joues
chan_x0  = wheel_x1 + wheel_od/2 + 4;                     // bout du canal de butée, entre les deux paires de roues
blk_x    = chan_x0 - xs_min;                              // face arrière du taquet, dans le repère du coulisseau
axle_z   = T - 4.5;                                       // axe de poulie (joues affleurant le dessus du socle)
axle_x   = -(pul_r + 1.5);
groove_r = 9.9;                                           // rayon de fond de gorge de la poulie
cord_z   = axle_z + groove_r + cord_d/2;                  // hauteur du brin horizontal de la cordelette
pul_top  = axle_z + pul_r;
yk       = sl_w/2 - ear_t - 0.4;                          // bord extérieur des charnons de la cible

$fn = 72;

// prismes : profil (y, z) extrudé le long de x, et profil (x, z) extrudé le long de y
module prism_x(len, pts)   { rotate([90, 0, 90]) linear_extrude(len) polygon(pts); }
module prism_y(y0, w, pts) { translate([0, y0 + w, 0]) rotate([90, 0, 0]) linear_extrude(w) polygon(pts); }

// logement d'écrou M5 (8 sur plats), méplats parallèles à y pour pouvoir coulisser dans un trou oblong
module nut_m5(h) { rotate([0, 0, 30]) cylinder(d = 8.3 / cos(30), h = h, $fn = 6); }

module socle() {
    b = base_w/2;
    lug_w = (base_w - slot_w)/2;
    difference() {
        union() {
            translate([0, -b, 0]) cube([base_l, base_w, T]);                    // bloc posé sur la table
            for (y0 = [slot_w/2, -b])                                           // joues de poulie + crochets de table
                prism_y(y0, lug_w, [[1, T], [-lug_len, T], [-lug_len, -2], [-lug_len + 10, -lug_drop],
                                    [0, -lug_drop], [0, 0], [1, 0]]);
        }
        // axe de poulie M5
        translate([axle_x, -b - 1, axle_z]) rotate([-90, 0, 0]) cylinder(d = axle_d, h = base_w + 2);
        // canal de butée : le taquet de la glissière y circule et bute au fond, entre les deux paires de roues
        translate([chan_x0, -chan_w/2, chan_z]) cube([base_l, chan_w, T]);
        for (x = [wheel_x1, wheel_x2]) {
            // côté +y : position fixe
            translate([x, wheel_yb, -1]) cylinder(d = 5.3, h = T + 2);
            translate([x, wheel_yb, -1]) nut_m5(nut_p + 1);
            translate([x, wheel_yb, T - 0.6]) difference() {                    // dégagement : seule la bague intérieure porte
                cylinder(d = wheel_od + 3, h = 1);
                translate([0, 0, -1]) cylinder(d = 9.5, h = 3);
            }
            // côté -y : trous oblongs, pour plaquer les roues dans les rainures avant de serrer
            hull() for (dy = [-adj, adj]) translate([x, -wheel_yb + dy, -1]) cylinder(d = 5.3, h = T + 2);
            hull() for (dy = [-adj, adj]) translate([x, -wheel_yb + dy, -1]) nut_m5(nut_p + 1);
            difference() {
                hull() for (dy = [-adj, adj]) translate([x, -wheel_yb + dy, T - 0.6]) cylinder(d = wheel_od + 3, h = 1);
                hull() for (dy = [-adj, adj]) translate([x, -wheel_yb + dy, T - 1.6]) cylinder(d = 9.5, h = 3);
            }
        }
    }
}

// Glissière. Repère du coulisseau : z = 0 au-dessus de l'âme (= dessous du plateau), face avant du plateau en x = sl_front.
module glissiere() {
    h  = z_sb - rail_z0;                 // hauteur totale sous le dessus de l'âme
    zc = wheel_z - z_sb;                 // plan de roulement
    gf = groove_flat/2; gd = groove_depth;
    difference() {
        union() {
            translate([-sl_rear, -sl_w/2, -web_t]) cube([sl_len, sl_w, web_t]);                     // âme
            for (y0 = [rail_y, -rail_y - rail_t])
                translate([-sl_rear, y0, -h]) cube([sl_len, rail_t, h - 0.1]);                      // rails
            translate([-sl_rear, -rail_y - 0.5, -(z_sb - T - 0.5)])
                cube([end_t, 2*rail_y + 1, z_sb - T - 0.6]);                                        // cloison arrière
            translate([blk_x, -blk_w/2, -(z_sb - chan_z - 0.5)])
                cube([blk_l, blk_w, z_sb - chan_z - 0.6]);                                          // taquet avant
        }
        // rainures en V sur la face intérieure des deux rails, ouvertes à l'avant
        for (s = [-1, 1]) translate([-sl_rear + end_t, 0, 0]) scale([1, s, 1])
            prism_x(sl_len, [[rail_y - 1, zc + gf + gd + 1], [rail_y + gd, zc + gf],
                             [rail_y + gd, zc - gf], [rail_y - 1, zc - gf - gd - 1]]);
        // la cloison arrière passe au-dessus de la poulie
        translate([-sl_rear - 1, -6.5, -h - 1]) cube([end_t + 2, 13, h + 1 - (z_sb - pul_top - 1)]);
        // cordelette : elle traverse le taquet ; son nœud bute sur la face avant du taquet, accessible par l'avant
        translate([blk_x - 1, 0, cord_z - z_sb]) rotate([0, 90, 0]) cylinder(d = 3.5, h = blk_l + 2);
        // accès aux vis des roues quand le coulisseau est en xs_acc
        for (x = [wheel_x1, wheel_x2], s = [-1, 1])
            translate([x - xs_acc, s*wheel_yb, -web_t - 1]) cylinder(d = acc_d, h = web_t + 2);
        // avant-trous des vis M3 du plateau, dans les rails
        for (x = fix_x, s = [-1, 1])
            translate([x, s*(rail_y + rail_t/2), -12]) cylinder(d = 2.6, h = 13);
    }
}

// Plateau. Même repère : z = 0 au-dessous, face avant en x = sl_front.
module plateau() {
    hx = sl_front + hinge_x;      // axe de charnière
    px = sl_front + pin_x;        // axe des bobines
    cx = sl_front + ch_x0;        // début des couloirs
    cl = tray_l - ch_x0;          // leur longueur
    lip = [[sl_front + tg_t - 0.1, floor_t - 0.1], [sl_front + tg_t + 0.6, sl_t - lip_top],
           [sl_front + tg_t + 2.8, sl_t - lip_top], [sl_front + tg_t + 2.8, floor_t - 0.1]];
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
            for (y0 = [sl_w/2 - ear_t, -sl_w/2]) {                                             // oreilles de charnière
                translate([sl_front - 2, y0, 0]) cube([2 + hinge_x + ear_r, ear_t, sl_t + hinge_z]);
                translate([hx, y0, sl_t + hinge_z]) rotate([-90, 0, 0]) cylinder(r = ear_r, h = ear_t);
            }
        }
        // axe de charnière : logements des goupilles Ø3 dans les oreilles
        translate([hx, -sl_w, sl_t + hinge_z]) rotate([-90, 0, 0]) cylinder(d = ear_d, h = 2*sl_w);
        // axe des bobines : vis M5 à travers la nervure
        translate([px, -post_w, sl_t + pin_z]) rotate([-90, 0, 0]) cylinder(d = pin_d, h = 2*post_w);
        // vis M3 fraisées de fixation sur les rails de la glissière
        for (x = fix_x, s = [-1, 1]) translate([x, s*(rail_y + rail_t/2), 0]) {
            translate([0, 0, -1]) cylinder(d = 3.4, h = sl_t + 2);
            translate([0, 0, sl_t - 1.8]) cylinder(d1 = 3.4, d2 = 7, h = 1.81);
        }
    }
}

// Bobine d'un élévateur : tube lisse sur lequel porte la sangle, raccord conique, puis chapeau
// qui retient la sangle et cache la tête de vis (ecrou = false) ou l'écrou frein (ecrou = true).
// S'imprime debout, le tube sur le plateau d'impression, sans support ni pontage.
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
        if (ecrou) translate([0, 0, h - pocket]) cylinder(d = 8.3 / cos(30), h = pocket + 1, $fn = 6);
        else       translate([0, 0, h - pocket]) cylinder(d = 9.2, h = pocket + 1);
    }
}

// Entretoise imprimée : une de chaque côté du roulement de poulie. Elle ne porte que sur sa bague intérieure.
module entretoise() {
    difference() {
        cylinder(d = 8, h = spacer_h);
        translate([0, 0, -1]) cylinder(d = 5.3, h = spacer_h + 2);
    }
}

module poulie() {
    gw = cord_d + 0.6;
    difference() {
        cylinder(r = pul_r, h = pul_w);
        translate([0, 0, pul_w/2]) rotate_extrude()                             // gorge en V à 45° (imprimable sans support)
            polygon([[groove_r, -gw/2], [pul_r + 1, -gw/2 - (pul_r + 1 - groove_r)],
                     [pul_r + 1,  gw/2 + (pul_r + 1 - groove_r)], [groove_r, gw/2]]);
        translate([0, 0, 2.5]) cylinder(d = 16.15, h = pul_w);                  // logement du 625, emmanché
        translate([0, 0, -1])  cylinder(d = 13.5, h = 5);                       // lèvre de retenue de 2,5 mm
    }
}

// Cible relevée et verrouillée. Origine : face avant du plateau en x = 0, dessus du plateau en z = 0.
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
xs = (xs_o > -900) ? xs_o : (plie ? xs_plie : (xs_min + xs_max)/2);

module roue() {
    r = wheel_od/2;
    rotate_extrude() polygon([[2.5, -wheel_w/2], [r - wheel_ch, -wheel_w/2], [r, -wheel_flat/2],
                              [r, wheel_flat/2], [r - wheel_ch, wheel_w/2], [2.5, wheel_w/2]]);
}
module asm_glissiere() { translate([xs, 0, z_sb]) glissiere(); }
module asm_plateau()   { translate([xs, 0, z_sb]) plateau(); }
module asm_cible() {
    translate([xs + sl_front, 0, z_sb + sl_t])
        if (plie) translate([hinge_x, 0, hinge_z]) rotate([0, -90, 0]) translate([-hinge_x, 0, -hinge_z]) cible();
        else cible();
}
module asm_poulie()     { translate([axle_x, pul_w/2, axle_z]) rotate([90, 0, 0]) poulie(); }
module asm_roues()      { for (x = [wheel_x1, wheel_x2], s = [-1, 1]) translate([x, s*wheel_yb, wheel_z]) roue(); }
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
        translate([0, 0, bob_y - pocket + 0.2]) cylinder(d = 9, h = 5, $fn = 6);
    }
}
module asm_vis_roues() { // vis M5×20 tête bombée, montées par-dessus
    for (x = [wheel_x1, wheel_x2], s = [-1, 1]) translate([x, s*wheel_yb, 0]) {
        translate([0, 0, 0.2]) cylinder(d = 5, h = T + wheel_w, $fn = 20);
        translate([0, 0, T + wheel_w]) cylinder(d = 9.5, h = 2.75, $fn = 24);
    }
}
module asm_divers() {
    asm_axe();
    asm_vis_roues();
    if (!plie) {   // cordelette : brin horizontal du taquet à la poulie, puis brin vertical vers la poche à eau
        translate([axle_x, 0, cord_z]) rotate([0, 90, 0])
            cylinder(d = cord_d, h = xs + blk_x - axle_x + 2, $fn = 12);
        translate([axle_x - groove_r - cord_d/2, 0, axle_z - 120]) cylinder(d = cord_d, h = 120, $fn = 12);
    }
}
// Illustration de l'accrochage (rien à imprimer) : les deux élévateurs posés à plat,
// leur boucle de base sur une bobine, la sangle dans son couloir, partant vers la voile.
module asm_elevateurs() {
    sur_axe() for (s = [-1, 1]) translate([0, s*(post_w/2 + elev_w/2), 0]) {
        rotate([-90, 0, 0]) translate([0, 0, -12.5]) difference() {      // boucle autour de la bobine
            cylinder(d = bob_d + 5, h = 25, $fn = 32);
            translate([0, 0, -1]) cylinder(d = bob_d + 0.6, h = 27, $fn = 32);
        }
        translate([4, -12.5, -2.5]) cube([150, 25, 4]);                  // sangle à plat, vers la voile
    }
}
module asm_table() { translate([0, -110, -45]) cube([280, 220, 45]); }

module assemblage() {
    color("DodgerBlue") socle();
    color("SteelBlue") asm_glissiere();
    color("DeepSkyBlue") asm_plateau();
    color("White") asm_cible();
    color("Gainsboro") asm_poulie();
    color("DimGray") asm_roues();
    color("White") asm_bobines();
    color("OrangeRed") asm_divers();
    if (!plie) %asm_table();
}

// Les pièces sortent orientées pour l'impression, sans support.
if (part == "socle")            translate([0, 0, T]) rotate([180, 0, 0]) socle();        // dessus sur le plateau d'impression
else if (part == "glissiere")   rotate([180, 0, 0]) glissiere();                         // âme sur le plateau d'impression, rails vers le haut
else if (part == "plateau")     plateau();                                               // dessous sur le plateau d'impression
else if (part == "poulie")      poulie();
else if (part == "cible")       rotate([0, -90, 0]) cible();                             // dos sur le plateau d'impression
else if (part == "petites_pieces") {                                                     // 2 bobines + 4 entretoises (2 utiles, 2 de rechange)
    bobine(ecrou = false); translate([bob_fl + 4, 0, 0]) bobine(ecrou = true);
    for (i = [0 : 3]) translate([i*12 - 9, -16, 0]) entretoise();
}
else if (part == "asm_socle")      socle();
else if (part == "asm_glissiere")  asm_glissiere();
else if (part == "asm_plateau")    asm_plateau();
else if (part == "asm_cible")      asm_cible();
else if (part == "asm_poulie")     asm_poulie();
else if (part == "asm_roues")      asm_roues();
else if (part == "asm_bobines")    asm_bobines();
else if (part == "asm_divers")     asm_divers();
else if (part == "asm_table")      asm_table();
else if (part == "asm_elevateurs") asm_elevateurs();
else if (part == "x_socle_glissiere") intersection() { socle(); asm_glissiere(); }
else if (part == "x_fixe_glissiere")  intersection() { union() { asm_poulie(); asm_vis_roues(); } asm_glissiere(); }
else if (part == "x_glissiere_plateau") intersection() { asm_glissiere(); asm_plateau(); }
else if (part == "x_plateau_cible")   intersection() { asm_plateau(); asm_cible(); }
else if (part == "x_cible_reste")     intersection() { asm_cible(); union() { socle(); asm_glissiere(); asm_poulie(); asm_roues(); asm_axe(); asm_bobines(); } }
else assemblage();
