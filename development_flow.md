# Branching Workflow and Collaboration

This section outlines how developers will work on branches, manage their tasks, and merge code to maintain a streamlined workflow.

---

## Branching Overview

We will use the following branches to manage the project lifecycle:

- **`production`:** Stable, release-ready code for deployment.
- **`testing`:** Code undergoing QA/testing.
- **`development`:** The main branch where all feature branches are merged during active development.

Additionally, each developer will work on a **feature branch** created from the `development` branch.

---

## Workflow Steps

### 1. Task Assignment and Branch Creation

Each developer will be assigned a specific task with a corresponding feature branch:

| Developer         | Task                                   | Branch                   |
|--------------------|---------------------------------------|--------------------------|
| Sayyam             | Authentication (Controller, Service, Repository) | `feature/auth`          |
| Abdul Malik        | Localization (Controller, Service)   | `feature/localization`   |
| Fawad Hussain      | Localization (Repository)            | `feature/localization`   |
| Aziz ur Rehman     | UI Components from Figma             | `feature/ui-components` |

#### **Create feature branches:**

```bash
git checkout development
git checkout -b feature/<task-name>
```

Example:

```bash
git checkout -b feature/auth
```

---

### 2. Code Development and Commit

Developers work on their assigned tasks within their respective feature branches:

1. **Stage changes:**

```bash
git add .
```

2. **Commit changes with descriptive messages:**

```bash
git commit -m "Implemented login and signup controller for authentication"
```

3. **Push changes to the remote repository:**

```bash
git push origin feature/<task-name>
```

Example:

```bash
git push origin feature/auth
```

---

### 3. Pull Requests (PRs) and Merging

Once a feature is complete, the developer creates a **Pull Request (PR)** to merge their branch into `development`:

1. Go to the GitHub repository.
2. Click **New Pull Request**.
3. Set:
   - `base`: `development`
   - `compare`: `feature/<task-name>`
4. Add a title and description summarizing the changes.
5. Assign reviewers (e.g., team lead or senior developer).

---

### 4. Code Review

- Reviewers check for:
  - Code quality, consistency, and adherence to architecture.
  - Potential bugs or issues.
- Approved PRs are merged into the `development` branch.

---

### 5. Testing in the `testing` Branch

After all feature branches are merged into `development`, the `development` branch is merged into `testing` for QA:

```bash
git checkout testing
git merge development
git push origin testing
```

GitHub Actions will trigger workflows to:
- Build APKs and TestFlight builds.
- Send builds to testers for validation.

---

### 6. Deployment to `production`

After successful QA, the `testing` branch is merged into `production` for deployment:

```bash
git checkout production
git merge testing
git push origin production
```

GitHub Actions will:
- Build and deploy release APKs and IPAs.
- Notify stakeholders of the release.

---

## Handling Merge Conflicts

### **1. Pull the Latest Changes:**

```bash
git checkout development
git pull origin development
git checkout feature/<task-name>
git merge development
```

### **2. Resolve Conflicts:**

- Open conflicting files.
- Edit manually to resolve conflicts.
- Stage the resolved files:

```bash
git add .
```

### **3. Commit Resolved Code:**

```bash
git commit -m "Resolved conflicts with development branch"
git push origin feature/<task-name>
```

---

## Benefits of This Workflow

- **Parallel Development:** Developers can work independently without overwriting others’ work.
- **Code Quality Assurance:** PR reviews ensure high-quality code.
- **Clear Progress Tracking:** Task-specific branches provide visibility into each developer’s progress.
- **Minimized Conflicts:** Merging small, frequent updates reduces conflict complexity.

---

This workflow ensures smooth collaboration and consistent progress across all stages of the project.
