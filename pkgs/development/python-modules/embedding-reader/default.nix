{ buildPythonPackage
, fetchFromGitHub
, fsspec
, lib
, numpy
, pandas
, pyarrow
, pytestCheckHook
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "embedding-reader";
  version = "1.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rom1504";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-51UQOqXZcI1VBQ1k6omMStI7GZXNDQ6/e3ThafpP61U=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "pyarrow" ];

  propagatedBuildInputs = [ fsspec numpy pandas pyarrow ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "embedding_reader" ];

  meta = with lib; {
    description = "Efficiently read embedding in streaming from any filesystem";
    homepage = "https://github.com/rom1504/embedding-reader";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
