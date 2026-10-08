import { createOpenSCAD } from "openscad-wasm-prebuilt";
import fs from "node:fs";
import path from "node:path";

const src = "c:/Users/alexa/banc3d/scad";
const outPrint = "c:/Users/alexa/banc3d/stl";
for (const d of [outPrint, "./asm", "./asm_plie"]) fs.mkdirSync(d, { recursive: true });

function stats(stl) {
  const vs = [...stl.matchAll(/vertex\s+(\S+)\s+(\S+)\s+(\S+)/g)].map(m => [m[1], m[2], m[3]]);
  const min = [Infinity, Infinity, Infinity], max = [-Infinity, -Infinity, -Infinity];
  const edges = new Map();
  let vol = 0;
  for (let t = 0; t < vs.length; t += 3) {
    const [a, b, c] = [vs[t], vs[t + 1], vs[t + 2]].map(v => v.map(Number));
    for (const v of [a, b, c]) for (let i = 0; i < 3; i++) { if (v[i] < min[i]) min[i] = v[i]; if (v[i] > max[i]) max[i] = v[i]; }
    vol += (a[0] * (b[1] * c[2] - b[2] * c[1]) - a[1] * (b[0] * c[2] - b[2] * c[0]) + a[2] * (b[0] * c[1] - b[1] * c[0])) / 6;
    for (let k = 0; k < 3; k++) {
      const e = [vs[t + k].join(","), vs[t + (k + 1) % 3].join(",")].sort().join("|");
      edges.set(e, (edges.get(e) || 0) + 1);
    }
  }
  return { tris: vs.length / 3, openEdges: [...edges.values()].filter(c => c !== 2).length,
    min: min.map(v => +v.toFixed(2)), max: max.map(v => +v.toFixed(2)), cm3: +(vol / 1000).toFixed(2) };
}

async function render(file, defs) {
  const log = [];
  const o = await createOpenSCAD({ print: t => log.push(t), printErr: t => log.push(t) });
  const inst = o.getInstance();
  for (const f of fs.readdirSync(src)) inst.FS.writeFile("/" + f, fs.readFileSync(path.join(src, f), "utf8"));
  const args = ["/" + file];
  for (const [k, v] of Object.entries(defs)) args.push("-D", `${k}=${v}`);
  args.push("--export-format=asciistl", "-o", "/out.stl");
  let stl = null;
  try { inst.callMain(args); stl = inst.FS.readFile("/out.stl", { encoding: "utf8" }); } catch (e) { log.push(String(e)); }
  return { stl: stl && /vertex/.test(stl) ? stl : null, log };
}

const mode = process.argv[2] || "all";
// noms à la suite du mode : seulement ces pièces ou ces contrôles (« print socle coulisseau », « asm asm_divers »,
// « check x_cible_vis ») ; « print » avec des noms ne refait pas les supports de laser
const seules = process.argv.slice(3);
if (mode === "all" || mode === "print") {
  for (const p of ["socle", "coulisseau", "poulie", "cible", "bobine_tete", "bobine_ecrou", "entretoises_grappe"]) {
    if (seules.length && !seules.includes(p)) continue;
    const { stl, log } = await render("banc.scad", { part: `"${p}"` });
    if (!stl) { console.log(p, "ECHEC", log.join("\n")); continue; }
    fs.writeFileSync(path.join(outPrint, p + ".stl"), stl);
    console.log(p, JSON.stringify(stats(stl)), log.filter(l => /warn|error/i.test(l)).join(" | "));
  }
}
if (mode === "all" || (mode === "print" && !seules.length) || mode === "lasers") {
  // un support par télémètre de la liste outils/lasers.json (cotes constructeur ; le jeu est dans le .scad)
  const lasers = JSON.parse(fs.readFileSync("c:/Users/alexa/banc3d/outils/lasers.json", "utf8"));
  for (const f of fs.readdirSync(outPrint)) if (/^support_laser.*\.stl$/.test(f)) fs.unlinkSync(path.join(outPrint, f));
  const faits = [];
  for (const m of lasers) {
    const { stl, log } = await render("support_laser.scad", { laser_w: m.largeur, laser_l: m.longueur, laser_h: m.epaisseur, ...(m.jeu ? { fit: m.jeu } : {}) });
    const f = `support_laser_${m.slug}.stl`;
    if (!stl) { console.log(f, "ECHEC", log.join("\n")); continue; }
    fs.writeFileSync(path.join(outPrint, f), stl);
    const s = stats(stl);
    console.log(f, JSON.stringify(s));
    faits.push([m, f]);
  }
  // une ligne de tableau par support, dans la langue du README ; les télémètres qui ne mesurent que
  // depuis leur face arrière donnent une lecture plus longue de leur propre longueur
  const repere = (m, en) => m.reference === "avant" ? (en ? "front or rear" : "avant ou arrière")
    : (en ? `rear only: subtract ${m.longueur} mm from the reading` : `arrière seulement : retranchez ${m.longueur} mm de la lecture`);
  const ligne = (m, f, en) => `| ${m.modele} | ${m.longueur} × ${m.largeur} × ${m.epaisseur} | ${repere(m, en)} | \`${f}\` ([image](apercu/support_laser_${m.slug}.png)) |`;
  // le tableau des versions dans le README de chaque langue, entre les deux repères
  for (const [nom, entete, en] of [["README.md", "| Télémètre | Cotes constructeur (mm) | Repère de mesure | Fichier |", false],
                                   ["README.en.md", "| Distance meter | Manufacturer's dimensions (mm) | Measuring reference | File |", true]]) {
    const readme = "c:/Users/alexa/banc3d/" + nom;
    if (!fs.existsSync(readme)) continue;
    const txt = fs.readFileSync(readme, "utf8");
    const bloc = "<!-- supports:debut -->\n" + entete + "\n|---|---|---|---|\n" + faits.map(([m, f]) => ligne(m, f, en)).join("\n") + "\n<!-- supports:fin -->";
    const nouveau = txt.replace(/<!-- supports:debut -->[\s\S]*?<!-- supports:fin -->/, bloc);
    if (nouveau !== txt) { fs.writeFileSync(readme, nouveau); console.log(nom, ": tableau des supports mis à jour"); }
  }
}
if (mode === "all" || mode === "asm") {
  for (const [dir, plie] of [["./asm", "false"], ["./asm_plie", "true"]])
    for (const p of ["asm_socle", "asm_coulisseau", "asm_cible", "asm_poulie", "asm_roues", "asm_divers", "asm_table", "asm_elevateurs", "asm_bobines"]) {
      if (seules.length && !seules.includes(p)) continue;
      const { stl, log } = await render("banc.scad", { part: `"${p}"`, plie });
      if (!stl) { console.log(dir, p, "ECHEC", log.slice(-3).join("\n")); continue; }
      fs.writeFileSync(path.join(dir, p + ".stl"), stl);
    }
  console.log("asm ok");
}
if (mode === "all" || mode === "check") {
  // [contrôle, cible rabattue ?, position du coulisseau de 0 à 1 (-1 = position par défaut)]
  const checks = [["x_socle_coulisseau", "false", -1], ["x_socle_coulisseau", "true", -1], ["x_socle_coulisseau", "false", 1],
    ["x_socle_poulie", "false", -1], ["x_socle_roues", "true", -1], ["x_socle_roues", "false", 1],
    ["x_coulisseau_cible", "false", -1], ["x_coulisseau_cible", "true", -1], ["x_cible_vis", "false", -1], ["x_cible_vis", "true", -1], ["x_cible_reste", "false", -1], ["x_cible_reste", "true", -1],
    ["x_coulisseau_bobines", "false", -1], ["x_coulisseau_elevateurs", "false", -1]];
  for (const [p, plie, pos] of checks) {
    if (seules.length && !seules.includes(p)) continue;
    const { stl } = await render("banc.scad", { part: `"${p}"`, plie, pos, "$fn": 24 });
    const tag = `${p} plie=${plie} pos=${pos}`;
    if (!stl) console.log(tag, "-> vide (aucune interférence)");
    else console.log(tag, "-> intersection", JSON.stringify(stats(stl)));
  }
}
