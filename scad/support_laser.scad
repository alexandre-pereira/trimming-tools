// ============================================================
//  Support du télémètre laser, côté voile — reprise de votre « TEST.stl ».
//
//  Même principe : le télémètre est couché dans une auge ouverte à l'avant ; sous l'avant,
//  un bec plat descend sous le fond et porte une encoche. La suspente passe dans l'encoche,
//  sa patte d'attache, trop grosse, bute contre le bec : sous 5 kg, la suspente reste dans
//  l'axe du faisceau. Lecture du laser + constante = longueur de la suspente.
//
//  Ce qui change par rapport à TEST.stl :
//   - cotes du télémètre en paramètres : largeur, longueur, épaisseur ;
//   - parois moins hautes que le télémètre (moins_epais), pour le saisir et atteindre ses boutons ;
//   - dégagement réglable dans une paroi pour les boutons placés sur le côté ;
//   - encoche renforcée : une bande épaisse court le long des deux bords du bec et sous
//     l'encoche, et le bec lui-même est plus épais ;
//   - fond du bec arrondi, entrée en V, deux rainures pour un élastique, trou de dragonne.
//
//  Repère : y = sens du faisceau, face arrière du support en y = 0 ; z vers le haut, dessous
//  du fond en z = 0. Le bec est à l'avant (y = len), ses faces sont perpendiculaires au faisceau.
//  S'imprime debout sur la face avant du bec, sans support.
// ============================================================

// --- Télémètre : à mesurer au pied à coulisse (valeurs reprises de TEST.stl) ---
laser_w = 34.5;    // largeur
laser_l = 78.5;    // longueur
laser_h = 18;      // épaisseur
fit     = 0.5;     // jeu en largeur et en longueur
moins_epais = 3;   // les parois s'arrêtent à cette hauteur sous le dessus du télémètre

// --- Boutons sur le côté du télémètre : la paroi est abaissée en face d'eux ---
btn_cote = 0;      // 0 : aucun ; 1 : côté droit (x grand) ; -1 : côté gauche ; 2 : les deux
btn_y0   = 20;     // début du dégagement, depuis la face arrière du télémètre
btn_len  = 25;     // longueur du dégagement
btn_h    = 4;      // hauteur de paroi conservée sous le dégagement

// --- Auge ---
wall    = 3;       // parois
floor_t = 3;       // fond
r_ext   = 2;       // arrondi des arêtes verticales

// --- Bec et encoche (le bec reprend les 5 kg de la suspente) ---
bec_t    = 5;      // épaisseur du bec (4 sur TEST.stl)
bec_drop = 11;     // descente du bec sous le fond
bec_bas  = 14;     // largeur du bec en bas
slit_w   = 3;      // largeur de l'encoche : la suspente passe, la patte (ou son nœud) non
slit_d   = 2.5;    // profondeur de la partie droite de l'encoche, au-dessus du V d'entrée
v_w      = 7;      // V d'entrée : largeur en bas…
v_d      = 2;      // …et profondeur
band     = 4;      // bande de renfort : largeur le long des bords du bec…
band_t   = 4;      // …et surépaisseur vers l'arrière (le bec fait bec_t + band_t sur ses bords)

// --- Divers ---
elastique = true;  // deux rainures autour du support pour un élastique qui tient le télémètre
el_w = 3; el_d = 1;
el_pos = [0.3, 0.72];   // position des rainures, en fraction de la longueur
drag = 4;          // trou de dragonne dans la face arrière

// --- Valeurs dérivées ---
W      = laser_w + fit;
L      = laser_l + fit;
tray_w = W + 2*wall;
len    = wall + L;                     // face avant du bec = face avant du télémètre, au jeu près
wall_h = laser_h - moins_epais;
H      = floor_t + wall_h;
cx     = tray_w/2;                     // axe du faisceau et de l'encoche

$fn = 48;

module prism_y(y0, w) { translate([0, y0 + w, 0]) rotate([90, 0, 0]) linear_extrude(w) children(); }

module bec_profil() polygon([[0, 0], [tray_w, 0], [cx + bec_bas/2, -bec_drop], [cx - bec_bas/2, -bec_drop]]);

module encoche_profil() {
    zb = -bec_drop;
    polygon([[cx - v_w/2, zb - 1], [cx + v_w/2, zb - 1], [cx + slit_w/2, zb + v_d], [cx - slit_w/2, zb + v_d]]);
    translate([cx - slit_w/2, zb + v_d - 0.1]) square([slit_w, slit_d + 0.1]);
    translate([cx, zb + v_d + slit_d]) circle(d = slit_w, $fn = 24);
}

module bec() {
    difference() {
        union() {
            prism_y(len - bec_t, bec_t) bec_profil();                                   // plaque
            intersection() {                                                            // bande de renfort, sous le fond seulement
                prism_y(len - bec_t - band_t, band_t) difference() { bec_profil(); offset(delta = -band) bec_profil(); }
                translate([-1, 0, -bec_drop - 1]) cube([tray_w + 2, len + 1, bec_drop + 1]);
            }
        }
        prism_y(len - bec_t - band_t - 1, bec_t + band_t + 2) encoche_profil();          // encoche, à travers plaque et bande
    }
}

module support_laser() {
    difference() {
        union() {
            linear_extrude(H) offset(r = r_ext) offset(delta = -r_ext) square([tray_w, len]);   // bloc de l'auge
            bec();
        }
        translate([wall, wall, floor_t]) cube([W, L + 1, H]);                                // logement, ouvert à l'avant
        // dégagement des boutons latéraux
        for (s = btn_cote == 2 ? [-1, 1] : btn_cote == 0 ? [] : [btn_cote])
            translate([s > 0 ? tray_w - wall - 1 : -1, wall + btn_y0, floor_t + btn_h]) cube([wall + 2, btn_len, H]);
        // trou de dragonne dans la face arrière
        translate([cx, -1, floor_t + wall_h/2]) rotate([-90, 0, 0]) cylinder(d = drag, h = wall + 2);
        // rainures pour l'élastique, autour des parois et du fond
        if (elastique) for (f = el_pos) translate([0, f*len - el_w/2, 0]) difference() {
            translate([-1, 0, -1]) cube([tray_w + 2, el_w, H + 2]);
            translate([el_d, -1, el_d]) cube([tray_w - 2*el_d, el_w + 2, H + 2]);
        }
    }
}

// orientation d'impression : debout sur la face avant du bec (la face qui regarde la cible)
translate([0, 0, len]) rotate([-90, 0, 0]) support_laser();
