"""Rendu orthographique simple (z-buffer) de plusieurs STL ASCII colorés -> PNG."""
import re, sys, math
import numpy as np
from PIL import Image, ImageDraw

def load(path):
    txt = open(path, encoding="utf8").read()
    v = np.array(re.findall(r"vertex\s+(\S+)\s+(\S+)\s+(\S+)", txt), dtype=float)
    return v.reshape(-1, 3, 3)

def render(parts, az, el, out, W=1500, H=1100, margin=60, label=None, zoom_box=None):
    az, el = math.radians(az), math.radians(el)
    d = np.array([math.cos(el) * math.cos(az), math.cos(el) * math.sin(az), math.sin(el)])
    right = np.array([-math.sin(az), math.cos(az), 0.0])
    up = np.cross(d, right)
    light = np.array([0.35, -0.5, 0.8]); light /= np.linalg.norm(light)
    light2 = d
    allpts = np.concatenate([t.reshape(-1, 3) for t, _ in parts if _ is not None])
    if zoom_box is not None:
        allpts = np.array(zoom_box, dtype=float)
    sx, sy = allpts @ right, allpts @ up
    scale = min((W - 2 * margin) / (sx.max() - sx.min()), (H - 2 * margin) / (sy.max() - sy.min()))
    cx, cy = (sx.max() + sx.min()) / 2, (sy.max() + sy.min()) / 2
    zbuf = np.full((H, W), -1e9)
    img = np.full((H, W, 3), 255.0)
    nbuf = np.zeros((H, W, 3))
    idbuf = np.zeros((H, W), dtype=int)
    for pid, (tris, col) in enumerate(parts, 1):
        col = np.array(col, dtype=float)
        n = np.cross(tris[:, 1] - tris[:, 0], tris[:, 2] - tris[:, 0])
        ln = np.linalg.norm(n, axis=1); ok = ln > 1e-12
        tris, n = tris[ok], n[ok] / ln[ok, None]
        px = (tris @ right - cx) * scale + W / 2
        py = H / 2 - (tris @ up - cy) * scale
        pz = tris @ d
        for i in range(len(tris)):
            if n[i] @ d <= 0: continue
            x, y, z = px[i], py[i], pz[i]
            x0, x1 = max(int(math.floor(x.min())), 0), min(int(math.ceil(x.max())), W - 1)
            y0, y1 = max(int(math.floor(y.min())), 0), min(int(math.ceil(y.max())), H - 1)
            if x1 < x0 or y1 < y0: continue
            gx, gy = np.meshgrid(np.arange(x0, x1 + 1) + 0.5, np.arange(y0, y1 + 1) + 0.5)
            den = (y[1] - y[2]) * (x[0] - x[2]) + (x[2] - x[1]) * (y[0] - y[2])
            if abs(den) < 1e-12: continue
            w0 = ((y[1] - y[2]) * (gx - x[2]) + (x[2] - x[1]) * (gy - y[2])) / den
            w1 = ((y[2] - y[0]) * (gx - x[2]) + (x[0] - x[2]) * (gy - y[2])) / den
            w2 = 1 - w0 - w1
            inside = (w0 >= -1e-6) & (w1 >= -1e-6) & (w2 >= -1e-6)
            if not inside.any(): continue
            zz = w0 * z[0] + w1 * z[1] + w2 * z[2]
            sub = zbuf[y0:y1 + 1, x0:x1 + 1]
            m = inside & (zz > sub)
            if not m.any(): continue
            sub[m] = zz[m]
            shade = 0.30 + 0.50 * max(0.0, n[i] @ light) + 0.25 * max(0.0, n[i] @ light2)
            img[y0:y1 + 1, x0:x1 + 1][m] = np.clip(col * shade, 0, 255)
            nbuf[y0:y1 + 1, x0:x1 + 1][m] = n[i]
            idbuf[y0:y1 + 1, x0:x1 + 1][m] = pid
    # contours : ruptures de normale, de profondeur ou de pièce
    edge = np.zeros((H, W), dtype=bool)
    for ax in (0, 1):
        dn = np.abs(np.diff(nbuf, axis=ax)).sum(axis=2) > 0.35
        dz = np.abs(np.diff(np.where(zbuf < -1e8, -1e4, zbuf), axis=ax)) > 1.2
        di = np.diff(idbuf, axis=ax) != 0
        e = dn | dz | di
        if ax == 0: edge[:-1, :] |= e
        else: edge[:, :-1] |= e
    img[edge] = img[edge] * 0.25
    im = Image.fromarray(img.astype(np.uint8))
    if label:
        ImageDraw.Draw(im).text((20, 15), label, fill=(0, 0, 0))
    im.save(out)

if __name__ == "__main__":
    A = "asm/"
    C = {"socle": (40, 120, 235), "coulisseau": (70, 190, 250), "cible": (245, 245, 240), "poulie": (225, 225, 225),
         "roues": (90, 90, 95), "divers": (255, 90, 30), "table": (170, 140, 105)}
    names = ["table", "socle", "coulisseau", "cible", "poulie", "roues", "divers"]
    P = {k: load(A + "asm_" + k + ".stl") for k in names}
    def parts(sel): return [(P[k], C[k]) for k in sel]
    full = names
    notable = [k for k in names if k != "table"]
    render(parts(full), -125, 22, "view_iso.png", label="vue 3/4 arriere (comme la photo)")
    render(parts(full), -55, 25, "view_iso2.png", label="vue 3/4 avant (cote voile)")
    render(parts(notable), -90, 0, "view_side.png", label="vue de cote (y)")
    render(parts(notable), -90, 89.9, "view_top.png", label="vue de dessus")
    render(parts(notable), 180, 0, "view_back.png", label="vue depuis la poche a eau (-x)")
    render(parts([k for k in notable if k != "cible"]), -90, -89.9, "view_bottom.png", label="vue de dessous")
