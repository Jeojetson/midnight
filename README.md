# After Hours Records — real-art + instant-playlist build

This build focuses on the three things that were still weak: the Replay aisle presentation, real album artwork, and actually useful checkout controls.

## What changed

- Removed the decorative year-count UI from the top of the page.
- Added only functional header controls: **Connections** and **Cart**.
- Replay aisles now use **large 300px record sleeves** so the albums dominate the screen instead of sitting far away from the player.
- The player still walks horizontally through the long aisle while the camera follows.
- Album art lookup now uses the iTunes Search API's documented **JSONP / dynamic-script method**, which works from a static cross-origin website such as GitHub Pages.
- Artwork matching searches by the replay song + artist first, then falls back to album + artist. This is much more reliable when the PDF's album column was truncated.
- Real art is reduced to a low-resolution pixel grid. When cross-origin pixel access is available, the image is also blended slightly toward its actual average color. If the browser blocks average-color sampling, the real cover still displays rather than falling back to fake art.
- Checkout now has **Create in Spotify** and **Create in Apple Music** buttons.

## Controls

- WASD / arrows — move
- E / Enter — enter aisle / inspect record
- F — add/remove nearby album from cart
- C — checkout
- Q — leave a Replay aisle
- Escape — close panels

## Spotify instant playlists

Spotify can work entirely on GitHub Pages because the site uses the browser-safe **Authorization Code + PKCE** flow.

One-time setup for the site owner:

1. Create an app in the Spotify Developer Dashboard.
2. Open the deployed website and click **Connections**.
3. Copy the exact Redirect URI shown there into the Spotify app's Redirect URIs.
4. Paste the app's **Client ID** into Connections and save it.
5. Click **Connect Spotify** and authorize.

For a public deployment, you can also paste the Client ID once into `PUBLIC_SERVICE_CONFIG.spotifyClientId` near the top of the JavaScript in `index.html`. Client IDs are public identifiers; do **not** put a Spotify client secret in this static site.

At checkout the website:

1. searches Spotify for each replay song in the cart,
2. creates a private playlist,
3. adds matched tracks in batches,
4. returns a link to open the finished playlist.

## Apple Music instant playlists

Apple Music uses **MusicKit on the Web**. The website is wired to:

1. load MusicKit,
2. ask the visitor to authorize their Apple Music account,
3. resolve the cart songs against the Apple Music catalog,
4. create a library playlist,
5. add the matched catalog songs.

MusicKit also needs a signed **Apple Music developer token** belonging to the website owner.

For testing, paste that token into **Connections**. For a public deployment, set `PUBLIC_SERVICE_CONFIG.appleDeveloperToken` in `index.html`, or preferably serve a fresh signed token from a tiny backend/serverless function.

**Never put the Apple `.p8` private key in this website or repository.** Only the signed developer token belongs in the browser.

## Real album covers

The artwork system does not bundle copied album images into the repository. Instead, while the user approaches records, the site queries Apple's public iTunes Search API and loads the matching promotional cover art.

The lookup flow is:

1. replay song + artist search,
2. score candidate results against song / artist / album,
3. fall back to album + artist if necessary,
4. load high-resolution artwork,
5. downsample it to a chunky pixel grid,
6. blend toward the sampled average color where browser CORS permissions allow it.

This should make the shelves show the **actual covers**, not generated placeholders, once the network lookup completes.

## GitHub Pages

The website is still a single-file static site.

1. Upload `index.html` to your repository.
2. Go to **Settings → Pages**.
3. Deploy from the `main` branch / root folder.
4. Once the final GitHub Pages URL exists, use that exact URL as the Spotify Redirect URI.

## Important deployment note

Spotify's public Client ID can safely live in the HTML. Apple Music's signed developer token is also consumed by the browser, but it expires; for a long-lived public site, a small token endpoint is cleaner than manually editing the HTML every time it rotates.

## Important: previewing real album covers on a Mac

Do **not** double-click `index.html` and run it as `file://...` if you want reliable live artwork.
Safari can restrict cross-site catalog requests from local files.

Instead, double-click `start.command`. It starts a small local web server and opens:

```text
http://localhost:8765/index.html
```

That uses the same HTTP environment the deployed GitHub Pages site will use.
The page caches successfully resolved artwork URLs in local storage, so revisiting an aisle is much faster.

The artwork resolver now:

1. searches Apple's iTunes catalog using an exact Replay song + artist,
2. falls back to album + artist,
3. loads the real artwork,
4. reduces it to a small pixel grid,
5. blends the pixels slightly toward the cover's average color,
6. enlarges that grid back into the shelf cover.
