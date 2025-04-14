param(
    [string]$imageName,
    [string]$registryName,
    [string]$dockerTag = "latest"
)

try {

    az acr login --name "${registryName}"

    docker tag "${imageName}:${dockerTag}" "${registryName}.azurecr.io/${imageName}:${dockerTag}"

    docker push "${registryName}.azurecr.io/${imageName}:${dockerTag}"

} catch {
    Write-Host "Error checking Docker status: $_"
    exit 1
}