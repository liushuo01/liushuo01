# 网站部署指南

本指南将帮助您将游戏预约系统公开到公网，让其他用户可以访问。

## 项目特性

这是一个**纯前端应用**，使用HTML、CSS和JavaScript开发，数据存储在浏览器的localStorage中。

> **重要说明**：由于使用localStorage存储数据，每个用户的数据只保存在自己的浏览器中，不同用户之间的数据**不会共享**。如果需要真正的多用户数据共享，需要添加后端服务。

## 部署方案

### 方案一：GitHub Pages (免费)

1. **创建GitHub仓库**
   - 注册或登录GitHub账号
   - 创建一个新的仓库

2. **上传代码**
   - 将项目文件上传到仓库
   - 确保包含所有HTML文件（index.html, register.html, appointment.html, appointments.html）

3. **启用GitHub Pages**
   - 进入仓库设置
   - 找到"GitHub Pages"部分
   - 选择分支（通常是main或master）
   - 点击"Save"保存设置
   - 等待几分钟，GitHub会生成访问URL

### 方案二：Vercel (免费)

1. **注册Vercel账号**
   - 访问vercel.com并注册账号
   - 可以使用GitHub/GitLab/Bitbucket账号登录

2. **导入项目**
   - 点击"New Project"
   - 选择"Import Project"
   - 连接到您的代码仓库（如GitHub）
   - 选择要部署的仓库

3. **部署设置**
   - 配置：保持默认设置
   - 点击"Deploy"
   - 等待部署完成，获取访问URL

### 方案三：Netlify (免费)

1. **注册Netlify账号**
   - 访问netlify.com并注册账号

2. **部署项目**
   - 点击"New site from Git"
   - 连接到您的代码仓库
   - 选择分支

3. **构建设置**
   - 构建命令：留空（因为是纯静态网站）
   - 发布目录：留空（使用根目录）
   - 点击"Deploy site"
   - 获取访问URL

### 方案四：Cloudflare Pages (免费)

1. **注册Cloudflare账号**
   - 访问cloudflare.com并注册账号

2. **创建Pages项目**
   - 进入"Pages"部分
   - 点击"Create a project"
   - 连接到您的代码仓库

3. **配置部署**
   - 构建命令：留空
   - 构建输出目录：留空
   - 点击"Save and Deploy"
   - 获取访问URL

### 方案五：使用自己的服务器

如果您有自己的服务器，可以使用以下步骤部署：

1. **上传文件**
   - 使用FTP或SCP将项目文件上传到服务器的web目录
   - 通常是`/var/www/html/`或类似目录

2. **配置Web服务器**
   - 如果使用Nginx，确保配置文件正确指向项目目录
   - 示例Nginx配置：
     ```nginx
     server {
         listen 80;
         server_name your-domain.com;
         root /var/www/html;
         index index.html;
     }
     ```

3. **设置域名（可选）**
   - 将您的域名解析到服务器IP地址

## 部署前准备

### 优化项目结构（可选）

1. **清理不必要的文件**
   - 可以保留app.py和templates目录，它们不会影响静态网站部署

2. **更新README.md**
   - 添加部署信息和访问URL

### 自定义域名（可选）

所有托管服务都支持自定义域名，您可以：
1. 购买一个域名（如从GoDaddy、Namecheap等）
2. 在托管服务中配置自定义域名
3. 更新域名的DNS设置

## 注意事项

1. **数据存储限制**
   - 用户数据存储在各自的浏览器localStorage中
   - 不同用户之间的数据无法共享
   - 清除浏览器数据会删除用户的所有数据

2. **跨域限制**
   - 网站部署后，所有功能应该正常工作
   - localStorage在不同域名下是隔离的

3. **浏览器兼容性**
   - 建议使用现代浏览器（Chrome 60+, Firefox 55+, Safari 12+, Edge 79+）

4. **性能优化**
   - 可以考虑压缩HTML、CSS和JavaScript文件
   - 使用CDN加速静态资源

## 升级建议（可选）

如果需要真正的多用户数据共享，可以考虑：

1. **添加后端服务**
   - 使用Node.js + Express
   - 或Python + Flask
   - 或任何其他后端技术

2. **使用数据库**
   - SQLite（轻量级）
   - MySQL/PostgreSQL（更强大）
   - MongoDB（NoSQL）

3. **实现API**
   - 用户认证API
   - 预约数据API
   - 数据同步API

## 故障排除

1. **页面无法加载**
   - 检查文件路径是否正确
   - 确保index.html位于根目录

2. **功能异常**
   - 检查浏览器控制台是否有错误
   - 确保JavaScript文件正确加载

3. **数据丢失**
   - 提醒用户不要清除浏览器数据
   - 考虑添加数据导出功能

## 联系信息

如果在部署过程中遇到问题，可以参考各托管服务的官方文档或寻求技术支持。