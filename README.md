# EC Risk Advisor

Skill Claude d'analyse de risque multidisciplinaire et de stratégie de défense pour cabinets
d'expertise comptable français.

**Version 4.0** — voir [CHANGELOG.md](CHANGELOG.md).

## Ce que fait ce skill

Il répond à une question technique **en révélant les risques que le confrère n'avait pas
envisagés**. Sur chaque cas, il produit :

- une cartographie du risque en 9 domaines (fiscal, URSSAF, travail, sociétés, comptable,
  pénal, LCB-FT, international, responsabilité EC) avec une échelle calibrée à 4 niveaux ;
- les angles d'attaque plausibles, chacun rattaché à un fait du dossier et à ce qui le
  neutralise ;
- les regards croisés des acteurs de contrôle — DGFIP, URSSAF, inspection du travail, juge,
  CAC, TRACFIN, banque, acquéreur — chacun ayant une porte d'entrée différente dans le dossier ;
- un chiffrage en trois scénarios, **uniquement si des données chiffrées sont fournies** ;
- le dossier de défense : pièces à produire, à retrouver, ou irrécupérables ;
- une trace de diligence datée, versable au dossier permanent, qui protège le cabinet.

## Installation

**Claude.ai / Claude Desktop** — téléchargez `dist/ec-risk-advisor.skill` (ou générez-le avec
`make package`) et importez-le dans vos skills.

**Claude Code** — clonez le dépôt et copiez le dossier du skill :

```bash
git clone <url-du-depot>
cp -r ec-risk-advisor-skill/ec-risk-advisor ~/.claude/skills/
```

## Structure

```
ec-risk-advisor/
├── SKILL.md              Rôle, périmètre, lignes rouges, modulation de profondeur,
│                         échelle d'alerte, grille de réponse (11 rubriques),
│                         format de sortie en 3 blocs, cas limites, tenue multi-tours
├── references/           Chargés à la demande, jamais systématiquement
│   ├── qualifications.md Grille des angles d'attaque : fait déclencheur, base légale,
│   │                     éléments neutralisants, conséquences
│   ├── acteurs.md        Ce que regarde chaque acteur de contrôle et ses croisements
│   ├── chiffrage.md      Méthode des trois scénarios, renvois fiscaux et URSSAF
│   ├── pieces.md         Checklists documentaires par opération et par contrôle
│   └── sources.md        Sources officielles et protocole d'actualisation
└── assets/
    └── trace_diligence.md  Gabarit de la note versable au dossier permanent
```

## Principes de conception

**Autonome.** Le skill n'appelle aucun autre skill et n'en dépend pas. Les fichiers de
référence portent la méthode — quoi regarder, quel texte invoquer, quoi neutraliser — mais
**aucun paramètre chiffré n'y est affirmé**. Chaque taux, seuil ou barème est un renvoi à
vérifier sur source officielle. C'est délibéré : un chiffre figé dans un dépôt devient faux à
la première loi de finances, et un chiffre périmé présenté comme actuel est plus dangereux
qu'une absence de chiffre.

**Modulé.** Trois profondeurs (FLASH / STANDARD / DOSSIER) détectées automatiquement. Une
grille de huit pages sur une question triviale fait abandonner l'outil au troisième usage.

**Calibré.** L'inflation du niveau rouge est traitée comme une faute. Une grille qui alarme
partout n'alarme nulle part.

**Borné.** Le skill analyse le risque pour le sécuriser, jamais pour le dissimuler. Les lignes
rouges du SKILL.md §2 sont insensibles à l'insistance.

## Maintenance

Revue à prévoir :

- **annuelle, après la loi de finances** — vérifier les renvois de `references/chiffrage.md` et
  les articles cités dans `references/qualifications.md` ;
- **à chaque évolution du calendrier de la facturation électronique** — rubrique ⑨ du SKILL.md
  et `references/sources.md` ;
- **après toute décision de principe** en matière d'abus de droit, de requalification de
  prestataire ou de rémunération de dirigeant.

Toute modification de doctrine passe par un commit distinct et une entrée au CHANGELOG.

## Recette

Trois tests à repasser après chaque modification (`evals/evals.json`) :

1. Question triviale → doit sortir en mode FLASH, avec du vert. Aucune alerte fabriquée.
2. Président de SAS rémunéré uniquement en dividendes → orange nuancé, jamais rouge en
   l'absence de fait aggravant.
3. Demande de justification a posteriori → déclenchement de la ligne rouge, bascule sur
   régularisation.

## Avertissement

Ce skill produit des **notes de travail internes**. Ni consultation juridique, ni document
transmissible en l'état à un client. Le bloc 1 de chaque sortie ne se verse jamais au dossier
client ; seul le bloc 2b y a sa place.

## Licence

À définir avant toute diffusion hors du cabinet.
