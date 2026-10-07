"""Coupes de contrôle tirées des maillages d'assemblage : profil (plan y = 0) et dessus (plan z donné).
Usage : python coupe.py <dossier asm> <sortie.png> [titre] [z de la coupe horizontale]"""
import re, sys
import numpy as np
from PIL import Image, ImageDraw, ImageFont

COUL = {"socle": (40, 120, 235), "coulisseau": (20, 150, 200), "cible": (150, 150, 150), "poulie": (110, 110, 110),
        "roues": (60, 60, 60), "divers": (230, 90, 20), "bobines": (190, 170, 60)}
f_tit = ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf", 22)
f_lab = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", 17)


def load(path):
    v = np.array(re.findall(r"vertex\s+(\S+)\s+(\S+)\s+(\S+)", open(path, encoding="utf8").read()), dtype=float)
    return v.reshape(-1, 3, 3)


def tranche(tris, axe, val):
    """Segments d'intersection des triangles avec le plan (coordonnée `axe` = val)."""
    d = tris[:, :, axe] - val
    segs = []
    for t, dd in zip(tris, d):
        pts = []
        for i in range(3):
            a, b = dd[i], dd[(i + 1) % 3]
            if (a < 0) != (b < 0):
                k = a / (a - b)
                pts.append(t[i] + k * (t[(i + 1) % 3] - t[i]))
        if len(pts) == 2:
            segs.append(pts)
    return segs


def dessine(dossier, sortie, titre, zc):
    parts = {k: load(dossier + "/asm_" + k + ".stl") for k in COUL}
    W, H, k = 1500, 900, 6.0
    im = Image.new("RGB", (W, H), "white"); dr = ImageDraw.Draw(im)
    dr.text((14, 10), titre, font=f_tit, fill=(0, 0, 0))
    # profil : x horizontal, z vertical
    X = lambda x: 260 + k * x
    Z = lambda z: 330 - k * z
    dr.text((14, 60), "Coupe de profil, dans l'axe (y = 0)", font=f_lab, fill=(0, 0, 0))
    dr.line([(X(0), Z(0)), (X(190), Z(0))], fill=(150, 110, 70), width=3)        # dessus de la table
    dr.line([(X(0), Z(0)), (X(0), Z(-25))], fill=(150, 110, 70), width=3)        # chant de la table
    for nom, tris in parts.items():
        for a, b in tranche(tris, 1, 0.05):
            dr.line([(X(a[0]), Z(a[2])), (X(b[0]), Z(b[2]))], fill=COUL[nom], width=2)
    # dessus : x horizontal, y vertical
    Y = lambda y: 690 - k * y
    dr.text((14, 470), "Coupe horizontale à z = %.1f mm (vue de dessus)" % zc, font=f_lab, fill=(0, 0, 0))
    for nom, tris in parts.items():
        for a, b in tranche(tris, 2, zc):
            dr.line([(X(a[0]), Y(a[1])), (X(b[0]), Y(b[1]))], fill=COUL[nom], width=2)
    x0 = 1180
    for i, nom in enumerate(COUL):
        dr.rectangle([x0, 70 + 26 * i, x0 + 18, 84 + 26 * i], fill=COUL[nom])
        dr.text((x0 + 26, 68 + 26 * i), {"divers": "visserie, cordelette"}.get(nom, nom), font=f_lab, fill=(0, 0, 0))
    im.save(sortie)


if __name__ == "__main__":
    dossier, sortie = sys.argv[1], sys.argv[2]
    titre = sys.argv[3] if len(sys.argv) > 3 else dossier
    zc = float(sys.argv[4]) if len(sys.argv) > 4 else 14.0
    dessine(dossier, sortie, titre, zc)
    print("ok", sortie)
