# 券商月度金股总结 — 部署到 GitHub Pages 指南

## 部署效果预览

部署完成后，你将获得一个公网可访问的地址：
`https://你的用户名.github.io/仓库名/`

举例：`https://zhangsan.github.io/gold-stock/`

---

## 第一次部署（一次性操作，约10分钟）

### 步骤1：注册 GitHub 账号

访问 https://github.com 注册（如已有账号跳过）。

### 步骤2：创建仓库

1. 登录后点右上角 `+` → `New repository`
2. 仓库名建议：`gold-stock` （或任意英文名）
3. **Public**（公开）— GitHub Pages 免费版只支持公开仓库
4. 不要勾选 "Initialize this repository with a README"
5. 点 `Create repository`

### 步骤3：本地安装 Git（若未安装）

访问 https://git-scm.com/download/win 下载安装 Git for Windows，一路默认即可。

### 步骤4：本地初始化并推送

打开 `gold_stock_site` 文件夹，右键 → `Git Bash Here`，依次执行：

```bash
git init
git add .
git commit -m "initial commit"
git branch -M main
# 下面这行的 URL 替换成你自己的仓库地址
git remote add origin https://github.com/你的用户名/gold-stock.git
git push -u origin main
```

首次 push 会弹出登录窗口，用 GitHub 账号授权。

### 步骤5：启用 GitHub Pages

1. 打开你的 GitHub 仓库页面
2. 点顶部 `Settings` → 左侧 `Pages`
3. `Source` 选择 `Deploy from a branch`
4. `Branch` 选择 `main`，`/ (root)`
5. 点 `Save`

等 1-2 分钟，页面顶部会显示：
`Your site is live at https://你的用户名.github.io/gold-stock/`

点开就能看到网站了！

---

## 日常更新（每月/每周操作，约1分钟）

每次有新的数据（新月度金股、股价刷新等），只需：

```bash
cd 你的仓库路径/gold_stock_site
git add data.js prices.json
git commit -m "update: 数据刷新"
git push
```

推送后约1-2分钟，GitHub Pages 自动重新部署，网站自动更新。

我在文件夹下已经创建了 `一键部署.bat`，双击即可完成上述命令。

---

## 隐私性提醒

⚠️ GitHub Pages 是**公开**的，任何知道 URL 的人都能访问。

如果金股数据敏感，请：
- **不要**使用 GitHub Pages
- 改用公司内网 Nginx / IIS 部署（把 index.html + data.js 放到 Web 目录即可）
- 或使用腾讯云 COS 静态托管（可设密码/IP白名单）

已经通过 .gitignore 排除了 Excel 源文件，只上传：
- index.html（网站）
- data.js（数据，已加工后的JSON）
- prices.json（股价缓存）
- build_site.py（构建脚本）

---

## 常见问题

**Q: 网站显示 404？**  
A: 检查 GitHub Pages 是否已启用；`index.html` 是否在仓库根目录。

**Q: 推送失败提示需要登录？**  
A: 建议在 GitHub 生成 Personal Access Token 代替密码（Settings → Developer settings → Personal access tokens）。

**Q: 如何设置访问密码？**  
A: GitHub Pages 不支持密码保护。如需鉴权请用 Vercel（免费方案有 Password Protection）或 Cloudflare Access。
