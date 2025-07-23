# Navigate to project root
cd /project

# Initialize git repository
git init

# Create .gitignore files for backend and frontend
echo "venv/
__pycache__/
*.pyc
.env
.idea/
.vscode/
" > .gitignore

mkdir -p frontend
echo "build/
.flutter-plugins
.packages
.pub-cache/
.flutter-plugins-dependencies
.dart_tool/
.idea/
.vscode/
*.iml
*.log
" > frontend/.gitignore

# Add all files and commit
git add .
git commit -m "Initial commit - project setup"

# Add remote GitHub repository (replace URL with your repo)
git remote add origin https://github.com/IA990/MaBoutique.ma.git

# Push to GitHub main branch
git branch -M main
git push -u origin main
