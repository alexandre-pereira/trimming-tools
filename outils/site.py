"""Construit le site de présentation à partir du README : python outils/site.py [dossier de sortie]

Le site est le README rendu en HTML, avec une bannière, un sommaire, les fichiers STL à télécharger
et les images. Il existe en anglais (à la racine du site, la langue par défaut, depuis README.en.md)
et en français (dans fr/, depuis README.md) : ce qui change dans un README se reporte dans l'autre.
Il est reconstruit à chaque modification du dépôt par GitHub Actions (.github/workflows/pages.yml),
donc la page suit le dossier : ce qui change dans les README, stl/ ou apercu/ change sur le site.

L'habillage (weflare.css, weflare.svg, weflare-mark.svg) est celui de tous les outils WeFlare : les
mêmes fichiers sont dans le dépôt de chaque outil.
"""
import os, re, shutil, sys, html, json
import markdown

OUTILS = os.path.dirname(os.path.abspath(__file__))
RACINE = os.path.dirname(OUTILS)
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(RACINE, "_site")
DEPOT = "https://github.com/alexandre-pereira/trimming-tools"
# la première langue est à la racine du site, les autres dans un dossier à leur nom
LANGUES = ["en", "fr"]
# clé du localStorage qui retient la langue choisie par le visiteur
CLE_LANGUE = "wf-lang"
# image des aperçus de lien (réseaux sociaux, messageries)
IMAGE_APERCU = "apercu/banc_ouvert_avant.png"

TEXTES = {
    "en": {
        "readme": "README.en.md",
        "locale": "en_GB",
        "sous_titre": "Measure your lines with a laser, under 5 kg, with two 3D-printed parts: 7 files for the bench, a holder sized for your distance meter, €30 of hardware.",
        "etiquette": "Free tool to 3D-print",
        "telecharger": "Download the STL files",
        "source": "Source code",
        "sommaire": "Contents",
        "fichiers": "One STL file per part, already oriented for printing, in millimetres. Recommended materials are further down.",
        "supports_titre": "The laser holder, in the version for your distance meter",
        "supports": "Leica DISTO and Bosch models under €500, at the manufacturer's dimensions (length × width × thickness) plus 0.5 mm of clearance. Other distance meter: see further down.",
        "taille": "%d kB",
        "cree": "Developed and offered free of charge by WeFlare.",
        "autres": "Other free tools:",
        "outils": [("https://trim.weflare.fr/", "Wing Trim, the app to measure and trim your lines"),
                   ("https://soundings.weflare.fr/", "PG Soundings, the free-flight forecast inside Windy")],
        "pied": "Page built automatically from the repository: it reflects the files as of the last change.",
        "langue": "Language",
    },
    "fr": {
        "readme": "README.md",
        "locale": "fr_FR",
        "sous_titre": "Mesurer ses suspentes au laser, sous 5 kg, avec deux pièces imprimées en 3D : 7 fichiers pour le banc, un support à la taille de votre télémètre, 30 € de quincaillerie.",
        "etiquette": "Outil gratuit à imprimer en 3D",
        "telecharger": "Télécharger les fichiers STL",
        "source": "Code source",
        "sommaire": "Sommaire",
        "fichiers": "Un fichier STL par pièce, déjà orienté pour l'impression, en millimètres. Les matières conseillées sont plus bas.",
        "supports_titre": "Le support du laser, dans la version de votre télémètre",
        "supports": "Leica DISTO et Bosch à moins de 500 €, aux cotes du constructeur (longueur × largeur × épaisseur) plus 0,5 mm de jeu. Autre télémètre : voir plus bas.",
        "taille": "%d Ko",
        "cree": "Développé et offert gratuitement par WeFlare.",
        "autres": "Autres outils gratuits :",
        "outils": [("https://trim.weflare.fr/", "Wing Trim, l'application de mesure et de calage des suspentes"),
                   ("https://soundings.weflare.fr/fr/", "PG Soundings, la prévision du vol libre dans Windy")],
        "pied": "Page construite automatiquement à partir du dépôt : elle reflète l'état des fichiers au dernier changement.",
        "langue": "Langue",
    },
}

# ce qui est propre à cette page ; le reste vient de la feuille commune des outils WeFlare
STYLE = """
.tt-vues { display: grid; grid-template-columns: repeat(auto-fit, minmax(14rem, 1fr)); gap: 12px; }
.tt-vues figure { margin: 0; padding: 10px; }
.tt-vues img { display: block; width: 100%; border-radius: 8px; background: #fff; }
.tt-vues figcaption { margin-top: 8px; padding: 0 4px 2px; font-size: .88rem; font-weight: 600; }
.tt-cols { display: grid; grid-template-columns: minmax(0, 1fr); gap: 24px; margin-top: clamp(28px, 5vw, 44px); }
@media (min-width: 60rem) { .tt-cols { grid-template-columns: 14rem minmax(0, 1fr); gap: 32px; align-items: start; } .tt-sommaire { position: sticky; top: 16px; } }
.tt-sommaire { padding: 16px 18px; font-size: .9rem; }
.tt-sommaire h2 { margin: 0 0 8px; font-size: .74rem; font-weight: 700; letter-spacing: .06em; text-transform: uppercase; color: var(--wf-muted); }
.tt-sommaire ol { margin: 0; padding: 0; list-style: none; display: grid; gap: 6px; }
.tt-sommaire a { color: var(--wf-ink); text-decoration: none; }
.tt-sommaire a:hover { color: var(--wf-accent-strong); text-decoration: underline; }
.tt-fichiers { margin-bottom: 28px; scroll-margin-top: 16px; }
.tt-fichiers h2 { margin: 0 0 6px; }
.tt-fichiers ul + h2 { margin-top: 24px; }
.tt-fichiers p { margin: 0 0 14px; color: var(--wf-muted); }
.tt-fichiers ul { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(13rem, 1fr)); gap: 8px; }
.tt-fichiers li { margin: 0; }
.tt-fichiers .wf-btn { display: block; padding: 9px 12px; font: 600 .85rem var(--wf-mono); overflow-wrap: anywhere; }
.tt-fichiers .wf-btn small { display: block; margin-top: 2px; font: 400 .8rem var(--wf-font); color: var(--wf-muted); }
.tt-fichiers .tt-vue { display: inline-block; margin: 2px 0 0 4px; font-size: .82rem; }
"""


def lire(*chemin):
    return open(os.path.join(*chemin), encoding="utf-8").read()


def vers(depuis, langue):
    """Adresse du dossier d'une langue, depuis la page d'une autre : « ./ », « fr/ » ou « ../ »"""
    if depuis == langue:
        return "./"
    return ("" if depuis == LANGUES[0] else "../") + ("" if langue == LANGUES[0] else langue + "/")


def banniere(readme):
    """Le titre et le tableau d'images du début du README passent dans la bannière.

    Rend le titre, les figures (image, texte de remplacement, légende) et le README sans eux.
    """
    readme = readme.replace("\r\n", "\n")
    titre = re.search(r"^# (.*)\n", readme).group(1).strip()
    readme = re.sub(r"^# .*\n", "", readme, count=1)
    # le lien vers le README de l'autre langue ne sert que sur GitHub : la page a son choix de langue
    readme = re.sub(r"^\[[^\]]*\]\(README(\.\w+)?\.md\)\s*\n", "", readme, count=1, flags=re.M)
    tableau = re.search(r"\n\|([^\n]*)\|\n\|---[^\n]*\n\|([^\n]*!\[[^\n]*)\|\n", readme)
    legendes = [c.strip() for c in tableau.group(1).split("|")]
    images = re.findall(r"!\[([^\]]*)\]\(([^)]+)\)", tableau.group(2))
    readme = readme.replace(tableau.group(0), "\n\n", 1)
    return titre, [(src, alt, legende) for (alt, src), legende in zip(images, legendes)], readme


def page(langue, logo, style, stls, lasers, site):
    t = TEXTES[langue]
    base = vers(langue, LANGUES[0])
    taille = lambda f: t["taille"] % round(os.path.getsize(os.path.join(RACINE, "stl", f)) / 1024)
    titre, figures, readme = banniere(lire(RACINE, t["readme"]))
    corps = markdown.markdown(readme, extensions=["tables", "fenced_code", "toc", "sane_lists"],
                              extension_configs={"toc": {"toc_depth": "2"}})
    corps = corps.replace("<table>", '<div class="wf-scroll"><table>').replace("</table>", "</table></div>")
    # les images et les STL sont à la racine du site, quelle que soit la langue
    corps = re.sub(r'(src|href)="(apercu|stl)/', r'\1="%s\2/' % base, corps)
    # sommaire : les titres de niveau 2
    titres = re.findall(r'<h2 id="([^"]+)">(.*?)</h2>', corps)
    sommaire = "".join('<li><a href="#%s">%s</a></li>' % (i, re.sub(r"<.*?>", "", h)) for i, h in titres)
    fichiers = "".join('<li><a class="wf-btn wf-btn--ghost" href="%sstl/%s" download>%s<small>%s</small></a></li>'
                       % (base, f, html.escape(f), taille(f)) for f in stls)
    # le support du laser : une version par télémètre de outils/lasers.json
    supports = ""
    for m in lasers:
        f = "support_laser_%s.stl" % m["slug"]
        if not os.path.exists(os.path.join(RACINE, "stl", f)):
            continue
        supports += ('<li><a class="wf-btn wf-btn--ghost" href="%sstl/%s" download>%s<small>%s × %s × %s mm · %s</small></a>'
                     % (base, f, html.escape(m["modele"]), m["longueur"], m["largeur"], m["epaisseur"], taille(f)))
        if os.path.exists(os.path.join(RACINE, "apercu", "support_laser_%s.png" % m["slug"])):
            supports += '<a class="tt-vue" href="%sapercu/support_laser_%s.png">image</a>' % (base, m["slug"])
        supports += "</li>"
    vues = "".join('<figure class="wf-card"><img src="%s%s" alt="%s"><figcaption>%s</figcaption></figure>'
                   % (base, src, html.escape(alt), html.escape(legende)) for src, alt, legende in figures)
    choix = "".join('<a href="%s" lang="%s" hreflang="%s"%s onclick="try{localStorage.setItem(\'%s\',\'%s\')}catch(e){}">%s</a>'
                    % (vers(langue, l), l, l, ' aria-current="page"' if l == langue else "", CLE_LANGUE, l, l.upper())
                    for l in LANGUES)
    outils = "".join('<li><a href="%s">%s</a></li>' % (url, html.escape(nom)) for url, nom in t["outils"])
    # la page par défaut envoie vers sa langue le visiteur qui en a choisi une autre, ou dont le
    # navigateur est dans une autre langue du site tant qu'il n'a rien choisi
    renvoi = ""
    if langue == LANGUES[0]:
        renvoi = ("<script>try{var l=localStorage.getItem('%s')||(navigator.language||'').slice(0,2).toLowerCase();"
                  "if(%s.indexOf(l)>=0)location.replace(l+'/'+(location.protocol=='file:'?'index.html':'')+location.hash)}catch(e){}</script>\n"
                  % (CLE_LANGUE, json.dumps(LANGUES[1:])))
    # balises des aperçus de lien : elles demandent des adresses complètes, donc le domaine du site
    social = ['<meta property="og:type" content="website">',
              '<meta property="og:locale" content="%s">' % t["locale"],
              '<meta property="og:title" content="%s">' % html.escape(titre),
              '<meta property="og:description" content="%s">' % html.escape(t["sous_titre"])]
    if site:
        adresse = lambda l: "%s/%s" % (site, "" if l == LANGUES[0] else l + "/")
        social += ['<link rel="canonical" href="%s">' % adresse(langue)]
        social += ['<link rel="alternate" hreflang="%s" href="%s">' % (l, adresse(l)) for l in LANGUES]
        social += ['<link rel="alternate" hreflang="x-default" href="%s">' % adresse(LANGUES[0]),
                   '<meta property="og:url" content="%s">' % adresse(langue),
                   '<meta property="og:image" content="%s/%s">' % (site, IMAGE_APERCU)]
    social = "\n".join(social)

    return f"""<!doctype html>
<html lang="{langue}">
<head>
<meta charset="utf-8">
{renvoi}<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(titre)}</title>
<meta name="description" content="{html.escape(t["sous_titre"])}">
<meta name="theme-color" content="#f5f7f9">
{social}
<link rel="icon" type="image/svg+xml" href="{base}favicon.svg">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Mona+Sans:wght@400..800&display=swap">
<style>{style}</style>
</head>
<body>
<header class="wf-top">
<span class="wf-brand">{logo}</span>
<nav class="wf-lang" aria-label="{t["langue"]}">{choix}</nav>
</header>
<main class="wf-page">
<div class="wf-hero">
<span class="wf-eyebrow">{t["etiquette"]}</span>
<h1 class="wf-title">{html.escape(titre)}</h1>
<p class="wf-lead">{html.escape(t["sous_titre"])}</p>
<div class="wf-actions">
<a class="wf-btn" href="#stl">{t["telecharger"]}</a>
<a class="wf-btn wf-btn--ghost" href="{DEPOT}">{t["source"]}</a>
</div>
</div>
<div class="tt-vues">{vues}</div>
<div class="tt-cols">
<nav class="tt-sommaire wf-card"><h2>{t["sommaire"]}</h2><ol>{sommaire}</ol></nav>
<div class="wf-prose">
<section class="tt-fichiers wf-card" id="stl"><h2>{t["telecharger"]}</h2>
<p>{t["fichiers"]}</p>
<ul>{fichiers}</ul>
<h2>{t["supports_titre"]}</h2>
<p>{t["supports"]}</p>
<ul>{supports}</ul></section>
{corps}
</div>
</div>
</main>
<footer class="wf-foot"><div class="wf-foot-in">
<div class="wf-made">{logo}<span>{t["cree"]}</span></div>
<ul class="wf-tools"><li>{t["autres"]}</li>{outils}</ul>
<p>{t["pied"]}</p>
</div></footer>
</body>
</html>
"""


def main():
    os.makedirs(OUT, exist_ok=True)
    for d in ("stl", "apercu"):
        dst = os.path.join(OUT, d)
        if os.path.isdir(dst):
            shutil.rmtree(dst)
        shutil.copytree(os.path.join(RACINE, d), dst)
    stls = sorted(f for f in os.listdir(os.path.join(RACINE, "stl")) if f.endswith(".stl") and not f.startswith("support_laser_"))
    lasers = json.loads(lire(OUTILS, "lasers.json"))
    site = ""
    cname = os.path.join(RACINE, "CNAME")
    if os.path.exists(cname):
        shutil.copy(cname, OUT)
        site = "https://" + lire(cname).strip()
    shutil.copy(os.path.join(OUTILS, "weflare-mark.svg"), os.path.join(OUT, "favicon.svg"))

    # le logo WeFlare est dessiné dans la page, pour prendre la couleur du texte
    logo = lire(OUTILS, "weflare.svg").strip().replace("<svg ", '<svg class="wf-logo" ', 1)
    style = lire(OUTILS, "weflare.css") + STYLE
    for langue in LANGUES:
        dossier = OUT if langue == LANGUES[0] else os.path.join(OUT, langue)
        os.makedirs(dossier, exist_ok=True)
        open(os.path.join(dossier, "index.html"), "w", encoding="utf-8", newline="\n").write(
            page(langue, logo, style, stls, lasers, site))
    open(os.path.join(OUT, ".nojekyll"), "w").close()
    print("site écrit dans", OUT, ":", len(stls), "fichiers STL,", len(lasers), "télémètres,", ", ".join(LANGUES))


if __name__ == "__main__":
    main()
