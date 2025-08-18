# S3 Static Website Hosting with CloudFront + OAC (Terraform)

This project deploys a **private S3 static website** fronted by **Amazon CloudFront** using an **Origin Access Control (OAC)** so the bucket stays non-public. It’s fully managed as **Infrastructure as Code** with Terraform and wired to **GitHub Actions** + **Terraform Cloud** for CI/CD.

> **Live demo (decommissioned later to avoid cost):** CloudFront domain was provisioned and served the portfolio site. See `docs/` for screenshots and proof.

## What I built
- **S3 bucket (private)** with **Block Public Access = ON**.
- **CloudFront distribution** (HTTPS) using **OAC** to read from the bucket.
- **Bucket policy** that allows `s3:GetObject` **only** from the CloudFront distribution ARN.
- Terraform code to **upload site assets** (HTML/CSS/JS) with proper `Content-Type` and cache headers.
- **CI/CD**:
  - Pull Requests → **terraform plan** (read-only preview).
  - Push/Merge to `main` → **terraform apply** in **Terraform Cloud** + **CloudFront invalidation** so changes go live immediately.
- **Remote state in Terraform Cloud** (workspace: `s3-static-website`).

## Repo structure
```
s3-static-website/
  main.tf
  variables.tf
  outputs.tf
  site/
.github/workflows/terraform.yml
docs/
  screenshots/
  proof-pack.md
```

## CI/CD flow
1. **PR opened** → GitHub Actions runs `terraform fmt/validate/plan` in **Terraform Cloud** and posts logs.
2. **Merge to `main`** → Actions runs **apply** in Terraform Cloud and then a **CloudFront invalidation**.
3. The run prints **Terraform outputs** (CloudFront domain & ID).

## How to reproduce (quick)
1. Fork/clone, set up **Terraform Cloud** org/workspace.
2. In the TFC workspace, add Terraform variable `bucket_name` with a **globally-unique** value.
3. Add **Environment** vars in TFC: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`.
4. Push to `main` and watch Actions apply.

## Tear-down
Use Terraform Cloud **Queue destroy plan** (or `terraform destroy`) to remove the stack. Then clear TFC env vars and repo secrets.

## Future scope
- Custom domain + ACM/Route53
- S3 **versioning + lifecycle** (expire non-current versions)
- CloudFront **standard logs** to S3 + Athena
- **AWS WAF** on CloudFront
- GitHub **OIDC** (keyless CI)

See `docs/proof-pack.md` for screenshots after decommissioning.
