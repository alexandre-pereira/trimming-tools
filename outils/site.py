"""Construit le site de présentation à partir du README : python outils/site.py [dossier de sortie]

Le site est le README rendu en HTML, avec une bannière, un sommaire, les fichiers STL à télécharger
et les images. Il est reconstruit à chaque modification du dépôt par GitHub Actions (.github/workflows/pages.yml),
donc la page suit le dossier : ce qui change dans README.md, stl/ ou apercu/ change sur le site.
"""
import os, re, shutil, sys, html
import markdown

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(RACINE, "_site")
TITRE = "Banc de calage parapente"
SOUS_TITRE = "Un banc de calage de suspentes imprimé en 3D, au laser et à la poche à eau de 5 kg, pour moins de 60 €."

STYLE = """
:root { --bg: #f4f5f7; --surface: #ffffff; --fg: #1a2330; --muted: #5d6b7c; --line: #d7dde6; --accent: #1b5fc7; --accent-fg: #fff; --code: #eef1f5; }
@media (prefers-color-scheme: dark) { :root { --bg: #10161e; --surface: #18212c; --fg: #e6ebf2; --muted: #9aa8ba; --line: #2b3745; --accent: #7eaaff; --accent-fg: #0b1420; --code: #202b38; } }
* { box-sizing: border-box; }
body { margin: 0; background: var(--bg); color: var(--fg); font: 400 1rem/1.55 "IBM Plex Sans", "Segoe UI", Arial, sans-serif; }
a { color: var(--accent); }
header.banniere { background: var(--surface); border-bottom: 1px solid var(--line); }
header.banniere .in { max-width: 62rem; margin-inline: auto; padding: 2.5rem 1.25rem 2rem; display: grid; gap: .75rem; }
header.banniere h1 { margin: 0; font: 600 2.4rem/1.1 "Barlow Semi Condensed", "Arial Narrow", Arial, sans-serif; text-wrap: balance; }
header.banniere p { margin: 0; color: var(--muted); max-width: 60ch; }
header.banniere .vues { display: grid; grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr)); gap: 1rem; margin-top: .5rem; }
header.banniere img { width: 100%; height: auto; border: 1px solid var(--line); border-radius: 6px; background: #fff; }
.page { max-width: 62rem; margin-inline: auto; padding: 1.5rem 1.25rem 4rem; display: grid; grid-template-columns: minmax(0, 1fr); gap: 2rem; }
@media (min-width: 60rem) { .page { grid-template-columns: 14rem minmax(0, 1fr); align-items: start; } nav.sommaire { position: sticky; top: 1rem; } }
nav.sommaire { background: var(--surface); border: 1px solid var(--line); border-radius: 6px; padding: 1rem; font-size: .9rem; }
nav.sommaire h2 { font-size: .75rem; letter-spacing: .06em; text-transform: uppercase; color: var(--muted); margin: 0 0 .5rem; }
nav.sommaire ol { margin: 0; padding-left: 1.1rem; display: grid; gap: .3rem; }
main { min-width: 0; }
main h2 { font: 600 1.7rem/1.15 "Barlow Semi Condensed", "Arial Narrow", Arial, sans-serif; margin: 2.5rem 0 .75rem; padding-top: 1rem; border-top: 1px solid var(--line); text-wrap: balance; }
main h2:first-child { margin-top: 0; border: 0; padding-top: 0; }
main h3 { font: 600 1.2rem/1.2 "Barlow Semi Condensed", "Arial Narrow", Arial, sans-serif; margin: 1.75rem 0 .5rem; }
main p, main li { max-width: 70ch; }
main img { max-width: 100%; height: auto; border: 1px solid var(--line); border-radius: 6px; background: #fff; }
main code { font: .9em "IBM Plex Mono", Consolas, monospace; background: var(--code); padding: .1em .35em; border-radius: 3px; }
main pre { background: var(--code); padding: 1rem; overflow-x: auto; border-radius: 6px; }
main .scroll { overflow-x: auto; margin: 1rem 0; }
main table { border-collapse: collapse; width: 100%; background: var(--surface); border: 1px solid var(--line); font-size: .95rem; }
main th, main td { text-align: left; padding: .5rem .7rem; border-bottom: 1px solid var(--line); vertical-align: top; }
main th { font-size: .75rem; letter-spacing: .06em; text-transform: uppercase; color: var(--muted); font-weight: 500; }
main td a { overflow-wrap: anywhere; }
.fichiers { background: var(--surface); border: 1px solid var(--line); border-radius: 6px; padding: 1rem 1.25rem; margin: 1rem 0 2rem; }
.fichiers h2 { border: 0; margin: 0 0 .5rem; padding: 0; font-size: 1.4rem; }
.fichiers ul { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(14rem, 1fr)); gap: .5rem; }
.fichiers a.btn { display: block; padding: .5rem .75rem; background: var(--accent); color: var(--accent-fg); border-radius: 4px; text-decoration: none; font-weight: 500; }
.fichiers a.btn small { display: block; font-weight: 400; opacity: .85; }
footer { max-width: 62rem; margin-inline: auto; padding: 0 1.25rem 3rem; color: var(--muted); font-size: .85rem; }
"""


def taille(p):
    o = os.path.getsize(p)
    return "%d Ko" % round(o / 1024)


def main():
    readme = open(os.path.join(RACINE, "README.md"), encoding="utf-8").read()
    # le titre de premier niveau et le tableau d'images d'entrée passent dans la bannière
    readme = re.sub(r"^# .*\n", "", readme, count=1)
    corps = markdown.markdown(readme, extensions=["tables", "fenced_code", "toc", "sane_lists"],
                              extension_configs={"toc": {"toc_depth": "2"}})
    corps = corps.replace("<table>", '<div class="scroll"><table>').replace("</table>", "</table></div>")
    # sommaire : les titres de niveau 2
    titres = re.findall(r'<h2 id="([^"]+)">(.*?)</h2>', corps)
    sommaire = "".join('<li><a href="#%s">%s</a></li>' % (i, re.sub(r"<.*?>", "", t)) for i, t in titres)

    os.makedirs(OUT, exist_ok=True)
    for d in ("stl", "apercu"):
        dst = os.path.join(OUT, d)
        if os.path.isdir(dst):
            shutil.rmtree(dst)
        shutil.copytree(os.path.join(RACINE, d), dst)
    stls = sorted(f for f in os.listdir(os.path.join(RACINE, "stl")) if f.endswith(".stl"))
    fichiers = "".join('<li><a class="btn" href="stl/%s" download>%s <small>%s</small></a></li>'
                       % (f, html.escape(f), taille(os.path.join(RACINE, "stl", f))) for f in stls)
    cname = os.path.join(RACINE, "CNAME")
    if os.path.exists(cname):
        shutil.copy(cname, OUT)

    page = f"""<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{TITRE}</title>
<meta name="description" content="{html.escape(SOUS_TITRE)}">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Barlow+Semi+Condensed:wght@600&family=IBM+Plex+Mono&family=IBM+Plex+Sans:wght@400;500;600&display=swap">
<style>{STYLE}</style>
</head>
<body>
<header class="banniere"><div class="in">
<h1>{TITRE}</h1>
<p>{html.escape(SOUS_TITRE)}</p>
<div class="vues">
<img src="apercu/banc_ouvert_avant.png" alt="Le banc en service, vu du côté de la voile">
<img src="apercu/banc_plie.png" alt="Le banc plié pour le transport">
</div>
</div></header>
<div class="page">
<nav class="sommaire"><h2>Sommaire</h2><ol>{sommaire}</ol></nav>
<main>
<section class="fichiers"><h2>Fichiers à imprimer</h2>
<p>Un fichier STL par pièce, déjà orienté pour l'impression, en millimètres. Les matières conseillées sont plus bas.</p>
<ul>{fichiers}</ul></section>
{corps}
</main>
</div>
<footer>Page construite automatiquement à partir du dépôt : elle reflète l'état des fichiers au dernier changement.</footer>
</body>
</html>
"""
    open(os.path.join(OUT, "index.html"), "w", encoding="utf-8").write(page)
    open(os.path.join(OUT, ".nojekyll"), "w").close()
    print("site écrit dans", OUT, ":", len(stls), "fichiers STL,", len(titres), "sections")


if __name__ == "__main__":
    main()
