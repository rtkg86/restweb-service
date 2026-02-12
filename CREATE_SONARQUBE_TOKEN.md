# How to Create a Security Token in SonarQube

## Prerequisites
- SonarQube is running (http://localhost:9000)
- You have admin or user account access
- You're logged in to SonarQube

---

## Step-by-Step Guide

### Step 1: Access SonarQube Dashboard
1. Open your browser and navigate to: **http://localhost:9000**
2. Log in with your credentials (default: admin/admin)
3. If this is your first login, you'll be prompted to change the default password - do this first

### Step 2: Navigate to Security Settings
1. Click on your **profile icon** in the top-right corner
   - Look for your username or avatar icon
2. Click on **My Account** from the dropdown menu

### Step 3: Access Security Tokens
1. In the My Account page, find the left sidebar menu
2. Click on **Security** tab/option
3. You'll see a section called **Generate Tokens**

### Step 4: Generate Your Token
1. In the token name field, enter: `jenkins-token` (or any descriptive name)
2. Leave the expiration date empty (for no expiration) or set one if needed
3. Click the **Generate** button

### Step 5: Copy Your Token
⚠️ **IMPORTANT:** The token appears only ONCE! Do the following:

1. Copy the generated token immediately
2. Save it in a secure location (password manager or encrypted file)
3. **Do NOT lose it** - SonarQube won't show it again

### Step 6: Use in Jenkins
Once you have the token, add it to Jenkins:

1. Go to Jenkins: **http://localhost:8081**
2. Navigate to **Manage Jenkins** → **Credentials** → **System** → **Global credentials**
3. Click **Add Credentials**
4. Configure:
   - **Kind**: Secret text
   - **Secret**: Paste your SonarQube token
   - **ID**: `sonarqube-token`
   - **Description**: `SonarQube Token`
5. Click **Create**

---

## Token Security Best Practices

✅ **DO:**
- [ ] Save token in a secure password manager
- [ ] Use descriptive names for tokens
- [ ] Regenerate tokens regularly
- [ ] Keep token private (never commit to Git)
- [ ] Revoke old tokens when not needed

❌ **DON'T:**
- [ ] Share your token in messages/emails
- [ ] Commit token to version control
- [ ] Use the same token for multiple systems
- [ ] Lose track of where tokens are used
- [ ] Use indefinite expiration for production

---

## Visual Step-by-Step

```
1. SonarQube Dashboard
   └─ Profile Icon (top-right)
      └─ My Account
         └─ Security (left menu)
            └─ Generate Tokens
               └─ Enter Name + Click Generate
                  └─ COPY TOKEN IMMEDIATELY

2. Add to Jenkins
   └─ Manage Jenkins
      └─ Credentials
         └─ System
            └─ Global credentials
               └─ Add Credentials
                  └─ Kind: Secret text
                  └─ Secret: [Paste Token]
                  └─ ID: sonarqube-token
                  └─ Create
```

---

## Troubleshooting

### Problem: Can't find Security in My Account
**Solution:**
- Make sure you're logged in as admin
- Try refreshing the page
- Check if you have permission to generate tokens

### Problem: Token disappeared after generation
**Solution:**
- ✅ This is normal - tokens only show once
- Go back and generate a new one
- Copy it immediately this time

### Problem: Jenkins can't authenticate with token
**Solution:**
- Verify the token is correct (no extra spaces)
- Ensure Jenkins can reach SonarQube (http://sonarqube:9000)
- Check Jenkins logs: `docker-compose logs jenkins`

---

## Token Expiration Options

When generating a token, you can set expiration:

| Option | When to Use |
|--------|-----------|
| **No expiration** | Development/testing |
| **7 days** | Temporary access |
| **30 days** | Standard practice |
| **90 days** | Long-term projects |
| **Custom date** | Specific project end date |

---

## Using the Token in Jenkins Pipeline

Once added to Jenkins credentials, use it in Jenkinsfile:

```groovy
environment {
    SONAR_LOGIN = credentials('sonarqube-token')
}

stages {
    stage('SonarQube Analysis') {
        steps {
            sh '''
                mvn sonar:sonar \
                    -Dsonar.projectKey=restweb-service \
                    -Dsonar.host.url=http://sonarqube:9000 \
                    -Dsonar.login=$SONAR_LOGIN
            '''
        }
    }
}
```

---

## Complete Example Workflow

### 1. Create Token in SonarQube (5 minutes)
```
Profile Icon → My Account → Security → Generate Token
Name: jenkins-token
Copy: [Save securely]
```

### 2. Add to Jenkins (3 minutes)
```
Manage Jenkins → Credentials → Add Credentials
Kind: Secret text
Secret: [Paste token]
ID: sonarqube-token
Create
```

### 3. Use in Pipeline (Already done in Jenkinsfile!)
```
The Jenkinsfile is already configured to use the token
Just ensure the credential ID matches: sonarqube-token
```

---

## Quick Checklist

After creating your token:

- [ ] Token created in SonarQube
- [ ] Token saved securely
- [ ] Token added to Jenkins credentials
- [ ] Credential ID is: `sonarqube-token`
- [ ] Jenkinsfile references the credential
- [ ] First build triggered and authenticated

---

## Next Steps

Once your token is set up:

1. ✅ Configure Jenkins (already documented in SETUP_CHECKLIST.md)
2. ✅ Create Jenkins Pipeline Job
3. ✅ Trigger first build
4. ✅ Monitor SonarQube analysis

For detailed setup, see: **SETUP_CHECKLIST.md → Step 3: SonarQube Configuration → Create Security Token**

---

**Your token is now ready to use! 🔑✅**

