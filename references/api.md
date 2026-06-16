# ht-ml.app API reference

Base URL: `https://api.ht-ml.app/v1`. All requests and responses are JSON
(except asset upload, which is `multipart/form-data`). Errors return an
appropriate HTTP status and a body with a `detail`/`message` field describing
what to fix.

Placeholders below (`{site_id}`, `{update_key}`) are stand-ins — always read the
real values from your own create response. Never reuse literal example values.

---

## POST /v1/sites

Create a new site.

**Request body:**

| Field          | Type   | Required | Notes |
| :------------- | :----- | :------- | :---- |
| `html_content` | string | Yes      | The full HTML document. |
| `password`     | string | No       | If present, makes the site private (shared secret). |

**Success (200):**

```json
{
  "site_id": "{site_id}",
  "update_key": "{update_key}",
  "status": "active",
  "url": "https://{site_id}.ht-ml.app/"
}
```

The site is live immediately at `url`. The `update_key` is returned only once.

**Rejected (422):** the HTML failed a content-safety scan. The body's `detail`
explains the failing categories; revise and resubmit.

---

## GET /v1/sites/{site_id}

Get a site's status and the assets referenced by its HTML. No auth; read access
is public unless the site is password-protected.

**Success (200):**

```json
{
  "site_id": "{site_id}",
  "status": "active",
  "assets": [
    { "relative_path": "images/logo.png", "asset_type": "image", "status": "missing" }
  ],
  "help_endpoints": ["/v1/sites/{site_id}/assets"]
}
```

`assets[].status` is `missing` until the corresponding file is uploaded. Only
`<img>` and `<video>` `src` values are enumerated as assets.

**Not found (404):** no such site.

---

## PUT /v1/sites/{site_id}

Replace the site's core HTML. Re-scans the HTML and invalidates this site's CDN
cache immediately (only this site).

**Headers:** `Authorization: Bearer {update_key}`

**Request body:**

| Field          | Type   | Required | Notes |
| :------------- | :----- | :------- | :---- |
| `html_content` | string | Yes      | The replacement HTML document. |
| `password`     | string | No       | Value sets/replaces it; `""` clears it; omit to leave unchanged. |

**Success (200):** same shape as create (minus a fresh `update_key` — the key is
unchanged).

**Failure:** `403` if the `update_key` is wrong or the site doesn't exist;
`422` if the new HTML fails the scan.

---

## POST /v1/sites/{site_id}/assets

Upload one asset referenced by the site's HTML.

**Headers:** `Authorization: Bearer {update_key}`
**Content-Type:** `multipart/form-data`
**Query params:** `relative_path` — the exact path as written in the HTML
(e.g. `images/logo.png`).
**Body:** a single `file` field with the binary contents.

Rules:
- The `relative_path` must be an **exact** match of a `src`/`href` referenced in
  the HTML.
- Reserved names `index.html` and `metadata.json` are rejected.

**Success (200):** `{"message": "Asset uploaded successfully"}`
**Failure (403):** wrong `update_key`, path not referenced in the HTML, or a
reserved name.

---

## GET /v1/help

Returns a self-describing JSON document of endpoints, password guidance, and
error codes. Useful for runtime discovery.

---

## Error codes

| Code | Name | Meaning & action |
| :--- | :--- | :--- |
| `401` | Unauthorized (write) | Missing/invalid `update_key`. Send `Authorization: Bearer {update_key}`. |
| `401` | Unauthorized (read)  | Site is password-protected. Send the password as cookie `ht_ml_pwd=<password>`. |
| `403` | Forbidden | Asset path not referenced in the HTML, or invalid `update_key`. |
| `404` | Not Found | No site with that `site_id`. |
| `422` | Unprocessable Entity | HTML failed the content-safety scan. Read the message and revise. |

---

## Password protection details

- Set a `password` on create or update. It is salted and hashed server-side and
  never returned by the API.
- Readers authenticate by sending the password as a cookie `ht_ml_pwd=<password>`
  (URL-encoded). Without it, a protected site returns a `401` password prompt.
- Coach the user: use a **unique, non-personal** password; it is a **shared
  secret** that anyone who should access the site must be given.

## Public content

All published content is public and may be indexed, crawled, copied, or archived.
Warn the user before publishing on their behalf. Full terms: <https://ht-ml.app/terms>.
