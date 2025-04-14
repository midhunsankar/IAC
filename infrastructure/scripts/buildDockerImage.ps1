param (
    [string]$imageName,
    [string]$dockerfilePath,
    [string]$dockerfileName = "Dockerfile",
    [string]$dockerfileContext = "."
)

$contextPath = Get-Location

Set-Location -Path $dockerfilePath

# Build the Docker image
Write-Host "Building Docker image: $imageName"
docker build -t $imageName -f $dockerfileName $dockerfileContext

# Check if the build was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Docker image '$imageName' built successfully."
} else {
    Write-Host "Failed to build Docker image '$imageName'."
    exit 1
}

Set-Location -Path $contextPath