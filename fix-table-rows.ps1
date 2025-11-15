# Fix Table Rows Glassmorphism
Write-Host "=== FIXING TABLE ROWS & HEADERS ===" -ForegroundColor Cyan

$frontendPath = "d:\Semester_5\Project_KP\ciptastok_project\frontend\src\app"
$filesChanged = 0

# Pattern untuk table rows dan headers
$replacements = @(
    # Table header dengan bg-gray-2
    @{
        Find = 'className="border-b border-stroke bg-gray-2 dark:border-strokedark dark:bg-meta-4"'
        Replace = 'className="border-b border-stroke bg-white/40 dark:border-strokedark dark:bg-white/5"'
    },
    
    # Table rows dengan alternating colors - Pattern 1
    @{
        Find = 'i % 2 === 0 ? ''bg-white dark:bg-gray-800'' : ''bg-gray-50 dark:bg-gray-800/50'''
        Replace = '""'  # Empty string - no alternating
    },
    
    # Table row className dengan conditional background
    @{
        Find = 'className={`border-b border-stroke hover:bg-gray-50 dark:border-strokedark dark:hover:bg-gray-700 transition-colors ${
                      i % 2 === 0 ? ''bg-white dark:bg-gray-800'' : ''bg-gray-50 dark:bg-gray-800/50''
                    }`}'
        Replace = 'className="border-b border-stroke/50 hover:bg-white/30 dark:border-strokedark/50 dark:hover:bg-white/10 transition-colors"'
    },
    
    # Select/dropdown dengan dark:bg-gray-800
    @{
        Find = 'className="rounded-md border border-gray-300 px-3 py-1.5 text-sm focus:border-primary focus:outline-none focus:ring-1 focus:ring-primary dark:border-gray-600 dark:bg-gray-800 dark:text-white"'
        Replace = 'className="glass-button rounded-md px-3 py-1.5 text-sm focus:border-primary focus:outline-none focus:ring-1 focus:ring-primary dark:text-white"'
    },
    
    # Tab buttons dengan conditional bg-white
    @{
        Find = 'activeTab === ''condition'' ? ''bg-white dark:bg-gray-800 text-gray-900 dark:text-white border-b-2 border-primary'''
        Replace = 'activeTab === ''condition'' ? ''bg-white/60 dark:bg-white/10 text-gray-900 dark:text-white border-b-2 border-primary'''
    },
    @{
        Find = 'activeTab === ''value'' ? ''bg-white dark:bg-gray-800 text-gray-900 dark:text-white border-b-2 border-primary'''
        Replace = 'activeTab === ''value'' ? ''bg-white/60 dark:bg-white/10 text-gray-900 dark:text-white border-b-2 border-primary'''
    }
)

Get-ChildItem -Path $frontendPath -Filter *.tsx -Recurse | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName | Out-String
    $originalContent = $content
    $changed = $false
    
    foreach ($replacement in $replacements) {
        if ($content.Contains($replacement.Find)) {
            $content = $content.Replace($replacement.Find, $replacement.Replace)
            $changed = $true
        }
    }
    
    if ($changed) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        $filesChanged++
        Write-Host "  [OK] Fixed: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`n=== RESULTS ===" -ForegroundColor Cyan
Write-Host "Files fixed: $filesChanged" -ForegroundColor Green

Write-Host "`n=== ADDITIONAL MANUAL FIXES ===" -ForegroundColor Yellow
Write-Host "Check these files manually:" -ForegroundColor White
Write-Host "- monitoring/approve/[assignment_id]/page.tsx" -ForegroundColor DarkYellow
Write-Host "- riwayat/detail/[assignment_id]/page.tsx" -ForegroundColor DarkYellow
Write-Host "- produk/page.tsx" -ForegroundColor DarkYellow
Write-Host "`nLook for:" -ForegroundColor White
Write-Host "1. Table rows: i % 2 === 0 ? 'bg-white..." -ForegroundColor DarkGray
Write-Host "2. Table headers: bg-gray-2 dark:bg-meta-4" -ForegroundColor DarkGray
