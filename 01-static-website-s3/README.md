# Project 01 - Host a Static Website on AWS S3

## Problem Statement

Your company wants to host a marketing website.

Requirements:

- No servers to manage
- Low cost
- High availability
- Publicly accessible

Build a solution using AWS S3 Static Website Hosting.

---

## Architecture

```
User (Browser)
      │
      ▼ HTTP
Amazon S3 Bucket
(Static Website Hosting enabled)
      │
      ▼
index.html + style.css
```

> ⚠️ **Production upgrade path:** For HTTPS, add CloudFront + ACM in front of S3. See Production Notes at the bottom.

---

## Project Structure

```
01-static-website-s3/
├── policies/
│   └── bucket-policy.json     ← S3 bucket policy for public read access
└── source-code/
    ├── index.html
    └── style.css
```

---

## Prerequisites

- AWS Account → [Sign up free](https://aws.amazon.com/free/)
- A browser
- No servers, no CLI needed — everything done in the AWS Console

---

## Step 1 - Review the Website Files

### source-code/index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tech With Sandesh</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Welcome to My Website</h1>
  <p>Hosted on AWS S3</p>
</body>
</html>
```

### source-code/style.css

```css
body {
  text-align: center;
  margin-top: 100px;
  font-family: Arial, sans-serif;
}
```

### policies/bucket-policy.json

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
    }
  ]
}
```

> ⚠️ Replace `YOUR-BUCKET-NAME` with your actual S3 bucket name before applying.

---

## Step 2 - Create an S3 Bucket

1. Log in to [AWS Console](https://console.aws.amazon.com)
2. Search for **S3** and click it
3. Click **Create bucket**
4. Fill in:

| Field | Value |
|-------|-------|
| Bucket name | `techwithsandesh-website` (must be globally unique) |
| AWS Region | `ap-south-1` (or your preferred region) |

5. Leave all other settings as default
6. Click **Create bucket**

Expected — bucket appears in the S3 list:

```
techwithsandesh-website   ap-south-1   ...
```

---

## Step 3 - Disable Public Access Block

By default, S3 blocks all public access. We need to allow it for static website hosting.

1. Click your bucket name
2. Go to **Permissions** tab
3. Click **Edit** under **Block Public Access**
4. **Uncheck** → `Block all public access`
5. Click **Save changes**
6. Type `confirm` in the confirmation box
7. Click **Confirm**

Expected — all four checkboxes are unchecked and the banner shows:

```
Public access is not blocked
```

---

## Step 4 - Upload Website Files

1. Click the **Objects** tab
2. Click **Upload**
3. Click **Add files**
4. Select both files:
   - `source-code/index.html`
   - `source-code/style.css`
5. Click **Upload**

Expected — both files listed under Objects:

```
index.html    ...
style.css     ...
```

---

## Step 5 - Enable Static Website Hosting

1. Go to **Properties** tab
2. Scroll down to **Static website hosting**
3. Click **Edit**
4. Select **Enable**
5. Fill in:

| Field | Value |
|-------|-------|
| Index document | `index.html` |
| Error document | `index.html` (optional — returns homepage on 404) |

6. Click **Save changes**

Expected — the Static website hosting section shows a URL like:

```
http://techwithsandesh-website.s3-website-ap-south-1.amazonaws.com
```

> ℹ️ Copy and save this URL — you will use it in Step 7.

---

## Step 6 - Configure Bucket Policy

Without a bucket policy, files are private even with public access unblocked.

1. Go to **Permissions** tab
2. Scroll to **Bucket policy**
3. Click **Edit**
4. Paste the following policy — **replace `techwithsandesh-website` with your actual bucket name**:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::techwithsandesh-website/*"
    }
  ]
}
```

5. Click **Save changes**

Expected — the Permissions tab shows:

```
Bucket policy: Public
```

---

## Step 7 - Access the Website

1. Go to **Properties** tab
2. Scroll down to **Static website hosting**
3. Click the **Bucket website endpoint** URL

Or open it directly in your browser:

```
http://techwithsandesh-website.s3-website-ap-south-1.amazonaws.com
```

Expected output in browser:

```
Welcome to My Website
Hosted on AWS S3
```

> ℹ️ The text will be centered on the page thanks to the CSS file.

---

## Verification Checklist

✅ S3 bucket created

✅ Public access block disabled

✅ Both `index.html` and `style.css` uploaded

✅ Static website hosting enabled with `index.html` as index document

✅ Bucket policy applied — Permissions tab shows `Public`

✅ Website loads in browser with correct text and centered styling

✅ No `Access Denied` or `403 Forbidden` error

---

## Troubleshooting

**403 Access Denied when opening the URL:**
- Check the bucket policy is applied and the resource ARN ends with `/*`
- Check that public access block is fully disabled (all 4 checkboxes unchecked)

**CSS not loading (unstyled text):**
- Ensure `style.css` was uploaded to the same bucket root as `index.html`
- Check the `<link>` tag in `index.html` points to `style.css` (not a path)

**404 on the endpoint:**
- Confirm Static Website Hosting is **enabled** and index document is set to `index.html`

---

## Cleanup

To avoid incurring AWS charges:

1. Go to the bucket → **Objects** tab
2. Select all files → **Delete**
3. Go back to S3 bucket list
4. Select your bucket → **Delete**
5. Type the bucket name to confirm → **Delete bucket**

---

## Production Notes

> ⚠️ **HTTPS / Security Limitation:**
> The S3 static website endpoint serves content over **HTTP only** — it does not support HTTPS.
> For a production-grade deployment, use the following architecture:
>
> ```
> User (HTTPS) → CloudFront Distribution → S3 Bucket (Origin Access Control)
>                       ↑
>           ACM SSL Certificate (must be in us-east-1)
>                       ↑
>           Custom Domain via Route 53 (optional)
> ```
>
> Steps to upgrade:
> 1. Request a free SSL certificate in **AWS Certificate Manager (ACM)** in `us-east-1`
> 2. Create a **CloudFront distribution** — set S3 as the origin with **Origin Access Control (OAC)**
> 3. Attach the ACM certificate to the CloudFront distribution
> 4. Update the S3 bucket policy to only allow access from CloudFront (not the public)
> 5. (Optional) Create a **Route 53** alias record pointing your domain to CloudFront
>
> This ensures HTTPS, low latency via global CDN, and locks down direct S3 access.

---

## Key Learnings

- AWS S3 bucket creation and configuration
- Disabling S3 Block Public Access
- S3 Static Website Hosting
- S3 Bucket Policies (JSON IAM policy)
- Public access vs object ACLs
- Static website endpoint URL format
- CloudFront + ACM for HTTPS (production upgrade)
- Route 53 DNS (optional custom domain)
