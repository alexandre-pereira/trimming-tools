"""Schémas de montage : vues éclatées avec la visserie et les pièces achetées, légendées."""
import math, re
import numpy as np
from PIL import Image, ImageDraw, ImageFont

OUT = "c:/Users/alexa/banc3d/apercu/"
STL = "c:/Users/alexa/banc3d/stl/"
FONT = "C:/Windows/Fonts/arial.ttf"
FONTB = "C:/Windows/Fonts/arialbd.ttf"
f_lab = ImageFont.truetype(FONT, 19)
f_lst = ImageFont.truetype(FONT, 22)
f_tit = ImageFont.truetype(FONTB, 24)
f_big = ImageFont.truetype(FONTB, 34)

BLEU, BLEU2, BLANC = (40, 120, 235), (70, 190, 250), (240, 240, 235)
ACIER, NOIR, ROUGE, ORANGE, JAUNE, GRIS = (185, 190, 200), (85, 85, 90), (200, 40, 60), (255, 120, 30), (250, 200, 30), (215, 215, 215)


# ---------- maillages ----------
def load(path):
    v = np.array(re.findall(r"vertex\s+(\S+)\s+(\S+)\s+(\S+)", open(path, encoding="utf8").read()), dtype=float)
    return v.reshape(-1, 3, 3)


def frame(d):
    d = np.array(d, float); d /= np.linalg.norm(d)
    a = np.array([1.0, 0, 0]) if abs(d[0]) < 0.9 else np.array([0, 1.0, 0])
    u = np.cross(a, d); u /= np.linalg.norm(u)
    v = np.cross(d, u)
    return u, v, d


def tube(p0, d, L, do, di=0.0, n=28):
    """Cylindre (ou prisme à n côtés) d'axe d partant de p0, éventuellement percé."""
    u, v, d = frame(d); p0 = np.array(p0, float)
    R, r = do / 2, di / 2
    th = np.linspace(0, 2 * math.pi, n + 1)
    P = lambda t, rad, h: p0 + rad * (math.cos(t) * u + math.sin(t) * v) + h * d
    T = []
    for i in range(n):
        a, b = th[i], th[i + 1]
        T += [[P(a, R, 0), P(b, R, 0), P(b, R, L)], [P(a, R, 0), P(b, R, L), P(a, R, L)]]          # flanc
        T += [[P(a, r, L), P(a, R, L), P(b, R, L)], [P(a, r, L), P(b, R, L), P(b, r, L)]]          # dessus
        T += [[P(a, r, 0), P(b, R, 0), P(a, R, 0)], [P(a, r, 0), P(b, r, 0), P(b, R, 0)]]          # dessous
        if r > 0:
            T += [[P(a, r, 0), P(b, r, L), P(b, r, 0)], [P(a, r, 0), P(a, r, L), P(b, r, L)]]      # alésage
    return np.array(T)


def box(mn, mx):
    x0, y0, z0 = mn; x1, y1, z1 = mx
    c = np.array([[x0, y0, z0], [x1, y0, z0], [x1, y1, z0], [x0, y1, z0], [x0, y0, z1], [x1, y0, z1], [x1, y1, z1], [x0, y1, z1]], float)
    q = [(0, 3, 2, 1), (4, 5, 6, 7), (0, 1, 5, 4), (2, 3, 7, 6), (1, 2, 6, 5), (0, 4, 7, 3)]
    T = []
    for a, b, cc, d in q:
        T += [[c[a], c[b], c[cc]], [c[a], c[cc], c[d]]]
    return np.array(T)


def vis(p0, d, L, dia, tete=None, htete=None, six=False):
    """Vis : dessous de tête en p0, tige de longueur L le long de d."""
    u, v, dd = frame(d); p0 = np.array(p0, float)
    tete = tete or dia * 1.9; htete = htete or dia * 0.55
    return np.concatenate([tube(p0 - htete * dd, d, htete, tete, n=6 if six else 28), tube(p0, d, L, dia, n=16)])


def ecrou(p0, d, m, h=None):
    af = {3: 5.5, 4: 7, 5: 8, 6: 10}[m]
    return tube(p0, d, h or m * 0.8, af / math.cos(math.radians(30)), m, n=6)


def rondelle(p0, d, m):
    return tube(p0, d, {4: 0.8, 5: 1.1, 6: 1.6}[m], {4: 9, 5: 10, 6: 12}[m], m + 0.3)


def move(t, off):
    return t + np.array(off, float)


# ---------- rendu ----------
def render_scene(parts, az, el, W, H, margin=70):
    az, el = math.radians(az), math.radians(el)
    d = np.array([math.cos(el) * math.cos(az), math.cos(el) * math.sin(az), math.sin(el)])
    right = np.array([-math.sin(az), math.cos(az), 0.0])
    up = np.cross(d, right)
    light = np.array([0.35, -0.5, 0.8]); light /= np.linalg.norm(light)
    allp = np.concatenate([t.reshape(-1, 3) for t, _ in parts])
    sx, sy = allp @ right, allp @ up
    scale = min((W - 2 * margin) / (sx.max() - sx.min()), (H - 40 - 2 * margin) / (sy.max() - sy.min()))
    cx, cy = (sx.max() + sx.min()) / 2, (sy.max() + sy.min()) / 2
    Hc = H / 2 + 20
    proj = lambda p: (float((np.array(p, float) @ right - cx) * scale + W / 2), float(Hc - (np.array(p, float) @ up - cy) * scale))
    zbuf = np.full((H, W), -1e9); img = np.full((H, W, 3), 255.0)
    nbuf = np.zeros((H, W, 3)); idb = np.zeros((H, W), dtype=int)
    for pid, (tris, col) in enumerate(parts, 1):
        col = np.array(col, float)
        n = np.cross(tris[:, 1] - tris[:, 0], tris[:, 2] - tris[:, 0])
        ln = np.linalg.norm(n, axis=1); ok = ln > 1e-12
        tris, n = tris[ok], n[ok] / ln[ok, None]
        px = (tris @ right - cx) * scale + W / 2; py = Hc - (tris @ up - cy) * scale; pz = tris @ d
        for i in range(len(tris)):
            if n[i] @ d <= 0: continue
            x, y, z = px[i], py[i], pz[i]
            x0, x1 = max(int(math.floor(x.min())), 0), min(int(math.ceil(x.max())), W - 1)
            y0, y1 = max(int(math.floor(y.min())), 0), min(int(math.ceil(y.max())), H - 1)
            if x1 < x0 or y1 < y0: continue
            den = (y[1] - y[2]) * (x[0] - x[2]) + (x[2] - x[1]) * (y[0] - y[2])
            if abs(den) < 1e-12: continue
            gx, gy = np.meshgrid(np.arange(x0, x1 + 1) + 0.5, np.arange(y0, y1 + 1) + 0.5)
            w0 = ((y[1] - y[2]) * (gx - x[2]) + (x[2] - x[1]) * (gy - y[2])) / den
            w1 = ((y[2] - y[0]) * (gx - x[2]) + (x[0] - x[2]) * (gy - y[2])) / den
            w2 = 1 - w0 - w1
            ins = (w0 >= -1e-6) & (w1 >= -1e-6) & (w2 >= -1e-6)
            if not ins.any(): continue
            zz = w0 * z[0] + w1 * z[1] + w2 * z[2]
            sub = zbuf[y0:y1 + 1, x0:x1 + 1]; m = ins & (zz > sub)
            if not m.any(): continue
            sub[m] = zz[m]
            sh = 0.32 + 0.48 * max(0.0, n[i] @ light) + 0.25 * max(0.0, n[i] @ d)
            img[y0:y1 + 1, x0:x1 + 1][m] = np.clip(col * sh, 0, 255)
            nbuf[y0:y1 + 1, x0:x1 + 1][m] = n[i]; idb[y0:y1 + 1, x0:x1 + 1][m] = pid
    edge = np.zeros((H, W), dtype=bool)
    for ax in (0, 1):
        e = (np.abs(np.diff(nbuf, axis=ax)).sum(axis=2) > 0.6) | (np.abs(np.diff(np.where(zbuf < -1e8, -1e4, zbuf), axis=ax)) > 1.5) | (np.diff(idb, axis=ax) != 0)
        if ax == 0: edge[:-1, :] |= e
        else: edge[:, :-1] |= e
    img[edge] = img[edge] * 0.25
    return Image.fromarray(img.astype(np.uint8)), proj


def panel(title, parts, labels, az, el, W=1000, H=640, margin=90, axes=()):
    """labels : (point 3D, texte, dx, dy) ; axes : segments 3D en pointillé (axe de montage)."""
    im, proj = render_scene(parts, az, el, W, H, margin)
    dr = ImageDraw.Draw(im)
    for a, b in axes:
        pa, pb = proj(a), proj(b); n = 60
        for k in range(0, n, 2):
            dr.line([(pa[0] + (pb[0] - pa[0]) * k / n, pa[1] + (pb[1] - pa[1]) * k / n),
                     (pa[0] + (pb[0] - pa[0]) * (k + 1) / n, pa[1] + (pb[1] - pa[1]) * (k + 1) / n)], fill=(120, 120, 120), width=1)
    for pt, text, dx, dy in labels:
        x, y = proj(pt); tx, ty = x + dx, y + dy
        bb = dr.multiline_textbbox((tx, ty), text, font=f_lab)
        if dx < 0:
            w = bb[2] - bb[0]; tx -= w; bb = (bb[0] - w, bb[1], bb[2] - w, bb[3])
        # garder l'étiquette dans le cadre
        sx_ = min(0, W - 10 - bb[2]) + max(0, 10 - bb[0]); sy_ = min(0, H - 10 - bb[3]) + max(0, 50 - bb[1])
        tx += sx_; ty += sy_; bb = (bb[0] + sx_, bb[1] + sy_, bb[2] + sx_, bb[3] + sy_)
        ex = bb[0] - 4 if x < bb[0] else (bb[2] + 4 if x > bb[2] else (bb[0] + bb[2]) / 2)
        ey = (bb[1] + bb[3]) / 2 if (x < bb[0] or x > bb[2]) else (bb[3] + 3 if y > bb[3] else bb[1] - 3)
        dr.line([(x, y), (ex, ey)], fill=(0, 0, 0), width=2)
        dr.ellipse([x - 4, y - 4, x + 4, y + 4], fill=(0, 0, 0))
        dr.rectangle([bb[0] - 4, bb[1] - 3, bb[2] + 4, bb[3] + 3], fill=(255, 255, 255))
        dr.multiline_text((tx, ty), text, font=f_lab, fill=(0, 0, 0))
    dr.rectangle([0, 0, W - 1, H - 1], outline=(150, 150, 150))
    dr.rectangle([0, 0, W - 1, 40], fill=(235, 238, 245)); dr.text((14, 8), title, font=f_tit, fill=(0, 0, 0))
    return im


Z, Y = (0, 0, 1), (0, 1, 0)


def p_roue():
    P = [(vis((0, 0, -5), Z, 25, 5, tete=9.5, htete=2.75), ACIER),
         (np.concatenate([tube((0, 0, 30), Z, 2.2, 19.6, 5), tube((0, 0, 32.2), Z, 5.9, 23.9, 5), tube((0, 0, 38.1), Z, 2.2, 19.6, 5)]), NOIR),
         (tube((0, 0, 50), Z, 2.7, 8, 5.3), BLANC),
         (box((-24, -20, 62), (24, 16, 73.5)), BLEU2),
         (ecrou((0, 0, 84), Z, 5, h=5), ACIER)]
    L = [((4, 0, 87), "écrou frein M5 (bague nylon), noyé dans le dessus\ndu coulisseau : ni colle ni frein-filet", 110, -40),
         ((24, 0, 68), "coulisseau (11,5 mm)", 90, -10),
         ((4, 0, 52), "entretoise imprimée de 2,7 mm", 130, -10),
         ((12, 0, 35), "roue V Ø24 × 10,2 ; 11 mm sur\nses 2 roulements 625,\ndéjà montés dedans", 110, -30),
         ((3, 0, 5), "vis M5×25 tête bombée,\nmontée par-dessous", 130, 0)]
    return panel("A — Roue (×4)", P, L, -70, 18, margin=110, axes=[((0, 0, -9), (0, 0, 96))])


def p_poulie():
    P = [(np.concatenate([tube((0, -82, 0), Y, 40, 5, n=20), tube((0, -82, 0), Y, 3.5, 5.6, n=20)]), ACIER),   # goupille Ø5 × 40 et son bout moleté
         (box((-9, -30, -9), (9, -22, 9)), BLEU),                                  # joue du socle
         (tube((0, -8, 0), Y, 3.3, 8, 5.3), BLANC),
         (tube((0, 10, 0), Y, 5, 16, 5), ACIER),                                   # roulement 625
         (tube((0, 30, 0), Y, 10, 25, 16.2), GRIS),                                # poulie
         (tube((0, 56, 0), Y, 3.3, 8, 5.3), BLANC),
         (box((-9, 72, -9), (9, 80, 9)), BLEU)]
    L = [((0, -60, -2.5), "goupille Ø5 × 40, moletée à un bout : emmanchée dans les deux\njoues, bout lisse en premier, 5 mm en retrait de chaque flanc", -215, 175),
         ((0, -26, 9), "joue du socle : trou à six pans\nde 4,95 sur plats", -60, -90),
         ((0, -6, -4), "entretoise imprimée", -60, 150),
         ((0, 12.5, 8), "roulement 625ZZ (5 × 16 × 5), à emmancher\ndans la poulie ; il glisse sur la partie lisse", -110, -160),
         ((0, 35, -12.5), "poulie imprimée Ø25", -40, 110),
         ((0, 58, 4), "entretoise imprimée", -20, -130),
         ((0, 76, -9), "joue du socle", -20, 80)]
    return panel("B — Poulie de renvoi, sur roulement à billes", P, L, -22, 16, margin=120, axes=[((0, -88, 0), (0, 86, 0))])


def bobine(y0, sens):
    """Bobine imprimée : chapeau en y0 (bout extérieur), tube de 26 mm dans le sens donné (+1 ou -1)."""
    d = (0, sens, 0)
    T = [tube((0, y0, 0), d, 6.75, 14, 9.2)]
    for k in range(3):                                             # raccord conique
        T.append(tube((0, y0 + sens * (6.75 + 0.833 * k), 0), d, 0.833, 14 - 1.67 * (k + 0.5), 5.3))
    T.append(tube((0, y0 + sens * 9.25, 0), d, 26, 9, 5.3))
    return np.concatenate(T)


def elev(y0):
    return np.concatenate([tube((0, y0, 0), Y, 25, 14, 9.6), box((-150, y0, -2.5), (-4, y0 + 25, 1.5))])


def p_axe():
    P = [(np.concatenate([tube((0, -160, 0), Y, 5, 8.5), tube((0, -155, 0), Y, 80, 5, n=16)]), ACIER),
         (bobine(-60, 1), BLANC),
         (elev(-50), ROUGE),
         (np.concatenate([box((-7, -8, -9), (7, 8, 0)), tube((0, -8, 0), Y, 16, 14, 5.3)]), BLEU2),
         (bobine(60, -1), BLANC),
         (elev(25), ROUGE),
         (ecrou((0, 76, 0), Y, 5, h=5), ACIER)]
    L = [((0, -120, -2.5), "vis M5×80 à tête cylindrique (CHC) :\nsa tête disparaît dans le chapeau", 60, 80),
         ((0, -56, 7), "chapeau de la bobine : il retient\nl'élévateur et cache la tête de vis", -200, -170),
         ((-90, -37, 1.5), "élévateur posé à plat : sa boucle de base\nse passe par-dessus le chapeau, sans rien dévisser,\npuis la sangle se couche dans son couloir.\nElle ne touche que du plastique lisse.", -520, 30),
         ((0, 0, 7), "nervure centrale du coulisseau", -60, -230),
         ((0, 40, 4.5), "bobine imprimée", 60, -150),
         ((0, 79, 4), "écrou frein M5, noyé\ndans l'autre chapeau", 50, -40)]
    return panel("C — Accrochage des élévateurs (monté une fois pour toutes, rien à démonter ensuite)", P, L, -55, 24, W=2010, H=640, margin=120, axes=[((0, -170, 0), (0, 90, 0))])


def p_charniere():
    slot = np.concatenate([tube((0, 6, 0), Y, 7, 7, 3.4), tube((0, 6, -5.5), Y, 7, 7, 3.4), box((-3.5, 6, -5.5), (3.5, 13, 0)),
                           box((-3.5, 6, -9), (-0.5, 13, 40))])
    P = [(np.concatenate([tube((0, -34, 0), Y, 12, 3, n=20), tube((0, -34, 0), Y, 3.5, 3.5, n=20)]), ACIER),   # goupille Ø3 × 12 et son bout moleté
         (np.concatenate([box((-4, -10, -12), (4, -4, 0)), tube((0, -10, 0), Y, 6, 8, 2.9)]), BLEU2),
         (slot, BLANC)]
    L = [((0, -28, 1.5), "goupille Ø3 × 12, moletée à un bout :\nce bout est serré dans l'oreille,\nla partie lisse sert d'axe", -60, -120),
         ((0, -7, -8), "oreille du coulisseau : son trou à six pans\nserre le bout moleté, sans colle", -230, 80),
         ((-2, 10, 25), "cible", 60, -40),
         ((2, 13, -3), "charnon à lumière borgne : la cible tourne\net coulisse sur la partie lisse ;\nla goupille ne peut ni sortir ni rentrer", 60, 40)]
    return panel("D — Charnière de la cible (×2)", P, L, -30, 16, margin=130, axes=[((0, -40, 0), (0, 20, 0))])


def p_verrou(W=1000, H=640):
    """Coupe de profil du verrouillage de la cible (dessin 2D)."""
    im = Image.new("RGB", (W, H), "white"); dr = ImageDraw.Draw(im)
    sc = 22
    def X(x): return 300 + x * sc
    def Zc(z): return 368 - z * sc
    def poly(pts, col): dr.polygon([(X(x), Zc(z)) for x, z in pts], fill=col, outline=(0, 0, 0))
    def T(x, y, t): dr.multiline_text((x, y), t, font=f_lab, fill=(0, 0, 0))
    poly([(-12, -11.5), (0, -11.5), (0, 0), (-12, 0)], BLEU2)                                   # plaque du coulisseau
    poly([(0, -11.5), (14, -11.5), (14, -9.7), (0, -9.7)], BLEU2)                               # plancher avant
    poly([(2.9, -9.7), (3.6, -5), (5.8, -5), (5.8, -9.7)], BLEU2)                     # lèvre inclinée
    poly([(0, -9), (3, -9), (3, 14), (0, 14)], BLANC)                                 # cible verrouillée
    dr.ellipse([X(3.5) - 6, Zc(4) - 6, X(3.5) + 6, Zc(4) + 6], fill=ACIER, outline=(0, 0, 0))   # axe
    # cible soulevée, en pointillé
    for z0 in range(0, 20, 2):
        dr.line([(X(8), Zc(z0 + 0.1)), (X(8), Zc(z0 + 1.1))], fill=(120, 120, 120), width=2)
        dr.line([(X(11), Zc(z0 + 0.1)), (X(11), Zc(z0 + 1.1))], fill=(120, 120, 120), width=2)
    dr.line([(X(8), Zc(0)), (X(11), Zc(0))], fill=(120, 120, 120), width=2)
    dr.line([(X(9.5), Zc(6)), (X(9.5), Zc(11))], fill=(200, 40, 60), width=3)
    dr.polygon([(X(9.5), Zc(12)), (X(9.1), Zc(10.6)), (X(9.9), Zc(10.6))], fill=(200, 40, 60))
    for (x, z, tx, ty, t) in [(-6, -6, 30, 470, "coulisseau"), (0, -4, 20, 300, "face avant du coulisseau :\nla languette s'y appuie"),
                               (4.6, -7, 520, 500, "lèvre inclinée : en poussant la cible vers le bas,\nsa languette s'y coince, sans jeu"),
                               (1.5, 10, 520, 110, "cible relevée et verrouillée :\nelle ne peut basculer ni en avant ni en arrière"),
                               (3.5, 4, 520, 200, "axe de charnière (goupille Ø3)"),
                               (9.5, 3, 560, 300, "pour rabattre : SOULEVER de 5,5 mm\n(la languette sort de la lèvre), puis RABATTRE")]:
        dr.line([(X(x), Zc(z)), (tx - 6 if tx > X(x) else tx + 230, ty + 12)], fill=(0, 0, 0), width=2)
        dr.ellipse([X(x) - 4, Zc(z) - 4, X(x) + 4, Zc(z) + 4], fill=(0, 0, 0)); T(tx, ty, t)
    dr.rectangle([0, 0, W - 1, H - 1], outline=(150, 150, 150))
    dr.rectangle([0, 0, W - 1, 40], fill=(235, 238, 245)); dr.text((14, 8), "F — Verrouillage de la cible à angle droit (coupe de profil)", font=f_tit, fill=(0, 0, 0))
    return im


def p_ensemble():
    g = lambda k: load("asm/asm_" + k + ".stl")
    xs, zsb, up = 52.95, 18.0, 46         # xs = xs_min + course/2 de banc.scad
    P = [(g("socle"), BLEU), (g("roues"), NOIR), (move(g("coulisseau"), (0, 0, up)), BLEU2),
         (move(g("cible"), (0, 0, up + 40)), BLANC), (move(g("poulie"), (-50, 0, 0)), GRIS)]
    Hw = []
    Pw = []
    for x in (xs - 20, xs + 10):
        for y in (-34.4, 34.4):
            Hw.append(vis((x, y, -33), Z, 25, 5, tete=9.5, htete=2.75))                      # vis des roues, dessous
            Pw.append(tube((x, y, 27), Z, 2.7, 8, 5.3))                                      # entretoise imprimée
            Hw.append(ecrou((x, y, zsb + up + 20), Z, 5, h=5))                               # écrous frein, dessus
    Hw.append(tube((-67, -100, 0), Y, 40, 5, n=20))                                           # goupille de la poulie
    Pw += [tube((-67, -30, 0), Y, 3.3, 8, 5.3), tube((-67, 20, 0), Y, 3.3, 8, 5.3)]           # ses entretoises
    Hw.append(tube((-67, -20, 0), Y, 5, 16, 5))                                               # roulement 625
    pz, px = zsb + up + 12, xs + 72
    Hw.append(np.concatenate([tube((px, 200, pz), (0, -1, 0), 5, 8.5), tube((px, 195, pz), (0, -1, 0), 80, 5, n=16)]))   # vis CHC des élévateurs
    Hw.append(ecrou((px, -84, pz), Y, 5, h=5))
    P.append((np.concatenate([move(bobine(96, -1), (px, 0, pz)), move(bobine(-70, 1), (px, 0, pz))]), BLANC))            # bobines
    hz = zsb + up + 15.5
    Hw += [tube((xs + 51.5, -68, hz), Y, 12, 3, n=20), tube((xs + 51.5, 56, hz), Y, 12, 3, n=20)]
    P.append((np.concatenate(Hw), ACIER))
    P.append((np.concatenate(Pw), BLANC))
    L = [((xs + 10, -34.4, -27), "A  roues : vis M5×25 dessous,\nentretoise, écrou frein M5 dessus (×4)", 60, 60),
         ((-67, -80, 0), "B  poulie sur roulement 625, 2 entretoises,\ngoupille Ø5 × 40 emmanchée dans les joues", -400, 40),
         ((px, 150, pz), "C  élévateurs : vis CHC M5×80,\n2 bobines, écrou frein", 50, -110),
         ((xs + 51.5, 62, hz), "D  charnières : goupille Ø3 × 12 (×2)", 150, 70),
         ((xs + 32, 0, zsb + up + 8), "E  puits du nœud\nde la cordelette", -420, -150),
         ((xs + 50, 0, zsb + up + 120), "cible", 90, -20),
         ((xs - 28, 20, zsb + up + 4), "coulisseau", -230, -30),
         ((127, 30, 17), "socle : ses deux bouts relevés\narrêtent les roues", 130, 40)]
    return panel("Vue d'ensemble éclatée — les lettres renvoient aux détails", P, L, -58, 24, W=2010, H=980, margin=120)


def p_cordelette(W=1000, H=640):
    im = Image.new("RGB", (W, H), "white"); dr = ImageDraw.Draw(im)
    def T(x, y, s): dr.multiline_text((x, y), s, font=f_lab, fill=(0, 0, 0))
    k = 2.6                                                                         # px par mm
    xs = 52.95                                                                      # coulisseau à mi-course
    X = lambda x: 150 + k * x
    Zp = lambda z: 250 - k * z
    R = lambda x0, z0, x1, z1, **kw: dr.rectangle([X(x0), Zp(z1), X(x1), Zp(z0)], **kw)
    R(0, -22, 172, 0, fill=(150, 110, 70))                                           # table
    T(X(145), Zp(-6), "table")
    dr.polygon([(X(x), Zp(z)) for x, z in [(-34, 17), (130, 17), (130, 0), (0, 0), (0, -14), (-26, -14), (-34, -4)]], fill=BLEU)   # socle + crochet
    R(-17, 9, 130, 17, fill=(25, 80, 170))                                           # canal de la cordelette (en transparence)
    R(-30.5, -15, -3.5, 17, fill=(25, 80, 170))                                      # fente de la poulie
    R(xs - 28, 18, xs + 48, 29.5, fill=BLEU2)                                      # coulisseau
    R(xs + 48, 18, xs + 102, 21, fill=BLEU2)                                     # plancher des couloirs
    R(xs + 27, 20, xs + 37, 29.5, fill="white", outline=(0, 0, 0))                 # puits du nœud
    for xw in (xs - 20, xs + 10):                                                    # roues
        R(xw - 12, 4.4, xw + 12, 14.6, fill=NOIR)
    dr.ellipse([X(-29.5), Zp(12.5), X(-4.5), Zp(-12.5)], fill=GRIS, outline=(0, 0, 0))   # poulie
    dr.ellipse([X(-25), Zp(8), X(-9), Zp(-8)], fill=ACIER, outline=(0, 0, 0))            # roulement
    dr.ellipse([X(-19.5), Zp(2.5), X(-14.5), Zp(-2.5)], fill=(90, 90, 95), outline=(0, 0, 0))
    dr.line([(X(-17), Zp(11)), (X(xs + 28), Zp(18.5))], fill=ORANGE, width=4)        # brin dans le canal
    dr.line([(X(-28), Zp(0)), (X(-28), Zp(-70))], fill=ORANGE, width=4)
    dr.ellipse([X(xs + 29), Zp(26), X(xs + 35), Zp(20)], fill=ORANGE, outline=(0, 0, 0))   # nœud
    dr.rounded_rectangle([X(-52), Zp(-70), X(-6), Zp(-125)], radius=14, fill=(150, 200, 250), outline=(0, 0, 0))
    T(X(-49), Zp(-90), "5,00 kg")
    for (x, z, tx, ty, s) in [(xs + 32, 23, 560, 60, "nœud en huit dans le puits, ouvert dessus ;\nle brin sort par une fente de 3 mm du fond"),
                               (20, 13.5, 40, 100, "le brin court dans un canal du socle, sous le\ncoulisseau, presque à l'horizontale"),
                               (xs + 40, 27, 640, 150, "coulisseau (ici à mi-course)"),
                               (xs + 16, 8, 640, 210, "roues, fixées sous le coulisseau,\nde chaque côté du socle"),
                               (-17, -9, 200, 330, "poulie sur roulement à billes, logée dans\nle bloc des crochets, sous les rainures"),
                               (-28, -45, 200, 410, "boucle nouée sur la poignée du lest"),
                               (-15, -105, 200, 500, "lest (poche à eau ou bidon) : le peser à 5,00 kg ;\nil repose au sol au repos")]:
        x, y = X(x), Zp(z)
        end = (tx - 6, ty + 12) if tx > x else (tx + 200, ty + 44 if y > ty + 44 else ty + 12)
        dr.line([(x, y), end], fill=(0, 0, 0), width=2); dr.ellipse([x - 4, y - 4, x + 4, y + 4], fill=(0, 0, 0)); T(tx, ty, s)
    dr.rectangle([0, 0, W - 1, H - 1], outline=(150, 150, 150))
    dr.rectangle([0, 0, W - 1, 40], fill=(235, 238, 245)); dr.text((14, 8), "E — Cordelette et lest (vu de profil)", font=f_tit, fill=(0, 0, 0))
    return im


if __name__ == "__main__":
    top = p_ensemble()
    row = [p_roue(), p_poulie()]
    axe = p_axe()
    row2 = [p_charniere(), p_cordelette()]
    ver = p_verrou()
    W = 2010; pad = 10
    hs = [70, top.height, 640, axe.height, 640, 640]
    sheet = Image.new("RGB", (W + 2 * pad, sum(hs) + pad * (len(hs) + 1)), "white")
    d = ImageDraw.Draw(sheet)
    d.text((pad + 6, 18), "Banc de calage — schéma de montage avec la visserie", font=f_big, fill=(0, 0, 0))
    y = pad + 70
    sheet.paste(top, (pad, y)); y += top.height + pad
    sheet.paste(row[0], (pad, y)); sheet.paste(row[1], (pad + 1010, y)); y += 640 + pad
    sheet.paste(axe, (pad, y)); y += axe.height + pad
    sheet.paste(row2[0], (pad, y)); sheet.paste(row2[1], (pad + 1010, y)); y += 640 + pad
    sheet.paste(ver, (pad, y))
    lx = pad + 1040                                                                  # liste à droite du dernier détail
    d.text((lx, y + 20), "Visserie et pièces achetées", font=f_tit, fill=(0, 0, 0))
    lines = ["A   4 roues V Ø24 × 10,2, roulements 625 inclus",
             "A   4 vis M5×25 tête bombée, 4 écrous frein M5, 4 entretoises imprimées",
             "B   1 roulement 625ZZ, 1 goupille Ø5 × 40 moletée à un bout, 2 entretoises et 1 poulie imprimées",
             "C   1 vis CHC M5×80, 1 écrou frein M5, 2 bobines imprimées",
             "D   2 goupilles Ø3 × 12 moletées à un bout",
             "E   cordelette de 2 mm, lest de 5 kg",
             "",
             "Ni colle ni frein-filet : écrous frein et goupilles serrées.",
             "Sangle velcro autour du bloc pour le transport."]
    for i, s in enumerate(lines):
        d.text((lx, y + 80 + i * 40), s, font=f_lst, fill=(0, 0, 0))
    sheet.save(OUT + "schema_montage.png")
    top.save(OUT + "schema_ensemble.png"); row[0].save(OUT + "schema_A_roue.png"); row[1].save(OUT + "schema_B_poulie.png")
    axe.save(OUT + "schema_C_axe_elevateurs.png"); row2[0].save(OUT + "schema_D_charniere.png"); row2[1].save(OUT + "schema_E_cordelette.png")
    ver.save(OUT + "schema_F_verrou_cible.png")
    print("ok", sheet.size)
