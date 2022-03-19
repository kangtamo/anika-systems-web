param endpointName string 
param location string 
// Storage Account shoule have static website enabled (use storageAccStaticWebsite.bicep module or implement manually)
param storageAccountName string

resource CDNEndpointStaticWeb 'Microsoft.Cdn/profiles/endpoints@2020-04-15' = {
  name: endpointName
  location: location
  properties: {
    originHostHeader: '${storageAccountName}.z13.web.core.windows.net' // look into "Warning no-hardcoded-env-urls"
    isHttpAllowed: true
    isHttpsAllowed: true
    queryStringCachingBehavior: 'IgnoreQueryString'
    contentTypesToCompress: [
      'application/eot'
      'application/font'
      'application/font-sfnt'
      'application/javascript'
      'application/json'
      'application/opentype'
      'application/otf'
      'application/pkcs7-mime'
      'application/truetype'
      'application/ttf'
      'application/vnd.ms-fontobject'
      'application/xhtml+xml'
      'application/xml'
      'application/xml+rss'
      'application/x-font-opentype'
      'application/x-font-truetype'
      'application/x-font-ttf'
      'application/x-httpd-cgi'
      'application/x-javascript'
      'application/x-mpegurl'
      'application/x-opentype'
      'application/x-otf'
      'application/x-perl'
      'application/x-ttf'
      'font/eot'
      'font/ttf'
      'font/otf'
      'font/opentype'
      'image/svg+xml'
      'text/css'
      'text/csv'
      'text/html'
      'text/javascript'
      'text/js'
      'text/plain'
      'text/richtext'
      'text/tab-separated-values'
      'text/xml'
      'text/x-script'
      'text/x-component'
      'text/x-java-source'
    ]
    isCompressionEnabled: true
    origins: [
      {
        name: 'origin1'
        properties: {
          hostName: '${storageAccountName}.z13.web.core.windows.net' // look into "Warning no-hardcoded-env-urls"
        }
      }
    ]
  }
}
