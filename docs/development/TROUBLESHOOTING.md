# Troubleshooting: Formatter Not Working in VS Code

## Issue: Format Document Command Does Nothing

If `Shift+Option+F` or the "Format Document" command doesn't work, here are the steps to diagnose and fix:

---

## ✅ Checklist

### 1. **Is the Extension Running?**

When you press **F5** to launch Extension Development Host, check:

- [ ] A new VS Code window opened with title `[Extension Development Host]`
- [ ] In the main window's Debug Console, you see activation messages
- [ ] No error messages in Debug Console

**How to check:**
1. In the **main** VS Code window (this project)
2. View → Output → Select "Log (Extension Host)" from dropdown
3. Look for errors related to `kf-sql-formatter`

---

### 2. **Is TypeScript Compiled?**

```bash
# Run this in terminal
npm run compile

# Check for errors
# Should complete without errors
```

**Verify dist/ folder exists:**
```bash
ls -la dist/
# Should see: extension.js, formatter.js, and passes/ folder
```

---

### 3. **Is the File Language Set to SQL?**

Bottom-right corner of VS Code should show **"SQL"** or **"Spark SQL"**

**If it shows "Plain Text":**
1. Click on "Plain Text" in bottom-right
2. Select "SQL" or "Spark SQL"
3. Try formatting again

---

### 4. **Is There a Default Formatter Conflict?**

VS Code might have another SQL formatter installed.

**Check:**
1. Right-click in the SQL file
2. Select "Format Document With..."
3. You should see "KF SQL Formatter" in the list
4. Select it and check "Configure Default Formatter"

**Or check settings:**
- `Cmd+,` (Mac) or `Ctrl+,` (Windows) to open Settings
- Search for "default formatter"
- Make sure no conflicting SQL formatter is set

---

### 5. **Manual Test: Run the Command Directly**

1. **Open Command Palette**: `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows)
2. Type: `KF SQL Formatter`
3. You should see:
   - `KF SQL Formatter: Auto-Alias Everything (Semantic)`
   - `KF SQL Formatter: Normalize Semicolons`
4. Try running one of these commands
5. If these work but Format Document doesn't, there's a formatter registration issue

---

### 6. **Check Extension Activation**

The extension activates when you open a `.sql` file.

**Test activation:**
1. In Extension Development Host window
2. Open `examples/test-simple.sql`
3. In main window, check Debug Console for:
   ```
   Activating extension 'kef.kf-sql-formatter'...
   ```

**If you don't see activation:**
- Extension might not be loading
- Check for errors in Output → Log (Extension Host)

---

### 7. **Nuclear Option: Reload Extension Development Host**

In the Extension Development Host window:
- `Cmd+R` (Mac) or `Ctrl+R` (Windows)
- This reloads the extension
- Try formatting again

---

## 🔍 Debugging Steps

### Step 1: Check Extension is Loaded

In Extension Development Host window:
1. Help → Toggle Developer Tools
2. Console tab
3. Type: `vscode.extensions.all`
4. Look for `kef.kf-sql-formatter` in the list

### Step 2: Check Formatter is Registered

In Extension Development Host console:
```javascript
vscode.languages.getLanguages().then(langs => console.log(langs))
// Should see 'sql' and 'spark-sql' in the list
```

### Step 3: Manual Format Test

In main window Debug Console, add this to `src/extension.ts`:
```typescript
export function activate(context: vscode.ExtensionContext) {
  console.log('🚀 KF SQL Formatter is activating!');

  const selector: vscode.DocumentSelector = [
    { language: 'sql', scheme: 'file' },
    // ... rest of code
```

Recompile and reload - you should see the emoji in Debug Console.

---

## 🛠️ Common Fixes

### Fix 1: Language Not Set
```
File → Preferences → Settings → Search "files.associations"
Add: "*.sql": "sql"
```

### Fix 2: Extension Not in Development Mode
Make sure you pressed **F5** in the main window, not just opened a new window.

### Fix 3: Compilation Issues
```bash
# Clean and rebuild
rm -rf dist/
npm run compile
```

### Fix 4: Package the Extension and Install
```bash
npm run package
# Install the .vsix file manually
```

---

## 📊 Expected Behavior

**When working correctly:**

1. **Press F5** in main window
2. Extension Development Host opens
3. **Open** `examples/test-simple.sql`
4. **Press** `Shift+Option+F`
5. **File formats instantly** - you see changes in the editor
6. **Formatting applied:**
   - Keywords become UPPER case
   - Leading commas appear
   - Aliases align

**What you should see:**

Before:
```sql
select id, name, email from users where status = 'active'
```

After:
```sql
SELECT
  id
  , name
  , email
FROM users
WHERE status = 'active'
;
```

---

## 🆘 Still Not Working?

### Capture Debug Info

1. **Main Window:**
   - View → Output → "Log (Extension Host)"
   - Copy any errors

2. **Extension Development Host:**
   - Help → Toggle Developer Tools → Console
   - Copy any errors

3. **Check:**
   ```bash
   # Does dist/extension.js exist?
   cat dist/extension.js | head -20

   # Check package.json main entry point
   grep "main" package.json
   # Should show: "main": "./dist/extension.js"
   ```

4. **Report:**
   - What VS Code version? (Help → About)
   - What happens when you press F5?
   - Any error messages?
   - Does the Extension Development Host window open?

---

## 🎯 Quick Diagnostic Script

Run this to check everything:

```bash
#!/bin/bash
echo "=== KF SQL Formatter Diagnostics ==="
echo ""
echo "1. Compiled files:"
ls -lh dist/*.js 2>/dev/null || echo "❌ No compiled files!"
echo ""
echo "2. Package.json main:"
grep '"main"' package.json || echo "❌ No main entry!"
echo ""
echo "3. TypeScript compilation:"
npm run compile 2>&1 | tail -5
echo ""
echo "4. Extension activation:"
grep "activationEvents" package.json
echo ""
echo "=== Next Steps ==="
echo "1. Press F5 in VS Code"
echo "2. Check Debug Console for errors"
echo "3. Open .sql file in Extension Development Host"
echo "4. Try Shift+Option+F"
```

Save as `debug-extension.sh`, run with `bash debug-extension.sh`
