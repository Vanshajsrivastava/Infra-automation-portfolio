# Proof Pack: S3 + CloudFront (OAC) Static Website

Evidence that the site was deployed through Terraform + CI/CD and served over CloudFront. Use this if the stack is torn down.

## 1) Live site (CloudFront domain)
![CloudFront home](screenshots/01-cloudfront-home.jpg)

## 2) View Source (HTML)
![View source](screenshots/02-view-source.jpg)

## 3) Network headers (DevTools)
![Network headers](screenshots/03-network-headers.jpg)

## 4) GitHub Actions — All runs
![Actions list](screenshots/04-actions-all-runs.jpg)

## 5) GitHub Actions — Apply (main)
![Actions apply run](screenshots/05-actions-apply-run.jpg)

## 6) Terraform Cloud — Runs
![Terraform Cloud runs](screenshots/06-terraform-cloud-runs.jpg)

---

### Notes
- **Architecture**: CloudFront (HTTPS) → S3 private bucket via **OAC**. Bucket blocks public access; policy allows reads only from the CF distribution ARN.
- **CI/CD**: PRs run plan; `main` runs apply; automatic CloudFront **invalidation** after deploy.
- **State**: stored in Terraform Cloud (remote backend).

Generated: 2025-08-15 04:06:51Z UTC
