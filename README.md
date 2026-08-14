# After Hours Records

A self-contained interactive record-store site.

## This version

- focuses on the **game feel** instead of dashboard-style UI
- adds a full **intro splash page** with controls
- uses a larger, camera-following world
- adds a more animated player sprite
- adds a visible **stack of records in the character's hand** when albums are picked up
- keeps the archive structure by year and lets visitors explore aisle-by-aisle
- preserves the real-cover lookup system using the public iTunes Search API via JSONP
- keeps checkout lightweight by exporting playlist/search packs

## Controls

- **WASD / Arrow keys** — move
- **E / Enter** — inspect / enter / interact
- **F** — pick up / put back a nearby record
- **Q** — leave an aisle
- **C** — open checkout on the main floor
- **Esc** — close panels

## GitHub Pages

Upload `index.html` to the root of your repository and publish Pages from:

- branch: `main`
- folder: `/(root)`

## Notes

- Real covers are resolved lazily as visitors get near the records.
- If a particular album doesn't resolve artwork, the game falls back to a stylized sleeve.
- Checkout currently exports playlist/search packs instead of using direct Spotify/Apple account APIs.
