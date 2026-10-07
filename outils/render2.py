"""Images d'aperçu : une par fichier STL + assemblage ouvert / plié."""
import os, sys, itertools
import numpy as np
from render import load, render

OUT = "c:/Users/alexa/banc3d/apercu/"
STL = "c:/Users/alexa/banc3d/stl/"
os.makedirs(OUT, exist_ok=True)
C = {"socle": (40, 120, 235), "coulisseau": (70, 190, 250), "cible": (240, 240, 235), "poulie": (225, 225, 225),
     "roues": (90, 90, 95), "divers": (255, 90, 30), "table": (170, 140, 105),
     "bobines": (240, 240, 235), "elevateurs": (200, 40, 60),
     "bobine_tete": (240, 240, 235), "bobine_ecrou": (240, 240, 235), "entretoises_grappe": (240, 240, 235),
     "support_laser": (70, 190, 250)}

# une image par fichier STL (tel qu'il sera imprimé)
views = {"socle": (-120, 28), "coulisseau": (-60, 32), "poulie": (-60, 35), "cible": (-60, 35),
         "bobine_tete": (-60, 35), "bobine_ecrou": (-60, 35), "entretoises_grappe": (-60, 35),
         "support_laser": (-55, 30)}
for name, (az, el) in views.items():
    render([(load(STL + name + ".stl"), C[name])], az, el, OUT + name + ".png", W=1200, H=850,
           label=name + ".stl (orientation d'impression)")

names = ["table", "socle", "coulisseau", "cible", "poulie", "roues", "bobines", "divers"]
def asm(d, sel): return [(load(d + "/asm_" + k + ".stl"), C[k]) for k in sel]
notable = [k for k in names if k != "table"]
render(asm("asm", names), -125, 22, OUT + "banc_ouvert_arriere.png", label="banc en service, vu cote poche a eau")
render(asm("asm", names), -50, 22, OUT + "banc_ouvert_avant.png", label="banc en service, vu cote voile")
render(asm("asm", notable), -90, 0, OUT + "banc_ouvert_profil.png", label="banc en service, profil")
render(asm("asm_plie", notable), -125, 22, OUT + "banc_plie.png", label="banc plie pour le transport")
render(asm("asm_plie", notable), -90, 0, OUT + "banc_plie_profil.png", label="banc plie, profil")
sl = load(STL + "support_laser.stl")
use = np.stack([sl[:, :, 0], -sl[:, :, 2], sl[:, :, 1]], axis=2)      # remis en service : bec a l'avant, auge vers le haut
render([(use, C["support_laser"])], -55, 30, OUT + "support_laser_arriere.png", W=1200, H=850, label="support laser en service, vu de l'arriere : le telemetre se couche dans l'auge, face avant au ras du bec")
render([(use, C["support_laser"])], 130, -30, OUT + "support_laser_bec.png", W=1200, H=850, label="support laser vu de dessous : le bec, sa bande de renfort et l'encoche de la suspente")
ill = names + ["elevateurs"]
render(asm("asm", ill), -42, 38, OUT + "accrochage_elevateurs.png", label="accrochage : chaque elevateur a plat sur sa bobine, la sangle dans son couloir",
       zoom_box=list(itertools.product([37, 257], [-80, 80], [0, 60])))
render(asm("asm", ill), -90, 89.9, OUT + "accrochage_dessus.png", label="accrochage, vue de dessus",
       zoom_box=list(itertools.product([7, 267], [-80, 80], [0, 60])))
render(asm("asm", [k for k in ill if k != "table"]), -90, 0, OUT + "accrochage_profil.png", label="accrochage, profil",
       zoom_box=list(itertools.product([-40, 267], [-80, 80], [-20, 120])))
print("ok")
