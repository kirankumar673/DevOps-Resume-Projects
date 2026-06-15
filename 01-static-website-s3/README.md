# Project 01 - Host a Static Website on AWS S3

## Problem Statement

Your company wants to host a marketing website.

Requirements:

- No servers
- Low cost
- High availability
- Publicly accessible

Build a solution using AWS S3.

---

## Architecture

User
  │
  ▼
Amazon S3
  │
  ▼
Static Website

---

## Prerequisites

- AWS Account
- HTML File
- CSS File

---

## Step 1 - Create Website Files

### index.html

<!DOCTYPE html>
<html>
<head>
<title>Tech With Sandesh</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<h1>Welcome to My Website</h1>
<p>Hosted on AWS S3</p>
</body>
</html>

### style.css

body {
  text-align:center;
  margin-top:100px;
  font-family:Arial;
}

---

## Step 2 - Create S3 Bucket

AWS Console

↓

S3

↓

Create Bucket

Bucket Name:

techwithsandesh-website

Region:

ap-south-1

Click:

Create Bucket

---

## Step 3 - Disable Public Access Block

Bucket

↓

Permissions

↓

Block Public Access

↓

Edit

↓

Uncheck:

Block all public access

Save.

---

## Step 4 - Upload Website Files

Bucket

↓

Upload

Upload:

index.html
style.css

---

## Step 5 - Enable Static Website Hosting

Bucket

↓

Properties

↓

Static Website Hosting

↓

Enable

Index Document:

index.html

Save.

---

## Step 6 - Configure Bucket Policy

Bucket

↓

Permissions

↓

Bucket Policy

Use the bucket-policy.json file provided in this project.

Save.

---

## Step 7 - Access Website

Bucket

↓

Properties

↓

Static Website Hosting

↓

Copy Website Endpoint

Example:

http://techwithsandesh-website.s3-website-ap-south-1.amazonaws.com

Open in browser.

---

## Verification

Verify:

✅ Website loads

✅ CSS loads

✅ No Access Denied error

---

## Expected Output

Welcome to My Website

Hosted on AWS S3

---

## Cleanup

Delete Files

↓

Delete Bucket

---

## Key Learnings

- S3 Bucket
- Objects
- Bucket Policy
- Static Website Hosting
- Public Access
