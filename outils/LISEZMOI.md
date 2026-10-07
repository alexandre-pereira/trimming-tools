# Outils de génération

Scripts qui produisent les STL, les images d'aperçu et les schémas de montage.
OpenSCAD n'a pas besoin d'être installé : le rendu passe par sa version WebAssembly.

À lancer depuis ce dossier :

```
npm install openscad-wasm-prebuilt     # une seule fois
node generer_stl.mjs                   # STL dans ../stl, pièces d'assemblage dans ./asm, contrôles d'interférence
python render2.py                      # une image par STL + vues d'assemblage, dans ../apercu
python schema.py                       # schémas de montage avec la visserie, dans ../apercu
```

Python a besoin de `numpy` et `Pillow`. Les positions de la visserie dans `schema.py`
reprennent les cotes de `../scad/banc.scad` : si le modèle change, les mettre à jour.
