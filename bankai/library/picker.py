#!/usr/bin/env python
# Generates PICKER.html — the visual theme picker (local, reads shots/*.png)
import io, json, os, re, html

HERE = os.path.dirname(os.path.abspath(__file__))
themes = io.open(os.path.join(HERE, 'THEMES.md'), encoding='utf-8').read()
urls = json.load(io.open(os.path.join(HERE, 'shots', 'urls.json'), encoding='utf-8'))

def slug(n): return re.sub(r'[^a-zA-Z0-9]+', '-', n).strip('-').lower()[:60]
url_by_slug = {slug(n): u for n, u in urls.items()}

def find_shot(name):
    s = slug(name.strip())
    p = os.path.join(HERE, 'shots', s + '.png')
    return ('shots/' + s + '.png', url_by_slug.get(s, '')) if os.path.isfile(p) else (None, url_by_slug.get(s, ''))

# parse THEMES.md
lines = themes.split('\n')
family = ''
out, cards = [], []
cur = None
for ln in lines:
    m = re.match(r'^## Family [A-F] — (.+)$', ln)
    if m:
        family = m.group(1); continue
    if ln.startswith('### '):
        if cur: cards.append(cur)
        cur = {'name': ln[4:].strip(), 'family': family, 'ex': [], 'mech': [], 'identity': '', 'fits': '', 'pairs': ''}
        continue
    if not cur: continue
    if ln.startswith('**Identity**:'): cur['identity'] = ln[12:].strip()
    elif ln.startswith('**Fits**:'): cur['fits'] = ln[8:].strip()
    elif ln.startswith('**Exemplars**:'):
        for part in re.split(r'[;·]', ln[13:]):
            mm = re.search(r'([A-Za-zÀ-ÿ0-9][^—()*\n]{2,60}?)\s*—\s*0\d', part)
            if mm: cur['ex'].append(mm.group(1).strip())
    elif ln.startswith('**Mechanism palette**:'): cur['mech'].append(ln[22:].strip())
    elif ln.startswith('- **Mechanism palette**:'): cur['mech'].append(ln[24:].strip())
    elif ln.startswith('**Pairs well with**:'): cur['pairs'] = ln[19:].strip()
if cur: cards.append(cur)

nshots = 0
def render_card(t):
    global nshots
    thumbs = []
    for e in t['ex'][:6]:
        shot, url = find_shot(e)
        if shot: nshots += 1
        label = html.escape(e)
        thumbs.append(f'''<div class="ex">{'<a href="'+html.escape(url)+'" target="_blank">' if url else ''}<img loading="lazy" src="{shot}" alt="{label}" onerror="this.parentNode.classList.add('noimg');this.remove()">{'' if not url else '</a>'}<span>{label}</span></div>''' if shot else f'<div class="ex none"><span>{label}</span></div>')
    return f'''<article class="theme"><h3>{html.escape(t['name'])}</h3>
<p class="fam">{html.escape(t['family'])}</p>
<p class="id">{html.escape(t['identity'])}</p>
<p class="fits"><b>Fits:</b> {html.escape(t['fits'])}</p>
<div class="row">{''.join(thumbs)}</div>
<p class="mech"><b>Mechanisms:</b> {html.escape(' · '.join(t['mech']))}</p>
<p class="pairs"><b>Pairs:</b> {html.escape(t['pairs'])}</p></article>'''

byfam = {}
for t in cards: byfam.setdefault(t['family'], []).append(t)
body = '\n'.join(f'<section><h2>{html.escape(f)}</h2><div class="grid">' + '\n'.join(render_card(t) for t in ts) + '</div></section>' for f, ts in byfam.items())

doc = f'''<!doctype html><html lang="en"><head><meta charset="utf-8"><title>bankai — theme picker</title>
<style>
:root{{--bg:#101014;--card:#191922;--ink:#eceaf3;--mut:#9b98ad;--acc:#e2a24a;--line:#2a2a38}}
*{{box-sizing:border-box;margin:0}}
body{{background:var(--bg);color:var(--ink);font:15px/1.5 ui-sans-serif,system-ui;padding:40px 5vw 80px}}
header{{max-width:1500px;margin:0 auto 34px}}
h1{{font-size:clamp(26px,3.4vw,44px);letter-spacing:-.02em}} h1 b{{color:var(--acc)}}
header p{{color:var(--mut);max-width:70ch;margin-top:8px}}
section{{max-width:1500px;margin:38px auto}} section h2{{font:600 13px ui-monospace,monospace;letter-spacing:.16em;text-transform:uppercase;color:var(--acc);margin:0 0 14px}}
.grid{{display:grid;grid-template-columns:repeat(auto-fill,minmax(430px,1fr));gap:14px}}
.theme{{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:16px 16px 12px;display:flex;flex-direction:column;gap:8px}}
.theme h3{{font-size:18px;letter-spacing:-.01em}} .fam{{font:11px ui-monospace;color:var(--mut);margin-top:-4px}}
.id{{color:var(--ink)}} .fits{{color:var(--mut);font-size:13px}} .mech{{font-size:13px;color:var(--ink)}} .pairs{{font-size:12px;color:var(--mut)}}
.row{{display:grid;grid-template-columns:repeat(3,1fr);gap:6px;margin:4px 0}}
.ex{{position:relative;border-radius:8px;overflow:hidden;background:#0b0b10;aspect-ratio:4/3;border:1px solid var(--line)}}
.ex img{{width:100%;height:100%;object-fit:cover;object-position:top;display:block}}
.ex>span{{position:absolute;left:0;right:0;bottom:0;padding:3px 6px;font:11px ui-monospace;background:rgba(10,10,16,.82);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}}
.ex.none{{display:flex;align-items:flex-end}} .ex.none span{{position:static;background:none;color:var(--mut);padding:6px}}
b{{color:var(--ink)}}
@media(max-width:560px){{.grid{{grid-template-columns:1fr}}body{{padding:20px 3vw}}}}
</style></head><body>
<header><h1>bankai <b>theme picker</b></h1>
<p>33 directions × {nshots} visual exemplars from the 256-entry reference library. When choosing a theme for a build: scan the families, shortlist 3–5 whose <b>Fits</b> matches the brief, read the mechanism palettes, and click any image to open the live reference.</p></header>
{body}
</body></html>'''
io.open(os.path.join(HERE, 'PICKER.html'), 'w', encoding='utf-8').write(doc)
print(f"PICKER.html: {len(cards)} themes, {nshots} thumbnails embedded")
