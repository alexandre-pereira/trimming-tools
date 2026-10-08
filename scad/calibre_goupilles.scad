// ============================================================
//  Calibre des goupilles : à imprimer AVANT le banc, sur la même imprimante et dans la même matière.
//
//  Les goupilles du banc sont cannelées sur la moitié de leur longueur, et leurs trous sont ronds, au
//  diamètre nominal (axle_d et ear_d dans banc.scad). Une imprimante sort un trou à un ou deux
//  dixièmes près, le plus souvent trop petit : la barrette reprend donc ces trous dans huit
//  diamètres, de 0,05 en 0,05 mm. On y essaie ses goupilles, puis on reporte dans banc.scad le
//  diamètre du plus petit trou où la moitié lisse entre sans forcer : la moitié cannelée, elle,
//  doit y entrer à force et ne plus ressortir à la main.
//
//  Les trous sont imprimés comme sur le banc : axe horizontal, même longueur de prise.
//  Le nombre gravé au-dessus d'un trou est son diamètre en centièmes de millimètre : 300 = 3,00 mm.
// ============================================================

pas = 0.05;   // écart de diamètre entre deux trous voisins
n   = 8;      // trous par goupille

// --- Goupille Ø5 de la poulie : le modèle vaut axle_d = 5,00 ---
d5_min   = 4.90;   // plus petit diamètre (le plus grand : d5_min + (n - 1)*pas = 5,25)
d5_prise = 15;     // longueur cannelée de la goupille Ø5 × 30
d5_h     = 12;     // hauteur de la barrette : 3,5 mm de matière au-dessus et au-dessous du trou
d5_e     = 10;     // entraxe des trous

// --- Goupilles Ø3 des charnières : le modèle vaut ear_d = 3,00 ---
d3_min   = 2.90;   // de 2,90 à 3,25
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
            translate([(i + 0.5)*e, -1, h/2]) rotate([-90, 0, 0]) cylinder(d = d, h = prise + 2, $fn = 72);
            translate([(i + 0.5)*e, prise/2, h - ch_p]) nombre(round(d*100));
        }
    }
}

// Les deux barrettes bout à bout, à plat sur le plateau : les trous débouchent des deux côtés,
// pour chasser une goupille essayée.
barrette(d5_min, d5_prise, d5_h, d5_e);
translate([n*d5_e, 0, 0]) barrette(d3_min, d3_prise, d3_h, d3_e);
