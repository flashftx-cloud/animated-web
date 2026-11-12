Add-Type -AssemblyName System.Drawing

function Create-RoundedPath([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $d = [Math]::Max(1.0, [float]($r * 2.0))
    $path.AddArc($x, $y, $d, $d, [float]180, [float]90)
    $path.AddArc([float]($x + $w - $d), $y, $d, $d, [float]270, [float]90)
    $path.AddArc([float]($x + $w - $d), [float]($y + $h - $d), $d, $d, [float]0, [float]90)
    $path.AddArc($x, [float]($y + $h - $d), $d, $d, [float]90, [float]90)
    $path.CloseFigure()
    return $path
}

function Create-ChamferedPath([float]$x, [float]$y, [float]$w, [float]$h, [float]$c) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $pts = @(
        [System.Drawing.PointF]::new([float]($x + $c), [float]$y),
        [System.Drawing.PointF]::new([float]($x + $w - $c), [float]$y),
        [System.Drawing.PointF]::new([float]($x + $w), [float]($y + $c)),
        [System.Drawing.PointF]::new([float]($x + $w), [float]($y + $h - $c)),
        [System.Drawing.PointF]::new([float]($x + $w - $c), [float]($y + $h)),
        [System.Drawing.PointF]::new([float]($x + $c), [float]($y + $h)),
        [System.Drawing.PointF]::new([float]$x, [float]($y + $h - $c)),
        [System.Drawing.PointF]::new([float]$x, [float]($y + $c))
    )
    $path.AddPolygon($pts)
    return $path
}

# ==============================================================================
# 1. RENDER WATCH-ASSEMBLED.PNG (1200 x 1200)
# ==============================================================================
Write-Output "Rendering watch-assembled.png..."
$bmp = [System.Drawing.Bitmap]::new(1200, 1200)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.Clear([System.Drawing.Color]::Transparent)

# Outer Ambient Glow (Zero-G Space Ambient)
$glowPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
$glowPath.AddEllipse(200, 200, 800, 800)
$pbg = [System.Drawing.Drawing2D.PathGradientBrush]::new($glowPath)
$pbg.CenterColor = [System.Drawing.Color]::FromArgb(45, 245, 158, 11)
$pbg.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 0, 0, 0))
$g.FillEllipse($pbg, 200, 200, 800, 800)
$pbg.Dispose()
$glowPath.Dispose()

# Ambient floating zero-g particles
$rnd = [System.Random]::new(42)
for ($i=0; $i -lt 40; $i++) {
    $px = $rnd.Next(100, 1100)
    $py = $rnd.Next(100, 1100)
    $pr = $rnd.Next(1, 4)
    $pa = $rnd.Next(40, 180)
    $pBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb($pa, 245, 158, 11))
    $g.FillEllipse($pBrush, $px, $py, ($pr * 2), ($pr * 2))
    $pBrush.Dispose()
}

# --- WATCH STRAP (TOP & BOTTOM) ---
# Top strap
$topStrapPts = @(
    [System.Drawing.PointF]::new(460, 0),
    [System.Drawing.PointF]::new(740, 0),
    [System.Drawing.PointF]::new(725, 340),
    [System.Drawing.PointF]::new(475, 340)
)
$topStrapPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
$topStrapPath.AddPolygon($topStrapPts)
$strapBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(460, 0), [System.Drawing.PointF]::new(740, 0), [System.Drawing.Color]::FromArgb(255, 18, 20, 24), [System.Drawing.Color]::FromArgb(255, 32, 36, 44))
$g.FillPath($strapBrush, $topStrapPath)
for ($sy = 60; $sy -lt 320; $sy += 36) {
    $ridgePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(140, 10, 12, 15), 6)
    $g.DrawLine($ridgePen, 470, $sy, 730, $sy)
    $ridgePen.Dispose()
    $ridgePenH = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(70, 70, 80, 95), 2)
    $g.DrawLine($ridgePenH, 470, ($sy + 3), 730, ($sy + 3))
    $ridgePenH.Dispose()
}
$strapBrush.Dispose()

# Bottom strap
$botStrapPts = @(
    [System.Drawing.PointF]::new(475, 860),
    [System.Drawing.PointF]::new(725, 860),
    [System.Drawing.PointF]::new(740, 1200),
    [System.Drawing.PointF]::new(460, 1200)
)
$botStrapPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
$botStrapPath.AddPolygon($botStrapPts)
$strapBrush2 = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(460, 860), [System.Drawing.PointF]::new(740, 860), [System.Drawing.Color]::FromArgb(255, 18, 20, 24), [System.Drawing.Color]::FromArgb(255, 32, 36, 44))
$g.FillPath($strapBrush2, $botStrapPath)
for ($sy = 880; $sy -lt 1160; $sy += 36) {
    $ridgePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(140, 10, 12, 15), 6)
    $g.DrawLine($ridgePen, 470, $sy, 730, $sy)
    $ridgePen.Dispose()
    $ridgePenH = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(70, 70, 80, 95), 2)
    $g.DrawLine($ridgePenH, 470, ($sy + 3), 730, ($sy + 3))
    $ridgePenH.Dispose()
}
$strapBrush2.Dispose()

# --- 4 PUSHERS (STAINLESS STEEL BUTTONS) ---
function DrawPusherDirect($graphics, [float]$px, [float]$py, [float]$pw, [float]$ph) {
    $pRect = [System.Drawing.RectangleF]::new($px, $py, $pw, $ph)
    $pBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new($px, $py), [System.Drawing.PointF]::new($px, ($py + $ph)), [System.Drawing.Color]::FromArgb(255, 200, 205, 215), [System.Drawing.Color]::FromArgb(255, 80, 85, 95))
    $graphics.FillRectangle($pBrush, $pRect)
    $pBrush.Dispose()
    $pBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 40, 45, 52), 2)
    $graphics.DrawRectangle($pBorder, $px, $py, $pw, $ph)
    $pBorder.Dispose()
    for ($ky = ($py + 4); $ky -lt ($py + $ph - 4); $ky += 5) {
        $kPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(160, 255, 255, 255), 1)
        $graphics.DrawLine($kPen, $px, $ky, ($px + $pw), $ky)
        $kPen.Dispose()
    }
}
DrawPusherDirect $g 332 410 32 46   # LIGHT
DrawPusherDirect $g 332 744 32 46   # MODE
DrawPusherDirect $g 836 410 32 46   # ADJUST
DrawPusherDirect $g 836 744 32 46   # SEARCH

# --- WATCH CASE (OCTAGONAL RESIN ARMOR) ---
$casePath = Create-ChamferedPath 360 320 480 560 64
$caseBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(360, 320), [System.Drawing.PointF]::new(840, 880), [System.Drawing.Color]::FromArgb(255, 42, 47, 56), [System.Drawing.Color]::FromArgb(255, 16, 18, 22))
$g.FillPath($caseBrush, $casePath)
$caseBrush.Dispose()

$edgePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(180, 80, 88, 100), 3)
$g.DrawPath($edgePen, $casePath)
$edgePen.Dispose()

# Inner Resin Bezel Recess
$innerCasePath = Create-ChamferedPath 385 345 430 510 50
$innerCaseBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(385, 345), [System.Drawing.PointF]::new(815, 855), [System.Drawing.Color]::FromArgb(255, 14, 16, 20), [System.Drawing.Color]::FromArgb(255, 28, 32, 38))
$g.FillPath($innerCaseBrush, $innerCasePath)
$innerCaseBrush.Dispose()
$innerEdgePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(220, 20, 22, 26), 4)
$g.DrawPath($innerEdgePen, $innerCasePath)
$innerEdgePen.Dispose()

# 4 Corner Screws (Titanium rivets)
function DrawCornerScrewDirect($graphics, [float]$cx, [float]$cy) {
    $sBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new([float]($cx-12), [float]($cy-12)), [System.Drawing.PointF]::new([float]($cx+12), [float]($cy+12)), [System.Drawing.Color]::FromArgb(255, 210, 215, 225), [System.Drawing.Color]::FromArgb(255, 70, 75, 85))
    $graphics.FillEllipse($sBrush, [float]($cx-10), [float]($cy-10), [float]20, [float]20)
    $sBrush.Dispose()
    $sBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 30, 35, 40), 2)
    $graphics.DrawEllipse($sBorder, [float]($cx-10), [float]($cy-10), [float]20, [float]20)
    $sBorder.Dispose()
    $slotPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 30, 35, 40), 2)
    $graphics.DrawLine($slotPen, [float]($cx-6), $cy, [float]($cx+6), $cy)
    $graphics.DrawLine($slotPen, $cx, [float]($cy-6), $cx, [float]($cy+6))
    $slotPen.Dispose()
}
DrawCornerScrewDirect $g 408 368
DrawCornerScrewDirect $g 792 368
DrawCornerScrewDirect $g 408 832
DrawCornerScrewDirect $g 792 832

# --- DIAL MASK & TEXT PRINTING ---
$fontSilver = [System.Drawing.Font]::new("Arial", 16, [System.Drawing.FontStyle]::Bold)
$fontSmall = [System.Drawing.Font]::new("Arial", 10, [System.Drawing.FontStyle]::Bold)
$fontAmber = [System.Drawing.Font]::new("Arial", 12, [System.Drawing.FontStyle]::Bold)

$whiteBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(240, 240, 245))
$amberBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(245, 158, 11))
$silverBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(200, 205, 215))
$darkBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(120, 130, 145))

$sf = [System.Drawing.StringFormat]::new()
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$g.DrawString("CASIO", $fontSilver, $silverBrush, [float]600, [float]362, $sf)
$g.DrawString("WORLD TIME", $fontSmall, $whiteBrush, [float]600, [float]386, $sf)

# Button indicator labels
$g.DrawString("LIGHT", $fontSmall, $darkBrush, [float]436, [float]420)
$g.DrawString("MODE", $fontSmall, $darkBrush, [float]436, [float]755)
$sfR = [System.Drawing.StringFormat]::new()
$sfR.Alignment = [System.Drawing.StringAlignment]::Far
$g.DrawString("ADJUST", $fontSmall, $darkBrush, [float]764, [float]420, $sfR)
$g.DrawString("SEARCH", $fontSmall, $darkBrush, [float]764, [float]755, $sfR)

# --- LCD SCREEN HOUSING ---
$lcdPath = Create-RoundedPath 420 412 360 340 16
$lcdBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(420, 412), [System.Drawing.PointF]::new(780, 752), [System.Drawing.Color]::FromArgb(255, 18, 24, 20), [System.Drawing.Color]::FromArgb(255, 8, 12, 10))
$g.FillPath($lcdBrush, $lcdPath)
$lcdBrush.Dispose()

$lcdGlow = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(420, 412), [System.Drawing.PointF]::new(540, 530), [System.Drawing.Color]::FromArgb(60, 245, 158, 11), [System.Drawing.Color]::FromArgb(0, 245, 158, 11))
$g.FillPath($lcdGlow, $lcdPath)
$lcdGlow.Dispose()

$lcdBorder = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 45, 52, 60), 3)
$g.DrawPath($lcdBorder, $lcdPath)
$lcdBorder.Dispose()

# Gunmetal division bars
$barPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(220, 35, 40, 48), 3)
$g.DrawLine($barPen, 420, 562, 780, 562)
$g.DrawLine($barPen, 545, 412, 545, 562)
$barPen.Dispose()

# --- ZONE A: TOP-LEFT RADAR / ANALOG SUB-DIAL ---
$radarPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 245, 158, 11), 2)
$g.DrawEllipse($radarPen, 437, 441, 90, 90)
$g.DrawEllipse($radarPen, 477, 481, 10, 10)
for ($deg = 0; $deg -lt 360; $deg += 30) {
    $rad = $deg * [Math]::PI / 180
    $x1 = 482 + [Math]::Cos($rad) * 40
    $y1 = 486 + [Math]::Sin($rad) * 40
    $x2 = 482 + [Math]::Cos($rad) * 45
    $y2 = 486 + [Math]::Sin($rad) * 45
    $g.DrawLine($radarPen, [float]$x1, [float]$y1, [float]$x2, [float]$y2)
}
$hourPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 255, 255, 255), 4)
$g.DrawLine($hourPen, 482, 486, 464, 464)
$hourPen.Dispose()
$minPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 245, 158, 11), 3)
$g.DrawLine($minPen, 482, 486, 510, 460)
$minPen.Dispose()
$radarPen.Dispose()

# Annunciator badges: MUTE / ALM / SIG
$badgeFont = [System.Drawing.Font]::new("Arial", 8, [System.Drawing.FontStyle]::Bold)
$g.DrawString("ALM", $badgeFont, $amberBrush, [float]555, [float]420)
$g.DrawString("SIG", $badgeFont, $whiteBrush, [float]585, [float]420)
$g.DrawString("MUTE", $badgeFont, $darkBrush, [float]615, [float]420)

# --- ZONE B: TOP-RIGHT WORLD MAP ---
$mapPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(60, 245, 158, 11), 1)
for ($gridX = 556; $gridX -lt 770; $gridX += 18) {
    $g.DrawLine($mapPen, $gridX, 442, $gridX, 550)
}
for ($gridY = 446; $gridY -lt 550; $gridY += 16) {
    $g.DrawLine($mapPen, 556, $gridY, 766, $gridY)
}
$mapPen.Dispose()

# Continents Silhouettes
$contBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(120, 80, 95, 105))
$g.FillPolygon($contBrush, @(
    [System.Drawing.PointF]::new(566, 452),
    [System.Drawing.PointF]::new(600, 452),
    [System.Drawing.PointF]::new(595, 478),
    [System.Drawing.PointF]::new(580, 484),
    [System.Drawing.PointF]::new(566, 466)
))
$g.FillPolygon($contBrush, @(
    [System.Drawing.PointF]::new(588, 492),
    [System.Drawing.PointF]::new(606, 500),
    [System.Drawing.PointF]::new(596, 536),
    [System.Drawing.PointF]::new(586, 510)
))
$g.FillPolygon($contBrush, @(
    [System.Drawing.PointF]::new(624, 452),
    [System.Drawing.PointF]::new(648, 456),
    [System.Drawing.PointF]::new(646, 480),
    [System.Drawing.PointF]::new(638, 520),
    [System.Drawing.PointF]::new(622, 490)
))
$asiaGlow = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 245, 158, 11))
$g.FillPolygon($asiaGlow, @(
    [System.Drawing.PointF]::new(656, 450),
    [System.Drawing.PointF]::new(730, 456),
    [System.Drawing.PointF]::new(740, 482),
    [System.Drawing.PointF]::new(698, 512),
    [System.Drawing.PointF]::new(676, 506),
    [System.Drawing.PointF]::new(666, 476)
))
$asiaGlow.Dispose()
$g.FillPolygon($contBrush, @(
    [System.Drawing.PointF]::new(714, 508),
    [System.Drawing.PointF]::new(742, 514),
    [System.Drawing.PointF]::new(736, 538),
    [System.Drawing.PointF]::new(710, 532)
))
$contBrush.Dispose()

$beaconBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
$g.FillEllipse($beaconBrush, [float]686, [float]484, [float]6, [float]6)
$beaconBrush.Dispose()

# --- ZONE C: BOTTOM PRIMARY DIGITAL CLOCK ---
$lcdHeadFont = [System.Drawing.Font]::new("Arial", 14, [System.Drawing.FontStyle]::Bold)
$g.DrawString("THU  12-10", $lcdHeadFont, $whiteBrush, [float]442, [float]576)
$g.DrawString("DEL  UTC+5:30", $lcdHeadFont, $amberBrush, [float]758, [float]576, $sfR)

$digitFont = [System.Drawing.Font]::new("Consolas", 64, [System.Drawing.FontStyle]::Bold)
$secFont = [System.Drawing.Font]::new("Consolas", 36, [System.Drawing.FontStyle]::Bold)
$pmFont = [System.Drawing.Font]::new("Arial", 12, [System.Drawing.FontStyle]::Bold)

$digitBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 255, 255, 255))
$g.DrawString("10:58", $digitFont, $digitBrush, [float]436, [float]620)
$g.DrawString("50", $secFont, $amberBrush, [float]680, [float]630)
$g.DrawString("PM", $pmFont, $whiteBrush, [float]682, [float]674)

# Bezel text
$g.DrawString("<  ILLUMINATOR  >", $fontAmber, $amberBrush, [float]600, [float]768, $sf)
$g.DrawString("10 YEAR BATTERY  *  WATER 100M RESIST", $fontSmall, $whiteBrush, [float]600, [float]792, $sf)

# Mineral Crystal Specular Reflections
$glassPath = Create-RoundedPath 418 410 364 344 16
$glassBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(418, 410), [System.Drawing.PointF]::new(650, 750), [System.Drawing.Color]::FromArgb(45, 255, 255, 255), [System.Drawing.Color]::FromArgb(0, 255, 255, 255))
$g.FillPath($glassBrush, $glassPath)
$glassBrush.Dispose()

$glarePts = @(
    [System.Drawing.PointF]::new(430, 412),
    [System.Drawing.PointF]::new(530, 412),
    [System.Drawing.PointF]::new(470, 752),
    [System.Drawing.PointF]::new(420, 752)
)
$glarePath = [System.Drawing.Drawing2D.GraphicsPath]::new()
$glarePath.AddPolygon($glarePts)
$glareBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(20, 255, 255, 255))
$g.FillPath($glareBrush, $glarePath)
$glareBrush.Dispose()
$glarePath.Dispose()

# Cleanup
$whiteBrush.Dispose()
$amberBrush.Dispose()
$silverBrush.Dispose()
$darkBrush.Dispose()
$fontSilver.Dispose()
$fontSmall.Dispose()
$fontAmber.Dispose()
$digitFont.Dispose()
$secFont.Dispose()
$pmFont.Dispose()
$g.Dispose()

$bmp.Save("$pwd\watch-assembled.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Output "SUCCESS: watch-assembled.png created ($((Get-Item 'watch-assembled.png').Length) bytes)"

# ==============================================================================
# 2. RENDER WATCH-EXPLODED.PNG (1200 x 1200)
# ==============================================================================
Write-Output "Rendering watch-exploded.png..."
$bmp2 = [System.Drawing.Bitmap]::new(1200, 1200)
$g2 = [System.Drawing.Graphics]::FromImage($bmp2)
$g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g2.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g2.Clear([System.Drawing.Color]::Transparent)

# Tactical background grid & coordinates
$gridPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(25, 245, 158, 11), 1)
for ($x = 100; $x -lt 1100; $x += 100) {
    $g2.DrawLine($gridPen, $x, 50, $x, 1150)
}
for ($y = 100; $y -lt 1100; $y += 100) {
    $g2.DrawLine($gridPen, 50, $y, 1150, $y)
}
$gridPen.Dispose()

# Explosive Zero-G Axis Alignment Guideline
$axisPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(120, 245, 158, 11), 2)
$axisPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
$g2.DrawLine($axisPen, 600, 120, 600, 1080)
$axisPen.Dispose()

# Floating particles
for ($i=0; $i -lt 50; $i++) {
    $px = $rnd.Next(80, 1120)
    $py = $rnd.Next(80, 1120)
    $pr = $rnd.Next(1, 4)
    $pa = $rnd.Next(40, 200)
    $pBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb($pa, 245, 158, 11))
    $g2.FillEllipse($pBrush, $px, $py, ($pr * 2), ($pr * 2))
    $pBrush.Dispose()
}

# Floating Corner Screws
DrawCornerScrewDirect $g2 350 210
DrawCornerScrewDirect $g2 850 210
DrawCornerScrewDirect $g2 350 330
DrawCornerScrewDirect $g2 850 330

# LAYER 1: FRONT RESIN BEZEL & CASE
$l1Path = Create-ChamferedPath 380 140 440 100 24
$l1Brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(380, 140), [System.Drawing.PointF]::new(820, 240), [System.Drawing.Color]::FromArgb(255, 45, 50, 60), [System.Drawing.Color]::FromArgb(255, 16, 18, 22))
$g2.FillPath($l1Brush, $l1Path)
$l1Brush.Dispose()
$l1Pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(200, 245, 158, 11), 2)
$g2.DrawPath($l1Pen, $l1Path)
$l1Pen.Dispose()

$l1Cutout = Create-RoundedPath 430 156 340 68 12
$cutBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(220, 10, 12, 14))
$g2.FillPath($cutBrush, $l1Cutout)
$cutBrush.Dispose()

$sfCenter = [System.Drawing.StringFormat]::new()
$sfCenter.Alignment = [System.Drawing.StringAlignment]::Center
$headFont = [System.Drawing.Font]::new("Arial", 9, [System.Drawing.FontStyle]::Bold)
$g2.DrawString("CASIO   WORLD TIME   AE-1200WH", $headFont, [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 200, 205, 215)), [float]600, [float]142, $sfCenter)
$headFont.Dispose()

# LAYER 2: HARDENED MINERAL CRYSTAL GLASS
$l2Path = Create-RoundedPath 400 260 400 68 14
$l2Brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(400, 260), [System.Drawing.PointF]::new(800, 328), [System.Drawing.Color]::FromArgb(120, 120, 200, 240), [System.Drawing.Color]::FromArgb(40, 245, 158, 11))
$g2.FillPath($l2Brush, $l2Path)
$l2Brush.Dispose()
$l2Pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(220, 180, 230, 255), 2)
$g2.DrawPath($l2Pen, $l2Path)
$l2Pen.Dispose()
$g2.DrawLine([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(180, 255, 255, 255), 2), 430, 275, 580, 275)

# LAYER 3: GUNMETAL DIAL MASK / BEZEL SHROUD
$l3Path = Create-RoundedPath 395 350 410 76 12
$l3Brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(395, 350), [System.Drawing.PointF]::new(805, 426), [System.Drawing.Color]::FromArgb(255, 30, 34, 40), [System.Drawing.Color]::FromArgb(255, 12, 14, 16))
$g2.FillPath($l3Brush, $l3Path)
$l3Brush.Dispose()
$l3Pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(180, 100, 110, 125), 2)
$g2.DrawPath($l3Pen, $l3Path)
$l3Pen.Dispose()
$g2.DrawEllipse([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 245, 158, 11), 2), 430, 362, 52, 52)
$g2.DrawRectangle([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(200, 100, 110, 125), 1), 510, 362, 120, 52)
$g2.DrawRectangle([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(200, 100, 110, 125), 1), 650, 362, 130, 52)

# LAYER 4: HIGH-CONTRAST LCD DISPLAY MODULE
$l4Path = Create-RoundedPath 390 450 420 96 14
$l4Brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(390, 450), [System.Drawing.PointF]::new(810, 546), [System.Drawing.Color]::FromArgb(255, 20, 26, 22), [System.Drawing.Color]::FromArgb(255, 10, 14, 12))
$g2.FillPath($l4Brush, $l4Path)
$l4Brush.Dispose()
$l4Glow = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(390, 450), [System.Drawing.PointF]::new(810, 546), [System.Drawing.Color]::FromArgb(80, 245, 158, 11), [System.Drawing.Color]::FromArgb(10, 245, 158, 11))
$g2.FillPath($l4Glow, $l4Path)
$l4Glow.Dispose()
$l4Pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 245, 158, 11), 2)
$g2.DrawPath($l4Pen, $l4Path)
$l4Pen.Dispose()
$g2.DrawEllipse([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 245, 158, 11), 1), 425, 465, 50, 50)
$g2.DrawLine([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 255, 255, 255), 2), 450, 490, 440, 478)
$mapSubBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(220, 245, 158, 11))
$g2.FillRectangle($mapSubBrush, 505, 465, 80, 32)
$mapSubBrush.Dispose()
$lcdSubFont = [System.Drawing.Font]::new("Consolas", 24, [System.Drawing.FontStyle]::Bold)
$g2.DrawString("10:58:50 DEL", $lcdSubFont, [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 255, 255, 255)), [float]600, [float]468)
$lcdSubFont.Dispose()

# LAYER 5: MODULE 3299 CIRCUIT BOARD (PCB)
$l5Path = Create-RoundedPath 385 575 430 90 12
$l5Brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(385, 575), [System.Drawing.PointF]::new(815, 665), [System.Drawing.Color]::FromArgb(255, 12, 48, 28), [System.Drawing.Color]::FromArgb(255, 6, 26, 15))
$g2.FillPath($l5Brush, $l5Path)
$l5Brush.Dispose()
$l5Pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 40, 140, 80), 2)
$g2.DrawPath($l5Pen, $l5Path)
$l5Pen.Dispose()
$goldPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 245, 180, 40), 2)
$g2.DrawLine($goldPen, 410, 600, 460, 600)
$g2.DrawLine($goldPen, 460, 600, 480, 630)
$g2.DrawLine($goldPen, 480, 630, 560, 630)
$g2.DrawLine($goldPen, 640, 630, 720, 630)
$g2.DrawLine($goldPen, 720, 630, 750, 595)
$g2.DrawLine($goldPen, 750, 595, 780, 595)
$goldPen.Dispose()
$icRect = [System.Drawing.RectangleF]::new(570, 595, 50, 50)
$g2.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 20, 22, 26)), $icRect)
$g2.DrawRectangle([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 70, 75, 85), 1), 570, 595, 50, 50)
$icFont = [System.Drawing.Font]::new("Arial", 7, [System.Drawing.FontStyle]::Bold)
$g2.DrawString("CASIO`n3299", $icFont, [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(200, 200, 205, 215)), [float]575, [float]605)
$icFont.Dispose()
$g2.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 200, 205, 215)), 690, 608, 30, 14)
$g2.DrawRectangle([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 120, 125, 135), 1), 690, 608, 30, 14)

# LAYER 6: CR2025 3V LITHIUM COIN CELL POWERCELL
$l6Rect = [System.Drawing.RectangleF]::new(510, 690, 180, 64)
$l6Brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(510, 690), [System.Drawing.PointF]::new(690, 754), [System.Drawing.Color]::FromArgb(255, 240, 244, 250), [System.Drawing.Color]::FromArgb(255, 120, 130, 145))
$g2.FillEllipse($l6Brush, $l6Rect)
$l6Brush.Dispose()
$l6Pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 245, 158, 11), 2)
$g2.DrawEllipse($l6Pen, $l6Rect)
$l6Pen.Dispose()
$battFont = [System.Drawing.Font]::new("Arial", 8, [System.Drawing.FontStyle]::Bold)
$g2.DrawString("+ CASIO CR2025 3V LITHIUM +`n10-YEAR CONTINUOUS RUN", $battFont, [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 40, 45, 55)), [float]600, [float]706, $sfCenter)
$battFont.Dispose()

# LAYER 7: WR100M NITRILE HIGH-PRESSURE O-RING GASKET
$l7Path = Create-RoundedPath 395 780 410 56 16
$l7Glow = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(90, 239, 68, 68), 10)
$g2.DrawPath($l7Glow, $l7Path)
$l7Glow.Dispose()
$l7Pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 239, 68, 68), 4)
$g2.DrawPath($l7Pen, $l7Path)
$l7Pen.Dispose()

# LAYER 8: STAMPED GRADE 316L STAINLESS STEEL CASEBACK
$l8Path = Create-ChamferedPath 380 860 440 96 24
$l8Brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(380, 860), [System.Drawing.PointF]::new(820, 956), [System.Drawing.Color]::FromArgb(255, 180, 188, 200), [System.Drawing.Color]::FromArgb(255, 90, 98, 110))
$g2.FillPath($l8Brush, $l8Path)
$l8Brush.Dispose()
$l8Pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 230, 235, 245), 3)
$g2.DrawPath($l8Pen, $l8Path)
$l8Pen.Dispose()
$steelFont = [System.Drawing.Font]::new("Arial", 9, [System.Drawing.FontStyle]::Bold)
$steelBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 45, 50, 60))
$g2.DrawString("CASIO [3299] AE-1200WH`nSTAINLESS STEEL BACK * WATER RESISTANT 10BAR`nJAPAN MOV'T EA - CASED IN CHINA", $steelFont, $steelBrush, [float]600, [float]878, $sfCenter)
$steelFont.Dispose()
$steelBrush.Dispose()

DrawCornerScrewDirect $g2 405 880
DrawCornerScrewDirect $g2 795 880
DrawCornerScrewDirect $g2 405 935
DrawCornerScrewDirect $g2 795 935

# LAYER 9: DETACHED RESIN STRAP LOWER WING
$botL9Pts = @(
    [System.Drawing.PointF]::new(480, 990),
    [System.Drawing.PointF]::new(720, 990),
    [System.Drawing.PointF]::new(735, 1120),
    [System.Drawing.PointF]::new(465, 1120)
)
$botL9Path = [System.Drawing.Drawing2D.GraphicsPath]::new()
$botL9Path.AddPolygon($botL9Pts)
$botL9Brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.PointF]::new(480, 990), [System.Drawing.PointF]::new(720, 990), [System.Drawing.Color]::FromArgb(255, 22, 26, 32), [System.Drawing.Color]::FromArgb(255, 38, 44, 54))
$g2.FillPath($botL9Brush, $botL9Path)
$botL9Brush.Dispose()
$botL9Pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(120, 80, 90, 105), 2)
$g2.DrawPath($botL9Pen, $botL9Path)
$botL9Pen.Dispose()
$g2.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 210, 215, 225)), 475, 978, 250, 6)
$g2.DrawRectangle([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 50, 55, 65), 1), 475, 978, 250, 6)

# HUD Technical Dimension Vector Markings
$dimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(80, 245, 158, 11), 1)
$dimPen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dot
$g2.DrawLine($dimPen, 320, 140, 320, 956)
$g2.DrawLine($dimPen, 310, 140, 330, 140)
$g2.DrawLine($dimPen, 310, 956, 330, 956)
$dimPen.Dispose()

$dimFont = [System.Drawing.Font]::new("Arial", 8, [System.Drawing.FontStyle]::Bold)
$g2.DrawString("EXPLODED Z-AXIS DISPLACEMENT: 816mm", $dimFont, [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(160, 245, 158, 11)), [float]330, [float]540)
$dimFont.Dispose()

# Cleanup
$g2.Dispose()

$bmp2.Save("$pwd\watch-exploded.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp2.Dispose()
Write-Output "SUCCESS: watch-exploded.png created ($((Get-Item 'watch-exploded.png').Length) bytes)"
