{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "meraki";
  version = "1.41.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aXcGMRqkiVPnLEYrzIMLDiFXWurBRNlMg4OnRd5jlrY=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # All tests require an API key
  doCheck = false;

  pythonImportsCheck = [
    "meraki"
  ];

  meta = with lib; {
    description = "Provides all current Meraki dashboard API calls to interface with the Cisco Meraki cloud-managed platform";
    homepage = "https://github.com/meraki/dashboard-api-python";
    changelog = "https://github.com/meraki/dashboard-api-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dylanmtaylor ];
  };
}
