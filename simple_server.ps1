# Simple HTTP Server

$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host "Server started at http://localhost:$port/"
Write-Host "Press Ctrl+C to stop."

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    
    $localPath = $request.Url.LocalPath
    if ($localPath -eq '/') {
        $localPath = '/index.html'
    }
    
    $filePath = Join-Path (Get-Location) $localPath.TrimStart('/')
    
    if (Test-Path $filePath -PathType Leaf) {
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentLength64 = $content.Length
        
        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        switch ($ext) {
            '.html' { $response.ContentType = 'text/html; charset=utf-8' }
            '.css' { $response.ContentType = 'text/css; charset=utf-8' }
            '.js' { $response.ContentType = 'application/javascript; charset=utf-8' }
        }
        
        $response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $response.StatusCode = 404
        $content = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
    }
    
    $response.OutputStream.Close()
}

$listener.Stop()
$listener.Close()