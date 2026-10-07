// ============================================================
//  Calibre des goupilles : à imprimer AVANT le banc, sur la même imprimante et dans la même matière.
//
//  Les goupilles du banc tiennent par serrage dans des trous à six pans (axle_d et ear_d dans
//  banc.scad). Ce serrage se joue à quelques centièmes de millimètre, moins que la précision d'une
//  imprimante : la barrette reprend donc ces trous dans huit cotes, de 0,05 en 0,05 mm. On y essaie
//  ses goupilles, puis on reporte dans banc.scad la cote du trou où elles entrent à force et ne
//  bougent plus à la main.
//
//  Les trous sont imprimés comme sur le banc : axe horizontal, une pointe vers le haut, sur la même
//  longueur de prise. Le nombre gravé au-dessus d'un trou est sa cote sur plats en centièmes de
//  millimètre : 295 = 2,95 mm.
// ============================================================

pas = 0.05;   // écart de cote entre deux trous voisins
n   = 8;      // trous par goupille

// --- Goupille Ø5 de la poulie : le modèle vaut axle_d = 4,95 ---
d5_min   = 4.85;   // plus petite cote sur plats (la plus grande : d5_min + (n - 1)*pas = 5,20)
d5_prise = 15;     // longueur de prise dans une joue du socle
d5_h     = 12;     // hauteur de la barrette : 3 mm de matière au-dessus et au-dessous du trou
d5_e     = 10;     // entraxe des trous

// --- Goupilles Ø3 des charnières : le modèle vaut ear_d = 2,95 ---
d3_min   = 2.85;   // de 2,85 à 3,20
d3_prise = 6;      // épaisseur d'une oreille du coulisseau (ear_t)
d3_h     = 8;      // comme l'oreille : 4 mm de matière autour de l'axe (ear_r)
d3_e     = 9;

// --- Chiffres gravés, à 7 segments : lisibles en dépôt de fil, et sans police de caractères ---
ch_w = 2;      // largeur d'un chiffre
ch_h = 3.8;    // hauteur
ch_t = 0.65;   // largeur du trait
ch_g = 0.7;    // espace entre deux chiffres
ch_p = 0.5;    // profondeur de la gravure

// segments allumés de chaque chiffre : haut, haut droit, bas droit, bas, bas gauche, haut gauche, milieu
segs = [[1,1,1,1,1,1,0], [0,1,1,0,0,0,0], [1,1,0,1,1,0,1], [1,1,1,1,0,0,1], [0,1,1,0,0,1,1],
        [1,0,1,1,0,1,1], [1,0,1,1,1,1,1], [1,1,1,0,0,0,0], [1,1,1,1,1,1,1], [1,1,1,1,0,1,1]];

module chiffre(c) {
    m = (ch_h - ch_t)/2;
    pos = [[0, ch_h - ch_t, ch_w, ch_t], [ch_w - ch_t, m, ch_t, m + ch_t], [ch_w - ch_t, 0, ch_t, m + ch_t],
           [0, 0, ch_w, ch_t], [0, 0, ch_t, m + ch_t], [0, m, ch_t, m + ch_t], [0, m, ch_w, ch_t]];
    for (i = [0 : 6]) if (segs[c][i]) translate([pos[i][0], pos[i][1]]) square([pos[i][2], pos[i][3]]);
}

// nombre à trois chiffres, centré sur l'origine
module nombre(v) {
    c = [floor(v/100), floor(v/10) % 10, v % 10];
    translate([-(3*ch_w + 2*ch_g)/2, -ch_h/2, 0]) linear_extrude(ch_p + 1)
        for (i = [0 : 2]) translate([i*(ch_w + ch_g), 0]) chiffre(c[i]);
}

module barrette(d_min, prise, h, e) {
    difference() {
        cube([n*e, prise, h]);
        for (i = [0 : n - 1]) {
            d = d_min + i*pas;
            translate([(i + 0.5)*e, -1, h/2]) rotate([-90, 0, 0]) rotate([0, 0, 90])
                cylinder(d = d / cos(30), h = prise + 2, $fn = 6);                  // six pans, une pointe vers le haut
            translate([(i + 0.5)*e, prise/2, h - ch_p]) nombre(round(d*100));
        }
    }
}

// Les deux barrettes bout à bout, à plat sur le plateau : les trous débouchent des deux côtés,
// pour chasser une goupille essayée.
barrette(d5_min, d5_prise, d5_h, d5_e);
translate([n*d5_e, 0, 0]) barrette(d3_min, d3_prise, d3_h, d3_e);
