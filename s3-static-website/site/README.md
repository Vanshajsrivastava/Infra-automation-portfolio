# S3 Static Website

A clean, single-page portfolio ready for **AWS S3 static website hosting** (optional CloudFront for HTTPS).

## Deploy with AWS CLI (HTTP-only website endpoint)

> Replace the bucket name with a globally unique value.

```bash
BUCKET=my-portfolio-site-<unique>
REGION=eu-west-2

aws s3api create-bucket   --bucket $BUCKET   --region $REGION   --create-bucket-configuration LocationConstraint=$REGION

aws s3api put-bucket-website   --bucket $BUCKET   --website-configuration '{
    "IndexDocument": {"Suffix": "index.html"},
    "ErrorDocument": {"Key": "error.html"}
  }'

aws s3api put-public-access-block   --bucket $BUCKET   --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false

cat > policy.json <<'JSON'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::BUCKET_NAME_HERE/*"
  }]
}
JSON
sed -i "s/BUCKET_NAME_HERE/$BUCKET/g" policy.json
aws s3api put-bucket-policy --bucket $BUCKET --policy file://policy.json

aws s3 sync . s3://$BUCKET --exclude "policy.json" --exclude ".git/*" --delete

echo "Open: http://$BUCKET.s3-website.$REGION.amazonaws.com"
```

## Optional: CloudFront (HTTPS + CDN)

- Create a CloudFront distribution with the S3 bucket as origin.
- Use **Origin Access Control (OAC)** and make the bucket private.
- Set **Default Root Object** to `index.html`.
- If using a custom domain, request an ACM certificate in **us-east-1** and attach it.

## Customize

- Edit text in `index.html` (name, bio, links).
- Update project cards in the **Projects** section.
- Replace links in the **Contact** section.
