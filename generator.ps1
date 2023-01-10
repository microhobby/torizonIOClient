
# generate rest API client

# cleanup
sudo rm -rf ./clients
rm torizon-openapi.yaml

# get the platform specification
wget https://app.torizon.io/docs/ota/torizon-openapi.yaml

# generate source code
docker `
    run `
    --rm `
    -v ${PWD}:/local `
    openapitools/openapi-generator-cli `
    generate `
    -i /local/torizon-openapi.yaml `
    -g powershell `
    -o /local/clients/generated `
    --additional-properties tags="Toradex'`n'Torizon'`n'Platform" `
    --additional-properties projectUri="https://www.torizon.io/" `
    --additional-properties apiNamePrefix="TorizonPlatformAPI" `
    --additional-properties packageName="TorizonPlatformAPI" `
    --additional-properties packageVersion="0.0.3"

# docker generate it as root we need to change the ownership
sudo chown -R $env:USER ./clients

# build and publish
Set-Location ./clients/generated
./Build.ps1

Publish-Module `
    -Name '.\src\TorizonPlatformAPI' `
    -NuGetApiKey $env:NUGET_API_KEY `
    -Repository PSGallery `
    -Confirm:$false

Set-Location -
