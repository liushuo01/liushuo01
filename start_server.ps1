# 简单的HTTP服务器脚本

# 设置端口
$port = 8080

# 创建HTTP监听器
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host "服务器已启动，本地访问地址：http://localhost:$port/"
Write-Host "按 Ctrl+C 停止服务器"

# 主循环
while ($listener.IsListening) {
    try {
        # 获取请求上下文
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # 获取请求路径
        $localPath = $request.Url.LocalPath
        if ($localPath -eq '/') {
            $localPath = '/index.html'
        }
        
        # 构建本地文件路径
        $filePath = Join-Path (Get-Location) $localPath.TrimStart('/')
        
        Write-Host "请求: $localPath"
        
        # 处理文件请求
        if (Test-Path $filePath -PathType Leaf) {
            # 读取文件内容
            $content = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $content.Length
            
            # 设置内容类型
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            switch ($extension) {
                '.html' { $response.ContentType = 'text/html; charset=utf-8' }
                '.css'  { $response.ContentType = 'text/css; charset=utf-8' }
                '.js'   { $response.ContentType = 'application/javascript; charset=utf-8' }
                '.json' { $response.ContentType = 'application/json; charset=utf-8' }
                default { $response.ContentType = 'application/octet-stream' }
            }
            
            # 写入响应
            $response.OutputStream.Write($content, 0, $content.Length)
            $response.StatusCode = 200
            Write-Host "成功: 200 OK"
        } else {
            # 文件不存在
            $response.StatusCode = 404
            $content = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.ContentLength64 = $content.Length
            $response.OutputStream.Write($content, 0, $content.Length)
            Write-Host "错误: 404 Not Found - $filePath"
        }
    } catch {
        Write-Host "错误: $_"
    } finally {
        # 确保响应流关闭
        if ($response) {
            $response.OutputStream.Close()
        }
    }
}

# 清理
$listener.Stop()
$listener.Close()
Write-Host "服务器已停止"