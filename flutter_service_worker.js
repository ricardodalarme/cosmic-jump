'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "6533d032cdbab2ba8f631e7179cd608c",
"version.json": "080d99ac753493397d95c20550df27ae",
"index.html": "fdb2a5ae5659cc1e8b9bc051adcdc09f",
"/": "fdb2a5ae5659cc1e8b9bc051adcdc09f",
"main.dart.js": "beff827367b4fc9c5587448e8c5b1999",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"favicon.png": "6d576d1297b9436719fd85815c0d0a7b",
"icons/Icon-192.png": "b9e61bd16caf448f659a2ed654a86450",
"icons/Icon-maskable-192.png": "b9e61bd16caf448f659a2ed654a86450",
"icons/Icon-maskable-512.png": "33d82c9f8f348747ca03ad930c3ca837",
"icons/Icon-512.png": "33d82c9f8f348747ca03ad930c3ca837",
"manifest.json": "54632f03bdae9c546879d36cccf3af3e",
"assets/AssetManifest.json": "dcf5435252b30975adb747feb095038b",
"assets/NOTICES": "b90a081d1f7f3f02055dacb030a2f506",
"assets/FontManifest.json": "d751713988987e9331980363e24189ce",
"assets/AssetManifest.bin.json": "4eef5ac3a1af24b9de43714fbffaf6d0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "30c5ede3e6b2690fba526a7fe062801b",
"assets/assets/images/Asteroids/Asteroid.png": "ceb4f32ef0671751951bf5dac790a266",
"assets/assets/images/Traps/Saw/Off.png": "66d27386fec46e0b052941957d9bdc22",
"assets/assets/images/Traps/Saw/Chain.png": "69669f8f421b508058cdf1232dc49e28",
"assets/assets/images/Traps/Saw/On%2520(38x38).png": "817477a39df8b330334e3866c1cb574b",
"assets/assets/images/Backgrounds/Venus.png": "9d1e2e901a63a8b215c022cfb2e9671a",
"assets/assets/images/Backgrounds/Backgrounds.png": "cec5ef5e26cd101aeb0b84cf1bf4a12f",
"assets/assets/images/Backgrounds/Mars.png": "56c8eba836f523ef5cfbc68032b10059",
"assets/assets/images/Backgrounds/Mercury.png": "860651989f164828af40df022a24a553",
"assets/assets/images/Terrain/Terrain%2520(16x16).png": "df891f02449c0565d51e2bf7823a0e38",
"assets/assets/images/Planets/Pictures/Venus.png": "9d8194f2278445bb70fec2e440b468e5",
"assets/assets/images/Planets/Pictures/Mars.png": "aec7389301517e26c7d9002545ba3a76",
"assets/assets/images/Planets/Pictures/Mercury.png": "9fa4dc5a3749eea07473992d795d94b6",
"assets/assets/images/Fogs/Fog.png": "927ca64925ef147d081059c12e2db125",
"assets/assets/images/Items/AntiPoisonMask.png": "2371dc3e8d33dc50620c1c3dbbe52ff8",
"assets/assets/images/Items/Collected.png": "0aa8cdedde5af58d5222c2db1e0a96de",
"assets/assets/images/Items/Checkpoints/Checkpoint/Checkpoint%2520(No%2520Flag).png": "9126203dc833ec3b7dfb7a05e41910e5",
"assets/assets/images/Items/Checkpoints/Checkpoint/Checkpoint%2520(Flag%2520Idle)(64x64).png": "dd8752c20a0f69ab173f1ead16044462",
"assets/assets/images/Items/Checkpoints/Checkpoint/Rocket.png": "5edd0a11bb1cc362e2778c9395231b8c",
"assets/assets/images/Items/Checkpoints/Checkpoint/Checkpoint%2520(Flag%2520Out)%2520(64x64).png": "c4730e5429a75691e2d2a9351c76738e",
"assets/assets/images/Items/GravityBoots.png": "370689e7ee546af2adeaf929fecfe34c",
"assets/assets/images/Items/Jetpack.png": "92f2b2000a7d6885947a83652f92d4e0",
"assets/assets/images/Items/Glasses.png": "d1f7a260df5c1bc5119141484fb53348",
"assets/assets/images/Characters/Virtual%2520Guy/Idle%2520(32x32).png": "1cb575929ac10fe13dfafa61d78ba28d",
"assets/assets/images/Characters/Virtual%2520Guy/Jump%2520(32x32).png": "f28e95fc98b251913baf3a21d5602381",
"assets/assets/images/Characters/Virtual%2520Guy/Fall%2520(32x32).png": "5eb8c32845fad5fcc7794247eb91aed0",
"assets/assets/images/Characters/Virtual%2520Guy/Hit%2520(32x32).png": "bbd39134a77e658b0b9b64ded537972c",
"assets/assets/images/Characters/Virtual%2520Guy/Run%2520(32x32).png": "016f388a07f71a930fd79a7a806d5da8",
"assets/assets/images/Characters/Virtual%2520Guy/Double%2520Jump%2520(32x32).png": "612926916a3e8c5deff2023722c465ac",
"assets/assets/images/Characters/Virtual%2520Guy/Wall%2520Jump%2520(32x32).png": "76cbdd4a22d50bd65ac02be8a5eb1547",
"assets/assets/images/Characters/Pink%2520Man/Idle%2520(32x32).png": "1b35f85f1241dc1f0597cafbe1eac7f6",
"assets/assets/images/Characters/Pink%2520Man/Jump%2520(32x32).png": "cafaf2f48f36c9a6655a37f9c1c47b4a",
"assets/assets/images/Characters/Pink%2520Man/Fall%2520(32x32).png": "a20bd61d76132e4301fcfe7aa02ca9ba",
"assets/assets/images/Characters/Pink%2520Man/Hit%2520(32x32).png": "5d93268a09fb2959e1755da4ba201f9e",
"assets/assets/images/Characters/Pink%2520Man/Run%2520(32x32).png": "25fcce89dfb6673a81d384091c87353d",
"assets/assets/images/Characters/Pink%2520Man/Double%2520Jump%2520(32x32).png": "c76baa04d956c9d985c79643d7b2f672",
"assets/assets/images/Characters/Pink%2520Man/Wall%2520Jump%2520(32x32).png": "955d352171a2b666ae705b6205856ce1",
"assets/assets/images/Characters/Desappearing%2520(96x96).png": "1284313649da02eccc0d3ed6796996a3",
"assets/assets/images/Characters/Mask%2520Dude/Idle%2520(32x32).png": "29c95dbb63a9bf44c42821aa0cf49de8",
"assets/assets/images/Characters/Mask%2520Dude/Jump%2520(32x32).png": "99da59b514370539951a76ba1fe51821",
"assets/assets/images/Characters/Mask%2520Dude/Fall%2520(32x32).png": "469d2d7814fa8258325eb5d305808315",
"assets/assets/images/Characters/Mask%2520Dude/Hit%2520(32x32).png": "d03a7bbce7fbda59dd057397f86a8899",
"assets/assets/images/Characters/Mask%2520Dude/Run%2520(32x32).png": "b04bbc82dc692516a4b13c0d9d5b9ebd",
"assets/assets/images/Characters/Mask%2520Dude/Double%2520Jump%2520(32x32).png": "5afb26aa4240eff1eab105eb3263ab83",
"assets/assets/images/Characters/Mask%2520Dude/Wall%2520Jump%2520(32x32).png": "552254b40eac6d10d2c3d779edb92116",
"assets/assets/images/Characters/Ninja%2520Frog/Idle%2520(32x32).png": "cb655be6f9354444720c7ce1dbd61dae",
"assets/assets/images/Characters/Ninja%2520Frog/Jump%2520(32x32).png": "4f048ccbc783c8eb3824be9651da8a34",
"assets/assets/images/Characters/Ninja%2520Frog/Fall%2520(32x32).png": "ef8f3627041b7ae2a1dc76dfc3e419f3",
"assets/assets/images/Characters/Ninja%2520Frog/Hit%2520(32x32).png": "4c1ba2bf4e576409abbbd1aacc91d51d",
"assets/assets/images/Characters/Ninja%2520Frog/Run%2520(32x32).png": "fb191b4e6ac599286c38e496a700cfd2",
"assets/assets/images/Characters/Ninja%2520Frog/Double%2520Jump%2520(32x32).png": "351c1df6eb5ac94209e8e490ab816879",
"assets/assets/images/Characters/Ninja%2520Frog/Wall%2520Jump%2520(32x32).png": "37ec0be0f82c3750a07efa558c032ee7",
"assets/assets/images/Characters/Appearing%2520(96x96).png": "9449bf1f8d68ac08331aa091d6095e34",
"assets/assets/images/HUD/Main.png": "7ccfa6cc64116d18d258881d1819fafc",
"assets/assets/images/HUD/Health.png": "cac809432af601cccb22ce4f1b66591e",
"assets/assets/images/HUD/Joystick.png": "0d48d554dbd23681dc2c3dc26d9ec0cc",
"assets/assets/images/HUD/Energy.png": "0b85393940e7b387e5475417b65ff106",
"assets/assets/images/HUD/JumpButton.png": "c365c9b1778af4f9775873544b7feab1",
"assets/assets/images/HUD/red_button_sqr.png": "8c109fb14b7ada8a396287c7869531ad",
"assets/assets/images/HUD/Knob.png": "07acc29d4e539b9c402f4f1a57d9f4e0",
"assets/assets/images/HUD/Equipment.png": "2472784c796daf96636786dda3819602",
"assets/assets/images/HUD/Dialog.png": "da8b8d446e01f9892e6173291662e733",
"assets/assets/images/HUD/Pause.png": "b1ff61905afbaf4c2d253b2429e680ed",
"assets/assets/images/HUD/green_button_sqr.png": "96d513e58e934dd3986eb5f87ba7cf4e",
"assets/assets/yarn/Mars.yarn": "0819ee8e4ea8637eccf1278787566d7c",
"assets/assets/yarn/Mercury.yarn": "2d1c178e7728c5452ba7f3d5d25fb531",
"assets/assets/yarn/Venus.yarn": "d20b0424f52e3fd425bbe1a4b3f9b58a",
"assets/assets/tiles/Pixel%2520Adventure.tsx": "06d455a8519d8c1ca05600621f471513",
"assets/assets/tiles/Backgrounds.tsx": "527aabcaa7ec2176b5c12650018098e9",
"assets/assets/tiles/Mercury.tmx": "e48520db8c3a70bdb5e68b2a17693916",
"assets/assets/tiles/Venus.tmx": "af76edb241eae78a81733a5520a913cb",
"assets/assets/tiles/Pixel%2520Adventure.tiled-project": "f3345de7d9f33cbee85b1453acfc54e3",
"assets/assets/tiles/Mars.tmx": "43d3d0e4fe9f167dbde96834190fbc41",
"assets/assets/tiles/Pixel%2520Adventure.tiled-session": "c5b3fe9b923d94a16dfe17181d6ae394",
"assets/assets/audio/bounce.wav": "63621de02044af415adcb0cdbc7afe87",
"assets/assets/audio/jump.wav": "0955bb8692212a59ffbf265053d0f09a",
"assets/assets/audio/hit.wav": "3c90d1d642f2409a1ccede4189b8618f",
"assets/assets/audio/collect_item.wav": "81efa093638b482b3593b1022837169d",
"assets/assets/audio/disappear.wav": "1d328b82b7707e42002f42927346e923",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
